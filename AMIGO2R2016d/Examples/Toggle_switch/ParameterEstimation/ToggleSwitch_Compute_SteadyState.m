function [ res ] = ToggleSwitch_Compute_SteadyState( theta, InitialStates_AU, u_IPTG, u_aTc )
%ToggleSwitch_Compute_SteadyState Calculates the steady state for theta,
%u_IPTG and u_aTc.
%   Computes the steady state of the MToggleSwitch model for the given values of
%   theta and the inputs u_IPTG and u_aTc.
   
kL_p = theta(1);
g_m = theta(2);
kLm0 = theta(3);
kLm = theta(4);
theta_T = theta(5);
theta_aTc = theta(6);
n_aTc = theta(7);
n_T = theta(8);
g_p = theta(9);
kT_p = theta(10);
kTm0 = theta(11);
kTm = theta(12);
theta_L = theta(13);
theta_IPTG = theta(14);
n_IPTG = theta(15);
n_L = theta(16);
sc_T_molec = theta(17);
sc_L_molec = theta(18);
k_iptg = theta(19);
k_aTc = theta(20);

L_AU = InitialStates_AU(1);
T_AU = InitialStates_AU(2);

%% Steady state equation

L_molec = L_AU/sc_L_molec;
T_molec = T_AU/sc_T_molec;

L_m_dummy = 1/g_m*(kLm0 + (kLm/(1+(T_molec/theta_T*(1/(1+(aTci/theta_aTc)^n_aTc)))^n_T)));

T_m_dummy = 1/g_m*(kTm0 + (kTm/(1+(L_molec/theta_L*(1/(1+(IPTGi/theta_IPTG)^n_IPTG)))^n_L)));

L_molec = kL_p/g_p*L_m_dummy;

T_molec = kT_p/g_p*T_m_dummy; 

%L_AU = sc_L_molec*L_molec;
%T_AU = sc_T_molec*T_molec;

aTci = k_aTc*u_aTc/(g_p+k_aTc);
IPTGi = k_iptg*u_IPTG/(g_p+k_iptg);


res = [L_molec T_molec L_AU T_AU aTci IPTGi];
end

