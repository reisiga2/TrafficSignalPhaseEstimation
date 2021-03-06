% This function Uses the phases and generates initial outcome
% probabilities (emission probability).

% Input: phases as a matrix where each row specify a phase and each column
% specify a maneuver. The matrix has to have 12 columns. 
% in a row, if a maneuver exists set the value to be 1 and if it is not
% allowed set the value to 0.

%illegalManeuverProb: the probability of an illegal maneuver specify by
%user. This should be number from 0 to 100. 

% the arrangement of the maneuvers should be as following: 
%SBT=1, SBR=2, SBL=3,
%WBT=4, WBR=5, WBL=6,
%NBT=7, NBR=8, NBL=9,
%EBT=10, EBR=11, EBL=12.


% output is a matrix with the probabilities. It is also output the
% probabilities as a DiscreteD class.


function [emissinMatrix, emissinDiscreteD] = ...
    give_initial_emissionProbs(phases,illegalManeuverProb)

    if size(phases,2)~=12
        error('there should be 12 maneuvers specified in one phase');
    end   

throughManeuverIndex = [1, 4 , 7, 10];
turnManeuverIndex = [2 3 5 6 8 9 11 12];
    
straightThroghManWeight =3;
    
    emissinMatrix = zeros(size(phases,1),size(phases,2));

    for i= 1:size(phases,1)
        numStraightThroughMan = find_num_straightThroughMan(phases(i,:));
        numTurnMans = sum(phases(i,:))-numStraightThroughMan;
        
        weightednumofMans =  numStraightThroughMan*straightThroghManWeight...
            +numTurnMans;
        
        turnManeuverProbs = (100-(size(phases,2)- sum(phases(i,:)))...
            *illegalManeuverProb)/weightednumofMans;
        %turnManeuverProbs =turnManeuverProbs /100; % normalize 
        
        throghManeuverProbs = turnManeuverProbs*straightThroghManWeight;
        %throghManeuverProbs =throghManeuverProbs/100; % normalize.
        
        emissinMatrix(i,throughManeuverIndex)= throghManeuverProbs...
            *phases(i,throughManeuverIndex);% set the probability of throgh maneuvers
        
        emissinMatrix(i,turnManeuverIndex)=  turnManeuverProbs...
            *phases(i,turnManeuverIndex); % set the probability of turn movements
        
        illegalManeuverIdex = phases(i,:) == 0;
        emissinMatrix(i,illegalManeuverIdex)=illegalManeuverProb; % set the probability of illegal maneuvers.
        
        emissinDiscreteD(i)=DiscreteD(emissinMatrix(i,:));
    
    end
        
        
    

    

end
