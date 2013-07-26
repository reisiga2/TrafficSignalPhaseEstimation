classdef MarkovChainES<MarkovChain
    %MarkovChainES is a MarkovChain with internally expanded states,
    %to allow better modelling of state durations than
    %the standard MarkovChain.
    %
    %A HMM with expanded MarkovChain states (ESHMM) performs
    %about as well as a hidden semi-Markov Model (HSMM)
    %but roughly an order of magnitude faster.
    %
    %Johnson, 2005: Capacity and complexity of HMM duration modelling techniques. 
    %IEEE Sig Proc Letters 12(3), 407-410.
    %
    %When used in an HMM, all the internal sub-states,
    %corresponding to a single exterally visible state,
    %are tied to the same output probability density of the HMM.
    %
    %-------- Construction Example:
    %mc=initErgodic(MarkovChainES,nStates,stateDuration);
    %mc=mc.splitStates(3);%expand each state into 3 internal left-right substates
    %------------------------------
    %
    %Arne Leijon, 2011-08-03
    %Gustav Eje Henter 2011-11-24
    
    properties(Access=public)
        StateMap=1;%binary sparse matrix mapping external states to internal
        %           stateMap(n,k)==1 means internal state #n is part of external state #k
        %With StateMap=1, the MarkovChainES is identical to a MarkovChain.
    end
    %-------------------------------------------------------------------------
    methods(Access=public)
        function mc=MarkovChainES(varargin)%constructor
            %Usage:
            %mc=MarkovChainES; %creates a trivial MarkovChain with only one state
            %mc=MarkovChainES(mcIn);%just copies the given input object
            %mc=MarkovChainES(pInit,pTrans,StateMap);%Construct with given property values
            %For backward compatibility:
            %mc=MarkovChainES(propertyName,propertyValue,...)
            %
            %A square TransitionProb matrix defines a MarkovChainES with INFINITE duration.
            %If size(TransitionProb,2)=size(TransitionProb,1)+1, 
            %       the MarkovChain can have FINITE duration,
            %and S(t)=nStates+1 is then the END state.
            %
            %Result:
            %mc= constructed MarkovChainES object
            %
            mc=mc@MarkovChain(varargin{:});
            if nargin>2%there may be something not handled by superclass
                if ischar(varargin{1})%for backward combatibility
                    mc=setNamedProperties(mc,varargin{:});
                else
                    mc.StateMap=varargin{3};%StateMap must come as 3rd argument
                end;
            end;
        end
        function nS=nExtStates(mc)
            %number of states, as seen externally, i.e.,
            %without the internal state splitting.
            if numel(mc.StateMap)==1%no state splitting, just ordinary MarkovChain
                nS=size(mc.TransitionProb,1);
            else
                nS=size(mc.StateMap,2);
            end;
        end
        function mc=splitStates(mc,ss)
            %Split all states into internal sub-states
            %Input:
            %ss=    scalar or row vector with number of sub-states for each external state
            %       if single value, it is expanded and applied to all states
            %Result;
            %mc=    Markov Chain with extended internal states
            %
            %Arne Leijon, 2011-07-30
            nOldStates=mc.nStates;
            ss=round(ss);%must be integer
            if length(ss)==1
                ss=repmat(ss,1,nOldStates);
            elseif length(ss)~= nOldStates
                error('Incompatible length of sub-state counts');
            end;
            newS1=[1,1+cumsum(ss)];%first expanded state number for each external state
            nNewStates=sum(ss);%total number of new expanded states
            sMap=spalloc(nNewStates,nOldStates,nNewStates);%space for mc.StateMap
            [i,~,s]=find(mc.InitialProb);%find non-zero entries
            IP=sparse(newS1(i),1,s,nNewStates,1);%new InitialProb
            nNonZeroTransProb=sum(ss.*(ss+1)./2)...%for the diagonal block matrices
                +nNewStates*(sum(mc.TransitionProb(:)>0)-nOldStates);%off-diagonal blocks
            nNew2=nNewStates+diff(size(mc.TransitionProb));%one extra column if finite Duration
            TP=spalloc(nNewStates,nNew2,nNonZeroTransProb);%space for new TransitionProb
            for i=1:nOldStates%each old state
                iNew=newS1(i):(newS1(i+1)-1);%new state indices within old state=i
                sMap(iNew,i)=1;
                [sTP,sTP2]=splitTransProb(mc.TransitionProb(i,i),ss(i));%new TP blocks
                TP(iNew,iNew)=sTP;%new TransProb block on diagonal
                j=[1:(i-1),(i+1):size(mc.TransitionProb,2)];%all off-diagonal states
                oldTP2=mc.TransitionProb(i,j);
                sTP2=sTP2*(oldTP2./sum(oldTP2));%new set of off-diag column vectors
                TP(iNew,newS1(j))=sTP2;
            end;
            mc.InitialProb=IP;%set new expanded properties
            mc.TransitionProb=TP;
            mc.StateMap=sMap;
            function [TP,TPout]=splitTransProb(Aii,nSplit)
                %split ONE old diagonal transition prob into new substate transition matrix
                %with mostly unchanged duration probability distribution.
                TPout=min(1./nSplit,repmat(1-Aii,nSplit,1));
                TP=triu(repmat(TPout,1,nSplit),1);
                TPdiag=1-sum(TP,2)-TPout;
                TP=TP+diag(TPdiag);
            end
        end
        function mc=splitStatesTypeA(mc,ss)
            %Split all states into internal sub-states without skips or early exits
            %Input:
            %ss=    scalar or row vector with number of sub-states for each external state
            %       if single value, it is expanded and applied to all states
            %Result;
            %mc=    Markov Chain with "type A" extended internal states
            %
            %Arne Leijon, 2011-07-30
            %Gustav Eje Henter 2011-11-24 tested
            nOldStates=mc.nStates;
            ss=round(ss);%must be integer
            if length(ss)==1
                ss=repmat(ss,1,nOldStates);
            elseif length(ss)~= nOldStates
                error('Incompatible length of sub-state counts');
            end;
            
            durations = mc.meanStateDuration;
            f = mc.finiteDuration;
            % Do not use more substates than what is compatible with the mean
            ss = min(floor(durations(:)),ss(:));
            nSub = sum(ss);
            pStay = 1 - ss./durations;
            stateLimits = [0;cumsum(ss)];
            
            q = zeros(nSub,1);
            q(1+stateLimits(1:end-1)) = mc.InitialProb;
            A = spalloc(nSub,nSub+f,2*nSub+nnz(mc.TransitionProb));
            sMap = spalloc(nSub,nOldStates,nSub); % Space for mc.StateMap
            for bigState = 1:nOldStates,
                p = pStay(bigState);
                % Handle internally-connected states
                for subState = 1:ss(bigState)-1,
                    newState = stateLimits(bigState) + subState;
                    A(newState,newState) = p;
                    A(newState,newState+1) = 1-p;
                end
                % The externally-connected "end state" is special
                newState = stateLimits(bigState+1);
                bigStateTrans = mc.TransitionProb(bigState,:);
                bigStateTrans(bigState) = 0; % Cannot return to the same state
                bigStateTrans = bigStateTrans/sum(bigStateTrans); % Renormalize
                A(newState,1+stateLimits(1:end-1+f)) = (1-p)*bigStateTrans;
                A(newState,newState) = p;
                
                sMap(stateLimits(bigState)+1:stateLimits(bigState+1),bigState) = 1;
            end
            
            mc.InitialProb = q; % Set new expanded properties
            mc.TransitionProb = A;
            mc.StateMap = sMap;
        end
        function pD=probStateDuration(mc,tMax)
            %=probability mass of state durations t=1...tMax
            %for states as seen externally, i.e., without the internal state splitting.
            %Ref: Arne Leijon (201x) Pattern Recognition, KTH-SIP, Problem 4.8.
            if numel(mc.StateMap)==1
                pD=probStateDuration@MarkovChain(mc,tMax);%equiv to superclass
            else
                pD=zeros(mc.nExtStates,tMax);%space
                for i=1:mc.nExtStates% each external state
                    iDiag=(1==mc.StateMap(:,i)');%index of internal states
                    C=mc.TransitionProb(iDiag,iDiag)';%block matrix along diagonal
                    D=eye(size(C))-C;
                    for t=1:tMax
                        pD(i,t)=sum(D(:,1));
                        D=D*C;
                    end;
                end
            end
        end
        function d=meanStateDuration(mc)
            %expected value of number of time samples spent in each state
            %for states as seen externally, i.e., without the internal state splitting.
            %Ref: Arne Leijon (201x) Pattern Recognition, KTH-SIP, Problem 4.8.
            if numel(mc.StateMap)==1
                d=mc.meanStateDuration@MarkovChain;%equiv to superclass
            else
                d=zeros(mc.nExtStates,1);%space
                for i=1:mc.nExtStates% each external state
                    iDiag=(1==mc.StateMap(:,i)');%index of internal states
                    C=mc.TransitionProb(iDiag,iDiag);%block matrix along diagonal
                    D=(eye(size(C))-C')\eye(size(C));
                    d(i)=sum(D(:,1));%always start at first internal sub-state
                end
            end
        end
       %-------------------------- Minor changes to superclass methods:
        function [alfaHat, c]=forward(mc,pX)
            [alfaHat, c]=forward@MarkovChain(mc,mc.mapStateProb(pX));%expand and call superclass
        end
        function betaHat=backward(mc,pX,c)
            betaHat=backward@MarkovChain(mc,mc.mapStateProb(pX),c);
        end
        function [gamma, c]=forwardBackward(mc,pX)
            [gamma, c]=forwardBackward@MarkovChain(mc,mc.mapStateProb(pX));
            gamma=mc.StateMap'*gamma;%transform back to external states
        end
       function [optS,logP]=viterbi(mc,logpX)%*********** NOT tested
            [optS,logP]=viterbi@MarkovChain(mc,mc.mapStateProb(logpX));%just binary expanding, so OK with log prob
            optS=mc.int2bin(optS);%binary 1-of-K column representation
            optS=mc.bin2int(mc.StateMap'*optS);%back to external integer state indices
        end
        function S=rand(mc,T)
            S=rand@MarkovChain(mc,T);
            S=mc.int2bin(S);%binary 1-of-K column representation
            S=mc.bin2int(mc.StateMap'*S);%back to external integer state indices
        end
        function S=expectedStates(mc,T,state)
            if (nargin < 3),
                S=expectedStates@MarkovChain(mc,T);
            else
                S=expectedStates@MarkovChain(mc,T,state);
            end
            S=mc.int2bin(S);%binary 1-of-K column representation
            S=mc.bin2int(mc.StateMap'*S);%back to external integer state indices
        end
%         function lP=logprob(mc, S)
%             %expand S to probability matrix, and run forward
%             error('Not yet implemented');%********
%         end
        %-------------------------- Low-level learning methods:
%         function [aState,gamma,lP]=adaptAccum(mc,aState,pX)
%             [aState,gamma,lP]=adaptAccum@MarkovChain(mc,aState,mc.StateMap*pX);
%             gamma=mc.StateMap'*gamma;%transform back to external state prob.s,
%             %by summing state prob.s across internal states
%         end
%       **** function gamma= forwardBackward ???
        function [aState,gamma,lP]=adaptAccum(mc,aState,pX)
            [aState,gamma,lP]=adaptAccum@MarkovChain(mc,aState,mc.mapStateProb(pX));
            gamma=mc.StateMap'*gamma;%transform back to external state prob.s,
            %by summing state prob.s across internal states
        end
    end
    %-------------------------------------------------------------------------
    methods (Access=protected)%only subclasses can use it
        function pX=mapStateProb(mc,pX)
            %transform from external to internal state prob.s, if necessary
            if mc.nStates>mc.nExtStates && size(pX,1)==mc.nExtStates
                pX=mc.StateMap*pX;
                %else do nothing, assume size(pX)==mc.nStates (internal)
            end;
        end
        function mc=setNamedProperties(mc,varargin)%for backward compatibility
            %set named property value
            %varargin may include several (propName,value) pairs
            property_argin = varargin;
            while length(property_argin) >= 2,
                propName = property_argin{1};
                v = property_argin{2};
                property_argin = property_argin(3:end);
                switch propName
                    case {'StateMap','statemap'}
                        mc.StateMap=v;
                        %otherwise%do nothing
                end;
            end;
        end
    end
        %------------------------------------------------------------------------
    methods (Static,Access=public)% conversion methods
        function iz=bin2int(bz)%convert from binary 1-of-M to integer index format
            if any(sum(bz,1)~= 1)
                error('Input column vectors must be binary 1-of-M');
            end;
            [iz,j]=find(bz);
            iz=iz';
        end
    end
    methods(Access=public)
        function bz=int2bin(mc,iz)%convert integer indices to binary 1-of-M format
            iz=round(iz);%make sure it is integer
            if any(iz<1)
                error('Input vector must be integer indices >=1');
            end;
            bz=sparse(iz,1:length(iz),1,size(mc.TransitionProb,1),length(iz));
        end;
    end
end

