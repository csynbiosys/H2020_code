% This script contains the model structure we propose for the Toggle Switch
model.input_model_type='charmodelC';                                        % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'blackboxmodel'|'blackboxcost                             
model.n_st=6;                                                              % Number of states      
model.n_par=20;                                                             % Number of model parameters 
model.n_stimulus=2;                                                         % Number of inputs, stimuli or control variables   
model.stimulus_names=char('u_IPTG','u_aTc');                                % Name of stimuli or control variables
model.st_names=char('L_molec','T_molec','T_AU','L_AU','IPTGi','aTcI');     % Names of the states                                              
model.par_names=char('kL_p','g_m','kLm0','kLm','theta_T','theta_aTc','n_aTc','n_T','g_p',...
                     'kT_p','kTm0','kTm','theta_L','theta_IPTG','n_IPTG','n_L',...
                     'sc_T_molec',...
                     'sc_L_molec',...
                     'k_iptg',...
                     'k_aTc');                                 % Names of the parameters                     
model.eqns=...                                                              % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dL_molec = kL_p/g_m*(kLm0 + (kLm/(1+(T_molec/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)))-g_p*L_molec',...
                    'dT_molec = kT_p/g_m*(kTm0 + (kTm/(1+(L_molec/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)))-g_p*T_molec',...
                    'dT_AU = sc_T_molec*dT_molec',...
                    'dL_AU = sc_L_molec*dL_molec',...
                    'dIPTGi = k_iptg*(u_IPTG-IPTGi)-g_p*IPTGi',...
                    'daTci = k_aTc*(u_aTc-aTci)-g_p*aTci');

%==================
% PARAMETER VALUES
% =================

model.par=[]; % Parameter values
