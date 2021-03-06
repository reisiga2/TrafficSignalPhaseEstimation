% This script shows how the changes in dwelling and transition weights in
% the prior distribution influece the inference. we used syntehtic data
% generated for a fixed time signal with three phases at a four way interesection


clear all
close all

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection, 1: consider right turns.
partPhases = phases(1:8,:); 
phaseSequenceLength=20;
iteration = 1; 

% case A: No illegal maneuver
emissionProbs = [0 1 0 39 5 5 0 1 0 39 5 5;...
                 39 5 5 0 1 0 39 5 5 0 1 0;...
                 0 1 0 0 1 48 0 1 0 0 1 48]; % data generated based on these ratios. we considered three phase intersection.
% %Case B: some illegal maneuver

%  emissionProbs = [1 2 1 36 5 5 1 2 1 36 5 5;...
%                  36 5 5 1 2 1 36 5 5 1 2 1;...
%                  1 2 1 1 2 43 1 2 1 1 2 43];


for i = 1:iteration
tic;
% fixed time intersection.    
% data = ...
%     loadIntersectionData('syntethicFixedTime',[], 0,...
%     [1 2 3],emissionProbs,[10 10],[10 10 5; 25 25 10],... %[10 10] gives min and max num of cycles.
%     [],[],[],[]);    % generate a synthetic data.

%sensor actuated intersection...
data = make_adaptive_synthData_semiHMM(phaseSequenceLength);


    [dwellingWeight, transitionWeight, error] =...
    find_errorVSPriorParameters(data, partPhases ,500, 10 , 0.5); % calculate errors in inference.
    
    percError = error/size(data,1); % percentage in errors.

    if i==1
       sumError = zeros(size(error,1),size(error,2));  % initiate sumError.
    end
    
    sumError = sumError+percError;
toc;
end


AverageError = (sumError/iteration)*100;  % average error.
X= transitionWeight;
Y= dwellingWeight;

v=[0.2 0.5 0.8 1 5 10 15 20 30 40 50];     
[C,h]= contour(X, Y, AverageError,v);
set(h,'ShowText','on','TextStep',get(h,'LevelStep'))
ylabel('Dwelling Weight');
xlabel('Transition weight');
colormap cool
title('Error(%)')


figure
surf(X,Y,AverageError)
xlabel('alpha_d_w_e_l_l ');
ylabel('alpha_t_r_a_n_s');
zlabel('Error(%)');
view([40,25])

figure
% this generates a 2d  plot with colors .
errorAverageFlipped =  fliprows(AverageError) ;
imagesc(X,Y,errorAverageFlipped)
colorbar;
caxis([0, 10]);
xlim([1,9]);
ylim([1,500]);
gca()
xlabel('\mu_t ');
ylabel('\mu_d');
title('Error(%), C_s=8000, C_t=2000, C_p=1')
set(gca,'YTickLabel',{'450','400','350','300','250','200','150','100','50','1'})
