%pD=adaptSet(pD,aState)
%method to finally adapt a DiscreteD object
%using accumulated statistics from observed data.
%
%Input:
%pD=        DiscreteD object or array of such objects
%aState=    accumulated statistics from previous calls of adaptAccum
% nu is the parameters of the Dirichlet distribution. nu is a matrix whose
% columns reperestns the states and its rows represnts the outputs of the
% states.

%
%Result:
%pD=        adapted version of the DiscreteD object
%
%Theory and Method:    
%From observed sample data X(n), n=1....N, we are using the 
%accumulated sum of relative weights (relative frequencies)
%
%We have an accumulated weight (column) vector
%sumWeight, with one element for each observed integer value of Z=round(X):
%sumWeight(z)= sum[w(z==Z(n))]
%
%Arne Leijon 2011-08-29, tested
%            2012-06-12, modified use of PseudoCount

function pD=adaptSet(pD,aState,nu)
nu= nu';


    
for i=1:numel(pD)%for all objects in the array
    aState(i).sumWeight=aState(i).sumWeight+pD(i).PseudoCount;%/length(aState(i).sumWeight);
    %Arne Leijon, 2012-06-12: scalar PseudoCount added to each sumWeight element
    %Reasonable, because a Jeffreys prior for the DiscreteD.Weight is
    %equivalent to 0.5 "unobserved" count for each possible outcome of the DiscreteD.
    pD(i).ProbMass=aState(i).sumWeight+nu(:,i)-1; %direct ML estimate
%    pD(i).ProbMass=pD(i).ProbMass./sum(pD(i).ProbMass);%normalize probability mass sum
%   normalized by DiscreteD.set.ProbMass
end;


% write turns are considered here which probabilty makes the problem
% harder. 
% phases=...
% [0 0 3 4 5 6 0 8 0 10 11 12;
%  1 2 3 4 0 0 7 8 9 0 0 12;
%  0 0 3 4 5 0 0 8 0 10 0 12; 
%  1 0 3 4 0 0 0 8 9 0 0 12;
%  0 0 3 4 0 0 0 8 0 10 11 12;
%  0 0 3 4 5 6 0 8 0 0 0 12;
%  0 0 3 4 0 0 7 8 9 0 0 12;
%  1 2 3 4 0 0 0 8 0 0 0 12];

% no write turn considered in following phase definition
% phases=...
% [0 0 0 4 5 6 0 0 0 10 11 12;
%  1 2 3 0 0 0 7 8 9 0 0 0;
%  0 0 0 0 5 0 0 0 0 10 0 0; 
%  1 0 0 0 0 0 0 0 9 0 0 0;
%  0 0 0 0 0 0 0 0 0 10 11 12;
%  0 0 0 4 5 6 0 0 0 0 0 0;
%  0 0 0 0 0 0 7 8 9 0 0 0;
%  1 2 3 0 0 0 0 8 0 0 0 0];
% 
% % legalWeight=[2,2,10,10,5,5,5,5];
% % illegalWeight=1.1;
% legalWeight=[1,1,1,1,1,1,1,1];
% illegalWeight=1;
% 
% nu_outcome = setOutcomePriorPara(phases,legalWeight,illegalWeight);
% nu_outcome_trans = nu_outcome';
