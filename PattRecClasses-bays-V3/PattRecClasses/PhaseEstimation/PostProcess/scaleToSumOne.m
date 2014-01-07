%this function scales a matrix so that its rows sum to one.

function B = scaleToSumOne(A)

    rows=size(A,1);
    cols=size(A,2);
    
    B=zeros(rows, cols);
    
    for i=1:rows
        B(i,:)=A(i,:)/sum(A(i,:)); % scale rows to one
    end
    
end