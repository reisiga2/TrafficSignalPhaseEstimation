
function phases = updatePhases(possibleManeuvers) 
phases_temp = xlsread('DefualPhases.xlsx');
    
    NonRightTurnIndex=[1 3 4 6 7 9 10 12];
    
   tic;
    for i=1:size(phases_temp,1)
        for j=1: size(phases_temp,2)
          if  possibleManeuvers(1,j)==0
              phases_temp(i,j)=0;
          end
           
        end
    end
   toc; 
   
    phases_temp2 =  removeZeroSumRow(phases_temp);
    phases_temp3 =unique(phases_temp2, 'rows');
    phases_temp4 = remove_Phase_With_Only_RightTurns(phases_temp3);
    phases= unique(phases_temp4, 'rows');
     
    
    
    
    