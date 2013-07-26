function mc=testMarkovChainES2p
%test 2-state MarkovChainES duration distribution
%using exactly periodic data sequence
nStates=2;%external states
stateDur=10;%mean initial duration
mc=initErgodic(MarkovChainES,nStates,stateDur);
mc=mc.splitStates([4 4]);
disp('Mean State Duration');disp(mc.meanStateDuration);
figure(1);
plot(mc.probStateDuration(40)');
%learn state durations using EM
nPeriods=100;
stateD=[10 20];
pX=makeMCdataPeriodic(nStates,nPeriods,stateD);
nTraining=50;
for nT=1:nTraining
    aS=mc.adaptStart;
    [aS,~,lP(nT)]=mc.adaptAccum(aS,pX);
    mc=mc.adaptSet(aS);
    disp('Mean State Duration');disp(mc.meanStateDuration);
    figure(1+nT);
    plot(mc.probStateDuration(5*max(stateD))');
end
figure(99);
plot(lP,'r-');
% disp('Mean State Duration');disp(mc.meanStateDuration);
% figure(2);
% plot(mc.probStateDuration(40)');
    function z=makeMCdataPeriodic(nStates,nP,D)
        z=zeros(nStates,sum(D));%space for one period
        st=[1,1+cumsum(D)];%start time indices for states
        for s=1:nStates
           z(s,st(s):(st(s+1)-1))=1;%binary 1-of-K representation
        end;
        z=repmat(z,1,nP);
    end
end