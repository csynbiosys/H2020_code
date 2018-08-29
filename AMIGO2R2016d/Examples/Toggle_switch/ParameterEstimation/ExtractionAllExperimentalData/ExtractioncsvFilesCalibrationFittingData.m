% Extract data from Calibration experiments and create csv file to be used

clear all, clc, close all;
pathToData = '/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/Lugagne_model/Examining_Lugagne_experimental_data/Data_from_Lugagne_paper/CyberSwitch-master/Data/Experimental/';
data_to_compare = {'Calibration_1','Calibration_2','Calibration_3',...
                 'Calibration_4','Calibration_5','Calibration_6'};
%% Load up the datasets:

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

%% Extract a csv file with time (min), mean and std for each fluorescent reporter, for each experiment
GFP_start_mean = [];
RFP_start_mean = [];
GFP_start_std = [];
RFP_start_std = [];
for data_set=1:length(data)
    time_rfp_min = data(data_set).val.timerfp/60;
    time_gfp_min = data(data_set).val.timegfp/60;
    gfp_mean = nanmean(data(data_set).val.gfpMothers,2);
    gfp_std = nanstd(data(data_set).val.gfpMothers,[],2);
    rfp_mean = nanmean(data(data_set).val.rfpMothers,2);
    rfp_std = nanstd(data(data_set).val.rfpMothers,[],2);
    index = linspace(1,length(time_rfp_min),length(time_rfp_min));
    rowsi = strread(num2str(index),'%s');
    Data= table(time_rfp_min',time_gfp_min',gfp_mean,gfp_std,rfp_mean,rfp_std,'RowNames',rowsi);
    writetable(Data,strcat(data_to_compare{data_set},'_Expression.csv'));    
    GFP_start_mean = [GFP_start_mean,gfp_mean(1)];
    GFP_start_std = [GFP_start_std,gfp_std(1)];
    RFP_start_mean = [RFP_start_mean,rfp_mean(1)];
    RFP_start_std = [RFP_start_std,rfp_std(1)];
end
%% Plot to verify which are the initial conditions
figure(1);
errorbar(1:1:length(GFP_start_mean),GFP_start_mean,GFP_start_std,'o'); hold on;
figure(2);
errorbar(1:1:length(RFP_start_mean),RFP_start_mean,RFP_start_std,'o'); hold on;
% Apparently, the info.txt in the calibration experiment is wrong as to
% what concerns the ON incubation. You should consider
% data(i).ind.inputsbefore, where 1: aTC and 2: IPTG
%% Extract a csv file with time aTc and IPTG for each experiment
for data_set=1:length(data_to_compare)
    data_comp= data_to_compare{data_set};
    disp(['Loading up data from: ' data_comp]);
    cd(strcat(pathToData,data_comp));
    DataInd = readtable('Media.csv');
    IPTGLev = DataInd.Var1;
    aTcLev = DataInd.Var2;
    SwitchT = DataInd.Var3;
    IPTG = [];
    aTc = [];
    for i=1:length(IPTGLev)
        if i== length(IPTGLev)
            t = max([data(data_set).val.timerfp(end)/60,data(data_set).val.timegfp(end)/60]); % last acquisition time point 
            IPTG = [IPTG repmat(IPTGLev(i),[1,length(length(IPTG):1:round(t))])];
            aTc = [aTc repmat(aTcLev(i),[1,length(length(aTc):1:round(t))])];

        else  
            IPTG = [IPTG repmat(IPTGLev(i),[1,length(length(IPTG):1:round(SwitchT(i)/60))])];
            aTc = [aTc repmat(aTcLev(i),[1,length(length(aTc):1:round(SwitchT(i)/60))])];
        end
    end
    time_input = [0:1:round(t)]';
    aTc_pre = data(data_set).ind.inputsbefore(1,1).*ones(length(aTc),1);
    IPTG_pre = data(data_set).ind.inputsbefore(1,2).*ones(length(IPTG),1);
    index = linspace(1,length(time_input),length(time_input));
    rowsi = strread(num2str(index),'%s');
    Data= table(time_input,IPTG_pre,aTc_pre,IPTG',aTc','RowNames',rowsi);
    cd('/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/ParameterEstimation/ExtractionAllExperimentalData')

    writetable(Data,strcat(data_to_compare{data_set},'_Inputs.csv'));   
  
    
end


