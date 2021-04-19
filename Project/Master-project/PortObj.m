classdef PortObj < handle
    
  
    
    properties (Access = public)
        % Imported data
        prices         = [];    % Prices series
        benchmark      = [];    % Benchmark series
        dates          = [];    % Dates series
        priceslabels   = [];    % Prices series labels
        benchmarklabel = [];    % Benchmark label
        scenarioType   = 'hist';
        scenarios      = [];
        frequence      = 'd';
        N              = [];
        decayfactor    = 1;
        alpha          = 0.95;
        defaultConst   = 1;
        typeRisk       = 'both';
        scenarioMethod ='hist';
        portfolio_MV   =Portfolio(); % https://se.mathworks.com/help/finance/create-portfolio.html
        portfolio_CVAR =PortfolioCVaR(); % https://se.mathworks.com/help/finance/portfoliocvar.html

    end
   
    properties (Access = protected)
        returns        = [];    % Main returns used for calculation
        sreturns       = [];    % Simple returns
        lreturns       = [];    % Log returns
        ewmareturns    = [];    % Exponential weighted moving avarage
        mareturns      = [];    % Moving avarage returns
        ewma_cov       = [];    % Exp. weighted covariance
        lag            = [10];  % Lag for EWMA og MA

        cov            = [];    % Asset covariance matrix
        mean           = [];    % Asset mean array
        an_rsk            = [];    % Asset covariance matrix
        an_rets           = [];    % Asset mean array
        w_C            =[];
        w_MV           =[];
    
        MV_ret         =[];
        MV_rsk         =[];
        CVAR_rsk       =[];
        CVAR_ret       =[];
        CVAR_std       =[];
        returnType     = 'l'; 
        calc_CVaR      =[];
        businessdays    =[252];

    end
    
    methods (Access = public)
        function this = PortObj()
            
        end
        
        function riskType = getRiskType(this),              riskType=this.typeRisk;    end
        function prices = getPrices(this),                 prices = this.prices;                 end
        function benchmark = getBenchmark(this),           benchmark = this.benchmark;                                  end
        function N = getN(this),                           N = this.N;                 end
        function scenarios = getScenarios(this),           scenarios = this.scenarios;                 end

        function dates = getDates(this),                   dates = this.dates;                                          end
        function priceslabels = getPricesLabels(this),     priceslabels = this.priceslabels;       end
        function benchmarklabel = getBenchmarkLabel(this), benchmarklabel = this.benchmarklabel;                        end
        function [Mu,Sigma,an_rets,an_rsk]=getStatistics(this)
            if isempty(this.cov)
                [Mu,Sigma,an_rets,an_rsk]=computeStatistics(this,this.returns);
                this.mean=Mu; this.cov=Sigma;
                this.an_rets=an_rets; this.an_rsk=an_rsk;
            else
                Sigma=this.cov;
                Mu=this.mean;
                an_rsk=this.an_rsk;
                an_rets=this.an_rets;
            end % 
        end
        function [Mu,Sigma,an_Mu,an_Sigma]=getBenchmarkStatistics(this)
            if isempty(this.benchmark)
                Mu = [];
                Sigma = [];
                an_Mu = [];
                an_Sigma = [];
                return
            end
                b_returns=this.computeReturns(this.benchmark,this.returnType);
                [Mu,Sigma] = ewstats(b_returns,this.decayfactor);
                        an_Mu=Mu*this.businessdays;
                        an_Sigma=sqrt(Sigma)*sqrt(this.businessdays);

                
            end
       
        function returns = getReturns(this)
            returns=this.returns;
        end
        
        
        function setAlpha(this,alpha)
            this.alpha=alpha;
        end
        
        function rets=computeReturns(this,data,type)
            
            if isempty(this.dates)
                % create default
                dates = (1:size(this.prices,1))';
            else
                dates = this.dates;
            end
            
            switch this.returnType % https://se.mathworks.com/help/matlab/ref/switch.html
                
                case 'l'
                    rets=tick2ret(data,dates,'Continuous');
                    
                    
                case 's'
                    rets=tick2ret(data,dates,'Simple');
                    
                    
                    
                case 'e'
                    rets=tick2ret(data,dates,'Continuous');
                    retwts =  (this.decayfactor).^(size(rets,1)-1:-1:0)'; % ??
                    rets = rets.*repmat(retwts,1,size(rets,2)); % ?? 
                    
            end
        end
        
        %Compute staticics for the assets
        function [Mu,Sigma,annualized_rets,annualized_rsk]=computeStatistics(this,rets)
            Mu=mean(rets);
            Sigma=cov(rets);
            this.mean=Mu;this.cov=Sigma;
            annualized_rsk= sqrt(diag(Sigma)).*sqrt(this.businessdays);
            annualized_rets = Mu*this.businessdays;
            this.an_rets=annualized_rets;
            this.an_rsk = annualized_rsk;

        end
        
        function scenarios = computeScenarios(this,type)
            returns=this.returns;
            switch type
                case 'hist'
                    scenarios=returns;
                case 'boot'
                    b=opt_block(returns); % ??
                    b=ceil(mean(b(2,:)));
                    scenarios=overlappingBB(returns,b,20000); % ??
