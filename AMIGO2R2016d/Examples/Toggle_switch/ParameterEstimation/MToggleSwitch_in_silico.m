%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the MToggleSwitch model in response to a step in IPTG,
% aTc
% concentration specified in Run_MPLacr_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global epccOutputResultFileNameBase;
global IPTGe; 
global aTce; 
global ip; 

clear model;
clear exps;
clear sim;

results_folder = strcat('ToggleSwitch_rep',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = 'TogSwitch';

% Read the model into the model variable
ToggleSwitch_load_model;

% Load the calibration data
load('LugagneCalibrationData.mat');

% Compile the model
clear inputs;
inputs.model = model;
inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';

AMIGO_Prep(inputs);
      
% Fixed parts of the experiment
duration = 48*60;     % Duration of the experiment in min

clear newExps;
newExps.n_exp = 1;
newExps.n_obs{1}=2;                                  % Number of observables per experiment                         
newExps.obs_names{1} = char('RFP','GFP');
newExps.obs{1} = char('RFP = L_AU','GFP = T_AU');% Name of the observables 
newExps.exp_y0{1}=ToggleSwitch_Compute_SteadyState(model.par,Data.exp_data{1,ip}(:,1)',IPTGe,aTce);     
newExps.t_f{1}=duration;               % Experiment duration
    
newExps.u_interp{1}='sustained';
newExps.u{1}=[IPTGe;aTce];
newExps.t_con{1}=[0,duration];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mock an experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%clear inputs;
inputs.exps = newExps;
inputs.plotd.plotlevel='noplot';
    
inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = strcat('sim-',int2str(ip));

% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1.0D-7;
inputs.ivpsol.atol=1.0D-7;
    
sim = AMIGO_SModel(inputs);

save('simulations.mat','sim')

