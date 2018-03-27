%=======================
% PATHS RELATED DATA
%=======================

inputs.pathd.results_folder='Venturelli_set1';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='Venturelli';                      % To identify figures and reports for a given problem   

%========================
% MODEL RELATED DATA
%========================



inputs.model.input_model_type='charmodelC';                % Model introduction: 'charmodel'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=4;                                       % Number of states      
inputs.model.n_par=19;                                     % Number of model parameters 
inputs.model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('G1','G3','G4','G80');     								  % Names of the states                                              
inputs.model.par_names=char('w','d','b',...
							'ag1','ag3','ag4','a0g80','ag80','kg1','kg3',...
							'kg80','n1','n3','n80','yg1','yg3','yg4','yg80',...
							'e');   % Names of the parameters                     
inputs.model.stimulus_names=char('agal');                                        % Names of the stimuli, inputs or controls                      
inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dG1=agal*e+((ag1*(G4)^n1)/(((G4)^n1)+kg1^n1))+(-w)*G1*G80-yg1*G1',...
					'dG3=agal+(ag3*(G4^n3)/(G4^n3+kg3^n3))+(-d)*G3*G80-yg3*G3',...
					'dG4=ag4+(-b)*G80*G4-yg4*G4',...
					'dG80=a0g80+(ag80*(G4^n80)/((G4^n80)+kg80^n80))+(-w)*G1*G80+(-d)*G3*G80+(-b)*G80*G4-yg80*G80');
					
inputs.model.par=[2.666659555501383e-04 0.398406374501988100 0.0160 15 0.9 0.2 0.6...
				  0.9 8 8 2 3 2 2 0.004 0.004 0.004 0.004...
				  0.1];  

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

inputs.exps.n_exp=5;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
	inputs.exps.exp_y0{iexp}=[0.00224010507260388 6.19837186898240e-06 0.129868056417314 96.0145117189065];  %Initial conditions for each experiment          
	inputs.exps.t_f{iexp}=480;                            %Experiments duration
 end           
 
 %EXPERIMENT 1
 inputs.exps.n_obs{1}=4;								%Number of observed quantities
 inputs.exps.obs_names{1}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{1}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	%Observation function
 
 inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1
 inputs.exps.t_con{1}=[0 480];                        % Input switching times: Initial and final time    
 inputs.exps.u{1}=[1];                                 % Values of the inputs 
 
 %EXPERIMENT 2
 inputs.exps.n_obs{2}=4;								%Number of observed quantities
 inputs.exps.obs_names{2}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{2}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	%Observation function
 
 inputs.exps.u_interp{2}='pulse-up';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{2}=2;                            %Number of pulses    
 inputs.exps.u_min{2}=0;inputs.exps.u_max{2}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{2}=[linspace(0,480,6)];            %Times of switching: Initial time, Intermediate times, Final time	

%EXPERIMENT 3
 inputs.exps.n_obs{3}=4;								%Number of observed quantities
 inputs.exps.obs_names{3}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{3}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	%Observation function
 
 inputs.exps.u_interp{3}='pulse-down';                 %Stimuli definition for experiment 3
 inputs.exps.n_pulses{3}=3;                            %Number of pulses    
 inputs.exps.u_min{3}=0;inputs.exps.u_max{3}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{3}=[linspace(0,480,7)];            %Times of switching: Initial time, Intermediate times, Final time    
 
 %EXPERIMENT 4
 inputs.exps.n_obs{4}=4;								%Number of observed quantities
 inputs.exps.obs_names{4}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{4}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	%Observation function
 
 inputs.exps.u_interp{4}='step';                 %Stimuli definition for experiment 4
 inputs.exps.n_steps{4}=5;                            %Number of pulses   
 inputs.exps.u{4}(1,:)= [0.3 0.6 1 1 0];        %Minimum and maximum value for the input
 inputs.exps.t_con{4}=[0 150 300 330 350 480];            %Times of switching: Initial time, Intermediate times, Final time  
 
 %EXPERIMENT 5
 inputs.exps.n_obs{5}=4;								%Number of observed quantities
 inputs.exps.obs_names{5}=char('Gal1p','Gal3p','Gal4p','Gal80p') %Name of the observed quantities
 inputs.exps.obs{5}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	%Observation function
 
 inputs.exps.u_interp{5}='linear';                 %Stimuli definition for experiment 4
 inputs.exps.n_linear{5}=7;                            %Number of pulses   
 inputs.exps.u{5}(1,:)= [0.1 0.8 0.6 0.3 1 0.6 0];        %Minimum and maximum value for the input
 inputs.exps.t_con{5}=linspace(0,480,7);           %Times of switching: Initial time, Intermediate times, Final time  
 
%==================================
% UNKNOWNS RELATED DATA
%==================================

inputs.PEsol.id_global_theta='all';                         % 'all'|User selected 
inputs.PEsol.global_theta_max=3.*inputs.model.par;    % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0.5.*inputs.model.par;       % Minimum allowed values for the parameters
inputs.PEsol.global_theta_guess=inputs.model.par;
 
