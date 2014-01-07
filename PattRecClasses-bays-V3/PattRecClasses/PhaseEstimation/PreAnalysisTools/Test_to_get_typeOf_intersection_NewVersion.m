% this is a test to check if the HMM that comes from a fixed time priors,
%better fit data that comes from fixed time signals. 

clear all
close all

 transPara=1.001;
 dwellPara= 20;
 numTests=200;
logP_fix1 = zeros(1,numTests);
logP_fix2 = zeros(1,numTests);
logP_adaptive1 = zeros(1,numTests);
logP_adaptive2 = zeros(1,numTests);

% u=10*randn(1,6);
% v=randn(1,8);
% emissionProbs = [0 1 0 39+u(1) 5+v(1) 5+v(2) 0 1 0 39+u(2) 5+v(3)  5+v(4) ;...
%                  39+u(3) 5+v(5)  5+v(6)  0 1 0 39+u(4) 5+v(7)  5+v(8)  0 1 0;...
%                  0 1 0 0 1 48+u(5) 0 1 0 0 1 48+u(6)];


%emissionProbs=100*rand(3,12);
 
 phases = EnumeratePhases([1 1 1 1],1); % [1 1 1 1] full fourway intersection
 partPhases = phases(1:8,:); 
 %phaseSequenceLength=100; 
 %PriorParameters = give_DrichletParameter(partPhases, transPara,dwellPara,1);
% 
for i=1:numTests

% 
%                  
     u=10*randn(1,6);
     v=1.5* randn(1,8);
    emissionProbs = [0 1 0 39+u(1) 5+v(1) 5+v(2) 0 1 0 39+u(2) 5+v(3)  5+v(4) ;...
                 39+u(3) 5+v(5)  5+v(6)  0 1 0 39+u(4) 5+v(7)  5+v(8)  0 1 0;...
                 0 1 0 0 1 48+u(5) 0 1 0 0 1 48+u(6)];
             
    emissionProbs= 100*scale_matrix (emissionProbs);
             
   numPhases = size(emissionProbs,1);
   phases = 1:numPhases;
   
  data_fix = ... 
   loadIntersectionData('syntethicFixedTime',[], 0,...
   phases,emissionProbs,[20 20],[10 10 5 5; 30 30 10 10],... %[10 10] gives min and max num of cycles.
   [],[],[],[]);

    %lengthofSequence(i) = size(data_fix,1);

    dataSize = size(data_fix,1);
    data_adaptive= make_adaptive_synth_Data_fromHMM(dataSize);
     
%     NumbofStr=zeros(dataSize,1);
%     BigNumber=1000000;
%     for ji=1:dataSize
%        NumbofStr(ji,1) = (data_fix(ji,1)==1 || data_fix(ji,1)==4 ...
%            ||data_fix(ji,1)==7||data_fix(ji,1)==10);
%      end
%    legalTurnManeuverWeight= BigNumber*(1-(sum(NumbofStr)/dataSize) );
%    legalStraightManeuverWeight=BigNumber* sum(NumbofStr)/dataSize ; 
   
   PriorParameters =  give_DrichletParameter...
    (partPhases, transPara,dwellPara,1);     
%legalTurnManeuverWeight,legalStraightManeuverWeight);

 hmm_fix = make_initial_HMM_from_DirichletParameters...
    (PriorParameters.initials, PriorParameters.transitionMatrix,...
    PriorParameters.emissionMatrix);

adaptive_transitions = xlsread('adaptivePrior_FourWay.xlsx');

