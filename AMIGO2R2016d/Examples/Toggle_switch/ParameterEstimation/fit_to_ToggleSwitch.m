function [out] = fit_to_ToggleSwitch(epccOutputResultFileNameBase,epcc_exps,global_theta_guess)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit_to_ToggleSwitch - runs PE of the model structure we propose for the Toggle Switch to the calibration data published in Lugagne et al., 2017.
% PE is run, starting from 100 initial guesses for the parameters, on the whole dataset.
% An analytical solution for the steady state is used to define the initial
% conditions in a simulation of the system response to sustained inputs (48hrs)
% equal to the ON conditions. 
% Each vector of estimates is used to compute the SSE over the whole set. 
% Hence the estimate yielding the minimum SSE is selected. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    resultFileName = [strcat(epccOutputResultFileNameBase),'.dat'];
    rng shuffle;
    rngToGetSeed = rng;
    % Write the header information of the .dat file in which the results of
    % PE (estimates and the time required for computation) will be stored. 
    fid = fopen(resultFileName,'w');
    fprintf(fid,'HEADER DATE %s\n',datestr(datetime()));
    fprintf(fid,'HEADER RANDSEED %d\n',rngToGetSeed.Seed);
    fclose(fid);
    
    startTime = datenum(now);
    
    clear model;
    clear exps;
    clear best_global_theta;
    clear pe_results;
    clear pe_inputs;
    
    
    % Specify folder name and short_name
    results_folder = strcat('ToggleSwitchFit',datestr(now,'yyyy-mm-dd-HHMMSS'));
    short_name     = strcat('TSF');
 
    % Load experimental data. This data are derived, using the script
    % ExtractionAllExperimentalData/ExtractionCalibrationData.m, starting from data used in the paper
    % Lugagne et al. Please note that as of yet, there are doubts about the
    % data (We are waiting for clarifications on them from the authors, 
    % but a report justifying the current choices is available (Report2Sept2018.docx))
    load('LugagneCalibrationData.mat');
 
    % Read the model into the model variable
    ToggleSwitch_load_model; 

    % Initial guesses for theta
    global_theta_min = [0.01,0.1386,0.0005,0.1,1,1,2,2,0.0165,0.01,0.001,0.1,0.001,60,2,2,10,10,0.001,0.001];
    global_theta_max = [10,0.1386,1,100,100,1000,4,4,0.0165,10,3,100,1,6000,4,4,1000,1000,0.1,0.1];

    global_theta_guess = global_theta_guess';
    
    % Randomized vector of experiments
    exps_indexall = 1:1:6;
    % Definition of the Training set 
    exps_indexTraining = exps_indexall;
    % Definition of test set 
    exps_indexTest =  exps_indexall;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run  PE on the training set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inputs.model = model;
    inputs.model.par = global_theta_guess;
    
    % Define the exps structure, containing the experimental data to fit
    exps.n_exp = length(exps_indexTraining);
    
    for iexp=1:length(exps_indexTraining)
        exp_indexData = exps_indexTraining(iexp);
        exps.exp_type{iexp} = 'fixed'; 
        exps.n_obs{iexp} = 2; 
        exps.obs_names{iexp} = char('RFP','GFP');
        exps.obs{iexp} = char('RFP = L_AU','GFP = T_AU');
        exps.t_f{iexp} = Data.t_con{1,exp_indexData}(1,end); 
        exps.n_s{iexp} = Data.n_samples{1,exp_indexData};
        exps.t_s{iexp} = Data.t_samples{1,exp_indexData}; 
        exps.u_interp{iexp} = 'step';
        exps.t_con{iexp} = Data.t_con{1,exp_indexData}(1,:);
        exps.n_steps{iexp} = length(exps.t_con{iexp})-1;
        exps.u{iexp} = Data.input{1,iexp};
        exps.data_type = 'real';
        exps.noise_type = 'homo';
        
        exps.exp_data{iexp} = Data.exp_data{1,exp_indexData};
        exps.error_data{iexp} = Data.standard_dev{1,exp_indexData};
        
        % Compute the steady state considering the initial theta guess, u_IPTG and
        % u_aTc
        y0 = ToggleSwitch_Compute_SteadyState_OverNight(model,global_theta_guess,Data.exp_data{1,exp_indexData}(:,1)',Data.Initial_IPTG{1,exp_indexData},Data.Initial_aTc{1,exp_indexData});
        exps.exp_y0{iexp} = y0;
    end

    best_global_theta = global_theta_guess; 
    % g_m and g_p excluded from identification
    param_including_vector = [true,false,true,true,true,true,true,true,false,true,true,true,true,true,true,true,true,true,true,true];

    % Compile the model
    clear inputs;
    inputs.model = model;
    inputs.model.par = best_global_theta;
    inputs.exps  = exps;

    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_setup';
    
    AMIGO_Prep(inputs);

    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = strcat('pe-',int2str(epcc_exps));
    
 
    % GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERMENTS)
    inputs.PEsol.id_global_theta=model.par_names(param_including_vector,:);
    inputs.PEsol.global_theta_guess=transpose(best_global_theta(param_including_vector));
    inputs.PEsol.global_theta_max=global_theta_max(param_including_vector);  % Maximum allowed values for the paramters
    inputs.PEsol.global_theta_min=global_theta_min(param_including_vector);  % Minimum allowed values for the parameters
 
    % COST FUNCTION RELATED DATA
    inputs.PEsol.PEcost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
    inputs.PEsol.lsq_type='Q_expmax';
    inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero'
 
    % SIMULATION
    inputs.ivpsol.ivpsolver='cvodes';
    inputs.ivpsol.senssolver='cvodes';
    inputs.ivpsol.rtol=1.0D-8;
    inputs.ivpsol.atol=1.0D-8;

    % OPTIMIZATION
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS.maxeval = 200000;
    inputs.nlpsol.eSS.maxtime = 5000;
    param_including_vector = [true,false,true,true,true,true,true,true,false,true,true,true,true,true,true,true,true,true,true,true];

    inputs.nlpsol.eSS.log_var = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
    inputs.nlpsol.eSS.local.solver = 'lsqnonlin'; 
    inputs.nlpsol.eSS.local.finish = 'lsqnonlin'; 
    %inputs.rid.conf_ntrials=500;

    pe_start = now;
    pe_inputs = inputs;
    results = AMIGO_PE(inputs);
    pe_results = results;
    pe_end = now;
    
    % Save the best theta
    best_global_theta(param_including_vector) = results.fit.thetabest;
    
    % Write results to the output file
    fid = fopen(resultFileName,'a');
    used_par_names = model.par_names(param_including_vector,:);
    
    for j=1:size(used_par_names,1)
        fprintf(fid,'PARAM_FIT %s %f\n', used_par_names(j,:), results.fit.thetabest(j));
    end
 
    % Time in seconds
    fprintf(fid,'PE_TIME %.1f\n', (pe_end-pe_start)*24*60*60);
    fclose(fid);
    
    save([strcat(epccOutputResultFileNameBase,'.mat')],'pe_results','exps','pe_inputs','best_global_theta');
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run simulation on the test set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear inputs;
    clear exps;
    
    exps.n_exp = length(exps_indexTest);
    
    for iexp=1:length(exps_indexTest)
        
        exp_indexData = exps_indexTest(iexp);
        exps.exp_type{iexp} = 'fixed'; 
        exps.n_obs{iexp} = 2; 
        exps.obs_names{iexp} = char('RFP','GFP');
        exps.obs{iexp} = char('RFP = L_AU','GFP = T_AU');
        exps.t_f{iexp} = Data.t_con{1,exp_indexData}(1,end); 
        exps.n_s{iexp} = Data.n_samples{1,exp_indexData};
        exps.t_s{iexp} = Data.t_samples{1,exp_indexData}; 
        exps.u_interp{iexp} = 'step';
        exps.t_con{iexp} = Data.t_con{1,exp_indexData}(1,:);
        exps.n_steps{iexp} = length(exps.t_con{iexp})-1;
        exps.u{iexp} = Data.input{1,iexp};
        exps.data_type = 'real';
        exps.noise_type = 'homo';
        
        exps.exp_data{iexp} = Data.exp_data{1,exp_indexData};
        exps.error_data{iexp} = Data.standard_dev{1,exp_indexData};
        
        % Compute the steady state considering the initial theta guess, u_IPTG and
        % u_aTc
        y0 = ToggleSwitch_Compute_SteadyState_OverNight(model,best_global_theta,Data.exp_data{1,exp_indexData}(:,1)',Data.Initial_IPTG{1,exp_indexData},Data.Initial_aTc{1,exp_indexData});
        exps.exp_y0{iexp} = y0;

    end
   
    inputs.model = model;
    inputs.model.par = best_global_theta;
    inputs.exps  = exps;

    inputs.pathd.results_folder = results_folder;
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       ='-sim';
    inputs.plotd.plotlevel='noplot';
    
    AMIGO_Prep(inputs);

    % SIMULATION
    inputs.ivpsol.ivpsolver='cvodes';
    inputs.ivpsol.senssolver='cvodes';
    inputs.ivpsol.rtol=1.0D-8;
    inputs.ivpsol.atol=1.0D-8;

    %inputs.plotd.plotlevel='full';
    sim_results = AMIGO_SObs(inputs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute SSE on the test set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SSE = zeros(size(exps_indexTest));
    for iexp=1:length(exps_indexTest)
        exp_indexData = exps_indexTest(iexp);
        SSE(iexp) = sum((Data.exp_data{1,exp_indexData}-sim_results.sim.sim_data{1,iexp}).^2);
    end
    

    sim_inputs = inputs;
    sim_exps = exps;
    save([strcat(epccOutputResultFileNameBase,'-sim','.mat')],'sim_results','sim_inputs','sim_exps','best_global_theta','SSE');
    

    out = 1;
end
