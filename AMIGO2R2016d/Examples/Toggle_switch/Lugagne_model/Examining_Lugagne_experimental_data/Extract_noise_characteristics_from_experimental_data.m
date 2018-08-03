function [EXP_data] = Extract_noise_characteristics_from_experimental_data()

% Script to analyse experimental data shared by Lugagne et al in their paper. 
% This script will plot the fluorescence data (GFP and RFP) per cell and 
% calculate mean and standard deviation in fluorescence measurements 
% 
% 
% figure(1)
% subplot(1,2,1)
% %plot(timegfp,gfpMothers,'green'); hold on;
% plot(timegfp,mean(gfpMothers,2),'black'); hold on;
% err_gfp=std(gfpMothers,1,2); hold on;
% errorbar(timegfp,mean(gfpMothers,2),err_gfp,'yellow'); hold on;
% 
% subplot(1,2,2)
% %plot(timerfp,rfpMothers,'red'); hold on;
% plot(timerfp,mean(rfpMothers,2),'black'); hold on;
% err_rfp=std(rfpMothers,1,2); hold on;
% errorbar(timerfp,mean(rfpMothers,2),err_rfp,'blue'); hold on;



EXP_data=cell(1,6); 


for a=1:6  
    
    p1='Data_from_Lugagne_paper\CyberSwitch-master\Data\Experimental\Calibration_';
    p2=strcat(num2str(a),'\');
    
    name=(strcat(p1,p2)); 
    cd (name)
    
    % Load data
    load('FittingData.mat');
    load('FittingInputs.mat')
    
    meanGFP=mean(gfpMothers,2);
    stdGFP=std(gfpMothers,1,2); 
    meanRFP=mean(rfpMothers,2);
    stdRFP=std(rfpMothers,1,2); 
    
    EXP_data{1,a}=struct('meanGFP',meanGFP,'stdGFP',stdGFP,'meanRFP',meanRFP,'stdRFP',stdRFP,'timeGFP',timegfp,'timerfp',timerfp,'IPTGext',inputsbefore(1,2),'aTcext',inputsbefore(1,1));
    
    % Plot the noise characteristics of different calibration data sets
    figure(1)
    subplot(2,3,a)
    shadedErrorBar(timegfp/60,mean(gfpMothers,2),stdGFP,'lineprops','g'); hold on;
    shadedErrorBar(timerfp/60,mean(rfpMothers,2),stdRFP,'lineprops','r'); hold on;
    xlabel('Time in minutes')
    ylabel('Fluorescence (AU)')

    cd ..  
end

cd C:\Users\vkothama\GoogleDrive\PostDoc\Edinburgh\Projects\H2020\ToggleSwitch\Tools\AMIGO2R2016d\Examples\Toggle_switch\LugagneModel\analysing_experimental_data

save('LugagneData_init','EXP_data')


end
