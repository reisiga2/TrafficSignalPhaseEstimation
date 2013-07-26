% this function is calculating number of errors and the percentage of
% errors during the phase inference. It compares the inferred results with
% the real phases given in the data set.

function [error, percentage_error ] =...
    find_error(data,inferredPhaseSequence )

realPhaseSequence = (data(:,3))';

error =0;
dataSize = size(inferredPhaseSequence,2);

for j=1: dataSize
    if inferredPhaseSequence(j)~= realPhaseSequence(j)
        error= error+1;
    end
end
    percentage_error= (error/dataSize)*100;
    
end