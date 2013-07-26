%logP=logprob(hmm,x) gives conditional log(probability densities)
%for an observed sequence of (possibly vector-valued) samples,
%for each HMM object in an array of HMM objects.
%This can be used to compare how well HMMs can explain data from an unknown source.
%
%Input:
%hmm=   array of HMM objects
%x=     matrix with a sequence of observed vectors, stored columnwise
%NOTE:  hmm DataSize must be same as observed vector length, i.e.
%       hmm(i).DataSize == size(x,1), for each hmm(i).
%       Otherwise, probability is, of course, ZERO.
%
%Result:
%logP=  log P[x | hmm]
%       size(logP)== size(hmm)
%
%The log representation is useful because the probability densities
%exp(logP) may be extremely small for random vectors with many elements
%
%Method: run the forward algorithm with each hmm on the data.
%
%Ref:   Arne Leijon (200x): Pattern Recognition.
%  
%Arne Leijon 2007-08-16 tested (changed definition of scale factors)
%           2009-07-23 changed for Matlab R2008a
%           2011-05-26 generalized prob method

function logP=logprob(hmm,x)
hmmSize=size(hmm);%size of HMM array
T=size(x,2);%number of vector samples in observed sequence
logP=zeros(hmmSize);%space for result
for i=1:numel(hmm)%for all HMM objects
    if hmm(i).DataSize==size(x,1)
        [pX,lP]=prob(hmm(i).OutputDistr,x);%lP is max logprob all states, for each obs.
        [~,c]=forward(hmm(i).StateGen,pX);
        if length(lP)==1%can happen only if the HMM has only one state
            logP(i)=sum(log(c))+T*lP;
        else
            logP(i)=sum(log(c))+sum(lP);
        end
    else
        logP(i)=-Inf;
        warning('HMM:logprob:WrongDataSize','Incompatible DataSize');%but we can still continue
    end;
end;