function [model] = two_state_model_log_transform()

%======================
% MODEL RELATED DATA
%======================
model.AMIGOjac=0;
model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                              
model.n_st=4;                                       % Number of states      
model.n_par=14;                                     % Number of model parameters 
model.n_stimulus=2;                                 % Number of inputs, stimuli or control variables   
model.names_type='custom';                          % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...) 
model.st_names=char('IPTG_star','aTc_star','LacI_star','TetR_star');     % Names of the states                                              
model.par_names=char('alpha_LacI','theta_TetR','theta_aTc','n_aTc','n_TetR','gamma_LacI',...
        'alpha_TetR','theta_LacI','theta_IPTG','n_IPTG','n_LacI','gamma_TetR','k_in_IPTG','k_in_aTc');                  % Names of the parameters                     
model.stimulus_names=char('u_IPTG','u_aTc');                                        % Names of the stimuli, inputs or controls                      



model.eqns=...                    % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
 char('dIPTG_star=exp(-IPTG_star)*k_in_IPTG*(exp(u_IPTG)-exp(IPTG_star))',...
      'daTc_star=exp(-aTc_star)*k_in_aTc*(exp(u_aTc)-exp(aTc_star))',...
      'dLacI_star=exp(-LacI_star)*(alpha_LacI/(1+((exp(TetR_star)/theta_TetR)*(1/1+(exp(aTc_star)/theta_aTc)^n_aTc))^n_TetR)-gamma_LacI*exp(LacI_star))',...
      'dTetR_star=exp(-TetR_star)*(alpha_TetR/(1+((exp(LacI_star)/theta_LacI)*(1/1+(exp(IPTG_star)/theta_IPTG)^n_IPTG))^n_LacI)-gamma_TetR*exp(TetR_star))');              

                
%==================
% PARAMETER VALUES
% =================

model.par =[58.4683 30 11.65 2 2 1.65e-2 2.7732 31.94 9.06e-2 2 2 1.65e-2 2.75e-2 1.62e-1];


end                                 