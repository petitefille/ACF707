
%import data

duration = 5;

stop = datestr(today,24); % '19/07/2020'
start = datestr(today-365.25*duration,24);

% OR  chose specific start and stop dates 
 
% start = '18/07/2017';
% stop = '18/07/2019';
% duration = yearfrac(start,stop,1) % 2

% choose index (from Yahoo Finance): 
maxi = 98
index_tick = 'S&P100'

frequence = 'w';
nrBusinessDays = 252; 

% download data 
[AC,stock_names]=collectSP(duration,frequence,maxi,index_tick,NAN);
method = 'pchip';
AC = fillmissing(AC,method);

dates=AdjClose.Properties.RowTimes;
S = vartype('numeric');
mat = AdjClose(:,S);
prices = mat.Variables;
benchmark=prices(:,1);
prices(:,1)=[];% første kolonne som benchmarks slettes
returnType = 'l';
returns = computeReturns(prices,dates,returnType);



% Visualize price and returns
series = [benchmark(:), prices];
benchmarkName = indexName;
seriesNames = [benchmarkName];
asset_names_str = string(assetNames);
for i=1:length(asset_names_str)
     seriesNames = [seriesNames; asset_names_str(i)];
end  
pricesNames = [];
for i=1:length(asset_names_str)
     pricesNames = [pricesNames; asset_names_str(i)];
end 

N = length(pricesNames); % nr of assets in chosen portfolio

% Visualize prices & returns

% Choose firm/stock
% index 1 is benchmark/index
fig1=figure;

% I = 1 % DAX 
I = 2; % 2- ADIDAS

% Prices

subplot(2,1,1);
plot(dates(1:end),series(1:end,I),'b','LineWidth',2)    
% get returns
datetick('x','yyyy')
xlabel('Dates');
ylabel('Prices');
title('Price series');
box('on')
grid('on')

% Returns series
subplot(2,1,2);
plot(dates(1:end-1),tick2ret(prices(:,I),dates(:),'Continuous'),'b')
ylabel('Returns')
xlabel('Dates')
datetick('x','yyyy')
title('Return series')
box('on')
grid('on')


% Distribution analysis

% Choose asset
% I = 1 % DAX
I = 2 % ADIDAS

rets = computeReturns(prices,dates,'s');

% Fit distribution
if I == 1 % all
    [D PD] = allfitdist(deleteoutliers(rets),'PDF');
else
    [D PD] = allfitdist(deleteoutliers(rets(:,I-1)),'PDF'); % I = 1 - DAX, I = 2: ADDYY
    display(D,'=D')
end   

assignin('base','D',D)
data = [[D.NLogL]' [D.AIC]' [D.BIC]'];
names = fieldnames(D);
names = names(2:4);

for i=1:length([D.NLogL])
    RwNames{i} = D(i).DistName;
end    
dataTable=cell2table(num2cell(data), 'VariableNames',  names, 'RowNames',RwNames);
display(dataTable);

% Portfolio: 
returnType = 'l'; % logarithmic return
% daily returns of individual stocks
returns = computeReturns(prices,dates,returnType);

% risk measure
% riskType = 'MV'
% Conditional Value at Risk
% riskType = 'CVAR'
riskType = 'both';

alpha = 0.95;

%      case 'hist'
scenarios_H = returns;

%     case 'boot'
b = opt_block(returns);
b = ceil(mean(b(2,:)));
scenarios_B = overlappingBB_generator(returns,b,20000);

% case 'norm'
[Mu,Sigma] = ecmnmle(returns);
scenarios_N = mvnrnd(Mu,Sigma,20000); % 20 000 x 2

% case 'studT'
[mu S nu] = fitt(returns);
scenarios_T = MVT_RND(mu,S,nu,20000);
scenarios_T = transpose(scenarios_T);


% set default portfolio constraints
defaultConstraints = 1;

portfolioCVaR = PortfolioCVaR();
portfolioMV = Portfolio();


mu = mean(returns); % mean returns of individual assets
sigma = cov(returns); % cov matrix 

anRisk = sqrt(diag(sigma)).*sqrt(nrBusinessDays); 
% annualized risk - annualized std of ind stocks 
anRet = mu*nrBusinessDays; % annualized returns of ind stocks 

portfolioMV = Portfolio(portfolioMV,'AssetMean',mu,'AssetCovar',sigma,'AssetList',pricesNames);
% based on mean and std of individual assets
portfolioCVaR = PortfolioCVaR(portfolioCVaR,'AssetList',pricesNames,'Scenarios',model,'ProbabilityLevel',alpha);
% based on chosen scenario

if defaultConstraints
    portfolioMV = portfolioMV.setDefaultConstraints;
    portfolioCVaR = portfolioCVaR.setDefaultConstraints;
end  

% Optimization 

% Linprog ( Linear optimization)
solver = 'linprog';

% Linear programming
% a)
algorithm = {'dual-simplex'};
% b) 
% algorithm = {'interior-point'}
% c) compare alogrithms
% algorithm = {'dual-simplex','interior-point'}

% compute efficient frontier based on solver and algorithm
portCVaR = portfolioCVaR;
portMV = portfolioMV;
weightCVaR =[];
weightMV =[];
   
