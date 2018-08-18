% This script creates a data structure with all the experimental data 
% acquired on the Toggle Switch
% questions: 
% Why in PI_1-3.mat the switching times equal the sampling times?
% Why t_samples(end)<< t_con(end)?
% Why length(t_con) == length(input)? Normally length(input) =
% length(t_con)-1. The problem could be that the first t_con is not
% occurring at 0. 
%% Load the first dataset
load('PI_1-3.mat');

for i=1:length(EXP_data)
    Data.t_con{1,i} = [EXP_data{1,i}.switching_time EXP_data{1,i}.switching_time]';
    Data.input{1,i} = [EXP_data{1,i}.IPTGext EXP_data{1,i}.aTCext]';
    Data.n_samples{1,i} = [length(EXP_data{1,i}.meanRFP) length(EXP_data{1,i}.meanGFP)]';
    Data.t_samples{1,i} = [EXP_data{1,i}.timerfp; EXP_data{1,i}.timeGFP];
    Data.exp_data{1,i} = [EXP_data{1,i}.meanRFP EXP_data{1,i}.meanGFP]';
    Data.standard_dev{1,i} = [EXP_data{1,i}.stdRFP EXP_data{1,i}.stdGFP]';
    Data.Initial_IPTG{1,i} = EXP_data{1,i}.init(1,1);
    Data.Initial_aTc{1,i} = EXP_data{1,i}.init(1,2);
end

%%
load('DynStimTooFast_1-1.mat')
for j=1:length(EXP_data)
    i = i+1;
    Data.t_con{1,i} = [EXP_data{1,j}.switching_time EXP_data{1,j}.switching_time]';
    Data.input{1,i} = [EXP_data{1,j}.IPTGext EXP_data{1,j}.aTCext]';
    Data.n_samples{1,i} = [length(EXP_data{1,j}.meanRFP) length(EXP_data{1,j}.meanGFP)]';
    Data.t_samples{1,i} = [EXP_data{1,j}.timerfp; EXP_data{1,j}.timeGFP];
    Data.exp_data{1,i} = [EXP_data{1,j}.meanRFP EXP_data{1,j}.meanGFP]';
    Data.standard_dev{1,i} = [EXP_data{1,j}.stdRFP EXP_data{1,j}.stdGFP]';
    Data.Initial_IPTG{1,i} = EXP_data{1,j}.init(1,1);
    Data.Initial_aTc{1,i} = EXP_data{1,j}.init(1,2);

end

%%
load('DynStim_1-14.mat')
for j=1:length(EXP_data)
    i = i+1;
    Data.t_con{1,i} = [EXP_data{1,j}.switching_time EXP_data{1,j}.switching_time]';
    Data.input{1,i} = [EXP_data{1,j}.IPTGext EXP_data{1,j}.aTCext]';
    Data.n_samples{1,i} = [length(EXP_data{1,j}.meanRFP) length(EXP_data{1,j}.meanGFP)]';
    Data.t_samples{1,i} = [EXP_data{1,j}.timerfp; EXP_data{1,j}.timeGFP];
    Data.exp_data{1,i} = [EXP_data{1,j}.meanRFP EXP_data{1,j}.meanGFP]';
    Data.standard_dev{1,i} = [EXP_data{1,j}.stdRFP EXP_data{1,j}.stdGFP]';
    Data.Initial_IPTG{1,i} = EXP_data{1,j}.init(1,1);
    Data.Initial_aTc{1,i} = EXP_data{1,j}.init(1,2);
end

%%
%
load('Calibration_1-6.mat')
for j=1:length(EXP_data)
    i = i+1;
    Data.t_con{1,i} = [EXP_data{1,j}.switching_time EXP_data{1,j}.switching_time]';
    Data.input{1,i} = [EXP_data{1,j}.IPTGext EXP_data{1,j}.aTCext]';
    Data.n_samples{1,i} = [length(EXP_data{1,j}.meanRFP) length(EXP_data{1,j}.meanGFP)]';
    Data.t_samples{1,i} = [EXP_data{1,j}.timerfp; EXP_data{1,j}.timeGFP];
    Data.exp_data{1,i} = [EXP_data{1,j}.meanRFP EXP_data{1,j}.meanGFP]';
    Data.standard_dev{1,i} = [EXP_data{1,j}.stdRFP EXP_data{1,j}.stdGFP]';
    Data.Initial_IPTG{1,i} = EXP_data{1,j}.init(1,1);
    Data.Initial_aTc{1,i} = EXP_data{1,j}.init(1,2);
    
end
%%
load('BangBang_1-2.mat')
for j=1:length(EXP_data)
    i = i+1;
    Data.t_con{1,i} = [EXP_data{1,j}.switching_time EXP_data{1,j}.switching_time]';
    Data.input{1,i} = [EXP_data{1,j}.IPTGext EXP_data{1,j}.aTCext]';
    Data.n_samples{1,i} = [length(EXP_data{1,j}.meanRFP) length(EXP_data{1,j}.meanGFP)]';
    Data.t_samples{1,i} = [EXP_data{1,j}.timerfp; EXP_data{1,j}.timeGFP];
    Data.exp_data{1,i} = [EXP_data{1,j}.meanRFP EXP_data{1,j}.meanGFP]';
    Data.standard_dev{1,i} = [EXP_data{1,j}.stdRFP EXP_data{1,j}.stdGFP]';
    Data.Initial_IPTG{1,i} = EXP_data{1,j}.init(1,1);
    Data.Initial_aTc{1,i} = EXP_data{1,j}.init(1,2);
    
end

%
Data.expName = {'PI_1_1','PI_1_2','PI_1_3',...
                'DynStimTooFast_1_1',...
                'DynStim_1_1','DynStim_1_2','DynStim_1_3','DynStim_1_4','DynStim_1_5','DynStim_1_6','DynStim_1_7','DynStim_1_8','DynStim_1_9','DynStim_1_10','DynStim_1_11','DynStim_1_12','DynStim_1_13','DynStim_1_14',...
                'Calibration_1_1','Calibration_1_2','Calibration_1_3','Calibration_1_4','Calibration_1_5','Calibration_1_6',...
                'BangBang_1_1','BangBang_1_2'};