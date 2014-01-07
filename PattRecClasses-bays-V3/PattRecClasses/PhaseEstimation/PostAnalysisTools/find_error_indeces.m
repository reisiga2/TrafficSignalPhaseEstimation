% this function gives the location of the errors.

function errorData = find_error_indeces(data,inferredPhases)

    errorIndex = data(:,3)~=inferredPhases';
    
    wrongInferedphaes = inferredPhases(errorIndex );
    
    errorData_temp = data(errorIndex,:);
    errorData= [errorData_temp,wrongInferedphaes'];
    
    
end