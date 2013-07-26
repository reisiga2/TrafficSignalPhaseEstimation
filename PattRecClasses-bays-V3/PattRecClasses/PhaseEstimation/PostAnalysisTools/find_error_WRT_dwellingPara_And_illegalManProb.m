% This function calculates the error with respect to the prior dwelling
%parameter and illegal maneuver probabilites. 
% set eps larger than 0.1 to have a faster run.

function [dwellingWeight, illegalManProb, error] =...
    find_error_WRT_dwellingPara_And_illegalManProb(data, phases,maxDwellingWeight, maxIllegalManProb,eps)
    
    if nargin<5
       eps = 0.1; 
    end
    
    eps2=eps*100; % use different mesh size
    
   dwellingWeight = 1:eps2: maxDwellingWeight;% mesh
   illegalManProb = 0:eps:maxIllegalManProb;% mesh
   
   transitionProb_from_i_to_j =0.1; % set a transition prob
    
   
   error = zeros(size(dwellingWeight,2),size( illegalManProb,2));
   
  
   for i=1: size(dwellingWeight,2)
     
       for j=1: size(illegalManProb,2)
        
         PriorParameters = give_DrichletParameter...
    (phases,1.01 ,dwellingWeight(i),1,1); % set the priors base on the values of of dwelling and transition weights.

            initialHmm = ...
    initiateIntersectionHMM(data,phases,transitionProb_from_i_to_j,illegalManProb(j)); % set initial HMM

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix); % train the hmm
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' ); % infer phases from the trained HMM

    error(i,j)= find_error(data,inferredPhaseSequence); % calculate error.
      
       
       end
       
       
   end
   



end