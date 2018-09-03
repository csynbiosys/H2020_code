% Time derivative of the fluorescent reporters to see if cells are actually
% at steady state. 
figure;
subplot(3,2,1)
    plot(diff(mean(data(1).val.rfpMothers,2)));
    xlabel('time')
    ylabel('d/dt RFP')
    title('Calibration 1')
subplot(3,2,2)
    plot(diff(mean(data(2).val.rfpMothers,2)));
    xlabel('time')
    ylabel('d/dt RFP')
    title('Calibration 2')
subplot(3,2,3)
    plot(diff(mean(data(3).val.rfpMothers,2)));
    xlabel('time')
    ylabel('d/dt RFP')
    title('Calibration 3')
subplot(3,2,4)
    plot(diff(mean(data(2).val.rfpMothers,2)));
    xlabel('time')
    ylabel('d/dt RFP')
    title('Calibration 2')
subplot(3,2,5)
    plot(diff(mean(data(5).val.rfpMothers,2)));
    xlabel('time')
    ylabel('d/dt RFP')
    title('Calibration 5')
subplot(3,2,6)
    plot(diff(mean(data(6).val.rfpMothers,2)));
    xlabel('time')
    ylabel('d/dt RFP')
    title('Calibration 6')
    
%% plot of the Y0 for each experiment
% Y0Analyt: inital condition as the steady state obtained with analytical method
% Y0Used: initial condition for the experiment simulation (4800 min with inputsbefore, starting from Analyt)

for i=1:numel(data)
    figure;
    plot(1:1:6,Y0Analyt(i,:),'o'); hold on; 
    plot(1:1:6,Y0Used(i,:),'o'); hold on; 
    plot(3,mean(data(i).val.rfpMothers(1,:),2),'*'); hold on; 
    plot(4,mean(data(i).val.gfpMothers(1,:),2),'*')
    legend('Analytical','Used','rfp experimental','gfp experimental')
    title(data_to_compare{i})
    
end

%% Decision to have a look at the traces from which Used has been extracted
% Calibration 1
[Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym] = plot_mean_optimised_results_attempt(p,data(1));
figure; 
subplot(2,1,1)
plot(t/60,Ym(:,3)); hold on;
xlabel('time (min)')
ylabel('RFP (a.u.)')
title(data_to_compare{1})
subplot(2,1,2)
plot(t/60,Ym(:,4)); hold on;
xlabel('time (hours)')
ylabel('GFP (a.u.)')
%%
% Calibration 2
[Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym] = plot_mean_optimised_results_attempt(p,data(2));
figure; 
subplot(2,1,1)
plot(t/60,Ym(:,3)); hold on;
xlabel('time (min)')
ylabel('RFP (a.u.)')
title(data_to_compare{2})
subplot(2,1,2)
plot(t/60,Ym(:,4)); hold on;
xlabel('time (hours)')
ylabel('GFP (a.u.)')

%%
% Calibration 3
[Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym] = plot_mean_optimised_results_attempt(p,data(3));
figure; 
subplot(2,1,1)
plot(t/60,Ym(:,3)); hold on;
xlabel('time (min)')
ylabel('RFP (a.u.)')
title(data_to_compare{3})
subplot(2,1,2)
plot(t/60,Ym(:,4)); hold on;
xlabel('time (hours)')
ylabel('GFP (a.u.)')

%%
% Calibration 4
[Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym] = plot_mean_optimised_results_attempt(p,data(4));
figure; 
subplot(2,1,1)
plot(t/60,Ym(:,3)); hold on;
xlabel('time (min)')
ylabel('RFP (a.u.)')
title(data_to_compare{4})
subplot(2,1,2)
plot(t/60,Ym(:,4)); hold on;
xlabel('time (hours)')
ylabel('GFP (a.u.)')
%%
% Calibration 5
[Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym] = plot_mean_optimised_results_attempt(p,data(5));
figure; 
subplot(2,1,1)
plot(t/60,Ym(:,3)); hold on;
xlabel('time (min)')
ylabel('RFP (a.u.)')
title(data_to_compare{5})
subplot(2,1,2)
plot(t/60,Ym(:,4)); hold on;
xlabel('time (hours)')
ylabel('GFP (a.u.)')
%%
% Calibration 6
[Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym] = plot_mean_optimised_results_attempt(p,data(6));
figure; 
subplot(2,1,1)
plot(t/60,Ym(:,3)); hold on;
xlabel('time (min)')
ylabel('RFP (a.u.)')
title(data_to_compare{6})
subplot(2,1,2)
plot(t/60,Ym(:,4)); hold on;
xlabel('time (hours)')
ylabel('GFP (a.u.)')
