%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% venturelli_model.m file
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

															
