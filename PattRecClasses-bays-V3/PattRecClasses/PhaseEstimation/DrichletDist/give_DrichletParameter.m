% This function is to get a Drichlet prior parameters for an HMM.

% input:
%phases: phases is a matrix in which number of rows is equal to the number
%of possible phases and number of columns is equal to the number of
%maneuvers (12 maneuvers). Maneuvers are enumerated as following:
%Note:
%SBT=1, SBR=2, SBL=3,
%WBT=4, WBR=5, WBL=6,
%NBT=7, NBR=8, NBL=9,
%EBT=10, EBR=11, EBL=12.

%dwellingWeight:
%set a parameter for staying in one phase. 

% transitionWeight: we consdier a value for parameters on off-diagonal to show
% increase or decrease the transition chance from one state to another. It
% is more interesting if we have sigle value for trans_value in the prior.

%legalManeuverWeight,illegalManeuverWeight
% this gives weight to legal and illegal maneuvers in one phase.

function priorParameters = give_DrichletParameter...
    (phases, transitionWeight,dwellingWeight,legalManeuverWeight,illegalManeuverWeight)

if nargin<5
    illegalManeuverWeight=1;
end

if nargin<4
    legalManeuverWeight=1;
end
    priorParameters.initials=zeros(1,size(phases,1))+5; 

    priorParameters.transitionMatrix =...
    DirichletParam_transitionProbs_Matrix(phases,dwellingWeight,transitionWeight);
    
    priorParameters.emissionMatrix =...
        setDirichletPrior_emissionPara(phases,legalManeuverWeight,illegalManeuverWeight);
    

end
