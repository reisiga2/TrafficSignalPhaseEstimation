% this functin find the hmm for a fixed time intersection. It has its own
% priors and initial values. This is becasue we are interested to have
% these values fixed for every interesectin with same type of controller.


function [hmm, prob] = fixedTime_hmm_maker(data)
        
    phases  = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
    partPhases = phases(1:8,:);

    PriorParameters = give_DrichletParameter...
    (partPhases, 1.01,300,1);

    transitionProb_from_i_to_j=0.001;
    illegalManProb=0;

    initialHmm = ...
    initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);

    [hmm,prob] = train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        




end