function [] = Run_MToggleSwitch_in_silico_experiment( resultBase, numExperiments )
% This function calls MToggleSwitch_in_silico.m to simulate the MToggleSwitch model to a
% step in IPTG and aTc (the value of which is specified by IPTGExt and aTcExt) lasting 24
% hours. 
global epccOutputResultFileNameBase;
global IPTGe
global aTce

cd ('../../../');
AMIGO_Startup();

cd ('Examples/Toggle_switch/ParameterEstimation');
% b) Simulation of the dynamic to a step to 5 uM of IPTG (Figure 2b)
IPTGExt = [1];%0.25];
aTcExt = [0];%20];
for epcc_exps=1:numExperiments
    for ip = 1:length(IPTGExt)
        IPTGe = IPTGExt(ip);
        aTce = aTcExt(ip);
        try
            epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];
            MToggleSwitch_in_silico;
        catch err
            %open file
            errorFile = [resultBase,'-',num2str(epcc_exps),'.errorLog'];
            fid = fopen(errorFile,'a+');
            fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
            % close file
            fclose(fid);
        end
    end
end

