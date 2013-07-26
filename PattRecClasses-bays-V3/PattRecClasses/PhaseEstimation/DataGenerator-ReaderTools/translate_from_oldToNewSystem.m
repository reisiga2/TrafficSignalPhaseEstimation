

function newManeuversCount= translate_from_oldToNewSystem(oldmaneuversCount)

   
    newManeuversCount = zeros(size(oldmaneuversCount,1),1);
    
    oldsystem=[1 2 3 4 5 6 7 8 9 10 11 12];
    newsystem =[3 1 2 5 6 4 7 8 9 12 10 11 ];
    
  
    for i=1:size(oldmaneuversCount,1)
        for j=1:12
           if oldmaneuversCount(i)==oldsystem(j) 
                 newManeuversCount(i)=newsystem(j);
           end
            
        end
    end

end