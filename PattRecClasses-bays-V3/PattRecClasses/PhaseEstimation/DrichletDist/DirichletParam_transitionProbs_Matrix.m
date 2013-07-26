% this fucntion is to generate a matrix of parameters for a drichlet
% distribution. This is inparticular for transition probabilities. 
%It is very naive and should not be considered as a general method. 

%input: 

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

function  parameters =...
    DirichletParam_transitionProbs_Matrix(phases,dwellingWeight,transitionWeight)

    if nargin<3
        transitionWeight=1;
    end
    
    if nargin<2
        maneuverWeight=1;
    end
    
    numPhase=size(phases, 1);
    numOfManInEachPhase = zeros(1,numPhase);
    
    for k=1:numPhase
         numOfManInEachPhase(k)=sum(phases(k,:));
    end
    
     parameters=zeros(numPhase, numPhase);
    
    for i=1:numPhase
        for j=1:numPhase
            
            if(i==j)
                 parameters(i,j)= numOfManInEachPhase(i)*dwellingWeight; % set the off diagonal parameters
            
            else 
                 parameters(i,j)= transitionWeight;% set the diagonal parameters.
            end
            
        
        end
    end
    