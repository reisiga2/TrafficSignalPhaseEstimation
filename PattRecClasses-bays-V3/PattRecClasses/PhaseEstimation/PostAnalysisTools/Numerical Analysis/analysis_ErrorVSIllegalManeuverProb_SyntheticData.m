% This script investigate how the changes of illegal maneuver probabilities 
% in initial HMM affects the results in synthetic data. we considered a
% fixed time four way intersection with three phases. 

clear all
close all

DwellingW =1;
transtitionW =1.01;

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection, 1: consider right turns.
partPhases = phases(1:8,:); 

priorParameters = give_DrichletParameter...
    (partPhases, transtitionW ,DwellingW ,1,1); % fixed priors. you can change the priors to get different results. 

iteration = 30; 

% % %Case A: No illegal maneuver
% emissionProbs = [0 1 0 39 5 5 0 1 0 39 5 5;...
%                  39 5 5 0 1 0 39 5 5 0 1 0;...
%                  0 1 0 0 1 48 0 1 0 0 1 48]; % data generated based on these ratios. we considered three phase intersection.
           
 %Case B: some illegal maneuver
emissionProbs = [1 2 1 36 5 5 1 2 1 36 5 5;...
                  36 5 5 1 2 1 36 5 5 1 2 1;...
                  1 2 1 1 2 43 1 2 1 1 2 43];    
             
tic;
for i= 1:iteration

data = ...
    loadIntersectionData('syntethicFixedTime',[], 0,...
    [1 2 3],emissionProbs,[10 10],[10 10 5; 25 25 10],... %[10 10] gives min and max num of cycles.
    [],[],[],[]);    % generate a synthetic data.
    
[illegalManProb,error]=give_ErrorVSIllegalManeuverProb....
    (data,partPhases,priorParameters,0.1);

percError = error/size(data,1); % percentage in errors.

    if i==1
       sumError = zeros(1,size(error,2)); 
    end
    
sumError = sumError+percError;

end
toc;

AverageError = (sumError/iteration)*100;% calculate average error in percentage

figure; % plot the error for different valuse of transition probability. 
plot(illegalManProb,AverageError, 'linewidth',2);
xlabel('Probability of an illegal maneuvar (%)')
ylabel('error(%)')
title(['Dwelling Weight: ' num2str(DwellingW) ' and Transition Weight: '  num2str(transtitionW)]);
