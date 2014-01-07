% this function generate random phaseEmissions for a fixed time singal
% intersection. This function might give randomly emissions of a signal
% with two, three or four phases. 

function emissions = fixedTimeRandomEmissions() 
    phases = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
    partPhases = phases(1:8,:); 
   
    numPhases=1;
    while numPhases==1
        numPhases = 1+ floor(4*rand());
    end
    
    emissions = 100*rand(numPhases,12).*partPhases(1:numPhases,:);
    
    for i=1:numPhases
    emissions(i,:)=100*(emissions(i,:)/sum(emissions(i,:)));
    end
    
    
     
 end
        
    
