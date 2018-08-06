function [] = gen_params_guesses(numExperiments )

% Upper and lower boundaries selected for the parameters (theta refers to the parameter vector)
theta_min = [1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3 1e-3 2 2 1e-3 1e-3 1e-3];
theta_max = [1e+3 1e+3 1e+3 4 4 1e+2  1e+4 1e+3 1e+3 4 4 1e+2 1e+2 1e+2];

% Create a matrix of initial guesses for the vector of parameter estimates.
% The matrix has as many rows as the number of PE iterations
% (numExperiments).
% The vectors are obtained as latin hypercube samples within the boundaries selected above.
% Each vector is passed as input to the computing function

M_norm = lhsdesign(numExperiments,length(theta_min));
    M = zeros(size(M_norm));
    for c=1:size(M_norm,2)
        for r=1:size(M_norm,1)
            M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
        end
    end 
    
    ParFull = M; % in this case I am fitting all the values
save('MatrixParameters_InputComparison.mat','ParFull');