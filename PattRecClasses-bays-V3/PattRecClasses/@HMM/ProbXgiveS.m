% this function is simply calculates the probability of a sequence of
% observations given the state sequence. Here we in fact know what is the
% state sequence thus we only need to multiply the values of the outcomes. 

% input: sequence of observation X. sequence of the states S, and the
% underlying hmm. 

%output: the pr(X|S,lamda) where lamda is the hmm's parameter set.  


function prob = ProbXgiveS(X, S, hmm)

   nX=size(X,2);
   nS=size(S,2);
   prob=1;
   if nX~=nS
       ERROR('X and S should be of same dimension') 
   else
        for i=1: nX
            s=S(i);
            x=X(i);
            b=hmm.OutputDistr(s).ProbMass(x);
            prob=b*prob;
             
        end
       
   end



end
