% this script is to evaluate the error with respect to number of cycles at
% the intersection of a one way street with a two way street.  here we need
% to set the phases. as we did in our the conference  paper. 

clear all
close all
clc;

allPhases = [ 0 0 0 0 0 0 0 0 0 1 1 1;...
            0 0 0 0 0 0 0 0 0 1 1 0;...
            0 0 0 0 0 0 0 0 0 0 0 1;...
            1 0 0 0 0 0 1 1 0 0 0 0;...
            1 0 1 0 0 0 1 1 0 0 0 0;...
            1 0 1 0 0 0 0 0 0 0 0 0;...
            0 0 1 0 0 0 0 0 0 0 0 0] ;

maxNumCycle = 50;
GeneratingPhases = [1,5]; % we generate phaes from phases 1 and 5. 
numManeuver =[5 5; 27 27];
iteration = 30;
initail_transitionProb_from_i_to_j_unif =0.1429;
initail_transitionProb_from_i_to_j=0.01;
initail_illegal_Man_Prob=1;

DiricParam = give_DrichletParameter...
    (allPhases, 1.01,1,1,1);

emissionProbsGenData = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 58.1 16  25;...
                        35  0.1 14.2 0.1 0.1 0.1 35 15 0.1 0.1 0.1 0.1]; % change this values to generate data differently or with more number of phases


% this is to get the errors for uniform distributed transitio probabiliteis
[numCycle_unif,averageError_unif ,averagePercError_unif] = ...
    find_error_vs_numCycles(allPhases, DiricParam,...
maxNumCycle,GeneratingPhases,emissionProbsGenData,numManeuver,iteration,...
     initail_transitionProb_from_i_to_j_unif, initail_illegal_Man_Prob);
 
 % this is to get the errors for traffic specific transition probs.
[numCycle,averageError ,averagePercError] = ...
    find_error_vs_numCycles(allPhases, DiricParam,...
maxNumCycle,GeneratingPhases,emissionProbsGenData,numManeuver,iteration,...
     initail_transitionProb_from_i_to_j, initail_illegal_Man_Prob);
 
 
 figure
 plot(numCycle,averagePercError,'--r', 'lineWidth',2);
 hold on
 plot(numCycle,averagePercError_unif,'lineWidth',2)
 xlabel('Number of cycles spanning training dataset')
 ylabel('Error(%)');
 legend('a_i_i=0.94', 'a_i_i=0.1429')
 
 