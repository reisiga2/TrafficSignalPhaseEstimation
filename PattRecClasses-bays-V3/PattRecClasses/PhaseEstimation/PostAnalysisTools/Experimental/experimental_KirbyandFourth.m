% this script is to infere phases for the Kirby and fourth
% intersection. 
 clear all
 close all



maneuverIDList_fourth_kirby = [69050,69044,69079,...
    69046,68914,69052,68913,69081,69045,69080,69051,68912];

[data,numdataFiltered] =  ...
    loadIntersectionData('kirbyFourth.xlsx',...
    maneuverIDList_fourth_kirby, 0,...
    [],[],[],[],[],[],[],[]);

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);

[maneuverPercentage, totalTime, phaseList ] = data_statistics(data);

PriorParameters = give_DrichletParameter...
    (partPhases, 1.01,20,1, 200, 800);

transitionProb_from_i_to_j=0.1;
illegalManProb=0;

% initialHmm = ...
%     initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);

 initialHmm = make_initial_HMM_from_DirichletParameters...
    (PriorParameters.initials, PriorParameters.transitionMatrix,...
    PriorParameters.emissionMatrix); % set initial HMM


    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);

generatePlotsOfPhaseSequence('Kirby and Fourth',data,maneuverPercentage,inferredPhaseSequence, 450)


[dwellingPra, errorbyprior,errorbypriorPercent]=...
    give_errorVSdwellingPram(data,partPhases, 1000, 5); % gives error by changes in prior parameters.


% figure
% plot(dwellingPra, errorbypriorPercent, 'linewidth',2);
% xlabel('Prior Dwelling Parameter');
% ylabel('Error(%)');

%title('Kirby and Fourth. alpha_d_w_e_l_l=300 and alpha_t_r_a_n_s=1.01')
