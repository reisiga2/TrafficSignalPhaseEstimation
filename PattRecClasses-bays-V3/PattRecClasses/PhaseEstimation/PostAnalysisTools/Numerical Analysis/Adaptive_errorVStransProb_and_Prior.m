% this script gives the changes of error with respect to the transition
% probs and Drichlet parameters.

clear all
close all

[phases, numPhases] = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:);
phaseSequenceLength=20;
illegalManProb=0;
transPara=1.01;
dwellPara =1:0.1:2;
transitionProb_from_i_to_j=0.00001:0.01:0.1;
iteration = 30;

 averageError= zeros(size(dwellPara,2),size(transitionProb_from_i_to_j,2));
 
    for i=1:size(dwellPara,2)
        tic;
        for j=1:size(transitionProb_from_i_to_j,2)
           errorSum=0;
            for k=1:iteration

                data = make_adaptive_synthData_semiHMM(phaseSequenceLength);
                PriorParameters = give_DrichletParameter...
                                    (partPhases, transPara,dwellPara(i),1,1);

                 initialHmm = ...
                     initiateIntersectionHMM(data,partPhases,...
                     transitionProb_from_i_to_j(j),illegalManProb);

                 hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
                    PriorParameters.initials,PriorParameters.transitionMatrix,...
                    PriorParameters.emissionMatrix);
        
    
                 inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

                [error,errorpercentage ]= find_error(data,inferredPhaseSequence);
                errorSum = errorSum + errorpercentage;
            end
            
                averageError(i,j)=errorSum/iteration;
        end
        toc;
    end
    
    