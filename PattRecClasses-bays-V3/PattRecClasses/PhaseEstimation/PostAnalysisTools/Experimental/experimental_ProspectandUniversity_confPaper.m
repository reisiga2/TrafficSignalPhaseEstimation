% this script is to infere phases for the prospect and university
% intersection. Since this intersection is not a four way intersection, and
% the phases in the conference paper defined differently one should
% enumerate phases manually.  


 clear all
 close all



maneuverIDList_Prospect_and_University= [63121, 0,63127, 0, 0, 0,...
    63106, 63128, 0, 63129, 63123, 63108];

[data,numdataFiltered] =  ...
    loadIntersectionData('April3_UniveandProsp2.xlsx',...
    maneuverIDList_Prospect_and_University, 0,...
    [],[],[],[],[],[],[],[]);

[maneuverPercentage, totalTime, phaseList ] = data_statistics(data);

data = data(1:300,:);

phases =[ 0 0 0 0 0 0 0 0 0 1 1 1;...
          0 0 0 0 0 0 0 0 0 1 1 0;...
          0 0 0 0 0 0 0 0 0 0 0 1;...
          1 0 0 0 0 0 1 1 0 0 0 0;...
          1 0 1 0 0 0 1 1 0 0 0 0;...
          1 0 1 0 0 0 0 0 0 0 0 0;...
          0 0 1 0 0 0 0 0 0 0 0 0] ;

% PriorParameters = give_DrichletParameter...
%     (phases, 1.01,1.01,1.001,1,1);% 2000000,80000000); for BW

PriorParameters = give_DrichletParameter...
    (phases, 1.01,20,1.001,2000000,80000000); % for bayesian

transitionProb_from_i_to_j=0.02;
illegalManProb=0;

 initialHmm = ...
    initiateIntersectionHMM(data,phases,transitionProb_from_i_to_j,illegalManProb);

%  initialHmm = make_initial_HMM_from_DirichletParameters...
%     (PriorParameters.initials, PriorParameters.transitionMatrix,...
%     PriorParameters.emissionMatrix);

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);

generatePlotsOfPhaseSequence('Prospect and University',data,maneuverPercentage,inferredPhaseSequence, 300)

[dwellingPra, errorbyprior,errorbypriorPercent] = give_errorVSdwellingPram(data,phases,...
    1000, 5); % gives error by changes in prior parameters.


% figure
% plot(dwellingPra, errorbypriorPercent, 'linewidth',2);
% xlabel('Prior Dwelling Parameter');
% ylabel('Error(%)');
