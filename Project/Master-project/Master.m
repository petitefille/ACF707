
% 1. Data import

% set duration (double): must be between 0 og 10
% duration = 5;

% Set start and stop dates
% stop = datestr(today,24); % '19/07/2020'
% start = datestr(today-365.25*duration,24); % '19/07/2015'

% OR chose specific start and stop dates:  
 
start = '01/01/2005';
start = datenum(start,'dd/mm/yyyy'); % 732313
stop = '01/01/2010';stop = '01/01/2010';stop = '01/01/2010';
stop = datenum(stop,'dd/mm/yyyy') % 737624
duration = yearfrac(start,stop,1) % 5

% Choose index: 
% index_tick (string): DAX, S&P100 or S&P500 (from Yahoo Finance)

% m is max nr of stocks with respect to index(in excel sheet)
% 1. DAX: m = 29
% 2. S&P100: m = 98
% 3. S&P500: m = 500

% index_tick = 'DAX';
% max = 2;
% m = 
% index_tick = 'S&P500'
maxi = 98 % nr of stocks to include in portfolio
index_tick = 'S&P100'


% set frequence:
% frequence:  daily, weekly or monthly
% businessdays = 252, 50 or 12 - total nr of businessdays with respect to
% frequence

% 1. daily : frequence = 'd'
% frequence = 'd';
% businessdays = 252; 
% 2. weekly: frequence = 'w'
frequence = 'w';
businessdays = 50
% 3. monthly: frequence = 'm'
% frequence = 'm';
% businessdays = 12;

% Download data: AC og stocknames

% Treatment of missing data:

% 1. Linear interpolation
% NAN = 0;
% [AC,stock_names]=collectSP(duration,frequence,maxi,index_tick,NAN);
% method = 'linear';
% AC = fillmissing(AC,method);

% 2. Cubic interpolation
NAN = 0;
method = 'spline';
[AC,stock_names]=collectSP(duration,frequence,maxi,index_tick,NAN);
AC = fillmissing(AC,method);

% 3. Spline interpolation
% NAN = 0;
% [AC,stock_names]=collectSP(duration,frequence,maxi,index_tick,NAN);
% method = 'pchip';
% AC = fillmissing(AC,method);

% 4. Remove NAN dates for all stocks
% NAN = 1;
% [AC,stock_names]=collectSP(duration,frequence,maxi,index_tick,NAN);
% AC = rmmissing(AC);

% 5. EM algorithm
% NAN = 0
% [AC,stock_names]=collectSP(duration,frequence,max,index_tick,NAN); 


dates=AC.Properties.RowTimes;
S = vartype('numeric');
mat = AC(:,S);
prices = mat.Variables;
benchmark=prices(:,1);
prices(:,1)=[];
returnType = 'l';
returns = computeReturns(prices,dates,returnType);
[N,M]=size(returns);
I=[];
for i=1:N % for hver rad
    j=find(returns(i,:)==0); % returnerer indeksene til elementer lik 0
    if length(j) > 0.5*M % hvis antall 0 elementer i hver rad er større enn halvparten av antall aksjer
        I=[I,i]; % inkluder raden
    end
end
returns(I,:)=[];
prices(I,:)=[];
benchmark(I)=[];
dates(I)=[];




% % Visualize price and returns
series = [benchmark(:), prices]; % prices
benchmarklabel = index_tick;
% serieslabels = []
serieslabels = [benchmarklabel]; % stock list
stock_names_str = string(stock_names);
for i=1:length(stock_names_str)
     serieslabels = [serieslabels; stock_names_str(i)];
end  
priceslabels = [];
for i=1:length(stock_names_str)
    if i~= 88
     priceslabels = [priceslabels; stock_names_str(i)];
    end
end 

N = length(priceslabels);

% Visualize prices and returns: 

% Choose firm/stock
% index 0 is benchmark
fig1=figure;

% I = 1 % DAX 
I = 2; % 2- ADIDAS

% Prices

subplot(2,1,1);
plot(dates(1:end),series(1:end,I),'b','LineWidth',2)    
% get returns
datetick('x','yyyy')
ylabel('Prices');
title('Price series');
box('on')
grid('on')

