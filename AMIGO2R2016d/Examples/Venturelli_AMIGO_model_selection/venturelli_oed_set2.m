%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% venturelli_oed.m
%
% 					(AMIGO_OED)===>> exp_y0_type; tf_type; u_type; ts_type;
%									 u_interp; [n_steps]; [n_pulses];
%									 [exp_y0_min/max]; [tf_min/tf_max];
%									 [ts_min_dist]; [u_min/u_max];
%									 [exp_dataiexp]; [error_dataiexp];
%									 id_global_theta; [id_global_theta_y0];
%									 [global_theta_guess]; [global_theta_y0_guess];
%									 PEcost_type; [lsq_type]; [llk_type]; OEDcost_type;
%									 []: optional inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

venturelli_model_set2

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

inputs.exps.n_exp=2;								%Total number of experiments 
													% Total number of experiments (available + experiments to be designed)     
 inputs.exps.exp_type{1}='od';                     % or not be optimally designed : 'od' and 'fixed'
 inputs.exps.exp_type{2}='od';
 
%OBSERVABLES DEFINITION

for iexp=1:inputs.exps.n_exp
	 inputs.exps.n_obs{iexp}=4;                            % Number of observed quantities per experiment  
	 inputs.exps.obs_names{iexp}=char('Gal1p','Gal3p','Gal4p','Gal80p');      % Name of the observed quantities per experiment    
	 inputs.exps.obs{iexp}=char('Gal1p=G1_2','Gal3p=G3_2','Gal4p=G4_2','Gal80p=G80_2'); 
	 inputs.exps.exp_y0{iexp}=[2.87796558433283 0.0908609051975536 2.60787652042090 977.523604042372];  % Initial conditions for each experiment  
 end     

inputs.exps.exp_y0{1}=[2.87796558433283 0.0908609051975536 2.60787652042090 977.523604042372]; %steady state after no galactose
inputs.exps.exp_y0{2}=[0.00138113763960563 0.000696644542745701 2.20285327259989 1158.82050886456]; %steady state after no galactose

 
%EXPERIMENTS TO BE OPTIMALLY DESIGNED

%EXPERIMENT 1: PULSE-UP 2 pulses and sampling times every 10 min

inputs.exps.u_type{1}='od';                           % Type of stimulation: 'fixed' | 'od' (to be designed) 
inputs.exps.u_interp{1}='pulse-up';                   % Stimuli definition for experiment 1

inputs.exps.n_pulses{1}=3;
 inputs.exps.u_min{1}=0;
 inputs.exps.u_max{1}=1;                               % Minimum and maximum value for the input
 inputs.exps.tf_type{1}='fixed';                       % [] Type of experiment duration: 'fixed'(default) | 'od' (to be designed) 
 inputs.exps.t_f{1}=300;                               % Experiment duration
 inputs.exps.ts_type{1}='fixed';                       % [] Type of sampling times: 'fixed'(default) | 'od' (to be designed) 
 inputs.exps.n_s{1}=60;
  inputs.exps.std_dev{1}=0.1; 


%EXPERIMENT 2: PULSE-DOWN 2 pulses and sampling times every 10 min
inputs.exps.u_type{2}='od';                           % Type of stimulation: 'fixed' | 'od' (to be designed) 
inputs.exps.u_interp{2}='pulse-down';                   % Stimuli definition for experiment 1

inputs.exps.n_pulses{2}=3;
 inputs.exps.u_min{2}=0;
 inputs.exps.u_max{2}=1;                               % Minimum and maximum value for the input
 inputs.exps.tf_type{2}='fixed';                       % [] Type of experiment duration: 'fixed'(default) | 'od' (to be designed) 
 inputs.exps.t_f{2}=300;                               % Experiment duration
 inputs.exps.ts_type{2}='fixed';                       % [] Type of sampling times: 'fixed'(default) | 'od' (to be designed) 
 inputs.exps.n_s{2}=60;
  inputs.exps.std_dev{2}=0.1; 


%====================================
% PARAMETERS TO BE CONSIDERED FOR OED
%====================================
inputs.PEsol.id_global_theta=char('w_2','d_2','b_2',...
							'ag1_2','ag3_2','ag4_2','a0g80_2','ag80_2','kg1_2','kg3_2',...
							'kg80_2','yg1_2','yg3_2','yg4_2','yg80_2',...
							'e_2');
inputs.PEsol.global_theta_guess=[3.3600e-04 0.0114 0.0014 35 8 3.6 5.9 9 86.7 64.9...
								1.5 0.0263 0.004 0.0119 0.0073 1.02];
								
%==================================
% COST FUNCTION RELATED DATA
%==================================

inputs.PEsol.PEcost_type='lsq';					   % 'lsq' (weight least squares default)		   
inputs.PEsol.lsq_type='Q_expmax';
inputs.OEDsol.OEDcost_type='Eopt';

