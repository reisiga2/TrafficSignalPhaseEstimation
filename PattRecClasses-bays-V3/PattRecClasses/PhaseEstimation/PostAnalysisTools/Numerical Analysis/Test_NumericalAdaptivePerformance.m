% this script test the performance of HMM with adaptive signals.


clear all
close all

phaseSequenceLength=100;
data = make_adaptive_synthData_semiHMM(phaseSequenceLength);

[maneuverPercentage, totalTime, phaseList ] = data_statistics(data);

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);

transPara=1.01;
dwellPara =10;

PriorParameters = give_DrichletParameter...
    (partPhases, transPara,dwellPara,1,1);

transitionProb_from_i_to_j=0.01;
illegalManProb=0;

initialHmm = ...
    initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);
    errorpercentage = error*100/size(data,1);

generatePlotsOfPhaseSequence('Neil and Kirby',data,maneuverPercentage,inferredPhaseSequence, size(data,1))

