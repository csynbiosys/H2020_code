numExperiments=100;
resultBase='ICS_cv';

cd 18July2018_cvodes/PE_data/

for epcc_exps=1:numExperiments
    
     epccOutputResultFileNameBase = [resultBase,'-',num2str(epcc_exps)];
    
     % Load file containing results from PE
     load(strcat(epccOutputResultFileNameBase,'.mat')) 
     
     % Plot Convergence curves from all trials, using data from PE carried
     % out of data from a 50 hour experiment. 
     figure(1)
     %subplot(1,3,epcc_exps)
     plot(pe_results{1, 10}.nlpsol.conv_curve(:,1),pe_results{1, 10}.nlpsol.conv_curve(:,2)); hold on;
     xlabel('CPU time (seconds)')
     ylabel('Objective function value')
     
     
    

end
