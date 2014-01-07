% this function removes right turn movements from the data. This is becasue
% somethimes right turn only increase the complexity of th problem. If
% right maneuvers are allowed in every phase, one can just ignore them at
% the first level of analysis and then retag them after the phases are
% detemined based on their time. This is much easier to be done. 


function dataNoRightTurn = removeRightTurns(data)

    dataSize = size(data,1);
    RightTurnSets=[2 5 8 11];
    k=1;
    
    for i=1:dataSize
       
        if ~ismember(data(i,1),RightTurnSets)
            dataNoRightTurn(k,:)=data(i,:);
            k=k+1;
        end
        
    end