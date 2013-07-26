% this script tests data generation, phase generation, prior parameter
% generation, and plots errors with respect to changes in tranition probs.

clear all
close all

% maneuverIDList_fourth_kirby = [69050,69044,69079,...
%     69046,68914,69052,68913,69081,69045,69080,69051,68912];
% 
% data =  ...
%     loadIntersectionData('kirbyFourth.xlsx',...
%     maneuverIDList_fourth_kirby, 1,...
%     [],[],[],[],[],[],[],[]);

emissionProbs =[0 0 0 35 10 5 0 0 0 35 10 5;...
                35 5 10 0 0 0 35 10 5 0 0 0
                0 0 0 0 0 50 0 0 0 0 0 50]; % based on this emission probabilities data will be generated. 

data= ...
    loadIntersectionData('syntethicFixedTime',[], 0,...
    [1 2 3],emissionProbs,[2 10],[5 5 2; 25 25 6],...
    [],[],[],[]);

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);

priorParameters = give_DrichletParameter...
    (partPhases, 1.01,1000,1,1);

[transitionProb_from_i_to_j,error]=...
    find_errors_vs_initialTransition(data,partPhases,priorParameters,0.005);

figure;
plot(transitionProb_from_i_to_j,error, 'linewidth', 2);

