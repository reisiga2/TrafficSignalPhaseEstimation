% this tests the functions and methods in this part.
% this is a T-intersection.

clear all
close all

phases = EnumeratePhases([1 1 1 2]);
InitialHMM = initiateIntersectionHMM(phases,0.01,1);

phases_fourwayIntersection = EnumeratePhases([1 1 1 1]);


