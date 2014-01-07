% this script check the phases of Neil and kirby using two sets of priors,
% one with fixed time priors and one with adaptive priors. we are
% interested to see if one of the fits better to the data.

 clear all
 close all

data = xlsread('NeilandKirby.xlsx');

[maneuverPercentage, totalTime, phaseList] = data_statistics(data);

%data=removeRightTurns(data); % remove right turns here.
data=data(1:225,:);


%----------------------------------------------------------------------
% adaptive hmm to find
[hmm_adaptive,probability_adaptive]= adaptive_hmm_maker(data);


inferredPhaseSequence_adaptive = viterbi(hmm_adaptive ,(data(:,1))' );



  [error_adaptive,errorPercentage_adaptive]= find_error(data,inferredPhaseSequence_adaptive);
%     
  errorData_adaptive = find_error_indeces(data,inferredPhaseSequence_adaptive);
%  figure
%  plot(-probability_adaptive);
%  title('Sensor actuated')
%  xlabel('Iteration');
%  xlim([0,9]);
%  ylabel('-ln(pr(O|lamda))')
%  
 generatePlotsOfPhaseSequence('Neil and Kirby',data,...
    maneuverPercentage,inferredPhaseSequence_adaptive, size(data,1));

%-------------------------------------------------------------
%fixed time hmm 
%  phases  = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
%     partPhases = phases(1:8,:);
% 
% 
% [hmm_fix,probability_fix]= fixedTime_hmm_maker(data);
% inferredPhaseSequence_fix = viterbi(hmm_fix ,(data(:,1))' );
% dataWithPhases=[data,inferredPhaseSequence_fix'];
%  [error_fix,errorPercentage_fix]= find_error(data,inferredPhaseSequence_fix);
%     
%  errorData_fix = find_error_indeces(data,inferredPhaseSequence_fix);
%  figure
%  plot(-probability_fix, 'linewidth', 2);
%  title('fixed time')
%   xlabel('Iteration');
%  xlim([1,10]);
%  ylabel('-ln(pr(O|lamda))')
%  
%  generatePlotsOfPhaseSequence('Neil and Kirby',data,...
%     maneuverPercentage,inferredPhaseSequence_fix, size(data,1));
%  
