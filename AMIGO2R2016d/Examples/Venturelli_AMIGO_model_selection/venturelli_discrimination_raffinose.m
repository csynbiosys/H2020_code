%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: Dynamic optimization van der Pol oscillator 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%====================
% Brief description:
%====================

%        This is a well know dynamic optimization problem often used as a
%        test case for DO methods.
%        The objective is to simultaneously minimize the amplitude of the 
%        oscillations and the control effort subject to the oscillator
%        dynamics and maximum and minimum allowed values for the control u
%        min J=y3(tf)
%        dy1/dt=(1-y2*y2)*y1-y2+u
%        dy2/dt=y1
%        dy3/dt=y1^2+y2^2+u^2
%        -0.3<=u(t)<=1

%=============
% References:
%=============

%  > Tanartkit, P., & Biegler, L.T. (1995). Stable decomposition for dynamic
%    optimization. I&EC Res., 34, 1253-1266.  
%  > Vassiliadis, V. S.; Balsa-Canto, E.; Banga, J. R. Second order
%    sensitivities of general dynamic systems with application
%    to optimal control problems. Chem. Eng. Sci. 1999, 54, 3851.
%

%====================
% AMIGO2 TESTS   :
%====================

% Here the problem will be solved by means of the following CVP
% configuration: 20 fixed lenght elements
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='venturelli_disc';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='venturelli';             % To identify figures and reports for a given problem   
%inputs.pathd.runident='20step';             % To identify this specific run

%======================
% MDOEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';                % Model introduction: 'charmodel'|'matlabmodel'|'sbmlmodel'|'fortranmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                             
inputs.model.n_st=8;                                       % Number of states      
inputs.model.n_par=38;                                     % Number of model parameters 
inputs.model.n_stimulus=1;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('G1','G3','G4','G80','G1_2','G3_2','G4_2','G80_2');     								  % Names of the states                                              
inputs.model.par_names=char('w','d','b',...
							'ag1','ag3','ag4','a0g80','ag80','kg1','kg3',...
							'kg80','n1','n3','n80','yg1','yg3','yg4','yg80',...
							'e','w_2','d_2','b_2',...
							'ag1_2','ag3_2','ag4_2','a0g80_2','ag80_2','kg1_2','kg3_2',...
							'kg80_2','n1_2','n3_2','n80_2','yg1_2','yg3_2','yg4_2','yg80_2',...
							'e_2');   % Names of the parameters                     
inputs.model.stimulus_names=char('agal');                                        % Names of the stimuli, inputs or controls                      
inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dG1=agal*e+((ag1*(G4)^3)/(((G4)^3)+kg1^3))+(-w)*G1*G80-yg1*G1',...
					'dG3=agal+(ag3*(G4^2)/(G4^2+kg3^2))+(-d)*G3*G80-yg3*G3',...
					'dG4=ag4+(-b)*G80*G4-yg4*G4',...
					'dG80=a0g80+(ag80*(G4^2)/((G4^2)+kg80^2))+(-w)*G1*G80+(-d)*G3*G80+(-b)*G80*G4-yg80*G80',...
					'dG1_2=agal*e_2+((ag1_2*(G4_2)^3)/(((G4_2)^3)+kg1_2^3))+(-w_2)*G1_2*G80_2-yg1_2*G1_2',...
					'dG3_2=agal+(ag3_2*(G4_2^2)/(G4_2^2+kg3_2^2))+(-d_2)*G3_2*G80_2-yg3_2*G3_2',...
					'dG4_2=ag4_2+(-b_2)*G80_2*G4_2-yg4_2*G4_2',...
					'dG80_2=a0g80_2+(ag80_2*(G4_2^2)/((G4_2^2)+kg80_2^2))+(-w_2)*G1_2*G80_2+(-d_2)*G3_2*G80_2+(-b_2)*G80_2*G4_2-yg80_2*G80_2');
					
