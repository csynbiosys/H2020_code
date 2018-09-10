% This script creates a data structure with all the experimental data 
% acquired on the Toggle Switch
% questions: 
% The extraction relies on the info received through email exchange with
% Lugagne et al. 
% For the calibration Data, Media.csv files have been updated to ensure
% coherence with the profiles in FittingInputs.mat. 

%% Path to the data
clear all, clc, close all;
pathToData = '/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/Lugagne_model/Examining_Lugagne_experimental_data/Data_from_Lugagne_paper/CyberSwitch-master/Data/Experimental/';
data_to_compare = {'Calibration_1','Calibration_2','Calibration_3','Calibration_4','Calibration_5','Calibration_6',...
                    'PI_1','PI_2','PI_3',...
                    'BangBang_1','BangBang_2',...
                    'DynStim_1','DynStim_2','DynStim_3','DynStim_4','DynStim_5','DynStim_6','DynStim_7','DynStim_8','DynStim_9','DynStim_10','DynStim_11','DynStim_12','DynStim_13','DynStim_14',...
                    'DynStimTooFast'};

%% CALIBRATION %% Load up the datasets from Lugagne et al.
% FittingData are loaded and corrected for the lamp factor
% Only the Inputsbefore structure from FittingInputs is used. tcon, as well
% as the values of the inducers, are extracted from Media.csv for each
% experiment

for data_set=1:6
    data_comp= data_to_compare{data_set};
    disp(['Loading up data from: ' data_comp]);
    data(data_set).name = data_comp;
    cd(strcat(pathToData,data_comp));
    data(data_set).val = load('FittingData.mat');
    data(data_set).ind = load('FittingInputs.mat');
    
    
    % Adapt the levels with the lamp_factor
    data(data_set).val.rfpMothers=data(data_set).val.rfpMothers*data(data_set).val.lamp_mult;
    data(data_set).val.gfpMothers=data(data_set).val.gfpMothers*data(data_set).val.lamp_mult;
    % If time data starts negative, just shift it.
    data(data_set).val.timerfp = data(data_set).val.timerfp - data(data_set).val.timerfp(1);
    data(data_set).val.timegfp = data(data_set).val.timegfp - data(data_set).val.timegfp(1);
    cd('/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/ParameterEstimation/ExtractionAllExperimentalData')
end
%% REMAINING DATA
for data_set=7:length(data_to_compare)
    data_comp= data_to_compare{data_set};
    disp(['Loading up data from: ' data_comp]);
    data(data_set).name = data_comp;
    cd(strcat(pathToData,data_comp));
    data(data_set).val = load('Data.mat');
    
    data(data_set).val.rfpMothers=data(data_set).val.XP.rfp;
    data(data_set).val.gfpMothers=data(data_set).val.XP.gfp;
    % If time data starts negative, just shift it.
    data(data_set).val.timerfp = data(data_set).val.XP.timepoints - data(data_set).val.XP.timepoints(1);
    data(data_set).val.timegfp = data(data_set).val.timerfp;
    cd('/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/ParameterEstimation/ExtractionAllExperimentalData')
end

%%  This section extracts Switchingtimes and inducers values from Media.csv for each experiment
%% ALL DATA 
for data_set=1:length(data_to_compare)
    data_comp= data_to_compare{data_set};
    disp(['Loading up data from: ' data_comp]);
    cd(strcat(pathToData,data_comp));
    DataInd = readtable('Media.csv');
    IPTGLev = DataInd.Var1;
    aTcLev = DataInd.Var2;
    SwitchT = DataInd.Var3/60;
    if SwitchT(1)==0
        EXP_data{1,data_set}.IPTGext = IPTGLev(2:end);
        EXP_data{1,data_set}.aTcext = aTcLev(2:end);
        EXP_data{1,data_set}.switchingtimes = SwitchT;
    else 
        EXP_data{1,data_set}.IPTGext = IPTGLev;
        EXP_data{1,data_set}.aTcext = aTcLev;
        EXP_data{1,data_set}.switchingtimes = [0;SwitchT];
    end
end
cd('/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/ParameterEstimation/ExtractionAllExperimentalData')

%%
Data.expName = data_to_compare;
i = 0;
for data_set=1:length(Data.expName)
    i = i+1;
    Data.exp_data{1,i} = [nanmean(data(data_set).val.rfpMothers,2)'; nanmean(data(data_set).val.gfpMothers,2)'];
    Data.standard_dev{1,i} = [nanstd(data(data_set).val.rfpMothers,[],2)';nanstd(data(data_set).val.gfpMothers,[],2)'];
    Data.n_samples{1,i} = [length(data(data_set).val.rfpMothers) length(data(data_set).val.gfpMothers)]';
    Data.t_samples{1,i} = [data(data_set).val.timerfp/60; data(data_set).val.timegfp/60]; % sampling time in minutes
    Data.t_con{1,i} = [[EXP_data{1,data_set}.switchingtimes(1:end-1,1);max(Data.t_samples{1,data_set}(:,end))] [EXP_data{1,data_set}.switchingtimes(1:end-1);max(Data.t_samples{1,data_set}(:,end))]]';
    Data.input{1,i} = [EXP_data{1,data_set}.IPTGext EXP_data{1,data_set}.aTcext]';
    if data_set<7
        Data.Initial_IPTG{1,i} = data(data_set).ind.inputsbefore(1,2);
        Data.Initial_aTc{1,i} = data(data_set).ind.inputsbefore(1,1);
    elseif strcmp(data_to_compare{data_set},'DynStimTooFast')
        Data.Initial_IPTG{1,i} = 0.25;
        Data.Initial_aTc{1,i} = 20;
    else
        Data.Initial_IPTG{1,i} = 1;
        Data.Initial_aTc{1,i} = 0;
    end
        
end


%%
save('AllDataLugagne_Final.mat','Data')            
            