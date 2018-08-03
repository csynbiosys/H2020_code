%============================
% RESULTS PATHS RELATED DATA
%============================
inputs.pathd.results_folder=strcat('toggle_switch',datestr(now,'yyyy-mm-dd-HHMMSS'));             % Folder to keep results (in Results) for a given problem                       
inputs.pathd.short_name=strcat('TSM_log',int2str(rand(1,1)));                                   % To identify figures and reports for a given problem 
                                                                                          % ADVISE: the user may introduce any names related to the problem at hand 
inputs.pathd.runident='run';                                                                % [] Identifier required in order not to overwrite previous results
                                                                                          % This may be modified from command line. 'run1'(default)
                                                     
%============================
% Load MODEL RELATED DATA
%============================
model=two_state_model_M1();

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================

% Load experimental data: Lugagne's paper
load('LugagneData_init.mat');

% Loading model into inputs structure
inputs.model=model;
inputs.exps.n_exp=5;                                 % Number of experiments      
                       
inputs.model.exe_type='standard';


 for iexp= 1:inputs.exps.n_exp
     
     y0_init_ss = EXP_data{1,iexp}.init([1 2 5 6]); % use init2 when you need to set the initial conditions same as the IC from lugagne model's simulation
     y0_init_ss = y0_init_ss+(1e-7.*(y0_init_ss==0)); % Replaces 0 inputs and state values with a small 1e-7


     inputs.exps.n_obs{iexp}=2;                              % Number of observed quantities per experiment                         
     inputs.exps.obs_names{iexp}=char('LacI_star','TetR_star');       % name of observables
     inputs.exps.obs{iexp}=char('LacI=LacI_star','TetR=TetR_star'); 
     inputs.exps.exp_y0{iexp}= log(y0_init_ss); % initialise_M1_Lugagne_exp_data(EXP_data,iexp); %[0,0,0.304420014782823,0.932964573854386,450.362572537976,855.546160287592]; %get_initial_values();       % Initial conditions for each experiment       
     inputs.exps.t_f{iexp}=EXP_data{1,iexp}.timeGFP(1,end)/60;                               % Experiments duration
     inputs.exps.n_s{iexp}=length(EXP_data{1,iexp}.timeGFP(1,:));                               % Number of sampling times
     inputs.exps.t_s{iexp}=EXP_data{1,iexp}.timeGFP(1,:)/60;                         % [] Sampling times, by default equidistant and in minutes
    
     % Stimulus type
     inputs.exps.u_interp{iexp}='step';

 end
 
 
 % Inputs for each experiment
 inputs.exps.u{1}=log([1e-7 0.99 1e-7; 100 1e-7 100]); inputs.exps.t_con{1,1}=[0 60*7 60*15 inputs.exps.t_f{1,1}];inputs.exps.n_steps{1}=length(inputs.exps.t_con{1,1})-1;
 inputs.exps.u{2}=log([1e-7 0.99;100 1e-7]); inputs.exps.t_con{1,2}=[0 60*7 inputs.exps.t_f{1,2}];inputs.exps.n_steps{2}=length(inputs.exps.t_con{1,2})-1;
 inputs.exps.u{3}=log([0.99 1e-7;1e-7 100]); inputs.exps.t_con{1,3}=[0 60*7 inputs.exps.t_f{1,3}];inputs.exps.n_steps{3}=length(inputs.exps.t_con{1,3})-1;
 inputs.exps.u{4}=log([0.8 0.25 0.3; 20 75 20]); inputs.exps.t_con{1,4}=[0 60*3 60*12 inputs.exps.t_f{1,4}];inputs.exps.n_steps{4}=length(inputs.exps.t_con{1,4})-1;
 inputs.exps.u{5}=log([0.8 0.3 0.3;20 60 20]); inputs.exps.t_con{1,5}=[0 60*3 60*12 inputs.exps.t_f{1,5}];inputs.exps.n_steps{5}=length(inputs.exps.t_con{1,5})-1;

% Plot
inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 

AMIGO_Prep(inputs);
AMIGO_SModel(inputs);
