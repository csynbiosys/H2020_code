function [Y,Y0,t,Ym] = startingpoint_ode( p ,inputsbefore, values ) % added Y0 to see how they look like
%STARTING POINT compute the concentrations of mrna and proteins after a
%night for =/= inducer concentrations. the format of the inducer is
%[ATC;IPTG] it should contain only 1 value for each inducer.

    opts = odeset('NonNegative',1:5);
    %Greg: changed to avoid issues with bistable systems (the wrong
    %configuration can be found if inputsbefore = [0,0]
    %y0= [0;0;0;0;0];
    
    Y0= startingpoint_value(p, inputsbefore, values);
    funname= @toggle_derivative_sim;
    [t,Ym] = ode15s(funname,[0 4800],Y0,opts,inputsbefore',p); % modified to plot traces over time
    Y=Ym(end,:);
    
end