% This script creates a structure with the calibration data, 

clear all, clc, close all;
pathToData = '/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/Lugagne_model/Examining_Lugagne_experimental_data/Data_from_Lugagne_paper/CyberSwitch-master/Data/Experimental/';
data_to_compare = {'Calibration_1','Calibration_2','Calibration_3',...
                 'Calibration_4','Calibration_5','Calibration_6'};
%% Load up the datasets from Lugagne et al.
% FittingData are loaded and corrected for the lamp factor
% Only the Inputsbefore structure from FittingInputs is used. tcon, as well
% as the values of the inducers, are extracted from Media.csv for each
% experiment

for data_set=1:length(data_to_compare)
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

%%  This section extracts Switchingtimes and inducers values from Media.csv for each experiment
for data_set=1:length(data_to_compare)
    data_comp= data_to_compare{data_set};
    disp(['Loading up data from: ' data_comp]);
    cd(strcat(pathToData,data_comp));
    DataInd = readtable('Media.csv');
    IPTGLev = DataInd.Var1;
    aTcLev = DataInd.Var2;
    SwitchT = DataInd.Var3/60;
    EXP_data{1,data_set}.IPTGext = IPTGLev;
    EXP_data{1,data_set}.aTcext = aTcLev;
    EXP_data{1,data_set}.switchingtimes = [0;SwitchT];
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
    Data.Initial_IPTG{1,i} = data(data_set).ind.inputsbefore(1,2);
    Data.Initial_aTc{1,i} = data(data_set).ind.inputsbefore(1,1);
end

save('LugagneCalibrationData.mat','Data')    
%%  Analysis to see if the reconstruction from Media.csv is coherent with the FittingInputs used by Lugagne et al. 
% The results are not consistent for 
% Calibration_exps_IPTG = [2];
% Calibration_exps_aTc = [2,5,6];
for data_set=1:length(data_to_compare)
    data_comp= data_to_compare{data_set};
    disp(['Loading up data from: ' data_comp]);
    cd(strcat(pathToData,data_comp));
    DataInd = readtable('Media.csv');
    IPTGLev = DataInd.Var1;
    aTcLev = DataInd.Var2;
    SwitchT = DataInd.Var3/60;
    IPTG = zeros(1,length(0:1:data(data_set).val.timerfp(end)/60));
    aTc = zeros(1,length(0:1:data(data_set).val.timerfp(end)/60));
    t_samples = 0:1:data(data_set).val.timerfp(end)/60;
    length(t_samples)
    length(IPTG)
    IPTG(1,:) = IPTGLev(1);
    aTc(1,:)= aTcLev(1);
    for i=1:length(IPTGLev)-1
            up = find(t_samples>= SwitchT(i,1),1);
            IPTG(1,up:end) = IPTGLev(i+1);
            aTc(1,up:end) = aTcLev(i+1);
    end
    EXP_data{1,data_set}.IPTGext = IPTG;
    EXP_data{1,data_set}.aTcext = aTc;
    EXP_data{1,data_set}.time = t_samples;
    length(EXP_data{1,data_set}.IPTGext)
end

% Verify that the inputs are reconstructed correctly
for i=1:length(data_to_compare)
    figure;
    plot(EXP_data{1,i}.time, EXP_data{1,i}.IPTGext); hold on; 
    plot(data(i).ind.inputs(2,:));
    title('IPTG')
    legend('us','Lugagne')
end

for i=1:length(data_to_compare)
    figure;
    plot(EXP_data{1,i}.time, EXP_data{1,i}.aTcext); hold on; 
    plot(data(i).ind.inputs(1,:));
    title('aTc')
    legend('us','Lugagne')
end
%%        
load('Calibration_1-6.mat')
for j=1:length(EXP_data)
    i = i+1;
    Data.input{1,i} = [EXP_data{1,j}.IPTGext EXP_data{1,j}.aTCext]';
    Data.n_samples{1,i} = [length(EXP_data{1,j}.meanRFP) length(EXP_data{1,j}.meanGFP)]';
    Data.t_samples{1,i} = [EXP_data{1,j}.timerfp; EXP_data{1,j}.timeGFP];
    if EXP_data{1,j}.timerfp(end)<EXP_data{1,j}.switching_time(end)
          Data.t_con{1,i} = [[0;EXP_data{1,j}.switching_time(1:end-1);EXP_data{1,j}.timerfp(end)] [0;EXP_data{1,j}.switching_time(1:end-1);EXP_data{1,j}.timerfp(end)]]';
    end
    Data.exp_data{1,i} = [EXP_data{1,j}.meanRFP EXP_data{1,j}.meanGFP]';
    Data.standard_dev{1,i} = [EXP_data{1,j}.stdRFP EXP_data{1,j}.stdGFP]';
    Data.Initial_IPTG{1,i} = 1;
    Data.Initial_aTc{1,i} = 0;
end