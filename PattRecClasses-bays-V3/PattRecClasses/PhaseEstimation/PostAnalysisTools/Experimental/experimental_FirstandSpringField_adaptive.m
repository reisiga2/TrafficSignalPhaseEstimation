% this script is to infere phases for the green and first. This is a two
% phase intersection.

 clear all
 close all



maneuverIDList_Frist_SpringField = [36289,68481,68510,68482,68491,...
    36290,68492,68511,68483,68509,36288,68490];

data =  ...
    loadIntersectionData('SpringField-First_AdaptiveSignal.xlsx',...
    maneuverIDList_Frist_SpringField, 1,...
    [],[],[],[],[],[],[],[]);% 

data = data(1:200,:); % becasue I only manually labeled first 500 maneuvers.

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);

PriorParameters = give_DrichletParameter...
    (partPhases, 10,10,4,1);% change the function input to get different results.

transitionProb_from_i_to_j=0.01;
illegalManProb=0;

initialHmm = ...
    initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);

generatePlotsOfPhaseSequence('Prospect and University',data,inferredPhaseSequence, 200)