inputs.model.par=[2.666659555501383e-04 0.398406374501988100 0.0160 15 0.9 0.2 0.6...
				  0.9 8 8 2 3 2 2 0.004 0.004 0.004 0.004...
				  0.1 3.3600e-04 0.0114 0.0014 35 8 3.6 5.9 9 86.7 64.9...
				  1.5 3 2 2 0.0263 0.004 0.0119 0.0073 1.02];  
				   				  

%==========================================
% Dynamic optimization problem formulation
%==========================================
 inputs.DOsol.y0=[0.00224010507260388 6.19837186898240e-06 0.129868056417314 96.0145117189065 0.00138113763960563 0.000696644542745701 2.20285327259989 1158.82050886456];                                   %Initial conditions  
 inputs.DOsol.tf_type='fixed';                              %Process duration type: fixed or free
 inputs.DOsol.tf_guess=480;                                   %Process duration

 % COST FUNCTION
 
 inputs.DOsol.DOcost_type='max';                            %Type of problem: max/min
 inputs.DOsol.DOcost='(G1-G1_2)^2';                                  %Cost functional 

 % CVP DETAILS 
 
 %inputs.DOsol.u_interp='sustained';
 
 %inputs.model.n_stimulus=1;
 %inputs.DOsol.u_min=0;
 %inputs.DOsol.u_max=1;
 %inputs.DOsol.tcon_guess=480;
 
 %inputs.DOsol.u_interp='stepf';                                    % Stimuli definition for experiment 3:
                                                                   % OPTIONS:u_interp:
                                                                   % 'sustained' |'step'|'linear'
 %inputs.DOsol.n_steps=20; 
 %inputs.DOsol.u_min=zeros(1,inputs.DOsol.n_steps);
 %inputs.DOsol.u_max=1*ones(1,inputs.DOsol.n_steps);                % Minimum and maximum value for the input
 %inputs.DOsol.t_con=linspace(0,inputs.DOsol.tf_guess,inputs.DOsol.n_steps+1);             % Minimum and maximum value for the input         
      % Input swithching times: Initial and final time  

 inputs.DOsol.u_interp='pulse-down';                                    % Stimuli definition for experiment 3:
 inputs.DOsol.n_pulses=3                                                                   % OPTIONS:u_interp:
                                                                   % 'sustained' |'step'|'linear';
 inputs.DOsol.u_guess=1;            % Initial guess for the input 
 inputs.DOsol.u_min=0
 inputs.DOsol.u_max=1                % Minimum and maximum value for the input
 inputs.DOsol.t_con_guess=[linspace(0,480,7)];       % Input swithching times: Initial and final time   

 
%==================================
% NUMERICAL METHDOS RELATED DATA
%==================================
% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';                      % [] IVP solver: 'cvodes'(default, C)|'ode15s' (default, MATLAB, sbml)|'ode113'|'ode45'
inputs.ivpsol.rtol=1.0D-7;                             % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0D-7; 
 
 
% 
% OPTIMIZATION
%
inputs.nlpsol.nlpsolver='local_solnp';                  % [] NLP solver: 
%                                                       % LOCAL: 'local_fmincon'|'local_n2fb'|'local_dn2fb'|'local_dhc'|
%                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'|
%                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
%                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|
%                                                       % GLOBAL: 'de'|'sres'
%                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_n2fb'|'hyb_de_dn2fb'|'hyb_de_dhc'|'hyp_de_ipopt'|
%                                                       %         'hyb_de_solnp'|'hyb_de_nomad'|
%                                                       %         'hyb_sres_fmincon'|'hyb_sres_n2fb'|'hyb_sres_dn2fb'|'hyb_sres_dhc'|
%                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'
%                                                       % METAHEURISTICS:
%                                                       % 'ess' or 'eSS' (default)
%                                                       % Note that the corresponding defaults are in files: 
%                                                       % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
%                                                       % OPT_solvers\eSS_**\ess_options.m
%                                                       
inputs.nlpsol.reopt='off';                     % Reoptimization after convergence
inputs.nlpsol.reopt_local_solver='solnp';     % Optimizer for reoptimization
inputs.nlpsol.n_reOpts=2;                     % Number of reoptimizations
% 
