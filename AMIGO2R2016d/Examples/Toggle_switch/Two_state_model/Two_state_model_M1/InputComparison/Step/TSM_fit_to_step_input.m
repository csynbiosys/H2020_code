function [out] = TSM_fit_to_step_input(epccOutputResultFileNameBase,epcc_exps,global_theta_guess)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fit_to_InduciblePromoter_Step script - runs PE on the step class of inputs 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    resultFileName = [strcat(epccOutputResultFileNameBase),'.dat'];
    rng shuffle;
    rngToGetSeed = rng;
    
    % Write the header information of the .dat file in which the results of
    % PE (estimates, relative confidence intervals, residuals, relative
    % residuals and the time required for computation) will be stored. 
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
    results_folder = strcat('Toggle_switch',datestr(now,'yyyy-mm-dd-HHMMSS'));
    short_name     = strcat('TSM',int2str(epcc_exps));

    % Read the model into the model variable
    model=two_state_model_M1;

    % Start with no experiments
    exps.n_exp=0;

    % Compute the steady state considering the initial theta guess, 1 mM
    % IPTG and 0 ng(mL)^-1 of aTc
    y0 = initialise_M1_Lugagne_experiments(global_theta_guess,[1;1e-5],epcc_exps); % ensure that the inputs are non-zero

    % Define boundaries for the parameters (taken from scientific literature)
    global_theta_min = [1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3];       % Maximum allowed values for the parameters
    global_theta_max = [1e+4 1e+3 1e+3 4 4 1e+2 1e+4 1e+3 1e+3 4 4 1e+2 1e+2 1e+2];    % Minimum allowed values for the parameters

    global_theta_guess = global_theta_guess';

    % Specify the parameters to be calibrated. 
    % The selection depends on the identifiability analysis preceding the 
    % comparison: parameters that are not identifiable will fixed to the best
    % estimate available for them.
    % In our case, all parameters are identifiable. 
    param_including_vector = [true,true,true,true,true,true,true,true,true,true,true,true,true,true];

    % Compile the model
    clear inputs;
    inputs.model = model;
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_setup';
    AMIGO_Prep(inputs);


       
    % Fixed parts of the experiment
    duration = 50*60;               % Duration in of the experiment (minutes)
    dur = 100;                      % Duration of each step (minutes). 
    numCycles = duration/dur/2;     % Number of low-high cycles, corresponds to half of the number of steps
    inducer = log([(1e-5+(1-(1e-5))).*rand(1,2); (1e-5+(100-(1e-5))).*rand(1,2)]) ;  % Extract 2 random input values from the Uniform distribution in (0,1)mM for IPTG and (0,100) ng/mL for aTc, to be used as low and high values in each cycle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a new experiment to simulate with the step input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    clear newExps;
    newExps.n_exp = 1;                                         % Number of experiments 
    newExps.n_obs{1}=2;                                        % Number of observables per experiment                         
    newExps.obs_names{1}=char('LacI_star','TetR_star');                 % Name of the observables per experiment    
    newExps.obs{1}= char('LacI=LacI_star','TetR=TetR_star');           % Observation function
    newExps.exp_y0{1}=y0;                                      % Initial condition for the experiment    
    
    newExps.t_f{1}=duration;                                   % Experiment duration
    newExps.n_s{1}=duration/5 + 1;                             % Number of sampling times
    newExps.t_s{1}=0:5:duration ;                              % Times of samples

    newExps.u_interp{1}='step';                                % Interpolating function for the input
    newExps.n_steps{1}=numCycles*2;                            % Number of steps in the input
    newExps.u{1}=repmat(inducer,1,numCycles);                  % IPTG values for the input
    newExps.t_con{1}=0:duration/(2*numCycles):duration;        % Switching times

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Mock the experiment
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    clear inputs;
    inputs.model = model;
    inputs.exps = newExps;

    inputs.exps.data_type='pseudo';
    inputs.exps.noise_type='hetero_proportional_log_scale';
    inputs.exps.std_dev{1}=[0.05 0.05];
    

    inputs.plotd.plotlevel='full';

    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = strcat('sim-',int2str(epcc_exps));

    sim = AMIGO_SData(inputs);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now we need to add this experiment output to newExps and copy
    % to exps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    newExps.exp_type{1}='fixed';
    newExps.exp_data{1}   = sim.sim.exp_data{1};
    newExps.error_data{1} = sim.sim.error_data{1};

    newExps.data_type='real';                                     % Type of data: 'pseudo'|'pseudo_pos'|'real'             
    newExps.noise_type='hetero_proportional_log_scale';                                % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default) 

    exps = newExps;

    for i=1:10
        
        duration = i*5*60;                                        % Duration in minutes

        clear inputs;
        inputs.model = model;
        inputs.exps  = exps;

        % Reduce the input to a smaller set of values
        inputs.exps.t_f{1}          = duration;                   % Experiment duration
        inputs.exps.n_s{1}          = duration/5 + 1;             % Number of sampling times
        inputs.exps.t_s{1}          = 0:5:duration;               % Times of samples

        inputs.exps.n_steps{1}      = sum(exps.t_con{1} < duration);
        inputs.exps.t_con{1}        = exps.t_con{1}(1:inputs.exps.n_steps{1}+1);
        inputs.exps.u{1}            = exps.u{1}(:,1:inputs.exps.n_steps{1});

        inputs.exps.exp_data{1}     = exps.exp_data{1}(1:inputs.exps.n_s{1},:);
        inputs.exps.error_data{1}   = exps.error_data{1}(1:inputs.exps.n_s{1},:);

        inputs.pathd.results_folder = results_folder;                        
        inputs.pathd.short_name     = short_name;
        inputs.pathd.runident       = strcat('pe-',int2str(epcc_exps),'-',int2str(i));

        % GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)
        
        inputs.PEsol.id_global_theta=model.par_names(param_including_vector,:);
        inputs.PEsol.global_theta_guess=transpose(global_theta_guess(param_including_vector)); 
        inputs.PEsol.global_theta_max=global_theta_max(param_including_vector);  % Maximum allowed values for the parameters
        inputs.PEsol.global_theta_min=global_theta_min(param_including_vector);  % Minimum allowed values for the parameters

        % COST FUNCTION RELATED DATA
        inputs.PEsol.PEcost_type='lsq';        % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
        inputs.PEsol.lsq_type='Q_expmax';

        % SIMULATION
        inputs.ivpsol.ivpsolver='ode15s';
        inputs.ivpsol.senssolver='sensmat';
        inputs.ivpsol.rtol=1.0e-11;
        inputs.ivpsol.atol=1.0e-14;


        % OPTIMIZATION
        inputs.nlpsol.nlpsolver='eSS';
        inputs.nlpsol.eSS.maxeval = 200000;
        inputs.nlpsol.eSS.maxtime = 5000;
        inputs.nlpsol.eSS.log_var = [1 2 3 4 5 6 7 8 9 10 11 12 13 14];
        inputs.nlpsol.eSS.local.solver = 'fminsearch'; 
        inputs.nlpsol.eSS.local.finish = 'fminsearch';  
        inputs.rid.conf_ntrials=500;

        inputs.plotd.plotlevel='noplot';

        pe_start = now;
        results = AMIGO_PE(inputs);
        pe_inputs{i} = inputs;
        pe_results{i} = results;
        pe_end= now;

        % Write some results to the output file
        fid = fopen(resultFileName,'a');
        used_par_names = model.par_names(param_including_vector,:);


        for j=1:size(used_par_names,1)
            fprintf(fid,'HOUR %d PARAM_FIT %s %f\n', i*5, used_par_names(j,:), results.fit.thetabest(j));
            if isfield(results.fit,'rel_conf_interval')
                fprintf(fid,'HOUR %d REL_CONF %s %f\n',  i*5, used_par_names(j,:), results.fit.rel_conf_interval(j));
            end
            if isfield(results.fit,'residuals')
                fprintf(fid,'HOUR %d RESIDUAL %s %f\n', i*5, used_par_names(j,:), results.fit.residuals{1}(j));
            end
            if isfield(results.fit,'rel_residuals')
                fprintf(fid,'HOUR %d REL_RESIDUAL %s %f\n', i*5, used_par_names(j,:), results.fit.rel_residuals{1}(j));
            end
        end
        % Time in seconds
        fprintf(fid,'HOUR %d PE_TIME %.1f\n',  i*5, (pe_end-pe_start)*24*60*60);
        fclose(fid);
        
        best_global_theta_log{i}=results.fit.thetabest;


    end
    

    true_param_values = model.par(param_including_vector);
    save([epccOutputResultFileNameBase,'.mat'], 'pe_inputs','pe_results','exps','inputs','true_param_values','best_global_theta_log');
    out = 1;
end
