% this script is to infere phases for the green and first. This is a two
% phase intersection.

 clear all
 close all


maneuverIDList_Frist_SpringField = [36289,68481,68510,68482,68491,...
    36290,68492,68511,68483,68509,36288,68490];

data =  ...
    loadIntersectionData('SpringField-First_AdaptiveSignal.xlsx',...
    maneuverIDList_Frist_SpringField, 1,...
    [],[],[],[],[],[],[],[]); 

data = data(1:100,:); % becasue I only manually labeled first 200 maneuvers.
%data=removeRightTurns(data); % remove right turns here.
[maneuverPercentage, totalTime, phaseList ] = data_statistics(data);
%-------------------------------------------------------------------
%-------------------------------------------------------------------
% adaptive hmm to find
[hmm_adaptive,probability_adaptive]= adaptive_hmm_maker(data);

inferredPhaseSequence_adaptive = viterbi(hmm_adaptive ,(data(:,1))' );

[error_adaptive,errorPercentage_adaptive]= find_error(data,inferredPhaseSequence_adaptive);
    
errorData_adaptive = find_error_indeces(data,inferredPhaseSequence_adaptive);
 
 generatePlotsOfPhaseSequence('First and Springfield',data,...
    maneuverPercentage,inferredPhaseSequence_adaptive, size(data,1));

% --------------------------------------------------------------------
% --------------------------------------------------------------------

%fixed time hmm 
[hmm_fix,probability_fix]= fixedTime_hmm_maker(data);


inferredPhaseSequence_fix = viterbi(hmm_fix ,(data(:,1))' );

 [error_fix,errorPercentage_fix]= find_error(data,inferredPhaseSequence_fix);
    
 errorData_fix = find_error_indeces(data,inferredPhaseSequence_fix);
 
 generatePlotsOfPhaseSequence('Neil and Kirby',data,...
    maneuverPercentage,inferredPhaseSequence_fix, size(data,1));


%---------------------------------------------------------------
%----------------------------------------------------------------

% [phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
% partPhases = phases(1:8,:);
% 
%  PriorParameters = give_DrichletParameter...
%      (partPhases, 1.001,1.2,1,1);% change the function input to get different results.
% 
% transitionMatrix =xlsread('adaptivePrior_FourWay.xlsx');
% 
% % transitionProb_from_i_to_j=0.1;
% % illegalManProb=0;
%  
% % Becasue of the particular structure of the adaptive signals, and the
% % knowledge that some transitions are not possibles, I used different
% % initial HMM to prevent some unlikely transitions.
% 
% initialProbs=[0.1250 0.1250 0.1250 0.1250 0.1250 0.1250 0.1250 0.1250];
% mcProbs=xlsread('AdaptiveInitialTransProbs.xlsx'); % initial markov chain transition probs
% emissionPrbs=xlsread('AdaptiveInitialEmissionProbs.xlsx');% emission probs for initial hmm
% 
% mc = MarkovChain(initialProbs,mcProbs);
% emissions = DiscreteD(emissionPrbs);
% % initialHmm = ...
% %     initiateIntersectionHMM(data,partPhases,transitionProb_from_i_to_j,illegalManProb);
% 
%     initialHmm= HMM(mc, emissions);
% 
% %    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
% %         PriorParameters.initials,transitionMatrix,...
% %         PriorParameters.emissionMatrix);
%      
%     
%     
% 
% 
% %     but this HMM does not completely impose all the constraints in most
% %     of the adaptive signals. here we make some of the transition
% %     probabilities zero becasue they never appear in real adaptive
% %     signals.
% % %     
% %    iteration=10; 
% %     
% %    for i=1:iteration 
% %    hmm = modify_hmm_for_adaptiveSignals(hmm);
% %     
% %    %we learn hmm again and will modify it again 
% %      hmm=train(hmm,(data(:,1))',size((data(:,1)),1),...
% %         PriorParameters.initials,PriorParameters.transitionMatrix,...
% %         PriorParameters.emissionMatrix);
% %    
% %     hmm = modify_hmm_for_adaptiveSignals(hmm);
% %    end
% %     
% %    % now we use new hmm to infer phases.   
%     
%    
