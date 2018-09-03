function [Y0Used,Y0Analyt,dy_Y0Analyt,dy_Y0Used,t,Ym]= plot_mean_optimised_results_attempt( p , data , varargin)
    
ip = inputParser;
addParameter(ip,'RunSSA',false,@islogical);
ip.parse(varargin{:});
Y0Used = zeros(numel(data),6);
Y0Analyt = zeros(numel(data),6);

dy_Y0Analyt = zeros(numel(data),6);
dy_Y0Used = zeros(numel(data),6);

    for ds=1:numel(data)

        timegfp = data(ds).val.timegfp;
        timerfp = data(ds).val.timerfp;
        gfpMothers = data(ds).val.gfpMothers;
        rfpMothers = data(ds).val.rfpMothers;
        inputs =  data(ds).ind.inputs;
        inputsbefore = data(ds).ind.inputsbefore;
        
        fprintf('Simulating dataset #%d\n',ds) 
        disp('here: used observed initial conditions')
       % Y0= startingpoint_value(p, inputsbefore, data(ds).val);
        [Y0,Y0P,t,Ym]=startingpoint_ode( p ,inputsbefore, data(ds).val); % Ym is the matrix with simulation of the ON
        Y0Used(ds,:) = Y0;
        Y0Analyt(ds,:) = Y0P;
        iptg_ext = inputs(2,1);
        atc_ext = inputs(1,1);
        
        dy_Y0Analyt(ds,1) = p.crl + p.cil * hill_func(Y0P(4) * hill_func(Y0P(6),p.katc,p.matc),p.k_t,p.nt) - p.delta_mrnal*Y0P(1);%dlaciM(y(4),atc,y(1),p);
        dy_Y0Analyt(ds,2) = p.crt + p.cit * hill_func(Y0P(3) * hill_func(Y0P(5),p.kiptg,p.miptg),p.k_l,p.nl) - p.delta_mrnat*Y0P(2);%dtetrM(y(3),y(5),y(2),p);
        dy_Y0Analyt(ds,3) = p.cl*Y0P(1) - p.deltal*Y0P(3);
        dy_Y0Analyt(ds,4) = p.ct*Y0P(2) - p.deltat*Y0P(4);
        dy_Y0Analyt(ds,5) = (iptg_ext - Y0P(5))/(p.iptgdelay1/60);
        dy_Y0Analyt(ds,6) = max((atc_ext - Y0P(6))/(p.atcdelay1/60),0)-max((Y0P(6)-atc_ext)/(p.atcdelay2/60),0);

        dy_Y0Used(ds,1) = p.crl + p.cil * hill_func(Y0(4) * hill_func(Y0(6),p.katc,p.matc),p.k_t,p.nt) - p.delta_mrnal*Y0(1);%dlaciM(y(4),atc,y(1),p);
        dy_Y0Used(ds,2) = p.crt + p.cit * hill_func(Y0(3) * hill_func(Y0(5),p.kiptg,p.miptg),p.k_l,p.nl) - p.delta_mrnat*Y0(2);%dtetrM(y(3),y(5),y(2),p);
        dy_Y0Used(ds,3) = p.cl*Y0(1) - p.deltal*Y0(3);
        dy_Y0Used(ds,4) = p.ct*Y0(2) - p.deltat*Y0(4);
        dy_Y0Used(ds,5) = (iptg_ext - Y0(5))/(p.iptgdelay1/60);
        dy_Y0Used(ds,6) = max((atc_ext - Y0(6))/(p.atcdelay1/60),0)-max((Y0(6)-atc_ext)/(p.atcdelay2/60),0);
    end
        
% 
%         [~,~,LacI_opt,TetR_opt,iptg,atc] = generate_data(p,Y0,timerfp/60,inputs);
% 
%         % Plot original data:
%         subplot(numel(data),3,ds*3-1)
%         hold on
%         plot(timerfp/3600,mean(rfpMothers,2),'r','LineWidth',2);
%         plot(timerfp/3600,rfpMothers,'r');
%         plot(timerfp/3600,mean(gfpMothers,2),'g','LineWidth',2);
%         plot(timerfp/3600,gfpMothers,'g');
%         axis([0 length(inputs)/60 0 4.5e3]);
%         
%         % Plot optimized model
%         subplot(numel(data),3,ds*3)
%         hold on
%         plot(timerfp/3600,TetR_opt,'g','linewidth',2);
%         %plot(timerfp/3600,TetRs,'Color','g');
%         plot(timerfp/3600,LacI_opt,'r','linewidth',2);
%         %plot(timerfp/3600,LacIs,'r');
%         
%         clearvars LacIs TetRs
% 
%         axis([0 length(inputs)/60 0 4.5e3]);
% %         if isfield(data(ds),'name')
% %             title(data(ds).name,'Interpreter','None')
% %         end
%      
%         subplot(numel(data),3,ds*3-2);
%         [AX,H1,H2] = plotyy((1:length(inputs))/60,inputs(2,:)',(1:length(inputs))/60,inputs(1,:)',@stairs,@stairs);
%         set(H1,'Color','c')
%         set(H1,'Linewidth',2)
%         set(H2,'Color','m')
%         set(H2,'Linewidth',2)
%         set(AX(1),'Ycolor','c')
%         set(get(AX(1),'Ylabel'),'String','IPTG') 
%         set(AX(1),'Ylim',[-0.05 1.05])
%         set(AX(2),'Ycolor','m')
%         set(get(AX(2),'Ylabel'),'String','aTC') 
%         set(AX(2),'Ylim',[-5 105])
%         xlabel('time (h)');
%         set(AX(1),'Xlim',[0 length(inputs)/60])
%         set(AX(2),'Xlim',[0 length(inputs)/60])
%         hold on; plot(timerfp/3600,iptg,'c--','Linewidth',2);
%         hold on; plot(timerfp/3600,atc/100,'m--','Linewidth',2);
%         drawnow
%     end
end