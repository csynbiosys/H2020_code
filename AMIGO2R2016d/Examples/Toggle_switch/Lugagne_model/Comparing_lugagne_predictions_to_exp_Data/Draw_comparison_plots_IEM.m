function [SSE_LacI,SSE_TetR] = Draw_comparison_plots(EXP_data,results,inputs)
% calculate SSE to compare simulation data with expeimental data from
% Lugagne paper


SSE_LacI=[];
SSE_TetR=[];

for i=1:inputs.exps.n_exp

    figure(1)
    subplot(6,1,i)
    % plot(EXP_data{1,i}.timerfp/3600,EXP_data{1,i}.meanRFP,'r--+'); hold on;
    plot(results.sim.tsim{1,i}./60,results.sim.states{1,i}(:,4),'red'); hold on;
    title(strcat('calibration-',num2str(i+1)))
    xlabel('time(hours)')

    %figure(2)
    %subplot(2,3,i)
    %plot(EXP_data{1,i}.timeGFP/3600,EXP_data{1,i}.meanGFP,'g--+'); hold on;
    plot(results.sim.tsim{1,i}./60,results.sim.states{1,i}(:,5),'green'); hold on;
    title(strcat('calibration-',num2str(i+1)))
    xlabel('time(hours)')


    %% SSE calculation

    SSE_LacI=[SSE_LacI,sum((EXP_data{1,i}.meanGFP-results.sim.states{1,i}(:,4)).^2)]; %#ok<*AGROW>
    SSE_TetR=[SSE_TetR,sum((EXP_data{1,i}.meanRFP-results.sim.states{1,i}(:,5)).^2)];

end

end
