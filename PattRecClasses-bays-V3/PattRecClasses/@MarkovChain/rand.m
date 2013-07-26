%S=rand(mc,T)
%returns a random state sequence from given MarkovChain object.
%
%Input:
%mc=    MarkovChain object
%T= scalar defining maximum length of desired state sequence.
%   An infinite-duration MarkovChain always generates sequence of length=T
%   A finite-duration MarkovChain may return a shorter sequence,
%   if END state was reached before T samples.
%
%Result:
%S= integer row vector with random state sequence,
%   NOT INCLUDING the END state,
%   even if encountered within T samples
%If mc has INFINITE duration,
%   length(S) == T
%If mc has FINITE duration,
%   length(S) <= T
%
%Arne Leijon 2009-08-16 tested
%Gustav Eje Henter 2012-08-09 typo fix

%***** Should allow unspecified T, if mc.finiteDuration? *****

function S=rand(mc,T)
nStates=length(mc.InitialProb);
S=zeros(1,T);
pState=mc.InitialProb;
%temporarily create DiscreteD objects instead?????
for t=1:T
	state=RandDiscrete(pState);%choose one state at random
	if state>nStates%we have reached the END state of a finite-duration HMM
		break;end;
	S(t)=state;%store it for result
	pState=mc.TransitionProb(state,:)';%state prob distribution for next sample
end;
S=S(S>0);%in case exit was reached before desired sequence length


function X=RandDiscrete(p)
%generate X=random integer, given probability mass distributions= p
%p=column vector(s) with probabilities. 
%sum(p) must be ==1 in each column

%Arne Leijon 2001-07-23

limits=cumsum(p);
%r=rand;%uniformly distributed (0,1)
r=rand(1,size(p,2));%one for each input column
X=1+sum(repmat(r,size(limits,1),1)>limits);

