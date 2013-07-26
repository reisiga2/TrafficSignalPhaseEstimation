% this function is to remove any zero from the translated data. zeros in
% the translated data corresponds to the maneuvers that are impossible to
% happen or errors in data collection.  

function data2 = filterzeros(data1)

rowsOfData1=size(data1,1);
colsOfData1=size(data1,2);
k=1;

for i = 1:rowsOfData1
   
    if data1(i,1)==0
    
    else
        for j=1: colsOfData1
        data2(k,j) = data1(i,j);
        end
        k=k+1;
    end
    
end

end