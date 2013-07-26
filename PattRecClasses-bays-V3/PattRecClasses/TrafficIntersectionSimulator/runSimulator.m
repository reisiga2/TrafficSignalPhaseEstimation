clear all;
close all;
noOfCycles = 3;
[xSimulated switchingTimePolicy simulatedPhaseSequence maneuversSequence] = intersectionSimulator(noOfCycles);
fprintf('Simulation completed.\n');
fprintf('Results are in workspace variables named: xSimulated,switchingTimePolicy simulatedPhaseSequence and maneuversSequence\n');

Mdata = transformTomySystem( maneuversSequence);
 plot(Mdata,'*');
 
 