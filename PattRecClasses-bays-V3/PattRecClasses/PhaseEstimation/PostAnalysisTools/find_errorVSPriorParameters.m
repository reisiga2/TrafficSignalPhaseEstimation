% This function calculates the error with respect to the prior parameters. 
% set eps larger that 0.1 to have a faster run.

function [dwellingWeight, transitionWeight, error] =...
    find_errorVSPriorParameters(data, phases,maxDwellingWeight, maxTransitionWeight,eps)
    
    if nargin<5
       eps = 0.1; 
    end
    
    eps2=eps*10; % use different mesh size
    
   dwellingWeight = 1:eps2: maxDwellingWeight;% mesh
   transitionWeight = 1.001:eps:maxTransitionWeight;% mesh
   
      
   error = zeros(size(dwellingWeight,2),size(transitionWeight,2));
   
   
   for i=1: size(dwellingWeight,2)
      
       for j=1: size(transitionWeight,2)
        
         PriorParameters = give_DrichletParameter...
    (phases,transitionWeight(j) ,dwellingWeight(i),1, 2000,8000); % set the priors base on the values of of dwelling and transition weights.

           initialHmm = make_initial_HMM_from_DirichletParameters...
    (PriorParameters.initials, PriorParameters.transitionMatrix,...
    PriorParameters.emissionMatrix); % set initial HMM

    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix); % train the hmm
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' ); % infer phases from the trained HMM

    error(i,j)= find_error(data,inferredPhaseSequence); % calculate error.
      
       
       end
       
       
   end
  



end