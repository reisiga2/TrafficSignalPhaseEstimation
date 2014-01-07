% this function modify the transition probabilities of an  based on an adaptive
% signal strategies. For example it prohibit some of the transition that
% still hmm allows but are not in fact allowed in practice. then in gives
% new hmm that is sparse and is very close to thelearned hmm. 

function Modified_hmm = modify_hmm_for_adaptiveSignals(hmm)

    mc= hmm.StateGen; % get the learned markov chain 
    transProbs1 = mc.TransitionProb;
    
    numStates=size(transProbs1,1);
    transProbs2=zeros(numStates,numStates);
    
   % here we impose the strategies 
   for i=1: numStates
    transProbs2(i,i)= transProbs1(i,i);
   end
    
   % first row
   transProbs2(1,2)= transProbs1(1,2);
   transProbs2(1,4)=transProbs1(1,4);
   transProbs2(1,7)=transProbs1(1,7);
   transProbs2(1,8)= transProbs1(1,8);
   
   % second row
   transProbs2(2,1)= transProbs1(2,1);
   transProbs2(2,3)=transProbs1(2,3);
   transProbs2(2,5)=transProbs1(2,5);
   transProbs2(2,6)= transProbs1(2,6);
   
   %third row
   transProbs2(3,1)= transProbs1(3,1);
   
   %forth row
    transProbs2(4,2)= transProbs1(4,2);
    
    %fifth and sixth row
     transProbs2(5,1)= transProbs1(5,1);
     transProbs2(6,1)= transProbs1(6,1);
     
     %7th and 8th rows
   transProbs2(7,2)= transProbs1(7,2);
   transProbs2(8,2)= transProbs1(8,2);
   
   
   transProb3=scaleToSumOne(transProbs2);
   
   
   newMc=MarkovChain( mc.InitialProb,transProb3);
   emissionProbs = hmm.OutputDistr;
   
   
   Modified_hmm = HMM( newMc, emissionProbs);
    

end