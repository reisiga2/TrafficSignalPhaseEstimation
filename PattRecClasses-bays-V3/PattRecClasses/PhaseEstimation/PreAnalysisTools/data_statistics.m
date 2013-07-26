function [maneuverPercentage, totalTime, phaseList ] = data_statistics(data)

num=zeros(1,12);
iteration= size(data,1);

for i=1: iteration
    for j=1:12
    if data(i,1)==j
        num(j)=num(j)+1;
    end
    end
end
maneuverPercentage =(num/iteration)*100;
totalTime = max(data(:,2)); % seconds
phaseList = unique (data(:,3),'rows');
end

