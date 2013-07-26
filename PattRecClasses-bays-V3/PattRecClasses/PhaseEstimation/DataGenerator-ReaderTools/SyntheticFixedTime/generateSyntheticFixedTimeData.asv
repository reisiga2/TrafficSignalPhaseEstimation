% this function is built to generate synthetic data for a fixed time
% intersection. 

% Here is the idea and steps... 
% 1- Input the function the phases that you want to generate data from. 

% 2- The fucntion randomly select one of the phaes to start with. For
% example (if you  have phse 1 2 and 3) it might select phase 2 as starting
% phase and cycles 2--> 3--> 1-->2 --> ...

% 3- The function randomly selects number of cylces one might want to
% generate data from. One can also input this value. 

% 4- In each phase, the function select a random number from a uniform
% distribution. This number identifies total number of maneuvers
%synthesized in that phase. 

% 5- To synthesize data in each phase one need to have the emission
% probability of each maneuver in that phase. Emission probabilities can be
% an input of the function. 


%inputs:

% phases: a vector that gives the real phases for example :[1 2 5] means
% the data generated from phaes 1, 2 and 5. these phase numbering depend on
% the user and the way he/she enumerate all possible phases.

% emissionProbs = a matrix that has maneuver emission probabilities. It
% should have 12 columns (num of maneuvers). Each row corresponds to each
% phase. 

% NumCyclesbound: [MinNumCycles, MaxNumCycles]= set these values for the
%number of cyles and the function will pick the numCyles randomly from a 
%UNIF[MinNumCycles, MaxNumCycles]. If you want to have a fix number 
%of cyles set thse values to be equal. 



% numManeuversbound: maxManeuver, minManeuver: the maximum and Minimum number of maneuvers a
% phase can have. Since different phases can have different
% maximum/minimum these values are vectors. For example if you want to
% generate data from two phases, the maxManeuver is a row vector with two
% elements. Thus numManeuversbound is matrix with two rows. first row gives
% the min values and second row gives the max values. 


function data =...
    generateSyntheticFixedTimeData (phases,emissionProbs,NumCyclesbound, numManeuversbound)

    syntheticFixTimeData=[];
    phaseSequence=[];
    
    minNumCycles=NumCyclesbound(1);
    maxNumCycles=NumCyclesbound(2);
    minManeuver= numManeuversbound(1,:);
    maxManeuver = numManeuversbound(2,:);
    
    numPhase = size(emissionProbs,1);

    numCylces = floor(generate_UnifRand(minNumCycles-1,maxNumCycles,1,1))+1; 
    startPhase = floor(generate_UnifRand(0,numPhase,1,1))+1; % randomly select the start phase.
   
    numManeuvers = zeros(1,numPhase*numCylces-startPhase+1);
    
    for k = startPhase : (numPhase*numCylces-startPhase+1)  % iteration on the number of phase.  
         
           t= remainder(k,numPhase);
           
        numManeuvers(k) = floor(generate_UnifRand...
            (minManeuver(t)-1,maxManeuver(t),1,1))+1; % random number of maneuvers at the kth phase.
        
        syntheticFixTimeData_temp = singlePhaseRandomData...
            (emissionProbs(remainder(k,numPhase),:),numManeuvers(k)); % generate data for the kth phase 
        
        phaseDataSize(k) = size(syntheticFixTimeData_temp,2);
        
        phaseSequence_temp = repmat(phases(remainder(k,numPhase)),1,phaseDataSize(k));% gives a sequence of current phase 
        phaseSequence =[phaseSequence,phaseSequence_temp]; % sequence of phases that generates data.
       
        syntheticFixTimeData=[syntheticFixTimeData,syntheticFixTimeData_temp]; % augment data sets.
       
        
    end
        
    R=1:size(syntheticFixTimeData,2);
    data = [syntheticFixTimeData',R',phaseSequence'];

end