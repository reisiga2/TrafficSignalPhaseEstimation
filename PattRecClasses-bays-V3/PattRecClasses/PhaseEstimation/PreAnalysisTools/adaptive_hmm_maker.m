% this function find learns an hmm based on an sensor actuated signal 

%the reseon I did not input priors in this function is to keep the prior
%fix for every sensor actuated signal.


function [hmm,prob] = adaptive_hmm_maker(data)

  
    
    phases = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
    partPhases = phases(1:8,:);
    
    PriorParameters = give_DrichletParameter...
    (partPhases, 1.001,1.01,1);% change the function input to get different results.
    transitionMatrix = xlsread('adaptivePrior_FourWay.xlsx'); % use this
   % to get the better results. 



%     transitionProb_from_i_to_j=0.05;
%     illegalManProb=0;
%      initialHmm = ...
%          initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);
%      initialHmm = make_initial_HMM_from_DirichletParameters...
%     (PriorParameters.initials, PriorParameters.transitionMatrix,...
%     PriorParameters.emissionMatrix);

 initialHmm = make_initial_HMM_from_DirichletParameters...
    (PriorParameters.initials, transitionMatrix,...
    PriorParameters.emissionMatrix);
    

%     [hmm,prob] = train(initialHmm,(data(:,1))',size((data(:,1)),1),...
%         PriorParameters.initials,PriorParameters.transitionMatrix,...
%         PriorParameters.emissionMatrix);

  [hmm,prob] = train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,transitionMatrix,...
        PriorParameters.emissionMatrix);

end

%this is another set of initial hmm.

%     initialProbs=[0.1250 0.1250 0.1250 0.1250 0.1250 0.1250 0.1250 0.1250];
%     mcProbs=xlsread('AdaptiveInitialTransProbs.xlsx'); % initial markov chain transition probs
%     emissionPrbs=xlsread('AdaptiveInitialEmissionProbs.xlsx');% emission probs for initial hmm
% 
%     mc = MarkovChain(initialProbs,mcProbs);
%     emissions = DiscreteD(emissionPrbs);
%     initialHmm= HMM(mc, emissions);