function [model] = lugagne_toggle_switch_model_IEM()

% This is the script for the Inducer Exchange Model discussed in Lugagne's
% paper: https://www-nature-com.ezproxy.is.ed.ac.uk/articles/s41467-017-01498-0


%======================
% MODEL RELATED DATA
%======================

model.input_model_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                              
model.n_st=5;                                       % Number of states      
model.n_par=19;                                     % Number of model parameters 
model.n_stimulus=2;                                 % Number of inputs, stimuli or control variables   
model.names_type='custom';                          % [] Names given to states/pars/inputs: 'standard' (x1,x2,...p1,p2...,u1, u2,...) 
model.st_names=char('IPTG','mrna_LacI','mrna_TetR','LacI','TetR');     % Names of the states                                              
model.par_names=char('k_m0L','k_m0T','k_mL','k_mT','k_pL','k_pT','g_mL','g_mT','g_pL','g_pT','theta_LacI','N_LacI','theta_IPTG','N_IPTG','theta_TetR','N_TetR',...
    'theta_aTc','N_aTc','K_in_IPTG'); %,'K_out_IPTG','K_in_aTc','K_out_aTc');                  % Names of the parameters                     
model.stimulus_names=char('IPTGext','aTcext');                                        % Names of the stimuli, inputs or controls                      

model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
 char('dIPTG=K_in_IPTG*(IPTGext-IPTG)',... %+((K_in_IPTG*(IPTGext-IPTG))^2)^0.5)/2-(K_out_IPTG*(IPTG-IPTGext)+((K_out_IPTG*(IPTG-IPTGext))^2)^0.5)/2',...%dIPTG=max(K_in_IPTG*(IPTGext-IPTG),0)-max(K_out_IPTG*(IPTG-IPTGext),0)',... 
                    'dmrna_LacI=(k_m0L+k_mL/(1+(TetR/theta_TetR * 1/(1+(aTcext/theta_aTc)^N_aTc))^N_TetR)-g_mL*mrna_LacI)',...
                    'dmrna_TetR=(k_m0T+k_mT/(1+(LacI/theta_LacI * 1/(1+(IPTG/theta_IPTG)^N_IPTG))^N_LacI)-g_mT*mrna_TetR)',...
                    'dLacI=(k_pL*mrna_LacI-g_pL*LacI)',...
                    'dTetR=(k_pT*mrna_TetR-g_pT*TetR)');              

%==================
% PARAMETER VALUES
% =================

model.par =[3.045e-1 3.313e-1 13.01 5.055 6.606e-1 5.098e-1 1.386e-1 1.386e-1 1.65e-2 1.65e-2 124.9 2 2.926e-1 2 76.4 2.152 35.98 2 4e-2]; 


end                                 