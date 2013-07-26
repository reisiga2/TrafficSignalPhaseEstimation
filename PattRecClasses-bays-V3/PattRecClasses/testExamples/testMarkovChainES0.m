%test MarkovChainES0
nStates=3;%external states
stateDur=10;
mc=initLeftRight(MarkovChainES,nStates,stateDur);
disp('Mean State Duration');disp(mc.meanStateDuration);
figure(1);
plot(mc.probStateDuration(40)');
mc=mc.splitStates([4 5 6]);
disp('Mean State Duration');disp(mc.meanStateDuration);
figure(2);
plot(mc.probStateDuration(40)');