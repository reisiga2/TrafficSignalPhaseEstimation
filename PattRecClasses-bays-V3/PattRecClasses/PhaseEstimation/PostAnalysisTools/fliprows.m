function flippedA=fliprows(A) % this function get A, and move the values in the m to M-m wehre M is total rows.
    rows =size(A,1);
    
    
    
    for i=1:rows
        flippedA(i,:)=A(rows-i+1,:);
    end
 
end