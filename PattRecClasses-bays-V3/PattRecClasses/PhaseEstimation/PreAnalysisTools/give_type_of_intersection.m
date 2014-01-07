%This function returns the probability of a sequence of maneuvers for a fixed time hmm and adaptive hmm


function [fix_prob, fix_prob_total,adaptive_prob_total,adaptive_prob_data,...
    estimated_controller_type] =  give_type_of_intersection(data)

% adaptive hmm to find
[hmm_adaptive,adaptive_prob_data]= adaptive_hmm_maker(data);
[phaseSeq1,adaptive_prob_total]=viterbi(hmm_adaptive,(data(:,1))');
%-------------------------------------------------------------
%fixed time hmm 
[hmm_fix,fix_prob]= fixedTime_hmm_maker(data);
[phaseSeq2,fix_prob_total]=viterbi(hmm_fix,(data(:,1))');
%---------------------------------give the type


if fix_prob_total> adaptive_prob_total
    estimated_controller_type='fixe time controller';
else
    estimated_controller_type='sensor actuated controller';
end

end