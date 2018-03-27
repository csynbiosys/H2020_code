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
				  
