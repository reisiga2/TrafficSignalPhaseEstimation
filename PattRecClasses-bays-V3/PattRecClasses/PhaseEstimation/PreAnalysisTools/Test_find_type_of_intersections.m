% this script is to find type of intersection 
clear all
close all

% data set
   % this is data from fixed time intersection: green and first
%    maneuverIDList_Frist_Green = [68528,68531,68522,68524,68515,68530,....
%     68514,68533,68523,68532,68529,68513];
% 
% [data,numdataFiltered] =  ...
%     loadIntersectionData('GreenandFirst-gameData.xlsx',...
%     maneuverIDList_Frist_Green, 0,...
%     [],[],[],[],[],[],[],[]);% change 0 t0 1 if you want to pre-filter data
% 
% data = data(1:500,:);
%    
%--------------------------------------------------------------------
    % data set: data from fixed time intersection: 
%     maneuverIDList_fourth_kirby = [69050,69044,69079,...
%     69046,68914,69052,68913,69081,69045,69080,69051,68912];
% 
% [data,numdataFiltered] =  ...
%     loadIntersectionData('kirbyFourth.xlsx',...
%     maneuverIDList_fourth_kirby, 0,...
%     [],[],[],[],[],[],[],[]);
%-----------------------------------------------------------------
load hmm_adaptive
data = rand(hmm_adaptive, 300);
[fix_prob, adaptive_fix_total,adaptive_prob_total,adaptive_prob_data,...
    estimated_controller_type] =  give_type_of_intersection(data);



%end