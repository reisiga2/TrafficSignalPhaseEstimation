% this function gives error VS cycle length. 
%input: phases, Dirchlet parameters, MaxNumofCycles, 

function [numCycle,averageError ,averagePercError] = find_error_vs_numCycles(allPhases, DiricParam,...
maxNumCycle,GeneratingPhases,emissionProbsGenData,numManeuver,iteration,...
     transitionProb_from_i_to_j, illegal_Man_Prob)

        
        numCycle = 2: 1: maxNumCycle;
        cycleIte = size(numCycle,2);
        averageError = zeros(1,cycleIte);
        averagePercError = zeros(1,cycleIte);
        
  for j=1:cycleIte  
      
        totalMissLabled=0;
        totalDataSize=0;
        misslabled = zeros(1,iteration);
        percError = zeros(1,iteration);
        
    for i= 1: iteration
        
        data = ...
    loadIntersectionData('syntethicFixedTime',[], 0,...
    GeneratingPhases,emissionProbsGenData,[numCycle(j),numCycle(j)],numManeuver,... 
    [],[],[],[]);    % generate data for that number of cycle

    

    dataSize = size(data,2);
        
    initialHmm = ...
    initiateIntersectionHMM(data,allPhases,transitionProb_from_i_to_j,illegal_Man_Prob); % set initial HMM
       
    hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
         DiricParam.initials, DiricParam.transitionMatrix,...
         DiricParam.emissionMatrix); % train the hmm
     
    
     inferredPhaseSequence = viterbi(hmm,(data(:,1))' ); % phase sequence that is inferred by the trained HMM.
        
        totalDataSize= totalDataSize+ dataSize;
        [misslabled(i),percError(i)] = find_error(data,inferredPhaseSequence );
        totalMissLabled = totalMissLabled + misslabled(i); % bookkeeping. 
        
        
          
    end
        averageError(j) = totalMissLabled/iteration;
        averagePercError(j)= sum(percError)/iteration;
        
        % this is another way of calculating percentage of the error. 
        
%         averageError(j) = totalMissLabled/iteration; 
%         averagePercError(j) =  (totalMissLabled/totalDataSize)*100;
  end    
end