hmm_adaptive = make_initial_HMM_from_DirichletParameters...
    (PriorParameters.initials, adaptive_transitions,...
    PriorParameters.emissionMatrix);


 logP_fix1(i)=  logprob(hmm_fix,(data_fix(:,1))');
 logP_fix2(i)=  logprob(hmm_adaptive,(data_fix(:,1))');
 logP_adaptive1(i)=logprob(hmm_fix,(data_adaptive(:,1))');
 logP_adaptive2(i)=logprob(hmm_adaptive,(data_adaptive(:,1))');
 
% [S_fix1,logP_fix1(i)]=viterbi(hmm_fix,(data_fix(:,1))');
% [S_fix2,logP_fix2(i)]=viterbi(hmm_adaptive,(data_fix(:,1))');
% 
% [S_adaptive1,logP_adaptive1(i)]=viterbi(hmm_fix,(data_adaptive(:,1))');
% [S_adaptive2,logP_adaptive2(i)]=viterbi(hmm_adaptive,(data_adaptive(:,1))');

end
numTrained = floor(numTests/2);
numclassified =  ceil(numTests/2);

logP_fix = [logP_fix1;logP_fix2];
logP_adaptive=[logP_adaptive1;logP_adaptive2];

for i=1:numTrained
    groupAdaptive{1,i}='Sensor-actuated';
    groupFixed{1,i}='Fixed-time';
end
trainingData=[-logP_fix(:,1:numTrained),-logP_adaptive(:,1:numTrained)];
signalType=[groupFixed(1,1:numTrained),groupAdaptive(1,1:numTrained)];
svmOutput = svmtrain(trainingData',signalType','showplot',true);

xlabel( '$-\ln\left(\Pr\left(o|\lambda_{f}\right)\right)$', 'Interpreter', 'latex' );
ylabel( '$-\ln\left(\Pr\left(o|\lambda_{s}\right)\right)$', 'Interpreter', 'latex' );
set(0,'DefaultAxesFontSize',12);

figure


axesHandle = svmOutput.FigureHandles{1};   % Get the handle to the axes

childHandles=get(axesHandle,'children');    % Find the axes' children

hggroupHandle=childHandles(1);              % Get HGGROUP object handle that contains the line

lineHandle=get(hggroupHandle, 'children');  % Get the line's handle

% Get the X and Y data points of the line

xvals=get(lineHandle, 'XData');

yvals=get(lineHandle, 'YData');

% Using 2 points on the line, calculate slope and y-intercept

m=(yvals(2)-yvals(1))/(xvals(2)-xvals(1));

b=yvals(1)-m*xvals(1);

% Plot the y=mx+b line to check it (blue dashed line)

hold on;

plot(xvals, m*xvals+b, '-', 'LineWidth', 2);
numLinePoints = size(xvals,1);

NumToPlotTrain=50;
NumToplotClassify=20;
hold off
% make a nucer plot..... in which the separator line is not gigily. 
figure 
plot(-logP_fix(1,1:numTrained),-logP_fix(2,1:numTrained), 'rx','markersize',5)
 hold on
 plot(-logP_adaptive(1,1:numTrained),-logP_adaptive(2,1:numTrained), '*','markersize',5);

xlabel( '$-\ln\left(\Pr\left(o|\lambda_{f}\right)\right)$', 'Interpreter', 'latex' );
ylabel( '$-\ln\left(\Pr\left(o|\lambda_{s}\right)\right)$', 'Interpreter', 'latex' );
set(0,'DefaultAxesFontSize',12);
plot(-logP_fix(1,numTrained+1:end),-logP_fix(2,numTrained+1:end), 'gs','markersize',8, 'linewidth',1)
plot(-logP_adaptive(1,numTrained+1:end),-logP_adaptive(2,numTrained+1:end), 'co','markersize',8, 'linewidth', 1);
 eqtext = '$y=1.0922x-112.54$';
text(1400,2600, eqtext, 'Interpreter', 'Latex', 'FontSize', 12, 'Color', 'k');
legend('fixed time (training)', 'sensor actuated (training)',...
    'fixed time (classified)', 'sensor actuated (classified)');

line([xvals(1),xvals(numLinePoints-1)],[m*xvals(1)+b,m*xvals(numLinePoints-1)+b])

%----------------------------------------------


figure 
plot(-logP_fix(1,1:50),-logP_fix(2,1:50), 'rx','markersize',5)
 hold on
 plot(-logP_adaptive(1,1:50),-logP_adaptive(2,1:50), '*','markersize',5);

xlabel( '$-\ln\left(\Pr\left(o|\lambda_{f}\right)\right)$', 'Interpreter', 'latex' );
ylabel( '$-\ln\left(\Pr\left(o|\lambda_{s}\right)\right)$', 'Interpreter', 'latex' );
set(0,'DefaultAxesFontSize',12);
plot(-logP_fix(1,51:100),-logP_fix(2,51:100), 'gs','markersize',8, 'linewidth',1)
plot(-logP_adaptive(1,51:100),-logP_adaptive(2,51:100), 'co','markersize',8, 'linewidth', 1);
 eqtext = '$y=0.9989x-112.54$';
text(1400,2600, eqtext, 'Interpreter', 'Latex', 'FontSize', 12, 'Color', 'k');
legend('fixed time (training)', 'sensor actuated (training)',...
    'fixed time (classified)', 'sensor actuated (classified)');

line([xvals(1),xvals(numLinePoints-1)],[m*(xvals(1))+b,m*xvals(numLinePoints-1)+b])

eqtext = '$y=1.0922x-53.2$';
text(1400,2600, eqtext, 'Interpreter', 'Latex', 'FontSize', 12, 'Color', 'k');
%---------------------------------------------------------------------------------

% figure
% plot(x,-logP_fix1,'-bs');
% hold on
% plot(x,-logP_fix2,'--rs');
% legend('\lambda_f', '\lambda_s');
% title('Data from fixed-time signal');

% shift=50;
% 
% figure
% plot(-logP_fix1,-logP_fix2,'r*');
% hold on
% plot(-logP_adaptive1,-logP_adaptive2,'+');
% line([min(-logP_fix1)-shift,max(-logP_fix1)+3*shift],[min(-logP_fix1)-shift...
%     ,max(-logP_fix1)+3*shift]);
% 
% % xlabel('-ln(pr(O|\lambda_f))')
% % ylabel('-ln(pr(O|\lambda_s))')
% legend('Data from fixed-time signal','Data from sensor actuated signal');
% xlim([min(-logP_fix1)-shift,max(-logP_fix1)+3*shift]);
% ylim([min(-logP_fix1)-shift,max(-logP_fix1)+3*shift]);
% 
% xlabel( '$-\ln\left(\Pr\left(o|\lambda_{f}\right)\right)$', 'Interpreter', 'latex' );
% ylabel( '$-\ln\left(\Pr\left(o|\lambda_{s}\right)\right)$', 'Interpreter', 'latex' );
% set(0,'DefaultAxesFontSize',14);

% figure
% plot(x,-logP_adaptive1,'-bs');
% hold on
% plot(x,-logP_adaptive2,'--rs');
% legend('\lambda_f', '\lambda_s');
% title('Data from sensor actuated signal');


% figure
% plot(-logP_adaptive1,-logP_adaptive2,'rd');
% hold on
% H=line([min(-logP_adaptive1)-shift,max(-logP_adaptive1)+shift],...
%     [min(-logP_adaptive1)-shift, max(-logP_adaptive1)+shift]);
% 
% 
% xlabel('-ln(pr(O,S|\lambda_f))')
% ylabel('-ln(pr(O,S|\lambda_s))')
% title('Data from sensor actuated signal');

