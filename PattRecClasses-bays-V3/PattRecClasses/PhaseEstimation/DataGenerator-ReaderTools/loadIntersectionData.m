% this function loads data.

% IN GENERAL IF A VALUE IS NOT NEEDED SET IT TO [].

% input:

% Name of the data file.If the data needed to be synthetic, this name
% should be 'syntethicAdaptive' or 'syntethicFixedTime'.

% PrefilterFlag: if this is 0 errors in data will not be removed, if it is 1
% errors in data will be deleted. 

% ListofManeuverIDs at the intersection, if data is synthetic this list is
% it is not needed, set [] instead.
%Note:
%SBT=1, SBR=2, SBL=3,
%WBT=4, WBR=5, WBL=6,
%NBT=7, NBR=8, NBL=9,
%EBT=10, EBR=11, EBL=12.

%SyntheticDataphases : phases from which synthetic data should be generated. 
% for example if the data is generated from phase 1 and 4 set this to be [1
% 4]. if you are not generating Synthetic data for fixed time intersection
% set the value to be [].

%emissionProbs: emission probabilities of a phase to generate maneuvers.
%This is only needed for a fixed time synthetic data generation. 

%NumCyclesbound: A bound that specify number maximum and minimum number of
%cycles you want to generate data from in a fixed time synthetic data
%generation. for example [2  10].

%numManeuversbound: for a fixed time signal synthetic data generation only.
%It specify the min and max number of maneuvers from each phase. for
%example if you want to generate data from 3 phases this value will be a 2
%by three matrix. The first row is the min values and the second row will
%be the max values. 

%AdaptiveDataGeneratorFlag: a flag that specify the method of data
%generation. set it to zero if you want to generate data from an HMM. set
%it to anything else to generate data from another method.

 %Hmm_for_AdaptiveSignal: set it to [] if you want to generate data from an
 %default HMM. 
 
  %adaptiveDatasize : size of data you want to generate. 
  
  % adaptiveNumCycle: if you want to use another method of adaptive data
  % generation set this value else set it to [].
 
  
  % ADAPTIVE SIGNAL DATA GENERATOR ONLY GENERATES DATA FOR A FULL FOUR WAY
  % INTERSECTION. 


function [data,numdataFiltered] = ...
    loadIntersectionData(fileName, listofManeuverIDs, prefilterFlag,...
    SyntheticDataphases,emissionProbs,NumCyclesbound,numManeuversbound,...
    AdaptiveDataGeneratorFlag, Hmm_for_AdaptiveSignal,...
    adaptiveDatasize,adaptivephaseSequenceLength)
   

    if isempty(fileName)
        error('You must specify the file name.');
    end
    
    if isempty(listofManeuverIDs)
        listofManeuverIDs =[1 2 3 4 5 6 7 8 9 10 11 12]; 
    end
    
    if isempty(prefilterFlag)
        prefilterFlag = 1; 
    end
    
    if isempty(SyntheticDataphases)
         SyntheticDataphases =0;
    end
    
    if isempty(emissionProbs)
      emissionProbs = 0; 
    end
    
    if isempty(NumCyclesbound)
      NumCyclesbound = 0; 
    end
    
    if isempty(numManeuversbound)
      numManeuversbound= 0; 
    end
    
    if isempty(AdaptiveDataGeneratorFlag)
        AdaptiveDataGeneratorFlag=0;
    end
    
       
    if isempty(adaptiveDatasize)
        adaptiveDatasize=0;
    end
    
    if isempty(adaptivephaseSequenceLength)
        adaptivephaseSequenceLength = 0;
    end
    
    
    
        
        if strcmp(fileName, 'syntethicAdaptive')
            numdataFiltered=0;
           if  AdaptiveDataGeneratorFlag==0  
               
            data = make_adaptive_synth_Data_fromHMM(adaptiveDatasize,...
                Hmm_for_AdaptiveSignal );% generates data from an hmm for an adaptive signal
            
           else
               data = make_adaptive_synthData_semiHMM(adaptivephaseSequenceLength); % thsi need to be modified if you want to use your own values
               
           end
        
            
        elseif strcmp(fileName , 'syntethicFixedTime')
            numdataFiltered=0;
            data =  generateSyntheticFixedTimeData...
                (SyntheticDataphases,emissionProbs,...
                NumCyclesbound,numManeuversbound); % generate synthetic data for a fixed time signal.
            
        else 
          [data,numdataFiltered] = giveRealData(fileName,listofManeuverIDs,...
                          prefilterFlag);% read data from a file.
           
        end
        
        
       

end