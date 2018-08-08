%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: Toggle Switch model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================
% RESULTS PATHS RELATED DATA
%============================
inputs.pathd.results_folder='two_state_model_M1'; % Folder to keep results (in Results) for a given problem                       
inputs.pathd.short_name='TSM_M1_RIdent';                       % To identify figures and reports for a given problem 
inputs.pathd.runident='run1';                         % [] Identifier required in order not to overwrite previous results
                                                     
%============================
% MODEL RELATED DATA
%============================
model=two_state_model_M1();

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=6;                                 % Number of experiments   
 
 % Store model details 
 inputs.model=model;
 inputs.model.exe_type='standard';

  for iexp= 1:inputs.exps.n_exp
     inputs.exps.n_obs{iexp}=2;                             % number of observables
     inputs.exps.obs_names{iexp}=char('LacI_star','TetR_star');       % name of observables
     inputs.exps.obs{iexp}=char('LacI_star=LacI_star','TetR_star=TetR_star'); 
     
     % Noise in the data 
     inputs.exps.data_type='pseudo';
     inputs.exps.noise_type='hetero_proportional_log_scale';
     inputs.exps.std_dev{iexp}=[0.05 0.05];
  end
 
    
 for i3=1:3
    inputs.exps.u_interp{i3}='pulse-up';                                % [] Stimuli definition: u_interp: 'sustained' |'step'|'linear'(default)|
    inputs.exps.n_pulses{i3}=7;
    inputs.exps.t_f{i3} = 20*60;
    inputs.exps.t_con{i3}= 60.*[0 1.5 2 3.5 4 5.5 6 7.5 8 9.5 10 11.5 12 13.5 14 20];    % stimulus swithching times, experiment 1  
    inputs.exps.t_s{i3}   = (0:5:20*60);                         % sampling time is 5 minutes (5X60=300 seconds)
    inputs.exps.n_s{i3}   = length((0:5:20*60));                                % Number of sampling times

 end
    inputs.exps.u_min{1}=log([0.01; 0.001]); inputs.exps.u_max{1}=log([0.01; 100]);     inputs.exps.exp_y0{1}=log([1 10 400 400]);
    inputs.exps.u_min{2}=log([0.01; 10]);  inputs.exps.u_max{2}=log([0.01; 80]);     inputs.exps.exp_y0{2}=log([1 50 500 100]);
    inputs.exps.u_min{3}=log([0.6; 0.01]);  inputs.exps.u_max{3}=log([0.6; 50]);     inputs.exps.exp_y0{3}=log([1 0.0000001 400 200]);

    
for i2=4:6
    inputs.exps.u_interp{i2}='pulse-up';                                % [] Stimuli definition: u_interp: 'sustained' |'step'|'linear'(default)|
    inputs.exps.n_pulses{i2}=7;
    inputs.exps.t_f{i2} = 20*60;
    inputs.exps.t_con{i2}= 60.*[0 1.5 2 3.5 4 5.5 6 7.5 8 9.5 10 11.5 12 13.5 14 20];    % stimulus swithching times, experiment 1  
    inputs.exps.t_s{i2}   = (0:5:20*60);                         % sampling time is 5 minutes (5X60=300 seconds)
    inputs.exps.n_s{i2}   = length((0:5:20*60));                                % Number of sampling times
end
 
    inputs.exps.u_min{4}=log([0.01; 90]); inputs.exps.u_max{4}=log([1; 90]);     inputs.exps.exp_y0{4}=log([0.2 0.0000001 5 0.000000001]);
    inputs.exps.u_min{5}=log([0.001; 70]);  inputs.exps.u_max{5}=log([0.8; 70]);     inputs.exps.exp_y0{5}=log([0.1 0.0000001 8 0.0000001]);
    inputs.exps.u_min{6}=log([0.001; 100]);  inputs.exps.u_max{6}=log([0.6; 100]);     inputs.exps.exp_y0{6}=log([0.3 0.0000001 4 1]);

 
%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.PEsol.id_global_theta='all'; %|User selected 
inputs.PEsol.global_theta_min=[1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3];  % Minimum allowed values for the paramters
inputs.PEsol.global_theta_max=[1e+4 1e+3 1e+3 4 4 1e+2  1e+4 1e+3 1e+3 4 4 1e+2 1e+2 1e+2]; % Maximum allowed values for the parameters
inputs.PEsol.global_theta_guess=inputs.model.par;


%==================================
% NUMERICAL METHODS RELATED DATA
%==================================

% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: C:'cvodes'; MATLAB:'ode15s'(default)|'ode45'|'ode113'            
inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)                                                      
inputs.ivpsol.rtol=1.0D-7;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0D-7; 


%==================================
% COST FUNCTION RELATED DATA
%==================================       
inputs.PEsol.PEcost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.PEsol.lsq_type='Q_expmax';
inputs.nlpsol.eSS.log_var = (1:14); 

% OPTIMIZATION
inputs.nlpsol.nlpsolver='eSS';                        % [] NLP solver: 
 
%==================================
% RIdent or GRank DATA
%==================================
inputs.rid.conf_ntrials=500;                          % [] Number of tria§ls for the robust confidence computation (default: 500)

inputs.nlpsol.eSS.local.solver = 'nl2sol';
inputs.nlpsol.eSS.local.finish = 'nl2sol';
inputs.nlpsol.eSS.local.nl2sol.maxfeval = 500;
inputs.nlpsol.eSS.maxeval = 5000;
inputs.nlpsol.eSS.maxtime = 500;
inputs.nlpsol.eSS.local.nl2sol.objrtol =  inputs.ivpsol.rtol;
inputs.nlpsol.eSS.local.nl2sol.tolrfun = 1e-7;


%==================================
% DISPLAY OF RESULTS
%==================================

inputs.plotd.plotlevel='full';                       % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
% inputs.plotd.nx_contour=100;                          % [] Number of points for plotting the contours x and y direction
% inputs.plotd.ny_contour=100;                          %    ADVISE: >=50
% inputs.plotd.number_max_hist=6;                      % [] Maximum number of unknowns histograms per figure (multistart)                                                    

% Preprocess script
AMIGO_Prep(inputs)

% generate pseudo data
results=AMIGO_SData(inputs);

for iexp=1:inputs.exps.n_exp
    inputs.exps.exp_data{1,iexp}=results.sim.exp_data{1,iexp};
    inputs.exps.error_data{1,iexp}=results.sim.error_data{1,iexp};  
end

AMIGO_RIdent(inputs)