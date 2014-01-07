
load classificationdata
svmStruct = svmtrain(trainingdata,signalType,'showplot',true);
Group = svmclassify(svmStruct,testdate,'Showplot',true);
hold on 
line([2400,3000],[2400,3000]);
hold off
ylim([2400,3000])
xlim([2400,3000])
xlabel( '$-\ln\left(\Pr\left(o|\lambda_{f}\right)\right)$', 'Interpreter', 'latex' );
ylabel( '$-\ln\left(\Pr\left(o|\lambda_{s}\right)\right)$', 'Interpreter', 'latex' );
set(0,'DefaultAxesFontSize',10);