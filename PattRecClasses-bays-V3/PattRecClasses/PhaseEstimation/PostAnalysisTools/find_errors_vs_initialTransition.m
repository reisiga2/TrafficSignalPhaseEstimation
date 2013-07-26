% this function give errors in inference with respect to changes in off
% diagonal values of transition probabilities. 




function [error,transitionProb_from_i_to_j]=...
    find_errors_vs_initialTransition(data,phases,PriorParameters,illegalManProb,eps)

maxMesh = 1/size(phases,1); % maximum value that transition probability can take

if(eps>maxMesh)
    eps= maxMesh-0.000001;
end



transitionProb_from_i_to_j = 0.000001:eps:maxMesh;
    error =zeros(1,size(transitionProb_from_i_to_j,2));
    
    
    tic;
    for i=1:size(transitionProb_from_i_to_j,2)
        initialHmm = ...
    initiateIntersectionHMM(data,phases,transitionProb_from_i_to_j(i),illegalManProb);

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error(i)= find_error(data,inferredPhaseSequence);
    
 % to see how where the errors occur you can uncomment the following.    
%     figure 
%     plot(inferredPhaseSequence,'*')
%     hold on
%     plot(data(:,3),'o', 'MarkerEdgeColor','r');

    end
    
    toc;


end