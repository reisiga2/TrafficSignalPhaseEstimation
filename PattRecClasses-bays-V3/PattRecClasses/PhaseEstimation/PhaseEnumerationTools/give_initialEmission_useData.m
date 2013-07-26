% this function initiate the output emission distribution using data. 

function emissionProbD = give_initialEmission_useData(data,phases,illegalManProb)

percentage_of_Maneuvers = data_statistics(data);


for i=1:size(phases,1)
    emissionMatrix = phases(i,:).*percentage_of_Maneuvers;
    
    illegalManIndex =  emissionMatrix == 0;
     emissionMatrix(illegalManIndex )=illegalManProb;
    
    
    emissionProbD(i)= DiscreteD(emissionMatrix);
    

end