% this function is to generate plots.

function ...
    generatePlotsOfPhaseSequence(intersectionName,data,maneuverPercentage,inferredStateSequence, range)

sizeOfData= size(data, 1);

if range> sizeOfData
   
    error ('range is too big, please consier smaller range for plotting.')
    
else
    

figure
plot(data(1:range,2),data(1:range,1),'*', 'markersize', 5);
title(intersectionName);
set(gca,'YTick',1:1:12);
set(gca,'YTickLabel',{'SBT', 'SBR', 'SBL', 'WBT', 'WBR', 'WBL', 'NBT', 'NBR', 'NBL', 'EBT', 'EBR', 'EBL'});
xlabel('Time(sec)')
   %x = 1:range;
   realphases = (data(:,3))';
   time = (data(:,2))';
   
   indCORRECT = realphases(1:range)== inferredStateSequence(1:range);
   indINCORRECT = realphases(1:range)~= inferredStateSequence(1:range);
shifting=0.07;
figure
 
    plot(time(indINCORRECT) ,realphases(indINCORRECT)+shifting, '*', 'markersize',5.5, 'MarkerEdgeColor','b');
    legend()
    title(intersectionName);
    hold on
    plot(time(indCORRECT), inferredStateSequence(indCORRECT), 's', 'markersize',5.5, 'MarkerEdgeColor','g');
    plot(time(indINCORRECT), inferredStateSequence(indINCORRECT)-shifting, 'o', 'markersize',5.5, 'MarkerEdgeColor','r');
    legend('True','Correctly inferred','Incorrectly inferred');
    set(gca,'YTick',1:1:8);
    set(gca,'YTickLabel',{'Phase1', 'Phase2', 'Phase3', 'Phase4', 'Phase5', 'Phase6', 'Phase7', 'Phase8'});
    xlim([0,time(end)+5])
    xlabel('Time(sec)')
    ylabel('Phase')
    

%    figure
% bar(maneuverPercentage);
% ylim([0 100]);
% set(gca,'XTick',1:1:12);
% set(gca,'XTickLabel',{'SBT', 'SBR', 'SBL', 'WBT', 'WBR', 'WBL', 'NBT', 'NBR', 'NBL', 'EBT', 'EBR', 'EBL'});
% title(intersectionName);
% xlabel('Maneuver type')
% ylabel('Percentage (%)') 
  
   
end
    