% Returns
subplot(2,1,2);
plot(dates(1:end-1),tick2ret(prices(:,I),dates(:),'Continuous'),'b')
ylabel('Returns')
xlabel('Dates')
xlim([734436.48 736397.52]);
datetick('x','yyyy')
title('Return series')
box('on')
grid('on')

% remove lines - fjern plot/lagre figure

fig1=figure;

% Prices

subplot(2,1,1);
% plot(dates(1:end),series(1:end,I),'b','LineWidth',2)    
% get returns
datetick('x','yyyy')
ylabel('Prices');
title('Price series');
box('on')
grid('on')



% Returns
subplot(2,1,2);
plot(dates(1:end-1),tick2ret(prices(:,I),dates(:),'Continuous'),'b')
ylabel('Returns')
xlabel('Dates')
% xlim([734436.48 736397.52]);
datetick('x','yyyy')
title('Return series')
box('on')
grid('on')

% Histogram and distribution analysis

% Choose stock fra series (benchmark + stock) = list
% I = 1 % DAX
I = 2 % ADIDAS

% Simple returns 's'
% Log returns 'l'
% Exponential weighted return 'e'

rets = computeReturns(prices,dates,'s');

% Fit distribution
cla; P = []; D = [];

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
    Rnames{i} = D(i).DistName;
end    
testtable=cell2table(num2cell(data), 'VariableNames',  names, 'RowNames',Rnames);
display(testtable);

% 2. Portfolio settings

% lage en tabell som viser dette

% Set return type
% returnType = 's'; % simple return
% rets = computeReturns(prices,dates,returnType);

returnType = 'l'; % logarithmic return
returns = computeReturns(prices,dates,returnType);
% returns(:,88) = [];

% set decay factor: ?? range ?? 
% decayfactor = a number bewteen 0 and 1 (in computeReturns)

% returnType = 'e'; % exponentialweighted moving return
% rets = computeReturns(prices,dates,returnType);

% Choose risk measure
%  Variance
% typeRisk = 'MV'
% Conditional Value at Risk
typeRisk = 'CVAR';
% both
typeRisk = 'both';
alpha = 0.95;

% Choose scenario generation

% compute Scenarios

% scenarioMethod
% switch type

%      case 'hist'
scenarios_H = returns;

%     case 'boot'
b = opt_block(returns);
b = ceil(mean(b(2,:)));
% scenarios = overlappingBB(returns,b); % -0.0093   -0.0015
scenarios_B = overlappingBB_generator(returns,b,20000);

% case 'norm'
[Mu,Sigma] = ecmnmle(returns);
scenarios_N = mvnrnd(Mu,Sigma,20000); % 20 000 x 2


% case 'studT'
[mu S nu] = fitt(returns);
% scenarios_T = mvtrnd(S,nu,20000);
scenarios_T = MVT_RND(mu,S,nu,20000);
scenarios_T = transpose(scenarios_T);
% scenarios_T = mvtrnd(mu,S,nu,20000);
% X = fitdist(returns,'tLocationScaleDistribution');
% S = corr(returns)
% scenarios = mvtrnd(mu,S,nu,20000);
% [pdca,gn,gl] = fitdist(returns,'tLocationScale','By','Column');
% scenarios=mvtrnd2(pd.nu,pd.sigma,pd.mu,20000);


%returns(:,88) = []
portfolio_CVaR = PortfolioCVaR();
portfolio_MV = Portfolio();


% computeStatistics
Mu = mean(returns); % mean variable
mean_ = Mu; % % Asset mean array
Sigma = cov(returns); % cov variable
cov_ = Sigma; % Asset covariance matrix
annualized_rsk = sqrt(diag(Sigma)).*sqrt(businessdays); % an_rts variable
annualized_ret = Mu*businessdays; % an_rsk var
an_ret = annualized_ret; %  % Asset mean array
an_rsk = annualized_rsk; % Asset covariance matrix

