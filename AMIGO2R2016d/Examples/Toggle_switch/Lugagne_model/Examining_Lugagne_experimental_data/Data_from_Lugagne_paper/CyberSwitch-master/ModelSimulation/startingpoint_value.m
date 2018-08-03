function [Y] = startingpoint_value( p , inputs , values)
%STARTING POINT compute the concentrations of mrna and proteins after a
%night for =/= inducer concentrations. the format of the inducer is
%[ATC;IPTG] it should contain only 1 value for each inducer.

    Y(3)=mean(values.rfpMothers(1,:)); %the measured RFP fluorescence (ie y(3))
    Y(4)=mean(values.gfpMothers(1,:)); %the measured GFP fluorescence (ie y(4))
    % with the maturation model, the total LacI / RFP is given by y(7)= (p.deltal+p.maturationl)/p.maturationl*y(3)
    if ~isfield(p,'maturationt')
        LacI= Y(3);
        TetR= Y(4);
    else
        Y(7)= (p.deltal+p.maturationl)/p.maturationl*Y(3);
        Y(8)= (p.deltat+p.maturationt)/p.maturationt*Y(4);       
        LacI= Y(7);
        TetR= Y(8);
    end
    
    % error here! was originally as below
    %            + p.cit * hill_func(    LacI * hill_func(    inputs(1), ...
    Y(2) = (p.crt ...
            + p.cit * hill_func(    LacI * hill_func(    inputs(2), ... %inputs(2) is IPTG
                                                                p.kiptg, ...
                                                                p.miptg ...
                                                            ), ...
                                    p.k_l, ...
                                    p.nl ...
                                ) ...
            )...
            ./p.delta_mrnat;
        
    % error here! was originally as below
    %            + p.cil * hill_func(    TetR * hill_func(    inputs(2), ...
    Y(1) = (p.crl ...
            + p.cil * hill_func(    TetR * hill_func(    inputs(1), ... %inputs 1 is atc
                                                                p.katc, ...
                                                                p.matc ...
                                                            ), ...
                                    p.k_t, ...
                                    p.nt ...
                                )...
            ) ...
            ./p.delta_mrnal;
    
        % error here! was originally as below    
    %Y=[mRNAl,mRNAt,LacI,TetR,inputs(1)];
    Y(5)= inputs(2);
    Y(6)= inputs(1);
    
end
