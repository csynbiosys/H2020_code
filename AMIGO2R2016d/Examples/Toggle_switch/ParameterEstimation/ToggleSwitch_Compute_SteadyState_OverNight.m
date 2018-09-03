function [InitialConditions]= ToggleSwitch_Compute_SteadyState_OverNight(model,params,InitialExpData,IPTGe,aTce)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the initial state of the MToggleSwitch model after the
% ON inclubation, where cells are exposed to . We assume that the system is at steady state
% concentration specified in Run_MPLacr_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

results_folder = strcat('ToggleSwitch_repON',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = 'TogSwitchON';

% % Compile the model
clear inputs;
inputs.model = model;
inputs.model.par = params; 
inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';

AMIGO_Prep(inputs);
      
% Fixed parts of the experiment
duration = 24*60;     % Duration of the experiment in min

clear newExps;
newExps.n_exp = 1;
newExps.n_obs{1}=2;                                  % Number of observables per experiment                         
newExps.obs_names{1} = char('RFP','GFP');
newExps.obs{1} = char('RFP = L_AU','GFP = T_AU');% Name of the observables 
newExps.exp_y0{1}=ToggleSwitch_Compute_SteadyState(model,params,InitialExpData,IPTGe,aTce);     
newExps.t_f{1}=duration;               % Experiment duration
    
newExps.u_interp{1}='sustained';
newExps.u{1}=[IPTGe;aTce];
newExps.t_con{1}=[0,duration];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mock an experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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

InitialConditions = sim.sim.states(end,:);

end