portfolio_MV = Portfolio(portfolio_MV,'AssetMean',Mu,'AssetCovar',Sigma,'AssetList',priceslabels);
portfolio_CVaR = PortfolioCVaR(portfolio_CVaR,'AssetList',priceslabels,'Scenarios',scenarios_T,'ProbabilityLevel',alpha);

if defaultConst
    portfolio_MV = portfolio_MV.setDefaultConstraints;
    portfolio_CVaR = portfolio_CVaR.setDefaultConstraints;
end  

% 3. Optimization settings

% Choose optimisation solver
% a) Fmincon (general constraint minimization)
% solv = 'fmincon';
% b) Linprog ( Linear optimization)
solver = 'linprog';
% c) Quadprog (Quadratic programming)
% solv = 'quadprog'; 
% d) Compare all

% Choose optimisation algorithm
% Fmincon
% a) Trust-region-reflective
% algo = {'trust-region-reflective'};
% b) SQP (Sequential quadratic programming)
% algo = {'sqp'};
% c) Interior point
% algo = {'interior-point'}
% d) Compare all
% algo = {'interior-point','trust-region-reflective','sqp',}

% Quadratic programming
% a) 
% algo = {'interior-point-convex'}
% b)
% algo = {'trust-region-reflective'}
% compare all
% algo = {'interior-point-convex','trust-region-reflective'}

% Linear programming
% a)
algo = {'dual-simplex'};
% b) 
% algo = {'interior-point'}
% compare all
% algo = {'dual-simplex','interior-point'}

% computeFrontier based on solv and algo
PCVAR = portfolio_CVaR;
PMV = portfolio_MV;
w_C            =[];
w_MV           =[];
   
MV_ret         =[];
MV_rsk         =[];

CVAR_rsk       =[];
CVAR_ret       =[];
CVAR_std       =[];

calc_CVaR      =[];

time = [];

switch typeRisk
    case 'MV'
        t = tic;
        w1=estimateFrontier(PMV);
        [MV_ret,MV_rsk]=estimatePortMoments(PMV,w1);
        w_MV=w1;
        time=toc(t);
    case 'CVAR'
        switch solver
            case 'fmincon'
                for i=1:length(algo)
                    t=tic;
                    length(algo)
                    algo(i)
                    opt=optimoptions('fmincon','Algorithm',algo{i},'Display','off');
                    PCVAR=setSolver(PCVAR,'fmincon',opt);
                    w2=estimateFrontier(PCVAR);
                    time(i)=toc(t);
                end
                CVAR_ret=estimatePortReturn(PCVAR,w2);
                CVAR_std=estimatePortStd(PCVAR,w2);
                CVAR_rsk=estimatePortRisk(PCVAR,w2);
                w_C=w2;
            otherwise
                for i=1:length(algo)
                    t=tic;
                    opt=optimoptions(solver,'Algorithm',algo{i},'Display','off');
                    PCVAR=setSolver(PCVAR,'cuttingplane','MasterSolverOptions',opt);
                    w2=estimateFrontier(PCVAR);
                    time(i)=toc(t)
                end
                CVAR_ret=estimatePortReturn(PCVAR,w2);
                CVAR_std=estimatePortStd(PCVAR,w2);
                CVAR_rsk=estimatePortRisk(PCVAR,w2);
                w_C=w2;     
        end
    case 'both' 
        w1=estimateFrontier(PMV);
        [MV_rsk,MV_ret]=estimatePortMoments(PMV,w1);
        w_MV=w1;
        switch solver
            case 'fmincon'
                for i=1:length(algo)
                    t=tic;
                    opt=optimoptions('fmincon','Algorithm',algo{i},'Display','off');
                    PCVAR=setSolver(PCVAR,'fmincon',opt);
                    w2=estimateFrontier(PCVAR);
                    time(i)=toc(t);
                end
                CVAR_ret=estimatePortReturn(PCVAR,w2);
                CVAR_std=estimatePortStd(PCVAR,w2);
                CVAR_rsk=estimatePortRisk(PCVAR,w2);
                w_C=w2;
            otherwise
                for i=1:length(algo)
                    t=tic;
                    opt=optimoptions(solver,'Algorithm',algo{i},'Display','off');
                    PCVAR=setSolver(PCVAR,'cuttingplane','MasterSolverOptions',opt);
                    w2=estimateFrontier(PCVAR);
                    time{i}=toc(t);
                end
                CVAR_ret=estimatePortReturn(PCVAR,w2);
                CVAR_std=estimatePortStd(PCVAR,w2);
                CVAR_rsk=estimatePortRisk(PCVAR,w2);
                w_C=w2;     
        end
                    
                    
