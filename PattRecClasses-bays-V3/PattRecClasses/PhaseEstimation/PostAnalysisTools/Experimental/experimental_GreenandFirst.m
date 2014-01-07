% this script is to infere phases for the green and first. This is a two
% phase intersection.

 clear all
 close all



maneuverIDList_Frist_Green = [68528,68531,68522,68524,68515,68530,....
    68514,68533,68523,68532,68529,68513];

[data,numdataFiltered] =  ...
    loadIntersectionData('GreenandFirst-gameData.xlsx',...
    maneuverIDList_Frist_Green, 0,...
    [],[],[],[],[],[],[],[]);% change 0 t0 1 if you want to pre-filter data

data = data(1:500,:); % becasue I only manually labeled first 500 maneuvers.

data=removeRightTurns(data); % remove right turns here.

[maneuverPercentage, totalTime, phaseList ] = data_statistics(data);

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);

PriorParameters = give_DrichletParameter...
    (partPhases, 1.01,300,1,1);

transitionProb_from_i_to_j=0.01;
illegalManProb=0;

initialHmm = ...
    initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);

generatePlotsOfPhaseSequence('Green and First',data,maneuverPercentage,inferredPhaseSequence, 500)

[dwellingPra, errorbyprior,errorbypriorPercent] = give_errorVSdwellingPram(data,partPhases,...
    1000, 5); % gives error by changes in prior parameters.

figure
plot(dwellingPra, errorbypriorPercent, 'linewidth',2);
xlabel('Prior Dwelling Parameter');
ylabel('Error(%)');

