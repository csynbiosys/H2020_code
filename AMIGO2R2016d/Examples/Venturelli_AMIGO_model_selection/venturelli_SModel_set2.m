%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% venturelli_SModel.m file
%
% TITLE: GAL Network model
%
% References: Venturelli, Ophelia S., Hana El-Samad, and Richard M. Murray. 
%			  "Synergistic dual positive feedback loops established by molecular 
%			   sequestration generate robust bimodal response." Proceedings of 
%			   the National Academy of Sciences 109.48 (2012): E3324-E3333.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        INPUT FILE TO GENERATE FOR ITS USE IN AMIGO
%		
%		 Minimum required inputs:
%           > Paths related data
%           > Model:               model_type; n_st; n_par; n_stimulus; 
%                                  st_names; par_names; stimulus_names;  
%                                  eqns; par

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='venturelli_set2';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='venturelli';             % To identify figures and reports for a given problem   
%inputs.pathd.runident='20step';             % To identify this specific run

%======================
% MDOEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';                % Model introduction: 'charmodel'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=4;                                       % Number of states      
inputs.model.n_par=19;                                     % Number of model parameters 
inputs.model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('G1_2','G3_2','G4_2','G80_2');     								  % Names of the states                                              
inputs.model.par_names=char('w_2','d_2','b_2',...
							'ag1_2','ag3_2','ag4_2','a0g80_2','ag80_2','kg1_2','kg3_2',...
							'kg80_2','n1_2','n3_2','n80_2','yg1_2','yg3_2','yg4_2','yg80_2',...
							'e_2');   % Names of the parameters                     
inputs.model.stimulus_names=char('agal_2');                                        % Names of the stimuli, inputs or controls                      
inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dG1_2=agal_2*e_2+((ag1_2*(G4_2)^n1_2)/(((G4_2)^n1_2)+kg1_2^n1_2))+(-w_2)*G1_2*G80_2-yg1_2*G1_2',...
					'dG3_2=agal_2+(ag3_2*(G4_2^n3_2)/(G4_2^n3_2+kg3_2^n3_2))+(-d_2)*G3_2*G80_2-yg3_2*G3_2',...
					'dG4_2=ag4_2+(-b_2)*G80_2*G4_2-yg4_2*G4_2',...
					'dG80_2=a0g80_2+(ag80_2*(G4_2^n80_2)/((G4_2^n80_2)+kg80_2^n80_2))+(-w_2)*G1_2*G80_2+(-d_2)*G3_2*G80_2+(-b_2)*G80_2*G4_2-yg80_2*G80_2');
					
inputs.model.par=[3.3600e-04 0.0114 0.0014 35 8 3.6 5.9 9 86.7 64.9...
				  1.5 3 2 2 0.0263 0.004 0.0119 0.0073 1.02];   	
				  
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

inputs.exps.n_exp=4;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
	inputs.exps.exp_y0{iexp}=[0.00138113763960563 0.000696644542745701 2.20285327259989 1158.82050886456];  %Initial conditions for each experiment          
	inputs.exps.t_f{iexp}=720;                            %Experiments duration
 end           
 
 %EXPERIMENT 1
 inputs.exps.n_obs{1}=4;								%Number of observed quantities
 inputs.exps.obs_names{1}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{1}=char('Gal1p=G1_2','Gal3p=G3_2','Gal4p=G4_2','Gal80p=G80_2')	%Observation function
 
 inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1
 inputs.exps.t_con{1}=[0 720];                        % Input switching times: Initial and final time    
 inputs.exps.u{1}=[1];                                 % Values of the inputs 
 
 %EXPERIMENT 2
 inputs.exps.n_obs{2}=4;								%Number of observed quantities
 inputs.exps.obs_names{2}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{2}=char('Gal1p=G1_2','Gal3p=G3_2','Gal4p=G4_2','Gal80p=G80_2')	%Observation function
 
 inputs.exps.u_interp{2}='pulse-up';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{2}=2;                            %Number of pulses    
 inputs.exps.u_min{2}=0;inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{2}=[linspace(0,720,6)];            %Times of switching: Initial time, Intermediate times, Final time	

%EXPERIMENT 3
 inputs.exps.n_obs{3}=4;								%Number of observed quantities
 inputs.exps.obs_names{3}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{3}=char('Gal1p=G1_2','Gal3p=G3_2','Gal4p=G4_2','Gal80p=G80_2')	%Observation function
 
 inputs.exps.u_interp{3}='pulse-down';                 %Stimuli definition for experiment 3
 inputs.exps.n_pulses{3}=3;                            %Number of pulses    
 inputs.exps.u_min{3}=0;inputs.exps.u_max{3}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{3}=[linspace(0,720,7)];            %Times of switching: Initial time, Intermediate times, Final time    
 
 %EXPERIMENT 4
 inputs.exps.n_obs{4}=4;								%Number of observed quantities
 inputs.exps.obs_names{4}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{4}=char('Gal1p=G1_2','Gal3p=G3_2','Gal4p=G4_2','Gal80p=G80_2')	%Observation function
 
 inputs.exps.u_interp{4}='step';                 %Stimuli definition for experiment 4
 inputs.exps.n_steps{4}=5;                            %Number of pulses   
 inputs.exps.u{4}(1,:)= [0.3 0.6 1 1 0];        %Minimum and maximum value for the input
 inputs.exps.t_con{4}=[0 150 300 500 620 720];            %Times of switching: Initial time, Intermediate times, Final time  
 
 %EXPERIMENT 5
 inputs.exps.n_obs{5}=4;								%Number of observed quantities
 inputs.exps.obs_names{5}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{5}=char('Gal1p=G1_2','Gal3p=G3_2','Gal4p=G4_2','Gal80p=G80_2')	%Observation function
 
 inputs.exps.u_interp{5}='linear';                 %Stimuli definition for experiment 4
 inputs.exps.n_linear{5}=7;                            %Number of pulses   
 inputs.exps.u{5}(1,:)= [0.1 0.8 0.6 0.3 1 0.6 0];        %Minimum and maximum value for the input
 inputs.exps.t_con{5}=linspace(0,720,7);           %Times of switching: Initial time, Intermediate times, Final time  
