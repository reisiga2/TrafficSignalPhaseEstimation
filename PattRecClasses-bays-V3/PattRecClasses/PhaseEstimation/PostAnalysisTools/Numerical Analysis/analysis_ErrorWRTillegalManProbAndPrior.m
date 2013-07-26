% This script shows how the changes in dwelling and transition weights in
% the prior distribution influece the inference. we used syntehtic data
% generated for a fixed time signal with three phases at a four way interesection


clear all
close all

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection, 1: consider right turns.
partPhases = phases(1:8,:); 

iteration = 10; 

emissionProbs = [0 1 0 39 5 5 0 1 0 39 5 5;...
                 39 5 5 0 1 0 39 5 5 0 1 0;...
                 0 1 0 0 1 48 0 1 0 0 1 48]; % data generated based on these ratios. we considered three phase intersection.
 
  %Case B: some illegal maneuver

%  emissionProbs = [1 2 1 36 5 5 1 2 1 36 5 5;...
%                  36 5 5 1 2 1 36 5 5 1 2 1;...
%                  1 2 1 1 2 43 1 2 1 1 2 43];


for i = 1:iteration
tic;
    data = ...
    loadIntersectionData('syntethicFixedTime',[], 0,...
    [1 2 3],emissionProbs,[10 10],[10 10 5; 25 25 10],... %[10 10] gives min and max num of cycles.
    [],[],[],[]);    % generate a synthetic data.

    [dwellingWeight, illegalManProb, error] =...
     find_error_WRT_dwellingPara_And_illegalManProb(data, partPhases ,300,...
     1 , 0.1); % calculate errors in inference.
    
    percError = error/size(data,1); % percentage in errors.

    if i==1
       sumError = zeros(size(error,1),size(error,2));  % initiate sumError.
    end
    
    sumError = sumError+percError;
toc;
end


AverageError = (sumError/iteration)*100;  % average error.
X= illegalManProb;
Y= dwellingWeight;

figure
v=[0.2 0.5 0.8 1 5 10 15 20 30 40 50];     
[C,h]= contour(X, Y, AverageError,v);
set(h,'ShowText','on','TextStep',get(h,'LevelStep'))
ylabel('Dwelling Weight');
xlabel('Unallowed Maneuver Probability(%)');
colormap cool
title('Error(%)')


figure
surf(X,Y,AverageError)
xlabel('alpha_d_w_e_l_l ');
ylabel('alpha_t_r_a_n_s');
zlabel('Error(%)');
view([40,25])
