function [] = run_in_silico_experiment_parfor(resultBase, numExperiments )

% cd ('../../');
% AMIGO_Startup();
% 
% cd ('C:\Users\vkothama\GoogleDrive\PostDoc\Edinburgh\Projects\H2020\ToggleSwitch\Tools\AMIGO2R2016d\Examples\Toggle_switch\two_state_model\InputComparison');

% Upper and lower boundaries selected for the parameters (theta refers to the parameter vector)
theta_min = [1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3];
theta_max = [1e+4 1e+3 1e+3 4 4 1e+2  1e+4 1e+3 1e+3 4 4 1e+2 1e+2 1e+2];

% Create a matrix of initial guesses for the vector of parameter estimates.
% The matrix has as many rows as the number of PE iterations
% (numExperiments).

% The vectors are obtained as latin hypercube samples within the boundaries selected above.
% Each vector is passed as input to the computing function
% 
% M_norm = lhsdesign(numExperiments,length(theta_min));
%     M = zeros(size(M_norm));
%     for c=1:size(M_norm,2)
%         for r=1:size(M_norm,1)
%             M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
%         end
%     end 
%     
%     ParFull = M; % in this case I am fitting all the values
% save('MatrixParameters_InputComparison.mat','ParFull');
    
% For the sake of a fair comparison among input classes, all simulations
% used the same matrix of initial theta guesses
load('par_set1.mat');       
%load('truePars.mat')

parfor epcc_exps=1:numExperiments
        try
            global_theta_guess = ParFull(epcc_exps,:);
            epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];
           
            % Uncomment the desired function for parameter estimation
            [out] = TSM_fit_to_step_input(epccOutputResultFileNameBase,epcc_exps,global_theta_guess); % Uses hetero_proportional data (5%)
   
        catch err
            %open file
            errorFile = [resultBase,'-',num2str(epcc_exps),'.errorLog'];
            fid = fopen(errorFile,'a+');
            fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
            
            % close file
            fclose(fid);
        end
end
