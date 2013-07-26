%mc=adaptSet(mc,aState)
%method to finally adapt a single MarkovChain object
%using accumulated statistics from observed training data sets.
%
%Input:
%mc=        single MarkovChain object
%aState=    struct with accumulated statistics from previous calls of adaptAccum
%
%Result:
%mc=        adapted version of the MarkovChain object
%
%Method:
%We have accumulated, in aState:
%pI=        vector of initial state probabilities, with elements
%   pI(i)=  scalefactor* P[S(1)=i | all training sub-sequences]
%pS=        state-pair probability matrix, with elements
%   pS(i,j)=scalefactor* P[S(t)=i & S(t+1)=j | all training data]
%These data directly define the new MarkovChain, after necessary normalization.
%
%Ref:       Arne Leijon (20xx) Pattern Recognition, KTH-SIP
%
%Arne Leijon 2004-11-10 tested
%            2011-08-02 keep sparsity


% defin a dirichlet distribution as a prior. Here we just add the values
% for 7 states to check if the results work. if it worked we will make it
% as an input to the function. 



function mc=adaptSet(mc,aState,eta_init,eta_transition)


% to run the preivous version....
%eta_init=[50 50 50 50 50 50 50];
%numOfManInEachPhase =[3,2,1,3,4,2,1];
%eta_trans = Dirch_Para(7, 1000, numOfManInEachPhase, 1.01);
 
% to run for adaptive signal with 8 phases:
% eta_init=[50 50 50 50 50 50 50 50];
% numOfManInEachPhase =[6, 6, 2, 2, 3, 3, 3 , 3];
% eta_trans = Dirch_Para(8, 45, numOfManInEachPhase, 1.01);

% eta_init=[2 2 2 2];
%  eta_trans= [50 2 2 15 ;...
%              1 30 1 1 ;...
%              1 1 1 30 ;...
%              15 2 2 30]; 



if issparse(mc.InitialProb)%keep the sparsity structure
    mc.InitialProb=sparse((aState.pI+eta_init'-1)./(sum(aState.pI)+sum(eta_init)-size(eta_init,2)));%normalised
else
    mc.InitialProb=(aState.pI+eta_init'-1)./(sum(aState.pI)+sum(eta_init)-size(eta_init,2));%normalised
end;
if issparse(mc.TransitionProb)%keep the sparsity structure
    mc.TransitionProb=sparse((aState.pS+eta_transition-1)./(repmat(sum(aState.pS,2),1,size(aState.pS,2))+...
        repmat(sum(eta_transition,2),1,size(eta_transition,2))-size(eta_transition,2)));%normalized
else
    mc.TransitionProb=(aState.pS+eta_transition-1)./(repmat(sum(aState.pS,2),1,size(aState.pS,2))+...
        repmat(sum(eta_transition,2),1,size(eta_transition,2))-size(eta_transition,2));%normalized
end;
end