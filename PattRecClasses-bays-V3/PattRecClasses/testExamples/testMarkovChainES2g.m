function mc=testMarkovChainES2g
%test 2-state MarkovChainES duration distribution
%using data sequence with Gamma density of state durations
nStates=2;%external states
initialDur=[5 10];%mean initial duration
mc=initErgodic(MarkovChainES,nStates,initialDur);
mc=mc.splitStates([4 4]);
disp('Initial Mean State Duration');disp(mc.meanStateDuration);
figure(1);
plot(mc.probStateDuration(50)');
title('Initial State Durations');
xlabel('state duration');
ylabel('p(state duration)');
%learn state durations using EM
nPeriods=100;
stateD=[10 20];%mean state durations in training data
gammaShape=3;%sqrt(gammaShape)=mean/St.Dev
for s=1:nStates
    g(s)=GammaD(stateD(s)/gammaShape,gammaShape);%Gamma distributions, mean=stateD
end;
pX=makeMCdataGamma(nPeriods,g);
nTraining=50;
lP=zeros(1,nTraining);%space for logprob
for nT=1:nTraining
    aS=mc.adaptStart;
    [aS,~,lP(nT)]=mc.adaptAccum(aS,pX);
    mc=mc.adaptSet(aS);
    %     disp('Mean State Duration');disp(mc.meanStateDuration);
    %     figure(1+nT);
    %     plot(mc.probStateDuration(4*max(stateD))');
end
figure(99);
plot(lP,'r-');
xlabel('EM Iterations');
ylabel('log-prob( training data )');
disp('Trained Mean State Duration');disp(mc.meanStateDuration);
figure(2);
plot(mc.probStateDuration(4*max(stateD))');
hold on;
for s=1:nStates
    gammaP=exp(g.logprob(1:4*max(stateD)));%true state duration density
    plot(gammaP','--k');
end;
hold off;
title('Trained State Durations');
xlabel('state duration');
ylabel('p(state duration)');
    function z=makeMCdataGamma(nP,g)
        nS=numel(g);%number of states
        z=zeros(nS,0);%empty, for accumulation of data
        for p=1:nP
            izd=zeros(1,0);%space to accumulate one period
            for s=1:nS
                d=round(g(s).rand(1));%random state duration
                d=max(1,d);%never =0
                izd=[izd,repmat(s,1,d)];%save d repetitions of state integer indices
            end;
            zd=sparse(izd,1:length(izd),1);%1-of-K state selection
            z=[z,zd];%accumulate result
        end
    end
end