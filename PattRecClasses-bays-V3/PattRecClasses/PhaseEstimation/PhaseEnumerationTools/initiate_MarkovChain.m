% this function generates inital Makov chain for the algorithm. 
% input: phases, and transition probability form i to j.
%output: a markov chain object. 

function mc = initiate_MarkovChain(phases,transitionProb_from_i_to_j)
    n=size(phases,1); % number of phases
    pi = zeros(1, n); % inital probabilty vector for a markov chain.
    transitionProb = zeros(n,n);
    
    transitionProb_from_i_to_i = 1-(n-1)*transitionProb_from_i_to_j;
   
    if transitionProb_from_i_to_i<0
        error('the probability value can not be zero, set the trantion probability to a lower value.')
    end
    
    for i=1:n
        pi(i)= 1/n;
        for j=1:n
            if i==j
                transitionProb(i,j)= transitionProb_from_i_to_i ;
            else
                transitionProb(i,j)=transitionProb_from_i_to_j;
            end
        end
    end
    
    mc = MarkovChain(pi, transitionProb); 
   
 end