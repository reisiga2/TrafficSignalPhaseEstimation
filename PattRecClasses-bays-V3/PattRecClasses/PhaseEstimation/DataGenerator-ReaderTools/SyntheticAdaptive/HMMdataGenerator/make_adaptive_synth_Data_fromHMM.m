% This fucntion generates data for a fourway intersection with adaptive
% signal.

% you can set the hmm which generate data or use the default values. I
% recomend to stick with default. 



function data=...
    make_adaptive_synth_Data_fromHMM(dataSize, hmm)

  if  nargin<2 || isempty(hmm)
    % use default values. It is recommended to use defaults.  
    initialProbs = [ 0.25,  0.25, 0.0833 ,  0.0833, 0.0833,  0.0833,  0.0833, 0.0833]; 
    transitionProbs = xlsread('DefaultMarkovChain.xlsx'); 
    mc = MarkovChain(initialProbs,transitionProbs);
    %emissionProbs= adaptiveRandomEmissions();
    emissionProbs = xlsread('DefaultEmissionProbs.xlsx'); 
    
    for i=1:size(emissionProbs,1)
        emissionProbsD(i)= DiscreteD(emissionProbs(i,:));
    end
    
    hmm = HMM(mc ,emissionProbsD);
  end
  
    [synthData,phaseSequence] = rand(hmm,dataSize); % generates synth data from the hmm
     % and gives the sequence of the phases. 
    R=1:size(phaseSequence,2); % order of data
    
    data=[synthData',R',phaseSequence'];
    
 
end
