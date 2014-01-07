function emissions = adaptiveRandomEmissions()
A=rand(8,12);
phases = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
partPhases = phases(1:8,:); 
emissions = A.*partPhases;

for i=1:size(emissions,1)
    emissions(i,:)=100* emissions(1,:)/sum(emissions(1,:));
end


end