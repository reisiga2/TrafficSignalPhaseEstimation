% test. Use exat same values to check if it gives NAN again. 

p1=DiscreteD([0 3 0 27 10 10 0 3 0 27 10 10]);
p2=DiscreteD([27 10 10 0 3 0 27 10 10 0 3 0]);
p3=DiscreteD([0 3 0 0 3 44 0 3 0 44 3 0]);
p4=DiscreteD([0 3 44 0 3 0 0 3 44 0 3 0]);
p5=DiscreteD([0 3 0 0 3 0 03 0 51  20 20]);
p6= DiscreteD([0  0 51 20 20 0 3 0 0 3 0]);
p7=DiscreteD([0 3 0 0 3 0 51 20 20 0 3 0]);
p8 = DiscreteD([51 20 20 0 3 0 0 3 0 0 3 0]);

P= [p1 p2 p3 p4 p5 p6 p7 p8];
[phases, numPhases] = EnumeratePhases([1 1 1 1],0);
mc = initiate_MarkovChain(phases(1:8,:),0.001);
initialHmm=HMM(mc,P);


maneuverIDList_fourth_kirby = [69050,69044,69079,...
    69046,68914,69052,68913,69081,69045,69080,69051,68912];
data =  ...
    loadIntersectionData('kirbyFourth.xlsx',...
    maneuverIDList_fourth_kirby, 1,...
    [],[],[],[],[],[],[],[]);


PriorParameters = give_DrichletParameter...
    (phases(1:8,:), 1.01,100,1,1);

 hmm=train(initialHmm,(data(:,1))',size((data(:,1)),1),...
        PriorParameters.initials,PriorParameters.transitionMatrix,...
        PriorParameters.emissionMatrix);
        
    
    inferredPhaseSequence = viterbi(hmm,(data(:,1))' );

    error= find_error(data,inferredPhaseSequence);
    
    figure
    plot(inferredPhaseSequence,'*')
    hold on
    plot(data(:,3),'o', 'MarkerEdgeColor','r');