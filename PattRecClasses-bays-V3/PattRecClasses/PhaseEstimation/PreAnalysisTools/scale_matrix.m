%This function scale a matrix to sum to one in each row.

function scaledA = scale_matrix (A)

    numrows = size(A,1);
    scaledA = zeros(size(A,1),size(A,2));
    
    for i=1:numrows
      scaledA(i,:) = A(i,:)/sum(A(i,:));
      
    end

end