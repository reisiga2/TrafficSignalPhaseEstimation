% this is to test if the our classification speculation works well in
% thenumerical setting.

clear all
close all

    %fixed time hmm 
 phases  = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
    partPhases = phases(1:8,:);
    PriorParameters = give_DrichletParameter...
                                    (partPhases, transPara,dwellPara,1);
    

emissionProbs = [0 1 0 39 5 5 0 1 0 39 5 5;...
                 39 5 5 0 1 0 39 5 5 0 1 0;...
                 0 1 0 0 1 48 0 1 0 0 1 48];

numTests =5 ;



 figure
 hold on

for i=1:numTests
        

% fixed time data...
%  data = ... 
%     loadIntersectionData('syntethicFixedTime',[], 0,...
%     [1 2 3],emissionProbs,[10 10],[10 10 5; 25 25 10],... %[10 10] gives min and max num of cycles.
%     [],[],[],[]);

% adaptive data..
dataSize= floor(10000*rand())+10;
data= make_adaptive_synth_Data_fromHMM(dataSize);


[hmm_fix,probability_fix] = fixedTime_hmm_maker(data);
[S_fix,logP_fix]=viterbi(hmm_fix,(data(:,1))');

% [hmm_adaptive,probability_adaptive]= adaptive_hmm_maker(data);
% [S_adaptive,logP_adaptive]=viterbi(hmm_adaptive,(data(:,1))');
% inferredPhaseSequence_fix = viterbi(hmm_fix ,(data(:,1))' );
% dataWithPhases=[data,inferredPhaseSequence_fix'];
%  [error_fix,errorPercentage_fix]= find_error(data,inferredPhaseSequence_fix);
%  
% 
 plot(-probability_fix, 'linewidth', 2);
 
%    generatePlotsOfPhaseSequence('Neil and Kirby',data,...
%     maneuverPercentage,inferredPhaseSequence_fix, size(data,1));
%     
end
 title('fixed time')
 xlabel('Iteration');
 xlim([1,10]);
 ylabel('-ln(pr(O|lamda))')