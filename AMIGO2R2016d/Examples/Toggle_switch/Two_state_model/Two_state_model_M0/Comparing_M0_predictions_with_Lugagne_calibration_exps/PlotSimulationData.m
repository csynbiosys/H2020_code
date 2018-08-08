% After Loading the results folder, please run the following lines of code
% to plot predicted values of LacI and TetR from Simulation data. 

figure(1)
fig = figure;
left_color = [1 0 0]; 
right_color = [0 1 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);


for i=1:5
subplot(2,3,i); 
title(strcat('calibration dataset-',num2str(i+1)))
yyaxis left
plot(results.sim.tsim{1,i},exp(results.sim.states{1,i}(:,3)),'red'); hold on;
ylabel('LacI-RFP / TetR - GFP')
yyaxis right
plot(results.sim.tsim{1,i},exp(results.sim.states{1,i}(:,4)),'green'); hold on;
xlabel('Time (minutes)')
end


% plot experimental data
% Load Lugagne Experimental Data

load('LugagneData_init.mat')

for i=1:5
subplot(2,3,i); 
title(strcat('calibration dataset-',num2str(i+1)))
yyaxis left
plot(EXP_data{1,i}.timeGFP./60,EXP_data{1,i}.meanRFP,'red'); hold on;
ylabel('LacI-RFP / TetR - GFP')
yyaxis right
plot(EXP_data{1,i}.timeGFP./60,EXP_data{1,i}.meanGFP,'green'); hold on;
xlabel('Time (minutes)')
end