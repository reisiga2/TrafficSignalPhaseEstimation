% This script gives errors versus changes in initial transition
% probabilities, in the synthetic data case for a fixed time interesection.
% Here we consider 100 data sets and will take the average over each.

% data sets are generated from 10 cycles.

clear all
close all

DwellingW =300;
transtitionW =1.01;

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection, 1: consider right turns.
partPhases = phases(1:8,:); 

priorParameters = give_DrichletParameter...
    (partPhases,transtitionW ,DwellingW,1,1); % fixed priors. you can change the priors to get different results. 
iteration = 30; 

ProhibitManProb=0;
%case A: No illegal maneuver
% emissionProbs = [0 1 0 39 5 5 0 1 0 39 5 5;...
%                  39 5 5 0 1 0 39 5 5 0 1 0;...
%                  0 1 0 0 1 48 0 1 0 0 1 48]; % data generated based on these ratios. we considered three phase intersection.
% % %Case B: some illegal maneuver
  emissionProbs = [1 2 1 36 5 5 1 2 1 36 5 5;...
                  36 5 5 1 2 1 36 5 5 1 2 1;...
                  1 2 1 1 2 43 1 2 1 1 2 43];
             
sumError=0;

tic;
for i= 1:iteration

data = ...
    loadIntersectionData('syntethicFixedTime',[], 0,...
    [1 2 3],emissionProbs,[10 10],[10 10 5; 25 25 10],... %[10 10] gives min and max num of cycles.
    [],[],[],[]);    % generate a synthetic data.
    
[error,transitionProb_from_i_to_j]=...
    find_errors_vs_initialTransition(data,partPhases,...
    priorParameters,ProhibitManProb,0.02); % find the error

percError = error/size(data,1); % percentage in errors.

    if i==1
       sumError = zeros(1,size(error,2)); 
    end
    
sumError = sumError+percError;

end
toc;

AverageError = (sumError/iteration)*100;% calculate average error in percentage

figure; % plot the error for different valuse of transition probability. 
plot(transitionProb_from_i_to_j,AverageError, 'linewidth',2);
xlabel('Initial Transition probability from state i to state j')
ylabel('error(%)')
title(['Dwelling Weight: ' num2str(DwellingW) ' and Transition Weight: '  num2str(transtitionW)]);

