
% this function is accumulating the values in one vector. 

% the vector V is a row vector.

% example: V=[10 10 50 30] --> accumeV=[0,10,20,70,100]

function accumeV = accumilate_vector(V)
        
      accumeV = zeros(1, size(V,2)+1);
      accumeV(1)=0;  
            
     for i=2:size(V,2)+1
            accumeV(i) = accumeV(i-1)+V(i-1);
        
     end



end

