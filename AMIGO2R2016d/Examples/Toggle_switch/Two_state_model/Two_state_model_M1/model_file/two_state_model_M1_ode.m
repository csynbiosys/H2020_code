function [y] = two_state_model_M1_ode(t,InitVals,parameters,inputs) %#ok<INUSL>
% TSM representing bistable switch
% order of the states in the ODE model IPTG, aTc, LacI, TetR

% initial values
IPTG_star=InitVals(1); aTc_star=InitVals(2);
LacI_star=InitVals(3); TetR_star=InitVals(4);

% inputs
u_IPTG=inputs(1); u_aTc=inputs(2);

alpha_LacI=parameters(1,1); 
theta_TetR=parameters(1,2); 
theta_aTc=parameters(1,3);
n_aTc=parameters(1,4); 
n_TetR=parameters(1,5); 
gamma_LacI=parameters(1,6); 
alpha_TetR=parameters(1,7);
theta_LacI=parameters(1,8);
theta_IPTG=parameters(1,9);
n_IPTG=parameters(1,10);
n_LacI=parameters(1,11);
gamma_TetR=parameters(1,12);
k_in_IPTG=parameters(1,13);
k_in_aTc=parameters(1,14);

% Equations
y(1,1)= exp(-IPTG_star)*k_in_IPTG*(u_IPTG-exp(IPTG_star));
y(2,1)= exp(-aTc_star)*k_in_aTc*(u_aTc-exp(aTc_star)); 
y(3,1)=exp(-LacI_star)*(alpha_LacI/(1+((exp(TetR_star)/theta_TetR)*(1/1+(exp(aTc_star)/theta_aTc)^n_aTc))^n_TetR)-gamma_LacI*exp(LacI_star));
y(4,1)=exp(-TetR_star)*(alpha_TetR/(1+((exp(LacI_star)/theta_LacI)*(1/1+(exp(IPTG_star)/theta_IPTG)^n_IPTG))^n_LacI)-gamma_TetR*exp(TetR_star));              

end

