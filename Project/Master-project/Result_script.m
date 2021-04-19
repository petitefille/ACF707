%%
P4 = PortfolioCVaR('ProbabilityLevel',0.95,'NumAssets',97);
% Script for getting data from master GUI and calculating results
P(1)=P2 
P4=P4.setDefaultConstraints;

%opt=optimoptions('linprog','Algorithm','dual-simplex','Display','off');

P(3)=P(1);
P(4)=P(1);
P(2)=P(1);


%%
%Estimate Frontier
N_T=10;
S={'hist','boot','norm', 'studT'};
CVaR_lim=linspace(0.03,0.0927,N_T);

    for j=1:4

        for i=1:10
            t=tic;
            t2=tic;
            Scen=ScenarioGen(Returns_after_crash,S{j},20000);
            toc(t2)
            P4=P4.setScenarios(scenarios_T);
            w4=estimateFrontierByRisk(P4,CVaR_lim);
            time_byRisk(i,j)=toc(t);
            
        end
        display(j,'J')
    end
display('Finished')

%%

Pret_N=(estimatePortReturn(P(3),w_crash(:,:,3)))*100*52;
% Pret_N = (estimatePortReturn(P3,w3))*100*52;
Pret_T=(estimatePortReturn(P(4),w_crash(:,:,4)))*100*52;
% Pret_T = (estimatePortReturn(P4,w4))*100*52;
Pret_H=(estimatePortReturn(P(1),w_crash(:,:,1)))*100*52;
% Pret_H = (estimatePortReturn(P1,w1))*100*52;
Pret_B=(estimatePortReturn(P(2),w_crash(:,:,2)))*100*52;
% Pret_B = (estimatePortReturn(P2,w2))*100*52;

Prsk_N=(estimatePortRisk(P(3),w_crash(:,:,3)))*100;
% Prsk_N = (estimatePortRisk(P3,w3)*100);
Prsk_T=(estimatePortRisk(P(4),w_crash(:,:,4)))*100;
% Prsk_T = (estimatePortRisk(P4,w4)*100);
Prsk_H=(estimatePortRisk(P(1),w_crash(:,:,1)))*100;
% Prsk_H = (estimatePortRisk(P1,w1)*100);
Prsk_B=(estimatePortRisk(P(2),w_crash(:,:,2)))*100;
% Prsk_B = (estimatePortRisk(P2,w2)*100);

%%  
%Plot Frontier in mean-CVaR space
figure()
plot(Prsk_H,Pret_H,'LineWidth',2)
hold 'on'
plot(Prsk_B,Pret_B,'LineWidth',2)
plot(Prsk_N,Pret_N,'LineWidth',2)
plot(Prsk_T,Pret_T,'LineWidth',2)

title('Efficient frontier for different scenarios')
xlabel('Risk in %')
ylabel('Return in %')
grid 'on'
legend('Historic','Block boostrap','Multivariate Normal','Multivariate T','Location','Northwest')

%%
%Compared to Mean-Variance
Pstd_N=(estimatePortStd(P(3),w_crash(:,:,3)))*100;
% Pstd_N = (estimatePortStd(P3,w3))*100;
Pstd_T=(estimatePortStd(P(4),w_crash(:,:,4)))*100;
% Pstd_T = (estimatePortStd(P4,w4))*100;
Pstd_H=(estimatePortStd(P(1),w_crash(:,:,1)))*100;
% Pstd_H = (estimatePortStd(P1,w1))*100;
Pstd_B=(estimatePortStd(P(2),w_crash(:,:,2)))*100;
% Pstd_B = (estimatePortStd(P2,w2))*100;
w_MV=estimateFrontier(Port_MV);
% w_MV2=estimateFrontier(PMV);

%Plot Frontier in mean-std space
[Pstd_MV,Pret_MV]=plotFrontier(PMV);
% [Pstd_MV2,Pret_MV2]=plotFrontier(PMV);

figure()
plot(Pstd_MV2*100,Pret_MV2*100*52,'LineWidth',2)
hold 'on'
plot(Pstd_H,Pret_H,'LineWidth',2)
plot(Pstd_B,Pret_B,'LineWidth',2)
plot(Pstd_T,Pret_T,'LineWidth',2)
plot(Pstd_N,Pret_N,'LineWidth',2)
title('Efficient frontier for different scenarios')
xlabel('Risk in %')
ylabel('Return in %')
grid 'on'
legend('Mean-Variance','Historic','Block boostrap','Multivariate T','Multivariate Normal','Location','Northwest')

%%
% Plot performance of portfolios