end 

data = [];

if length(algo) > 1
    name = [];
    for i = 1:length(algo)
        name = [name; {solver}]
    end
    data = [data; name algo' time'];
    testtable = cell2table(data, 'VariableNames',{'Solver','Algorithm','time'});
else
    data=[data;{solver}' algo' time'];
    testtable=cell2table(data, 'VariableNames',{'Solver','Algorithm','time'});
end    

display(testtable);        
        
        
MV_rsk_c = MV_rsk;
MV_ret_c = MV_ret; 
CVAR_ret_c = CVAR_ret;
CVAR_std_c = CVAR_std;
CVAR_rsk_c = CVAR_rsk; 

% Tab 4 - result page

% get statistics and optimizationr results
% Note: use annualized values for visualization

% get statistics:
% annualized_rsk = an_rsk
% annualized_ret = an_ret

% get benchmark statistics
b_returns =  computeReturns(benchmark,dates,returnType);
decayfactor = 1; % set to 1
[Mu,Sigma] = ewstats(b_returns,decayfactor);
an_Mu = Mu*businessdays;
an_Sigma = sqrt(Sigma)*sqrt(businessdays);

annualized_benchmark_ret= an_Mu; 
annualized_benchmark_rsk = an_Sigma;

% get optimization results
MV_ret = MV_ret*businessdays;
MV_rsk = MV_rsk*sqrt(businessdays);
CVAR_ret = CVAR_ret*businessdays;
% CVAR_rsk = CVAR_rsk;
CVAR_std = CVAR_std*sqrt(businessdays);
% w_MV
w_CVAR = w_C;

MV_ret = MV_ret*100;
MV_rsk = MV_rsk*100;
CVAR_ret = CVAR_ret*100;
CVAR_rsk = CVAR_rsk*100;
CVAR_std = CVAR_std*100;

if strcmp(typeRisk,'CVAR')
    % compute asset CVaR
    rets=returns;
    [VaR,CVaR]=estimateCVaR(rets,speye(size(rets,2)),0.95);
    annualized_rsk = CVaR;
    % compute benchmark CVaR
    rets=tick2ret(benchmark,dates,'Continuous');
    [VaR,CVaR]=estimateCVaR(rets,1,0.95);
    annualized_benchmark_rsk = CVaR;
    
end  

annualized_ret = annualized_ret*100;
annualized_rsk = annualized_rsk*100;

annualized_benchmark_ret = annualized_benchmark_ret*100;
annualized_benchmark_rsk = annualized_benchmark_rsk*100;

fig = figure;
hold('on')
% riskType = 'both';
switch typeRisk
    case 'MV'
        % Plot efficient frontier and individual assets
        plot(MV_rsk,MV_ret,'-o','Color','b','MarkerSize',8);
        plot(annualized_rsk,annualized_ret,'*','Color','r','MarkerSize',5);
        legend_str = {'MV Efficient Portfolios','Individual Assets'};
        if ~isempty(annualized_benchmark_rsk)
            plot(annualized_benchmark_rsk,annualized_benchmark_ret,'^','Color','k')
            legend_str = [legend_str,'Benchmark Portfoliio'];
        end
    case 'CVAR'    
        % plot(CVAR_rsk,CVAR_ret,'-o','Color','b','MarkerSize',8);
        plot(CVAR_rsk,CVAR_ret,'LineWidth',2);
        % plot(Pstd_H,Pret_H,'LineWidth',2)
        % [StarrMax, Max_I]=max((CVAR_ret/52)./CVAR_rsk);
        %
        %plot(annualized_rsk,annualized_ret,'*','Color','r','MarkerSize',5);
        legend_str = {'Historic'};
        legend_str = [legend_str, 'Block bootstrap'];
        legend_str = [legend_str, 'Multivariate normal'];
        legend_str = [legend_str,'Multivariate t'];
        
        %legend_str = {'CVaR Efficient Portfolios','Individual Assets'};
        if ~isempty(annualized_benchmark_rsk)
            %plot(annualized_benchmark_rsk,annualized_benchmark_ret,'^','Color','k')
            %legend_str = [legend_str,'Benchmark Portfolio'];
        end
    case 'both'
        % plot(MV_rsk,MV_ret,'-o','Color','b','MarkerSize',8);
        % plot(MV_rsk,MV_ret,'-','MarkerSize',8);
        plot(MV_rsk,MV_ret,'LineWidth',2);
        % plot(CVAR_std,CVAR_ret,'-','MarkerSize',8);
        plot(CVAR_std,CVAR_ret,'LineWidth',2);
        legend_str = [legend_str,'Mean-variance'];
        
        plot(annualized_rsk,annualized_ret,'*','Color','r','MarkerSize',5); 
        % legend_str = {'MV Efficient Portfolios','CVAR Efficient Portfolios','Individual Assets'};
        legend_str = {'Mean-variance'}
        if ~isempty(annualized_benchmark_rsk)
            plot(annualized_benchmark_rsk,annualized_benchmark_ret,'^','Color','k')
            % legend_str = [legend_str,'Benchmark Portfolio'];
            legend_str = [legend_str,'Multivariate T'];
        end    
end
        
grid('on');
% title('Select Portfolio');
title('Efficient frontier for different scenarios');
xlabel('Risk [%]');
ylabel('Return [%]');
% legend(legend_str,'Location','SouthEast');
legend(legend_str,'Location','NorthWest');

% select portfolio based on graph
sel = 3;
% case 'MV'
weights = w_MV(:,sel);
%case 'CVAR'
% weights=w_CVAR(:,sel);
% get price labels ENDRING
% labels = priceslabels;
% weights = weights(:);
% labels = labels(:);



% collect all components with weight < 1% as "others"
ind = abs(weights) > 0.01; % true if |weight| is > 0.01

% her vil ind weight components som er < 0.01 adderes som
% en weight component 
alloc = [weights(ind); sum(weights(~ind))]; 
alloc_labels = [labels(ind); {'Others'}];

% remove others if 0
if abs(alloc(end)) < 1e-3
    alloc(end) = [];
    alloc_labels(end) = [];
end

alloc_labels_weights = [];
for j = 1:length(alloc_labels)
    alloc_labels_weights{j} = [alloc_labels{j},char(10),num2str(round(alloc(j)*10000)/100),'%'];
end

% Pie chart of selected portfolio
fig = figure;  
h = pie(abs(alloc),alloc_labels_weights);
for j = 1:length(h)
    if strcmp(get(h(j),'Type'),'text')
        set(h(j),'FontSize',7);
    end
    if strcmp(get(h(j),'Type'),'patch')
        set(h(j),'FaceAlpha',0.7);
        set(h(j),'EdgeAlpha',0.2);
    end
end

% Show weights details in table
% nå blir alloc og ind sortert i descending order
% fra størst til minst
[alloc,ind] = sort(alloc,'descend');  % sort alloc and labels in descending order
alloc_labels = alloc_labels(ind);
data = {};
for j = 1:length(alloc)
    data = [data;[alloc_labels{j},'  (',sprintf('%2.2f',alloc(j)*100),'%)']];
end

testtable=cell2table(num2cell(data),'VariableNames', {'AssetAllocation'});
display(testtable);

% visualize portfolio performance, compare to benchmark
% fig = figure; 
% hold('on')
pf_prices = prices*weights;
pf_prices = 100*pf_prices/abs(pf_prices(1));  % normalize
if pf_prices(1) < 0
    pf_prices = pf_prices + 200;   % shift up if first val = -100
end
 
legend_str = {'Selected portfolio'};
if ~isempty(dates)
    % plot(dates,pf_prices);
    plot(dates,pf_prices,'--','LineWidth',1.5);
    % plot(dates,pf_prices,'LineWidth',1.5);
    axis('tight');
    datetick('x','keeplimits');
else
    plot(pf_prices);
end
grid('on');
box('off');
ylabel('Relative Performance [%]');
xlabel('Dates');
hold('on');
if ~isempty(benchmark)
    legend_str = [legend_str, benchmarklabel]; 
    benchmark = 100*benchmark/benchmark(1);   % normalize
    if ~isempty(dates)
        plot(dates,benchmark,'r');
        axis('tight');
        datetick('x','keeplimits');
    else
        plot(benchmark,'r');
    end
end
legend(legend_str,'Location','NorthWest');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h = legend(legend_str,'Location','NorthWest');
% set(h,'UIContextMenu',[]);
% set(h,'HitTest','off');
% set(h,'Box','off')
% el = get(h,'Children');
% for j = 1:length(el)  %change text backgrounds to white
%     if strcmp(get(el(j),'Type'),'text')
%         set(el(j),'BackgroundColor',[1,1,1]);
%     end
% end
           
% get statistics and extract corresponding asset
% S=handles.model.getScenarios; 
% disse heter scenarios


% [~,~,annualized_ret,annualized_rsk]=handles.model.getStatistics;
% computeStatistics
% Mu = mean(returns); % mean variable
% Sigma = cov(returns); % cov variable

% annualized_rsk = sqrt(diag(Sigma)).*sqrt(businessdays); % an_rts variable
% annualized_ret = Mu*businessdays; % an_rsk var

% if strcmp(handles.model.getRiskType,'CVAR')
%            [~,annualized_rsk]=handles.model.computeAssetCVaR;
% end
% handles.model.getRiskType 
% use percentages
% annualized_ret           = annualized_ret*100;
% annualized_rsk           = annualized_rsk*100;

% labels = pricelabels; 
% if ischar(selection)
    % ind = find(strcmp(labels,selection));
% else
    % ind = selection;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set confidence level
confidence_level = 0.95;

% Option 1: compute historical VaR

% computeHistoricalVaR(selection,confidence_level/100,handles.axes_results_valueatrisk);
% function [VaR,CVaR] = computeHistoricalVaR(this,pf_number,confidence_level,axes_handle)
% pf_number:            Portfolio number
% confidence_level      Confidence level (default 0.95)
% axes_handle           (optional) Visualize result to this graphics handle
%
% VaR                   Value at Risk (monthly)
% handle inputs
pf_number = sel; 
if (pf_number <= 0) || (pf_number > 11)
    VaR = [];
end
% get optimization results and compute per
switch typeRisk
    case 'CVAR'
        weights = w_C(:,pf_number);
    otherwise
        weights = w_MV(:,pf_number);
end
            
weights = weights(:);   % use column vectors
pf_prices = prices(:,:)*weights;  % portfolio prices
% compute monthly portfolio returns
% Note: we don't weight returns for our VaR analysis
            
rets = computeReturns(pf_prices,dates,returnType); % OBS dates + return type
% do we have enough data points?
if isempty(rets)
    VaR = []; 
else
    % use percentage
    rets = rets * 100;
    % Sort returns from smallest to largest
    sorted_rets = sort(rets);
    % Store the number of returns
    num_rets = numel(rets);
    [VaR,CVaR]=estimateCVaR(rets,1,confidence_level);
    VaR=-VaR;
    CVaR=-CVaR;
end        
% Plot results
if ~isempty(VaR)
% Histogram data
    [count,bins] = hist(rets,50);
    x_min = min(rets);
    clear max;
    x_max = max(rets);
    x_lim = max(abs([x_min,x_max]));
    % Create 2nd data set that is zero above Var point
    count_cutoff = count.*(bins < VaR);
    % Scale bins
    scale = (bins(2)-bins(1))*num_rets;
    % Plot full data set
    fig = figure;
    bar(bins,count/scale,'FaceColor',[0.1,0.5,1]);
    xlim([-x_lim,x_lim]);
    hold('on');
    % Plot cutoff data set
    bar(bins,count_cutoff/scale,'FaceColor',[1,0.2,0]);
    grid('on');
    hold('off');
    box('off');
    title(['Value at Risk: ',sprintf('%2.2f',VaR),'%'],'FontSize',9);
    vline(CVaR,'--r','CVaR')
end

% Option 2: compute parametric VaR
% Compute and visualize parametric Value at Risk
% pf_number:            Portfolio number
% confidence_level      Confidence level (default 0.95)
% axes_handle           (optional) Visualize result to this graphics handle

% VaR                   Value at Risk (monthly)
% handle inputs
pf_number = sel;
if (pf_number <= 0) || (pf_number > 11)
    VaR = [];
end
% set confidence level
confidence_level = 0.95;
% get optimization results and compute per
switch typeRisk
    case 'CVAR'
        weights = w_C(:,pf_number);
    otherwise
        weights = w_MV(:,pf_number);
end
weights = weights(:);  % use column vectors
pf_prices = prices(:,:)*weights;  % portfolio prices
% compute monthly portfolio returns
% Note: we don't weight returns for our VaR analysis
rets = computeReturns(pf_pri,dates,returnType);
% do we have enough data points?
if isempty(returns)
    VaR = []; 
else
    % use percentage
    rets = rets * 100;
    % Calculate mean and standard deviation of returns
    [mu,sigma] = normfit(returns);
    % Calculate VaR Estimate using Normal Distribution Fit
    VaR = sigma*norminv(1-confidence_level) + mu; % ??
    i=confidence_level:0.00001:0.9999999;
    CVaR=(sigma/(alpha*2*sqrt(pi))).*exp((VaR.^2)/2)+mu;
end
fig = figure;
if ~isempty(VaR)
    axis('on');
    % Construct domain of probabilities to graph distribution.
    %  100 equally spaced points between min and max return
    x_lim = max(abs(rets));
    x_min = -abs(x_lim);
    x_max = abs(x_lim);
    x_full = linspace(x_min,x_max,100);
    x_partial = x_full(x_full < VaR); % ??
    y_full = normpdf(x_full,mu,sigma);
    y_partial = normpdf(x_partial,mu,sigma);
    area(x_full,y_full,'FaceColor',[0.1,0.5,1]);
    hold('on');
    if ~isempty(x_partial)
        area(x_partial,y_partial,'FaceColor',[1,0.2,0]); 
    end
    grid('on');
    % Plot full data set
    a = histogram(rets,50,'Normalization','pdf');
    xlim([-x_lim,x_lim]);
    a.FaceAlpha=0.2;
    a.FaceColor='w';
    box('off');
    hold('off');
    title(['Value at Risk: ',sprintf('%2.2f',VaR),'%'],'FontSize',9);
    vline(CVaR,'--r','CVaR')
end
       

% Key metrics

% set risk-free rate
riskfreerate = 2/100;
% Get performance metrics
% pf_number:     Portfolio number
pf_number = sel;
% riskfreerate:  Risk-free rate
%
% metrics:       Structure containing following fields:
%                  annualizedvolatility
%                  annualizedreturn
%                  correlation
%                  sharperatio
%                  alpha
%                  riskadjusted_return
%                  inforatio
%                  trackingerror
%                  maxdrawdown
%                  CVaR

% check input
if (pf_number <= 0) || (pf_number > 11) || isempty(riskfreerate)
    metrics = [];
end
            
% get optimization results
switch typeRisk
    case 'CVAR'
        pf_rsk=CVAR_std_c*sqrt(businessdays);
        pf_ret=CVAR_ret_c*businessdays;
        weights = this.w_C(:,pf_number);
    otherwise
        weights = w_MV(:,pf_number);
        pf_rsk=MV_rsk_c*sqrt(businessdays);
        pf_ret=MV_ret_c*businessdays;
end
            
weights = weights(:);   % use column vectors
pf_prices = prices(:,:)*weights;  % portfolio prices
% compute portfolio/index return series (weighted if defined)
pf_returns = computeReturns(pf_prices,dates,returnType);   
b_returns = computeReturns(benchmark,dates,returnType);

% Annualized return and volatility
metrics.annualizedvolatility = pf_rsk(pf_number);
metrics.annualizedreturn = pf_ret(pf_number);

% Correlation
if ~isempty(b_returns)
    metrics.correlation = corrcoef([pf_prices(:),benchmark(:)]);
    metrics.correlation = metrics.correlation(1,2);
else
    metrics.correlation = '-';
end

% Sharpe ratio
metrics.sharperatio = sharpe(pf_returns, riskfreerate/businessdays);

% Alpha, risk-adjusted return
if ~isempty(b_returns)
    [alpha_, ra_return]  = portalpha(pf_returns, b_returns, riskfreerate/businessdays,'capm');
else
    alpha_ = '-';
    ra_return = '-';
end
metrics.alpha = alpha_;
metrics.riskadjusted_return = ra_return;

% Info ratio, tracking error
if ~isempty(b_returns)
    [ir,te] = inforatio(pf_returns, b_returns);
else
    ir = '-';
    te = '-';
end
metrics.inforatio = ir;
metrics.trackingerror = te;

% Max drawdown
metrics.maxdrawdown = maxdrawdown(pf_returns,'arithmetic');
% [~,metrics.CVaR]=this.computeHistoricalVaR(pf_number,0.95);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% computeHistoricalVaR(selection,confidence_level/100,handles.axes_results_valueatrisk);
% function [VaR,CVaR] = computeHistoricalVaR(this,pf_number,confidence_level,axes_handle)
% pf_number:            Portfolio number
% confidence_level      Confidence level (default 0.95)
% axes_handle           (optional) Visualize result to this graphics handle
%
% VaR                   Value at Risk (monthly)
% handle inputs
if (pf_number <= 0) || (pf_number > 11)
    VaR = [];
end
% get optimization results and compute per
% switch typeRisk
    % case 'CVAR'
        w = w_C(:,pf_number);
   %  otherwise
        % w = w_MV(:,pf_number);
% end
            
% w = w(:);   % use column vectors
% pf_pri = prices(:,:)*w;  % portfolio prices
% compute monthly portfolio returns
% Note: we don't weight returns for our VaR analysis
            
rets = computeReturns(pf_prices,dates,returnType); % OBS dates + return type
% do we have enough data points?
if isempty(rets)
    VaR = []; 
else
    % use percentage
    rets = rets * 100;
    % Sort returns from smallest to largest
    sorted_rets = sort(rets);
    % Store the number of returns
    num_rets = numel(rets);
    [VaR,CVaR]=estimateCVaR(rets,1,confidence_level);
    VaR=-VaR;
    CVaR=-CVaR;
end        
metrics.CVaR = CVaR;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
metrics.CVaR=-metrics.CVaR/100;
metrics.STARR=pf_ret(pf_number)/(251*metrics.CVaR);
            
I=find(pf_returns <riskfreerate);
semi_std=std(pf_returns([I]))*sqrt(251);
metrics.Sortino=((pf_ret(pf_number))-riskfreerate)/semi_std;
            
data = {'Annualized Volatility',[sprintf('%2.2f',100*metrics.annualizedvolatility),'%']; ...
                'Annualized Return',[sprintf('%2.2f',100*metrics.annualizedreturn),'%']; ...
                'CVaR',[sprintf('%2.2f',100*metrics.CVaR),'%']; ...
                'Correlation',sprintf('%2.2f',metrics.correlation); ...
                'Sharpe Ratio',sprintf('%2.2f',metrics.sharperatio); ...
                'STARR',[sprintf('%2.2f',metrics.STARR)]; ...
                'Sortino Ratio',[sprintf('%2.2f',metrics.Sortino)]; ...
                'Alpha',[sprintf('%2.2f',100*metrics.alpha),'%']; ...
                'Risk-adjusted Return',[sprintf('%2.2f',100*metrics.riskadjusted_return),'%']; ...
                'Information Ratio',[sprintf('%2.2f',100*metrics.inforatio),'%']; ...
                'Tracking Error',[sprintf('%2.2f',100*metrics.trackingerror),'%']; ...
                'Max. Drawdown',[sprintf('%2.2f',100*metrics.maxdrawdown),'%']}; 
              
   
testtable=cell2table(num2cell(data));
display(testtable);          
            
            
            
            
            
            



