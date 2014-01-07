% This function is to simplify seting the output distribution prior
% prameters. 


% input :

%phases: phases is a matrix in which number of rows is equal to the number
%of possible phases and number of columns is equal to the number of
%maneuvers (12 maneuvers). Maneuvers are enumerated as following:
%Note:
%SBT=1, SBR=2, SBL=3,
%WBT=4, WBR=5, WBL=6,
%NBT=7, NBR=8, NBL=9,
%EBT=10, EBR=11, EBL=12.

% if a maneuver is not allowed in one phase put zero else put 1.

%legalManeuverWeight: is the parameter that we want to assing to the legal
% maneuvers in one phase. the higher the value the more probable that
% maneuver will be. 

% illegalManeuverWeight, the value of the parameters we want to assign to a illegal
% maneuver in one phase. 


            


function nu_outcome = setDirichletPrior_emissionPara(phases,...,
    legalStraightManeuverWeight,legalTurnManeuverWeight, illegalManeuverWeight)

numPhases= size(phases,1);
numManeuvers = 12;

nu_outcome = zeros(numPhases,numManeuvers);

for i = 1:numPhases
    for j= 1: numManeuvers
        if phases(i,j)== 1 && rem(j,3)==1
            nu_outcome(i,j)= legalStraightManeuverWeight;
        elseif phases(i,j)== 1 && (rem(j,3)==0 || rem(j,3)==2)
            nu_outcome(i,j)= legalTurnManeuverWeight;           
        elseif phases(i,j)== 0
             nu_outcome(i,j)= illegalManeuverWeight;
        end
    end
end


end