%R=rand(pD,nData) returns random scalars drawn from given Discrete Distribution.
%
%Input:
%pD=    DiscreteD object
%nData= scalar defining number of wanted random data elements
%
%Result:
%R= vector with integer random data drawn from the DiscreteD object pD
%   (size(R)= [1, nData]
%U= sub-state sequence = zeros(1,nData), only for compatibility with GaussMixD
%
%Arne Leijon 2004-11-24
%           2006-04-13 fixed bug for trivial case length(pD.ProbMass)==1
%           2006-05-12 sub-state output added for compatibility
%           2009-07-21 sub-state output deleted again

function R=rand(pD,nData)
if numel(pD)>1
    error('Method works only for a single DiscreteD object');
end;
limits=cumsum(pD.ProbMass);
%u=rand;%uniformly distributed (0,1)
u=rand(1,nData);%one for each wanted random integer
R=1+sum(repmat(u,size(limits,1),1) > repmat(limits,1,nData),1);
if nargout>1
    U=zeros(1,nData);end;%DiscreteD has no sub-states
