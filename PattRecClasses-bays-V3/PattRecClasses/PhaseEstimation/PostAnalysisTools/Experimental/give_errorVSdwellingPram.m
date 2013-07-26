
% this function is to check how the error changes with dwelling prameter.

function [dwellingPra, error,errorPercent] = give_errorVSdwellingPram(data,phases,...
    maxDwellingpara, meshSize)


if nargin < 4
    meshSize=10;
end

dwellingPra = 1:meshSize:maxDwellingpara;

transitionProb_from_i_to_j=0.01;
illegalManProb=0;

numInteration = size(dwellingPra,2);

 initialHmm = ...
    initiateIntersectionHMM(data,phases,transitionProb_from_i_to_j,illegalManProb);
    
error = zeros(1,numInteration);
errorPercent = zeros(1,numInteration);

tic;
    for i=1:numInteration

    PriorParameters = give_DrichletParameter...
    (phases, 1.01,dwellingPra(i),1,1);

   hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
   
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    [error(i),errorPercent(i)]= find_error(data,inferredPhaseSequence);
    
    end

toc;
