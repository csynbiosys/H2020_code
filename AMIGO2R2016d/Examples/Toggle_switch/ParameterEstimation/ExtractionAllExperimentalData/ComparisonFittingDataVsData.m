% trying to workout which is the correction that has been performed to pass
% from data to fitting data
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
    data(data_set).Data = load('Data.mat');
    data(data_set).FittingData = load('FittingData.mat');
    
%     % Adapt the levels with the lamp_factor
%     data(data_set).val.rfpMothers=data(data_set).val.rfpMothers*data(data_set).val.lamp_mult;
%     data(data_set).val.gfpMothers=data(data_set).val.gfpMothers*data(data_set).val.lamp_mult;
%     % If time data starts negative, just shift it.
%     data(data_set).val.timerfp = data(data_set).val.timerfp - data(data_set).val.timerfp(1);
%     data(data_set).val.timegfp = data(data_set).val.timegfp - data(data_set).val.timerfp(1);
    cd('/Users/lucia/Documents/Projects/H2020/H2020_code/AMIGO2R2016d/Examples/Toggle_switch/ParameterEstimation/ExtractionAllExperimentalData')
end

%% Now try to workout what is happening
for i =1:length(data)
    figure(i)
    %plot(data(i).Data.XP.timepoints/60,mean(data(i).Data.XP.rfp,2),'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2))*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2),'lowess')*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2),'loess')*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2),'sgolay')*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2),'rlowess')*data(i).FittingData.lamp_mult,'o'); hold on; 
    %plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2),'rloess')*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).FittingData.timerfp/60,mean(data(i).FittingData.rfpMothers,2)*data(i).FittingData.lamp_mult,'*'); 
    title(strcat('RFP ave plots for Data and Fitting data: ',data_to_compare{i}))
    legend('Moving Scaled Data','lowess Scaled Data','loess Scaled Data','sgolay Scaled Data','rlowess Scaled Data','ScaledFittingData')
end

%%
for i =1:length(data)
    figure(i)
    plot(data(i).Data.XP.timepoints/60,mean(data(i).Data.XP.rfp,2),'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2)),'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.rfp,2))*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).FittingData.timerfp/60,mean(data(i).FittingData.rfpMothers,2),'*'); hold on; 
    plot(data(i).FittingData.timerfp/60,mean(data(i).FittingData.rfpMothers,2)*data(i).FittingData.lamp_mult,'*'); 
    title(strcat('RFP ave plots for Data and Fitting data: ',data_to_compare{i}))
    legend('Data','Smoothed Data','Smoothed Scaled Data','FittingData','ScaledFittingData')
end

%%
for i =1:length(data)
    figure(10+i)
    plot(data(i).Data.XP.timepoints/60,mean(data(i).Data.XP.gfp,2),'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.gfp,2)),'o'); hold on; 
    plot(data(i).Data.XP.timepoints/60,smooth(mean(data(i).Data.XP.gfp,2))*data(i).FittingData.lamp_mult,'o'); hold on; 
    plot(data(i).FittingData.timerfp/60,mean(data(i).FittingData.gfpMothers,2),'*'); hold on; 
    plot(data(i).FittingData.timerfp/60,mean(data(i).FittingData.gfpMothers,2)*data(i).FittingData.lamp_mult,'*'); 
    title(strcat('GFP ave plots for Data and Fitting data: ',data_to_compare{i}))
    legend('Data','Smoothed Data','Smoothed Scaled Data','FittingData','ScaledFittingData')
end