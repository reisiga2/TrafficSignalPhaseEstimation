% this function generate an initial HMM parameters. 

% input: phases

%output: an HMM to start the training. 

function initialHmm = ...
    initiateIntersectionHMM(data,phases,transitionProb_from_i_to_j,illegalManeuverProb,methodFlag)

% set method flag to zero to set initials similar for every leg. 
if nargin<5
    methodFlag =1;
end

mc = initiate_MarkovChain(phases,transitionProb_from_i_to_j);% initial Markov Chain 

if methodFlag==1
     emissinDiscreteD=give_initialEmission_useData(data,phases,illegalManeuverProb);
else
    
[emissinMatrix, emissinDiscreteD] =...
    give_initial_emissionProbs(phases,illegalManeuverProb); % initial Emission Distribution
end
initialHmm = HMM(mc ,emissinDiscreteD);
end