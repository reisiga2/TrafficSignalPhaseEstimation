% infering data phases of neil and kirby...


 clear all
 close all




load KirbyandNeil
data= KirbyandNeil;


[maneuverPercentage, totalTime, phaseList ] = data_statistics(data);

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);

PriorParameters = give_DrichletParameter...
    (partPhases, 1.01,1,1,1);

transitionProb_from_i_to_j=0.01;
illegalManProb=0;

initialHmm = ...
    initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);

generatePlotsOfPhaseSequence('Neil and Kirby',data,maneuverPercentage,inferredPhaseSequence, 1900)

% [dwellingPra, errorbyprior,errorbypriorPercent] = give_errorVSdwellingPram(data,partPhases,...
%     1000, 5); % gives error by changes in prior parameters.
% 
% figure
% plot(dwellingPra, errorbypriorPercent, 'linewidth',2);
% xlabel('Prior Dwelling Parameter');
% ylabel('Error(%)');