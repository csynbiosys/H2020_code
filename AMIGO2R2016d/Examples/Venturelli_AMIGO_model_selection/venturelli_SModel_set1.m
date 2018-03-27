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

inputs.exps.n_exp=4;                                                                                                           
 for iexp=1:inputs.exps.n_exp   
	inputs.exps.exp_y0{iexp}=[0.00224010507260388 6.19837186898240e-06...
					0.129868056417314 96.0145117189065];        
	inputs.exps.t_f{iexp}=720;                            
 end           
 
 %EXPERIMENT 1
 inputs.exps.n_obs{1}=4;								
 inputs.exps.obs_names{1}=char('Gal1p','Gal3p','Gal4p','Gal80p') 
 inputs.exps.obs{1}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	
 
 inputs.exps.u_interp{1}='sustained';                 
 inputs.exps.t_con{1}=[0 720];                         
 inputs.exps.u{1}=[1];                                 
 
 %EXPERIMENT 2
 inputs.exps.n_obs{2}=4;								
 inputs.exps.obs_names{2}=char('Gal1p','Gal3p','Gal4p','Gal80p') 
 inputs.exps.obs{2}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	
 
 inputs.exps.u_interp{2}='pulse-up';                 
 inputs.exps.n_pulses{2}=2;                             
 inputs.exps.u_min{2}=0;inputs.exps.u_max{2}=1;       
 inputs.exps.t_con{2}=[linspace(0,720,6)];           

%EXPERIMENT 3
 inputs.exps.n_obs{3}=4;								
 inputs.exps.obs_names{3}=char('Gal1p','Gal3p','Gal4p','Gal80p') 
 inputs.exps.obs{3}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	
 
 inputs.exps.u_interp{3}='pulse-down';                 
 inputs.exps.n_pulses{3}=3;                             
 inputs.exps.u_min{3}=0;inputs.exps.u_max{3}=1;        
 inputs.exps.t_con{3}=[linspace(0,720,7)];               
 
 %EXPERIMENT 4
 inputs.exps.n_obs{4}=4;								
 inputs.exps.obs_names{4}=char('Gal1p','Gal3p','Gal4p','Gal80p') 
 inputs.exps.obs{4}=char('Gal1p=G1','Gal3p=G3','Gal4p=G4','Gal80p=G80')	
 
 inputs.exps.u_interp{4}='step';                 
 inputs.exps.n_steps{4}=5;                            
 inputs.exps.u{4}(1,:)= [0.3 0.6 1 1 0];        
 inputs.exps.t_con{4}=[0 150 300 500 620 720];           
 
 
