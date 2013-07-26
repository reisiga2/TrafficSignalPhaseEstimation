


%input : V is a row vector that sums to 100. 

function randomData = singlePhaseRandomData(V,numMane)
    
    accumV=accumilate_vector(V);
       
    randomData =zeros(1, numMane);
    randomManeuver = generate_UnifRand(0,100,1,numMane);   
    
    for i=1:size(randomManeuver,2)
        for j=1:size(V,2)
            if (randomManeuver(i)>=accumV(j) && randomManeuver(i)<=accumV(j+1))
               randomData(i)=j;
            end
        end
    end

    
   

end
    