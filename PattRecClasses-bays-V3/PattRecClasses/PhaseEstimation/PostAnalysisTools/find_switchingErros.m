
% this function find if an inference was wrong and a switching happened. 

function switchingErrors = find_switchingErros(data, inferredphaseSequence)
    
    realPhaseSequence = (data(:,3))';
    dataSize = size(realPhaseSequence, 2);
    
    switchingErrors=0;
    
    for i=2:dataSize
        if (realPhaseSequence(i)~=inferredphaseSequence(i)...
                && inferredphaseSequence(i)~=inferredphaseSequence(i-1))
            
            switchingErrors=switchingErrors+1;
            
        end
    end
    
    
 end
    
