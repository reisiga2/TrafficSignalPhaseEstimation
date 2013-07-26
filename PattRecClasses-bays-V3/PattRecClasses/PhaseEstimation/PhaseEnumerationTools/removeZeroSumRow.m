% this function removes the rows of the matrix that all of its values are
% zero. 
 % this function is important to update phases. 

function P = removeZeroSumRow(temp_p)
    num_rows = size (temp_p,1);
    num_cols = size (temp_p,2);
    m=1;
    for i= 1: num_rows 
        rowSum = sum(temp_p(i,:));
        if (rowSum == 0)
            
        else
            for k =1:num_cols
                P(m,k) = temp_p (i,k);
            end
                m=m+1;
        end
    end
end
    