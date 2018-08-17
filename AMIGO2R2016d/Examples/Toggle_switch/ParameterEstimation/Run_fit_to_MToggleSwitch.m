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

cd ('Examples/Toggle_switch/ParameterEstimation');

% Specify the allowed boundaries for the parameters
theta_min = [];
theta_max = [];

% Create a matrix of initial guesses for the parameters, having as many
% rows as the number of PE iterations (numExperiments)
% Each vector is passed as input to the computing function
M_norm = lhsdesign(numExperiments,length(theta_min));
M = zeros(size(M_norm));
for c=1:size(M_norm,2)
    for r=1:size(M_norm,1)
        M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
    end
end 

ParFull = M;
save('MatrixParameters.mat','ParFull');

load('MatrixParameters.mat');

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

