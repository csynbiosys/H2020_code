%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the MToggleSwitch model in response to a step in IPTG,
% aTc
% concentration specified in Run_MPLacr_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global epccOutputResultFileNameBase;
global IPTGe; 
global aTce; 

% resultFileName = [epccOutputResultFileNameBase,'.dat']
clear model;
clear exps;
clear sim;

results_folder = strcat('ToggleSwitch_rep',datestr(now,'yyyy-mm-dd-HHMMSS'));
short_name     = 'TogSwitch';

% Read the model into the model variable
ToggleSwitch_load_model;

% Compile the model
clear inputs;
inputs.model = model;
inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'initial_setup';

AMIGO_Prep(inputs);
      
% Fixed parts of the experiment
duration = 24*60;     % Duration of the experiment in min

clear newExps;
newExps.n_exp = 1;
newExps.n_obs{1}=2;                                  % Number of observables per experiment                         
newExps.obs_names{iexp} = char('RFP','GFP');
newExps.obs{iexp} = char('RFP = L_AU','GFP = T_AU');% Name of the observables 
newExps.exp_y0{1}=ToggleSwitch_Compute_SteadyState(model.par,[42.5654936001928,1521.33340938933],0,0);    
    
newExps.t_f{1}=[duration;duration];                % Experiment duration
    
newExps.u_interp{1}={'sustained'; 'sustained'};
newExps.u{1}=[IPTGe; aTce];
newExps.t_con{1}=[0,duration;0, duration]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mock an experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
clear inputs;
inputs.exps = newExps;
inputs.plotd.plotlevel='noplot';
    
inputs.pathd.results_folder = results_folder;                        
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = strcat('sim-',int2str(i));

% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1.0D-7;
inputs.ivpsol.atol=1.0D-7;
    
sim = AMIGO_SModel(inputs);

save('simulations.mat','sim')

% fid = fopen(resultFileName,'a');
% fprintf(fid, '%f %f %f\n',IPTGe,sim.sim.states{1,1}(end,10),sim.sim.states{1,1}(end,10)/492); % IPTG and Citrine (AU)
% fclose(fid); 
