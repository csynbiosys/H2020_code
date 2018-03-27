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

%======================
% MDOEL RELATED DATA
%======================

venturelli_model_set1

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
	 inputs.exps.obs{iexp}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80'); 
	 inputs.exps.exp_y0{iexp}=[3735.42231633428 107.252083049288 43.9642884801915 0.0337165277415309];  % Initial conditions for each experiment  
end         
 
 inputs.exps.exp_y0{1}=[3735.42231633428 107.252083049288 43.9642884801915 0.0337165277415309]; %steady state after no galactose
inputs.exps.exp_y0{2}=[0.00224010507260388 6.19837186898240e-06 0.129868056417314 96.0145117189065]; %steady state after no galactose
%EXPERIMENTS TO BE OPTIMALLY DESIGNED

%EXPERIMENT 1: PULSE-UP 3 pulses and sampling times every 10 min

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


%EXPERIMENT 2: PULSE-DOWN 3 pulses and sampling times every 10 min
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
inputs.PEsol.id_global_theta=char('w','d','b',...
							'ag1','ag3','ag4','a0g80','ag80','kg1','kg3',...
							'kg80','yg1','yg3','yg4','yg80',...
							'e');
inputs.PEsol.global_theta_guess=[2.666659555501383e-04 0.398406374501988100 0.0160 15 0.9 0.2 0.6...
				  0.9 8 8 2 0.004 0.004 0.004 0.004...
				  0.1];
								
%==================================
% COST FUNCTION RELATED DATA
%==================================

inputs.PEsol.PEcost_type='lsq';					   % 'lsq' (weight least squares default)		   
inputs.PEsol.lsq_type='Q_expmax';
inputs.OEDsol.OEDcost_type='Eopt';

