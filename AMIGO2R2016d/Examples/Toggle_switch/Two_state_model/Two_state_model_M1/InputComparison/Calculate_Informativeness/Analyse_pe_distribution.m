% %% Generate CSV file with parameter estimates from all trials
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exclude the list of failed trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% excl=[10,25,40,61,64,78,81,89,99]; % list of failed trials when using CVODE
% 
% trials=(1:1:100);
% 
% % best theta guesses
% PE_IPC_step=[];
% 
% for trials=1:100
%  
%     
%     if trials~=10 && trials~=25 && trials~=40 && ...
%             trials~=61 && trials~=64 && trials~=78 && trials~=81 && ...
%             trials~=89 && trials~=99
%         
%         load(strcat('ICS_cv-',num2str(trials),'.dat'));
%         PE_IPC_step=[PE_IPC_step; best_global_theta_log{1, 10}']; %#ok<AGROW>
%         
%     end
%     
%     
% end
% 
% % write csv file with estimated parameter values
% csvwrite('TSM_Step.csv',PE_IPC_step)

%% Generate plots showing distribution of parameters


% % Generate Violin plots
% violinplot(best_theta_Step(:,1:7),inputs.model.par_names(1:7,:));
% 
% 
%% 
% figure(1)
% 
% for i=1:14
%     subplot(3,5,i)
%     violinplot(best_theta_Step(:,i))
%     title(strcat('True value (',inputs.model.par_names(i,:),')','=',num2str(inputs.model.par(i))));    
% end
% 


%% Plot Informativeness
best_theta_Step=importdata('TSM_Step.csv'); 
load('ModelParameters.mat')

figure(1)

for i=1:14
    error(:,i)=log2(best_theta_Step(:,i)./true_param_values(1,i));
end

set(gca,'TickLabelInterpreter','latex');
boxplot(error,par_names); hold on;
violinplot(error)
