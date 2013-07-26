function P = remove_Phase_With_Only_RightTurns(phase)

  
 NonRightTurnIndex=[1 3 4 6 7 9 10 12];
    k=1;
    phaseCOPY=phase;
    numrows = size(phaseCOPY,1);
    IndextoRemove=[];
 
    tic;  
    for j=1:numrows
        if phaseCOPY(j,NonRightTurnIndex)==zeros(1,size(NonRightTurnIndex,2))
            IndextoRemove(k)=j;
            k=k+1; 
        end
    end
    toc;
    
    if size(IndextoRemove)>0
        phaseCOPY(IndextoRemove,:)=[];
    end
    
    
    P = phaseCOPY;
    