[StarrMax, Max_I]=max((Pret_T/52)./Prsk_T);
Price=Prices2;

Max_I=1;
pf_MV=prices*w_MV(:,Max_I);
% pf_MV=prices*w_MV2(:,Max_I);
pf_hist=Price*w1(:,Max_I);
% pf_hist=prices*w1(:,Max_I);
pf_boot=Price*w_crash(:,Max_I,2);
% pf_boot=prices*w2(:,Max_I);
pf_norm=Price*w_crash(:,Max_I,3);
% pf_norm=prices*w3(:,Max_I);
pf_studt=Price*w_crash(:,Max_I,4);

% pf_studt=prices*w4(:,Max_I);

%%
%Relative
pf_MV=100*(pf_MV./pf_MV(1));
pf_hist=100*(pf_hist./pf_hist(1));
pf_boot=100*(pf_boot./pf_boot(1));
pf_norm=100*(pf_norm./pf_norm(1));
pf_studt=100*(pf_studt./pf_studt(1));

figure()
plot(dates,pf_MV,'--','LineWidth',1.5)
hold 'on'
plot(dates,pf_hist,'LineWidth',1.5)
plot(dates,pf_boot,'LineWidth',1.5)
plot(dates,pf_studt,'LineWidth',1.5)
plot(dates,pf_norm,'LineWidth',1.5)
legend('Mean-Variance','Historic','Block boostrap','Multivariate T','Multivariate Normal','Location','NorthWest')
datetick('x')
grid 'on'

%----------------
%Own method
%----------------
%%
S={'hist','boot','norm', 'studT'};
alpha=0.95;
N_S=20000; %Number of scenarios
N_T=10; % Number of repetition for timing

Ret_lim=linspace(Pret_N(1),Pret_N(end),N_T);
%Scen=ScenarioGen(Scenario_hist,S{i},N_S);

for i=3%1:length(S)
    for j=1:10
        t=tic;
        switch i
            case 1
                Scen=Scenario_hist;
            case 2
                Scen=Scenario_boot;
            case 3
                Scen=Scenario_norm;
            case 4
                Scen=Scenario_studT;
        end
        
        [w(:,j,i),VaR(j,i),CVaR(j,i)]=MinCVaRPort_Y(Scen,Mu,Ret_lim(j),alpha);
        time_min_Y(i,j)=toc(t);


    end
end
display(time_min_Y,'Yalmip time')

%%

CVaR_lim=linspace(0.03,0.0927,N_T);

for i=1:length(S)
    for j=1:10
        t=tic;
        Scen=ScenarioGen(Scenario_hist,S{i},N_S);
        [w,VaR,Ret]=MaxRetPort_Y(Scen,Mu,CVaR_lim(j),alpha);
        time_max_Y(i,j)=toc(t);


    end
end
display(time_max_Y,'Yalmip time')

%%
%Time pure LP solver - Max ret st CVaR

CVaR_lim=linspace(0.03,0.0927,N_T);
for i=1:length(S)
    for j=1:10
        t=tic;
        
        Scen=ScenarioGen(Scenario_hist,S{i},N_S);
        [~,~,~]=maxRetPort(Scen,CVaR_lim(j),0.95)
        
        timeMax(i,j)=toc(t);
        
        
    end
end

display(timeMax,'Max returns time')
%%

%Pure LP solver - min CVaR st return limit
Ret_lim=linspace(Pret_T(1)/5200,Pret_T(end)/5200,N_T);
for g=1:5
    Scen=ScenarioGen(Scenario_hist,S{4},N_S);

for i=4
    for j=1:10
        t=tic;
        
%         switch i
%             case 1
%                 Scen=Scenario_hist;
%             case 2
%                 Scen=Scenario_boot;
%             case 3
%                 Scen=Scenario_norm;
%             case 4
%                 Scen=Scenario_studT;
%         end
        if j==10 | max(mean(Scen)) <= Ret_lim(j)
            Ret_lim(j)=max(mean(Scen));
            display(Ret_lim)
            m=max(mean(Scen));
            display('high')

        elseif j==1 | min(mean(Scen)) >= Ret_lim
            Ret_lim(1)=min(mean(Scen));
            display(Ret_lim)
            m=min(mean(Scen));
            display('Low')
        end
        
        [wMin(:,j,g),VaR_LP(j,g),CVaR_LP(j,g)]=minCVaRPort(Scen,Ret_lim(j),0.95);
        
        timeMin(i,j)=toc(t);
        
        end
    end
end
display(timeMin,'Min CVaR time')