MVret =[];
MVrisk=[];

CVaRrisk =[];
CVaRret=[];
CVaRstd =[];

timeTaken = [];

switch riskType
    case 'MV'
        t = tic;
        w1=estimateFrontier(portMV);
        [MVret,MVrisk]=estimatePortMoments(portMV,w1);
        weightMV=w1;
        timeTaken=toc(t);
    case 'CVAR'
        for i=1:length(algorithm)
            t=tic;
            optim=optimoptions(solver,'Algorithm',algorithm{i},'Display','off');
            portCVaR=setSolver(portCVaR,'cuttingplane','MasterSolverOptions',optim);
            w2=estimateFrontier(portCVaR);
            timeTaken(i)=toc(t);
        end
        CVaRret=estimatePortReturn(portCVaR,w2);
        CVaRstd=estimatePortStd(portCVaR,w2);
        CVaRrisk=estimatePortRisk(portCVaR,w2);
        weightCVaR=w2;     
    case 'both'
        w1=estimateFrontier(portMV);
        [MVrisk,MVret]=estimatePortMoments(portMV,w1); % mean and standard deviation
        weightMV=w1;
        for i=1:length(algorithm)
            t=tic;
            optim=optimoptions(solver,'Algorithm',algorithm{i},'Display','off');
            portCVaR=setSolver(portCVaR,'cuttingplane','MasterSolverOptions',optim);
            w2=estimateFrontier(portCVaR);
            timeTaken{i}=toc(t);
        end
        CVaRret=estimatePortReturn(portCVaR,w2);
        CVaRstd=estimatePortStd(portCVaR,w2);
        CVaRrisk=estimatePortRisk(portCVaR,w2); % the conditional value-at-risk (CVaR) of portfolio returns for each portfolio
        weightCVaR=w2;     
end
 

% display results
data = [];

if length(algorithm) > 1
    name = [];
    for i = 1:length(algorithm)
        name = [name; {solver}]
    end
    data = [data; name algorithm' timeTaken'];
    testtable = cell2table(data, 'VariableNames',{'Solver','Algorithm','time'});
else
    data=[data;{solver}' algorithm' timeTaken'];
    testtable=cell2table(data, 'VariableNames',{'Solver','Algorithm','time'});
end    

display(testtable);        
        
% collect computed data and draw results        
MVrisk_c = MVrisk;
MVret_c = MVret; 
CVaRret_c = CVaRret;
CVaRstd_c = CVaRstd;
CVaRrisk_c = CVaRrisk; 

% get benchmark statistics
bRet =  computeReturns(benchmark,dates,returnType);
decayfactor = 1; % set to 1
[bMu,bSigma] = ewstats(bRet,decayfactor);
anBenchRet = bMu*nrBusinessDays;
anBenchRisk = sqrt(bSigma)*sqrt(nrBusinessDays);

% annualize optimisation results for visualization
MVret = MVret*nrBusinessDays; 
MVrisk = MVrisk*sqrt(nrBusinessDays);
CVaRret = CVaRret*nrBusinessDays;
CVaRstd = CVaRstd*sqrt(nrBusinessDays);

% use percentages
MVret = MVret*100;
MVrisk = MVrisk*100;
CVaRret = CVaRret*100;
CVaRrisk = CVaRrisk*100;
CVaRstd = CVaRstd*100;

if strcmp(riskType,'CVAR')
    % compute asset CVaR
    rets=returns;
    [VaR,CVaR]=estimateCVaR(rets,speye(size(rets,2)),0.95);
    anRisk = CVaR;      
end  

anRet = anRet*100;
anRisk = anRisk*100;

anBenchRet = anBenchRet*100;
anBenchRisk = anBenchRisk*100;

fig = figure;
hold('on')
% plot efficient frontier
switch riskType
    case 'CVAR'    
        plot(CVaRrisk,CVaRret,'LineWidth',1.5);
        legend_str = {'Historic','Block bootstrap','Mutivariate normal', 'Multivariate T'};
    case 'both'
        plot(MVrisk,MVret,'LineWidth',1.5);
        plot(CVaRstd,CVaRret,'-o','Color','r','MarkerSize',8);
        legend_str = {'Historic','Block bootstrap','Mutivariate normal', 'Multivariate T', 'Mean-variance'};
          
end
        
grid('on');
title('Efficient frontier for different scenarios');
xlabel('Annual risk (%)');
ylabel('Annual return (%)');
legend(legend_str,'Location','Northwest');

% select portfolio with highest STARR
[STARR, sel]=max((CVaRret/52)./CVARstd);
% case 'MV'
weights = w_MV(:,sel);
%case 'CVAR'
% weights=w_CVAR(:,sel);

% performance of portfolio
% fig = figure; 
% hold('on')
pf_prices = prices*weights;
pf_prices = 100*pf_prices/abs(pf_prices(1));  % standardize

plot(dates,pf_prices,'-','LineWidth',1.5);
axis('tight');
datetick('x','keeplimits');

grid('on');
box('off');
ylabel('Relative Performance [%]');
xlabel('Dates');
