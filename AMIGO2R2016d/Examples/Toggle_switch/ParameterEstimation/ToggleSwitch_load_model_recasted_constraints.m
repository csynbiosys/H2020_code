% This script contains the model structure we propose for the Toggle Switch
model.input_model_type='charmodelC';                                        % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|'blackboxmodel'|'blackboxcost                             
model.n_st=10;                                                              % Number of states      
model.n_par=18;                                                             % Number of model parameters 
model.n_stimulus=2;                                                         % Number of inputs, stimuli or control variables   
model.stimulus_names=char('u_IPTG','u_aTc');                                % Name of stimuli or control variables
model.st_names=char('L_molec','T_molec','T_AU','L_AU','IPTGi','aTci','L_molec_viol','T_molec_viol','IPTGi_viol','aTci_viol');     % Names of the states                                              
model.par_names=char('g_m','kL_p_m0','kL_p_m','theta_T','theta_aTc','n_aTc','n_T','g_p',...
                     'kT_p_m0','kT_p_m','theta_L','theta_IPTG','n_IPTG','n_L',...
                     'sc_T_molec',...
                     'sc_L_molec',...
                     'k_iptg',...
                     'k_aTc');                                 % Names of the parameters                     
model.eqns=...                                                              % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dL_molec = 1/g_m*(kL_p_m0 + (kL_p_m/(1+(T_molec/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)))-g_p*L_molec',...
                    'dT_molec = 1/g_m*(kT_p_m0 + (kT_p_m/(1+(L_molec/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)))-g_p*T_molec',...
                    'dT_AU = sc_T_molec*dT_molec',...
                    'dL_AU = sc_L_molec*dL_molec',...
                    'dIPTGi = k_iptg*(u_IPTG-IPTGi)-g_p*IPTGi',...
                    'daTci = k_aTc*(u_aTc-aTci)-g_p*aTci',...
                    'dL_molec_viol = (fmax(L_molec,0))^2',...
                    'dT_molec_viol = (fmax(T_molec,0))^2',...
                    'dIPTGi_viol = (fmax(IPTGi,0))^2',...
                    'daTci_viol = (fmax(aTci,0))^2');

%==================
% PARAMETER VALUES
% =================
model.par=[0.1386,5.0000025,500.0005,40,0.213428215,3,3,0.01650,15.000005,500.0005,0.0222,0.00505,3,3,505,505,0.0505,0.0505]; % Parameter values set to the average of global_theta_guess min, max

