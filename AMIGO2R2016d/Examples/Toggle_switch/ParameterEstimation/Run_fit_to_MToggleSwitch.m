function [] = Run_fit_to_MToggleSwitch( resultBase, numExperiments )
% This function runs the script for the identification of the model structure
% we propose to describe the Toggle switch to the experimental data published in Lugagne et al., 2017.
% The dataset includes 26 experiments (6 calibration+20 control). Inconsistencies noted in the original repository of
% the paper have been addressed through private communication with the
% authors and corrected accordingly. Parameter estimation is performed
% using crossvalidation. To this end we split the data between training set
% (17 randomised experiments)and test (9 experiments) set. SSE is computed
% over the test set to select the best parameter estimates. 
% It takes two inputs:
% - a string with the identifier of the output files
% - the number of iterations of parameter estimation. 
% In the paper we used numExperiments = 100.

cd ('../../../');
AMIGO_Startup();
cd('Examples\Toggle_switch\ParameterEstimation');
  
% Create a matrix of initial guesses for the parameters, having as many
% rows as the number of PE iterations (numExperiments)
% Each vector is passed as input to the computing function
% theta_min = [5e-6,1e-3,1,2,2,1e-5,1e-3,1e-4,2,2,10,10,0.001,0.001];
% theta_max = [10,1000,100,4,4,30,1000,1e-2,4,4,1000,1000,0.1,0.1];
% theta_min = [5e-06,1e-3,1,2,2,1e-05,0.001,3.07e-4,2,2,1.32,1,0.001,0.001]; % verify Theta_T is correct 
% theta_max = [10,1000,100,4,4,30,1000,3.07e-2,4,4,1320,1000,0.1,0.1]; 
% theta_min = [5e-06,1e-3,70,1,2,2,1e-05,0.001,7,3.07e-4,2,2,1.32,1,0.001,0.001]; % increased upper bound on kdiff, Theta_TetR and Theta_LacI free %MatrixParameters2
% theta_max = [10,1000,7000,100,4,4,30,1000,700,3.07e-2,4,4,1320,1000,1,1];

% theta_min = [5e-06,1e-3,70,1,2,2,1e-05,0.001,7,3.07e-4,2,2,1.32,1,0.001,0.001]; % Theta_TetR and Theta_LacI free %MatrixParameters2
% theta_max = [10,1000,7000,100,4,4,30,1000,700,3.07e-2,4,4,1320,1000,.1,.1];
% M_norm = lhsdesign(numExperiments,length(theta_min));
% M = zeros(size(M_norm));
% for c=1:size(M_norm,2)
%     for r=1:size(M_norm,1)
%         M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
%     end
% end 
% 
% % %check the location of the parameters that are fixed
% % ParFull = [0.1386*ones(size(M,1),1) M(:,1:2) 40*ones(size(M,1),1) M(:,3:5) 0.0165*ones(size(M,1),1) M(:,6:7) 0.0215*ones(size(M,1),1) M(:,8:end)];
% % new 
% ParFull = [0.1386*ones(size(M,1),1) M(:,1:6) 0.0165*ones(size(M,1),1) M(:,7:end)];
% % 
%   save('MatrixParameters2.mat','ParFull');


load('MatrixParameters2.mat');

parfor epcc_exps=1:numExperiments
        try
            global_theta_guess = ParFull(epcc_exps,:);
            epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];
            [out] = fit_to_ToggleSwitch(epccOutputResultFileNameBase,epcc_exps,global_theta_guess);
        catch err
            %open file
            errorFile = [resultBase,'-',num2str(epcc_exps),'.errorLog'];
            fid = fopen(errorFile,'a+');
            fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
            % close file
            fclose(fid);
        end
end

