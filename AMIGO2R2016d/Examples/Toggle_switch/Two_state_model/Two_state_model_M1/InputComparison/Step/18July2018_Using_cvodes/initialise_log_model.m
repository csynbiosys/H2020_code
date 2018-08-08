function [y0_all] = initialise_log_model(global_theta_guess,inputs,epcc_exps)
% This function calculates the steady state values for variables in the
% toggle switch model and requires model parameters and Input values. 

% Setting up input related parameters
exps.exp_type{1} = 'fixed';
exps.u_interp{1} = 'sustained';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
exps.t_con{1}    = [0 24*60];                       % Input swithching times: Initial and final time
exps.t_f{1}      = 24*60;
exps.exp_y0{1}   = log([1e-5,1e-5,450.362572537976,855.546160287592]); %log([1e-4,1e-4,10,10]); %log([1e-5,1e-5,450.362572537976,855.546160287592]); %[1,0, 2764, 158]; % [0.1,100,2764,158];                                       %initial values of all states in the model
exps.u{1}        = inputs;                                                % Values of the inputs
exps.n_exp       = 1;

%% Folder where results will be stored
ss.pathd.results_folder     = strcat('IVP',num2str(epcc_exps*rand(1,1)));         % Folder to keep results (in Results) for a given problem          
ss.pathd.short_name         = 'TSM_cvodes';                      % To identify figures and reports for a given problem   
ss.pathd.runident           = strcat('y0',int2str(11));      % [] Identifier required in order not to overwrite previous results

% NUMERICAL METHODS RELATED DATA
ss.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|
ss.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)
ss.ivpsol.rtol=1.0e-11;                            % [] IVP solver integration tolerances
ss.ivpsol.atol=1.0e-14; 


%% Observable details

% number of observables
exps.n_obs{1}=2;                             

% names of observables
exps.obs_names{1}=char('LacI_star','TetR_star');

% Observables definition
exps.obs{1}=char('LacI=LacI_star','TetR=TetR_star');

% load model
model_init= two_state_model_log_transform();
model_init.par= global_theta_guess;

%setup model for simulation
ss.model=model_init;
ss.exps=exps;

% prevent display of plots when running the script. 
%figure(2)
ss.plotd.plotlevel='noplot';                % can also take values max,medium,min,noplot


%% Pre Process Inputs
AMIGO_Prep(ss)    

%% Generate pseudo-experimental data with noise
Output=AMIGO_SModel(ss);
   
% Initial values of all variables in the system, derived from a simulation
% run for 48 hours
y0_all=Output.sim.states{1,1}(end,:);

end

