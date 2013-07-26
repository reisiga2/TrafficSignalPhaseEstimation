%hmm=adaptSet(hmm,aState)
%method to finally adapt a single HMM object
%using accumulated statistics from observed training data sets.
%
%Input:
%hmm=       single HMM object
%aState=    accumulated statistics from previous calls of adaptAccum
%eta_init=  prior parameters for initial proabilities. 
%eta_transition: prior parameters for transition probabilitiess
%nu = prior parameters for outcomes.
% all the priors are considered to be Dirichlet distributions.

%
%Result:
%hmm=       adapted version of the HMM object
%
%Theory and Method:    
%
%Arne Leijon 2009-07-23 tested

function hmm=adaptSet(hmm,aState,eta_init,eta_transition,nu)

% Prune unused states (probably doesn't work with MarkovChainES)
%Gustav Eje Henter 2011-11-21 untested
%unused = (sum(aState.MC.pS,2) <= 0);
%if any(unused),
%    keep = ~unused;
%    aState.MC.pI = aState.MC.pI(keep);
%    aState.MC.pS = aState.MC.pS(keep,...
%        setdiff(1:size(aState.MC.pS,2),find(unused)));
%    hmm.OutputDistr = hmm.OutputDistr(keep);
%    aState.Out = aState.Out(keep);
%end

% Dispatch to sub-objects
hmm.StateGen=adaptSet(hmm.StateGen, aState.MC, eta_init, eta_transition);
hmm.OutputDistr=adaptSet(hmm.OutputDistr, aState.Out, nu);