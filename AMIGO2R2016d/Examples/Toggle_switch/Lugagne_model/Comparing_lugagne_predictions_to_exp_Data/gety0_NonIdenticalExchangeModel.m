function [y0_all] = gety0_NonIdenticalExchangeModel(EXP_data,iexp)
% This function calculates the steady state values for variables in
% Lugagne's toggle switch model.


% Calculate Initial values of the variables in the model
y0_init_ss = EXP_data{1,iexp}.init;


% Setting up input related parameters
exps.exp_type{1} = 'fixed';
exps.u_interp{1} = 'sustained';                               %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down'
exps.t_con{1}    = [0 80*60];                       % Input swithching times: Initial and final time
exps.t_f{1}      = 80*60;                           % This is the duration used by Lugagne et al in their simulations.
exps.exp_y0{1}   = y0_init_ss;                                       %initial values of all states in the model
exps.u{1}        = [EXP_data{1,iexp}.IPTGext; EXP_data{1,iexp}.aTcext];  % Values of the inputs taken from the original inputs used from the Lugagne calibration experiments. 
exps.n_exp       = 1;

%% Folder where results will be stored
ss.pathd.results_folder     = 'Initial_value_calculation';         % Folder to keep results (in Results) for a given problem
ss.pathd.short_name         = 'toggleSwitch_y0Calc_Data';                      % To identify figures and reports for a given problem
ss.pathd.runident           = strcat('y0_Data_stelling_',int2str(10));      % [] Identifier required in order not to overwrite previous results


% NUMERICAL METHODS RELATED DATA
ss.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|
ss.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)
ss.ivpsol.rtol=1.0e-7;                            % [] IVP solver integration tolerances
ss.ivpsol.atol=1.0e-7;


%% Observable details

% number of observables
exps.n_obs{1}=1;

% names of observables
exps.obs_names{1}=char('LacI');

% Observables definition
exps.obs{1}=char('LacI=dLacI');

% load model
model= lugagne_toggle_switch_model_NIEM(); 

%setup model for simulation
ss.model=model;
ss.exps=exps;

% prevent display of plots when running the script by using noplot
ss.plotd.plotlevel='medium';                % can also take values max,medium,min,noplot


%% Pre Process Inputs
AMIGO_Prep(ss)

%% Generate pseudo-experimental data with noise
Output=AMIGO_SModel(ss);

% Initial values of all variables in the system, derived from a simulation
% run for 24 hours

y0_all=Output.sim.states{1,1}(end,:);
end