%%
                case 'norm'
                    %[Mu,Sigma,~,~]=this.getStatistics;
                     %[Mu,Sigma]=ewstats(returns,1);                   
                    [Mu,Sigma]=ecmnmle(returns); % https://se.mathworks.com/help/finance/ecmnmle.html
					                              % estimates mean and variance of dataset
                    scenarios=mvnrnd(Mu,Sigma,20000); % https://se.mathworks.com/help/stats/mvnrnd.html 
                    
                case 'studT'
                    [mu S nu] = fitt(returns); % ??
                    scenarios=mvtrnd2(nu,S,mu,20000); % ??
                    % scenarios = mvtrnd(S,nu,20000);
            end
            this.scenarios=scenarios;
        end
        
        function importData(this,prices,benchmark,dates,priceslabels,benchmarklabel)
            % Import new data set
            
            % input handling https://se.mathworks.com/help/matlab/ref/nargin.html
            if nargin < 6
                benchmarklabel = [];
            end
            if nargin < 5
                priceslabels = [];
            end
            if nargin < 4
                dates = [];
            end
            if nargin < 3
                benchmark = [];
            end
            if nargin < 2
                prices = [];
            end
            
            
            returns=computeReturns(this,prices,this.returnType); % computes returns (simple, continuous or exponential)
            [N,M]=size(returns);
            I=[];
            for i=1:N % N er antall rader/antall observasjoner
                j=find(returns(i,:)==0);
                if length(j) > 0.5*M
                    I=[I,i];
                end
            end
            returns(I,:)=[];
            prices(I,:)=[];
            benchmark(I)=[];
            dates(I)=[];
            
            % assign new data
            this.returns        = returns;
            this.prices         = prices;
            this.benchmark      = benchmark;
            this.dates          = dates;
            this.priceslabels   = priceslabels;
            this.benchmarklabel = benchmarklabel;
            this.N              = length(priceslabels);
        end
        
        function setReturnType(this,str)
            this.returnType = str;
            this.returns=this.computeReturns(this.prices,str);
        end
        function setFrequence(this,f)
            this.frequence=f;
            switch f
                case 'd'
                    this.businessdays=252;
                case 'w'
                    this.businessdays=50;
                case 'm'
                    this.businessdays=12;
            end
        end
        
        
        function setRiskType(this,str)
            this.typeRisk = str;
        end
        function setScenarioMethod(this,str)
            this.scenarioMethod=str;
        end
        
        function [portfolio_MV,portfolio_CVAR]=setModel(this)

            scen=this.computeScenarios(this.scenarioMethod);
            portfolio_CVAR=this.portfolio_CVAR;
            portfolio_MV=this.portfolio_MV;
            
            [Mu,Sigma,~,~]=this.getStatistics;

            portfolio_MV=Portfolio(portfolio_MV,'AssetMean',Mu,'AssetCovar',Sigma,'AssetList',this.priceslabels);
			% https://se.mathworks.com/help/finance/create-portfolio.html
            portfolio_CVAR=PortfolioCVaR(portfolio_CVAR,'AssetList',this.priceslabels,'Scenarios',scen,'ProbabilityLevel',this.alpha);
			% https://se.mathworks.com/help/finance/portfoliocvar.html
            if this.defaultConst
                portfolio_MV=portfolio_MV.setDefaultConstraints;
                portfolio_CVAR=portfolio_CVAR.setDefaultConstraints;
            end
            
            this.portfolio_CVAR=portfolio_CVAR;
            this.portfolio_MV=portfolio_MV;
        end
            
            
        function time=computeFrontier(this,solver,algo)
            PCVAR=this.portfolio_CVAR;
            PMV=this.portfolio_MV;
            
            switch this.typeRisk
                case 'MV'
                    t=tic;
                    w1=estimateFrontier(PMV); % https://se.mathworks.com/help/finance/portfolio.estimatefrontier.html
                    [this.MV_ret,this.MV_rsk]=estimatePortMoments(PMV,w1);
                    this.w_MV=w1;
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
                                w2=estimateFrontier(PCVAR); % https://se.mathworks.com/help/finance/portfolio.estimatefrontier.html
                                
                                time(i)=toc(t);
                            end
                            this.CVAR_ret=estimatePortReturn(PCVAR,w2);
                            this.CVAR_std=estimatePortStd(PCVAR,w2);
                            this.CVAR_rsk=estimatePortRisk(PCVAR,w2);
                            this.w_C=w2;
                        otherwise
                            for i=1:length(algo)
                                t=tic;
                                opt=optimoptions(solver,'Algorithm',algo{i},'Display','off'); % https://se.mathworks.com/help/optim/ug/optim.problemdef.optimizationproblem.optimoptions.html
                                PCVAR=setSolver(PCVAR,'cuttingplane','MasterSolverOptions',opt); % https://se.mathworks.com/help/finance/portfolio.setsolver.html
                                w2=estimateFrontier(PCVAR);
                                time(i)=toc(t)
                            end
                                this.CVAR_ret=estimatePortReturn(PCVAR,w2); % https://se.mathworks.com/help/finance/portfolio.estimateportreturn.html
                                this.CVAR_std=estimatePortStd(PCVAR,w2); % https://se.mathworks.com/help/finance/portfoliocvar.estimateportstd.html
                                this.CVAR_rsk=estimatePortRisk(PCVAR,w2); % https://se.mathworks.com/help/finance/portfolio.estimateportrisk.html
                                this.w_C=w2;     
                    end
                case 'both'
               %% Here we are :)      
                    w1=estimateFrontier(PMV);
                    [this.MV_rsk,this.MV_ret]=estimatePortMoments(PMV,w1);
                    this.w_MV=w1; %%
                    switch solver
                        case 'fmincon'
                            for i=1:length(algo)
                                t=tic;
                                opt=optimoptions('fmincon','Algorithm',algo{i},'Display','off');
                                PCVAR=setSolver(PCVAR,'fmincon',opt);
                                w2=estimateFrontier(PCVAR);
                                
                                time(i)=toc(t);
                            end
                            this.CVAR_ret=estimatePortReturn(PCVAR,w2);
                            this.CVAR_std=estimatePortStd(PCVAR,w2);
                            this.CVAR_rsk=estimatePortRisk(PCVAR,w2);
                            this.w_C=w2;
                        otherwise
                            for i=1:length(algo)
                                t=tic;
                                opt=optimoptions(solver,'Algorithm',algo{i},'Display','off');
                                PCVAR=setSolver(PCVAR,'cuttingplane','MasterSolverOptions',opt);
                                w2=estimateFrontier(PCVAR);
                                time{i}=toc(t);
                            end
                                this.CVAR_ret=estimatePortReturn(PCVAR,w2);
                                this.CVAR_std=estimatePortStd(PCVAR,w2);
                                this.CVAR_rsk=estimatePortRisk(PCVAR,w2);
                                this.w_C=w2;     
                    end
                    
                    
            end

            
        end   % here I am 
        function [MV_ret,MV_rsk,CVAR_ret,CVAR_rsk,CVAR_std,w_MV,w_c] = getOptimizationResults(this);
            MV_ret=this.MV_ret*this.businessdays; MV_rsk=this.MV_rsk*sqrt(this.businessdays);
            CVAR_ret = this.CVAR_ret*this.businessdays; CVAR_rsk=this.CVAR_rsk;
            CVAR_std=this.CVAR_std*sqrt(this.businessdays); w_MV=this.w_MV; w_c=this.w_C;
        end
        function [VaR,CVaR,CVaR_dev] = computeAssetCVaR(this);
            rets=this.returns;
            [VaR,CVaR]=estimateCVaR(rets,speye(size(rets,2)),0.95);
        end
        
        function [VaR,CVaR] = computeBenchCVaR(this);
            rets=tick2ret(this.benchmark,this.dates,'Continuous');
            [VaR,CVaR]=estimateCVaR(rets,1,0.95);
        end
        function [VaR,CVaR] = computeHistoricalVaR(this,pf_number,confidence_level,axes_handle)
        % Compute and visualize historical Value at Risk
            
            % pf_number:            Portfolio number
            % confidence_level      Confidence level (default 0.95)
            % axes_handle           (optional) Visualize result to this graphics handle
            %
            % VaR                   Value at Risk (monthly)

            % handle inputs
            if (pf_number <= 0) || (pf_number > 11)
                VaR = [];
                return
            end
            if nargin < 3
                confidence_level = 0.95;
            end
            
            % get optimization results and compute per
            switch this.typeRisk
                case 'CVAR'
                    weights = this.w_C(:,pf_number);
                otherwise
                    weights = this.w_MV(:,pf_number);
            end
            
            weights = weights(:);   % use column vectors
            pf_prices = this.prices(:,:)*weights;  % portfolio prices
            % compute monthly portfolio returns
            % Note: we don't weight returns for our VaR analysis
            
            returns = this.computeReturns(pf_prices,this.returnType);
            % do we have enough data points?
            if isempty(returns)
                VaR = []; 
            else
                % use percentage
                returns = returns * 100;
                % Sort returns from smallest to largest
                sorted_returns = sort(returns);
                % Store the number of returns
                num_returns = numel(returns);
                [VaR,CVaR]=estimateCVaR(returns,1,confidence_level);
                VaR=-VaR;
                CVaR=-CVaR;

                
            end
            
            % Plot results if requested
            if exist('axes_handle','var') && ishandle(axes_handle)
                % make this axes current
                axes(axes_handle);
                hold('off');
                if isempty(VaR)
                    % Show message
                    cla('reset');
                    axis('off');
                    text(0.2,0.5,{'Too few observations', '  to calculate VaR'});
                else
                    axis('on');
                    % Histogram data
                    [count,bins] = hist(returns,50);
                    x_min = min(returns);
                    x_max = max(returns);
                    x_lim = max(abs([x_min,x_max]));
                    % Create 2nd data set that is zero above Var point
                    count_cutoff = count.*(bins < VaR);
                    % Scale bins
                    scale = (bins(2)-bins(1))*num_returns;
                    % Plot full data set
                    bar(bins,count/scale,'FaceColor',[0.1,0.5,1]);
                    set(axes_handle,'XLim',[-x_lim,x_lim]);
                    hold('on');
                    % Plot cutoff data set
                    bar(bins,count_cutoff/scale,'FaceColor',[1,0.2,0]);
                    grid('on');
                    hold('off');
                    box('off');
                    set(axes_handle,'YTickLabel',[]);
                    title(['Value at Risk: ',sprintf('%2.2f',VaR),'%'],'FontSize',9);
                    vline(CVaR,'--r','CVaR')
                end
            end
        end

        function [VaR,CVaR] = computeParameticVaR(this,pf_number,confidence_level,axes_handle)
        % Compute and visualize parametric Value at Risk

            % pf_number:            Portfolio number
            % confidence_level      Confidence level (default 0.95)
            % axes_handle           (optional) Visualize result to this graphics handle
            %
            % VaR                   Value at Risk (monthly)

            % handle inputs
            if (pf_number <= 0) || (pf_number > 11)
                VaR = [];
                return
            end
            if nargin < 3
                confidence_level = 0.95;
            end

            % get optimization results and compute per
            switch this.typeRisk
                case 'CVAR'
                    weights = this.w_C(:,pf_number);

                otherwise
                    weights = this.w_MV(:,pf_number);
            end
            
            weights = weights(:);  % use column vectors
            pf_prices = this.prices(:,:)*weights;  % portfolio prices

            % compute monthly portfolio returns
            % Note: we don't weight returns for our VaR analysis
            returns = computeReturns(this,pf_prices,this.returnType);
            % do we have enough data points?
            if isempty(returns)
                VaR = []; 
            else
                % use percentage
                returns = returns * 100;

                % Calculate mean and standard deviation of returns
                [mu,sigma] = normfit(returns);
                % Calculate VaR Estimate using Normal Distribution Fit
                VaR = sigma*norminv(1-confidence_level) + mu;
                i=confidence_level:0.00001:0.9999999;
                CVaR=(sigma/(this.alpha*2*sqrt(pi)))*exp((VaR^2)/2)+mu;
            end
            
            % Plot results if requested
            if exist('axes_handle','var') && ishandle(axes_handle)
                % make this axes current
                axes(axes_handle);
                hold('off');
                if isempty(VaR)
                    % Show message
                    cla('reset');
                    axis('off');
                    text(0.2,0.5,{'Too few observations', '  to calculate VaR'});
                else
                    axis('on');
                    % Construct domain of probabilities to graph distribution.
                    % 100 equally spaced points between min and max return
                    x_lim = max(abs(returns));
                    x_min = -abs(x_lim);
                    x_max = abs(x_lim);
                    x_full = linspace(x_min,x_max,100);
                    x_partial = x_full(x_full < VaR);
                    y_full = normpdf(x_full,mu,sigma);
                    y_partial = normpdf(x_partial,mu,sigma);
                    area(x_full,y_full,'FaceColor',[0.1,0.5,1]);
                    hold('on');
                    if ~isempty(x_partial)
                        area(x_partial,y_partial,'FaceColor',[1,0.2,0]);    
                    end
                    grid('on');

                    % Plot full data set
                    a = histogram(returns,50,'Normalization','pdf');
                    set(axes_handle,'XLim',[-x_lim,x_lim]);
                    a.FaceAlpha=0.2;
                    a.FaceColor='w';
                    box('off');
                    hold('off');
                    set(axes_handle,'YTickLabel',[]);
                    title(['Value at Risk: ',sprintf('%2.2f',VaR),'%'],'FontSize',9);
                    vline(CVaR,'--r','CVaR')

                end
            end
        end        
        
        function metrics = getPerformanceMetrics(this,pf_number,riskfreerate)
        % Get performance metrics

            % pf_number:     Portfolio number
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
                return
            end
            
            % get optimization results
            switch this.typeRisk
                case 'CVAR'
                    pf_rsk=this.CVAR_std*sqrt(this.businessdays);
                    pf_ret=this.CVAR_ret*this.businessdays;
                    weights = this.w_C(:,pf_number);
                otherwise
                    weights = this.w_MV(:,pf_number);
                    pf_rsk=this.MV_rsk*sqrt(this.businessdays);
                    pf_ret=this.MV_ret*this.businessdays;
            end
            
            weights = weights(:);   % use column vectors
            pf_prices = this.prices(:,:)*weights;  % portfolio prices

            % compute portfolio/index return series (weighted if defined)
            pf_returns = this.computeReturns(pf_prices);            
            b_returns  = this.computeReturns(this.benchmark);
            
            % Annualized return and volatility
            metrics.annualizedvolatility = pf_rsk(pf_number);
            metrics.annualizedreturn = pf_ret(pf_number);

              
            % Correlation
            if ~isempty(b_returns)
                metrics.correlation = corrcoef([pf_prices(:),this.benchmark(:)]);
                metrics.correlation = metrics.correlation(1,2);
            else
                metrics.correlation = '-';
            end
            
            % Sharpe ratio
            metrics.sharperatio = sharpe(pf_returns, riskfreerate/this.businessdays);

            % Alpha, risk-adjusted return
            if ~isempty(b_returns)
                [alpha, ra_return]  = portalpha(pf_returns, b_returns, riskfreerate/this.businessdays,'capm');
            else
                alpha = '-';
                ra_return = '-';
            end
            metrics.alpha = alpha;
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
            [~,metrics.CVaR]=this.computeHistoricalVaR(pf_number,0.95);
            metrics.CVaR=-metrics.CVaR/100;
            metrics.STARR=pf_ret(pf_number)/(251*metrics.CVaR);
            
            
            I=find(pf_returns <riskfreerate);
            semi_std=std(pf_returns([I]))*sqrt(251);
            metrics.Sortino=((pf_ret(pf_number))-riskfreerate)/semi_std;
            

        end
    end   
end