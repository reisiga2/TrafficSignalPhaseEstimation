%This script is to show how sensitive the results are to the sparse
%maneuvers. 

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

numCycle = [20,20];
GeneratingPhases = [1,5]; % we generate phaes from phases 1 and 5. 
numManeuver =[5 5; 27 27];
iteration = 30;

initail_transitionProb_from_i_to_j=0.01;
initail_illegal_Man_Prob=1;

DiricParam = give_DrichletParameter...
    (allPhases, 1.01,300,1,1);
eps =1; % mesh size
k=0;
maxDelta=14;

AverageEp = zeros(1,maxDelta*(1/eps)+(1/eps));
AverageEm = zeros(1,maxDelta*(1/eps)+(1/eps));

for delta = 0:eps:maxDelta
        k=k+1;    
        
        EpTotal=0;
        EmTotal=0;
        
    for i=1:iteration
        
        
        emissionProbsGenData = [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 58.1 16  25;...
                        35+(delta/2)  0.1 14.2-delta 0.1 0.1 0.1 35+(delta/2) 15 0.1 0.1 0.1 0.1]; 
        
                    
         data = ...
    loadIntersectionData('syntethicFixedTime',[], 0,...
    GeneratingPhases,emissionProbsGenData,numCycle,numManeuver,... 
    [],[],[],[]);    % generate data for that number of cycle

    

    dataSize = size(data,2);
        
    initialHmm = ...
    initiateIntersectionHMM(data,allPhases,initail_transitionProb_from_i_to_j,initail_illegal_Man_Prob); % set initial HMM
       
    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
         DiricParam.initials, DiricParam.transitionMatrix,...
         DiricParam.emissionMatrix); % train the hmm
     
    
     inferredPhaseSequence = viterbi(hmm,(data(:,1))' ); % phase sequence that is inferred by the trained HMM.
     
     [Ep, Em] = Find_TwoType_Errors(data,allPhases, inferredPhaseSequence);
     
      EpTotal = Ep+EpTotal;
      EmTotal= Em+EmTotal;
                    
    end
    
    AverageEp(k) = EpTotal/iteration;
    AverageEm(k) = EmTotal/iteration;
end
    
 ManeuverPercentage= 14.2:-eps:14.2-maxDelta; % 14.2 is the initial value of data generation in emissionProbsGenData;
 figure
 plot(ManeuverPercentage,AverageEp,'--r', 'lineWidth',2);
 hold on
 plot(ManeuverPercentage, AverageEm,'lineWidth',2)
 xlabel('Emission probability of maneuver SBL in phase p_5');
 ylabel('Error(%)');
 legend('Ep', 'Em');
 title('a_i_j=0.01 in the initial HMM, alpha_d_w_e_l_l=300, alpha_t_r_a_n_s=1.01')
 Ylim([0,100]);
 

