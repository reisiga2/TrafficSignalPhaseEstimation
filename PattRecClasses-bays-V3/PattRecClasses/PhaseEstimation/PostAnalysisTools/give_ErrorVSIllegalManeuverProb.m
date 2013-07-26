% this script gives how does the probability of illegal maneuvers in
% initial HMM influence the number of errors. 

% eps: gives size of the mesh. set eps to 0.1 is enouph.

function [illegalManProb,error]=give_ErrorVSIllegalManeuverProb....
    (data,phases,PriorParameters,transitionProb_from_i_to_j,eps) 

if nargin<5
    eps =0.1; %defualt
end


maxIllegalManProb= 2;% set this to any value as you wish. 
illegalManProb = 0:eps:maxIllegalManProb;

error = zeros(1,size(illegalManProb,2));

tic;
    for i=1:size(illegalManProb,2)
                
        initialHmm = ...
    initiateIntersectionHMM(data,phases,transitionProb_from_i_to_j,illegalManProb(i));

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error(i)= find_error(data,inferredPhaseSequence);
    
    end
toc;    
    
end