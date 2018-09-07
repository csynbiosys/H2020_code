function [] = Run_fit_to_MToggleSwitch( resultBase, numExperiments )
% This function runs the script for the identification of the model structure
% we propose to describe the Toggle switch to the experimental data published in Lugagne et al., 2017.
% Given the limited number of experimental data we do not use crossvalidation. 
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
% M_norm = lhsdesign(numExperiments,length(theta_min));
% M = zeros(size(M_norm));
% for c=1:size(M_norm,2)
%     for r=1:size(M_norm,1)
%         M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
%     end
% end 
% 
% %check the location of the parameters that are fixed
% ParFull = [0.1386*ones(size(M,1),1) M(:,1:2) 40*ones(size(M,1),1) M(:,3:5) 0.0165*ones(size(M,1),1) M(:,6:7) 0.0215*ones(size(M,1),1) M(:,8:end)];
% save('MatrixParameters.mat','ParFull');


load('MatrixParameters.mat');

parfor epcc_exps=1:numExperiments
        try
            global_theta_guess = ParFull(epcc_exps,:);
            epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];
            [out] = fit_to_ToggleSwitch(epccOutputResultFileNameBase,epcc_exps,global_theta_guess);
            %[out] = LookingForNegativeSolutions(epccOutputResultFileNameBase,epcc_exps,global_theta_guess);
        catch err
            %open file
            errorFile = [resultBase,'-',num2str(epcc_exps),'.errorLog'];
            fid = fopen(errorFile,'a+');
            fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
            % close file
            fclose(fid);
        end
end

