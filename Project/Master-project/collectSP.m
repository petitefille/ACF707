%collecting SP500 stocks
%Duration is how many years of data
%Frequence means daily('d') or weakily ('w') data from yahoo
%Random means collecting m random stocks from SP500, type 'on'. Else all SP
function [Adj_close,stock_names]=collectSP(duration,frequence,max,index_tick,NAN) 

% inkludere start, stop ??

% c=yahoo;
duration = 5;
start=today-365.25*duration;
stop=today;

if strcmp(index_tick,'DAX') % returns 1 if true 
    [~,stock_names]=xlsread('DAX_tick.xlsx');
    index_T='^GDAXI';
    index_N='DAX';
elseif strcmp(index_tick,'S&P500')
    [~,stock_names]=xlsread('s&p500.xlsx');
    index_T='^GSPC';
    index_N='SandP500';
elseif strcmp(index_tick,'S&P100')
    [~,stock_names]=xlsread('S&P100.xlsx');
    index_T='^OEX';
    index_N='SandP100';
    
end

stock = get_yahoo_stockdata6(index_T,start,stop,frequence);
n = length(stock_names);

if ~isempty(max) % hvis m er spesifisert
    m = max; % sett m lik maks
    stock_names = stock_names(1:m);
else
    m = n;
end

I = [];
final = [];
dates = [];

date_stock = datestr(stock.timeStamp); % dates index
date_stock = date_stock(:,1:11); 
n_stock = length(stock.timeStamp);

if NAN == 1 % intersection
    try
        tmp = get_yahoo_stockdata6(stock_names(1),start,stop,frequence);
        n_tmp = length(tmp.timeStamp);
        date_tmp = datestr(tmp.timeStamp);
        date_tmp = date_tmp(:,1:11);
        dates = intersect(date_tmp,date_stock,'rows');
    catch ME 
        warning('Stock is not in yahoo database'); % ha med hvilken stokk
        disp(I);
        % I = [I,i];    
    end
    for i = 2:m
        try
            tmp = get_yahoo_stockdata6(stock_names(i),start,stop,frequence);
            date_tmp = datestr(tmp.timeStamp);
            date_tmp = date_tmp(:,1:11);
            dates = intersect(dates,date_tmp,'rows');
        catch ME 
            warning('This stock is not in yahoo database');
            disp(I);
            % I = [I,i];    
        end
    end
    
    % nå inneholder dates alle felles datoer 
    
    [~,order] = sort(datenum(dates));
    sortedDates = dates(order,:);
    dates = datetime(sortedDates,'InputFormat','dd-MM-yyyy');

    date_stock = datetime(date_stock,'InputFormat','dd-MM-yyyy');
    AdjClose_stock = [];
    for j=1:length(dates);
        pos_stock = find(date_stock == dates(j));
        AdjClose_stock = [AdjClose_stock; stock.adjClosePrice(pos_stock)];
    end
    
    final = [final,AdjClose_stock];
    
    for i=1:m
        try     
            tmp = get_yahoo_stockdata6(stock_names(i),start,stop,frequence);
            tmp_name = tmp.name;
            date_tmp = datestr(tmp.timeStamp);
            date_tmp = date_tmp(:,1:11);
            date_tmp = datetime(date_tmp,'InputFormat','dd-MM-yyyy');
            AdjClose_tmp = [];
            for j=1:length(dates)
                    pos_tmp = find(date_tmp == dates(j));
                    AdjClose_tmp = [AdjClose_tmp; tmp.adjClosePrice(pos_tmp)];
            end
            final = [final,AdjClose_tmp];
        catch ME 
            warning('This stock is not in yahoo database');
            disp(I);
            I = [I,i];    
        end        
    end
    
    AdjClose_tt = array2timetable(final,'RowTimes',dates);
    
else % NAN = 0 => union
    try
        tmp = get_yahoo_stockdata6(stock_names(1),start,stop,frequence);
        n_tmp = length(tmp.timeStamp);
        date_tmp = datestr(tmp.timeStamp);
        date_tmp = date_tmp(:,1:11);
        dates = union(date_tmp,date_stock,'rows');
    catch ME 
        warning('Stock is not in yahoo database'); % ha med hvilken stokk
        % I = [I,i];    
    end

    for i = 2:m
        try
            tmp = get_yahoo_stockdata6(stock_names(i),start,stop,frequence);
            date_tmp = datestr(tmp.timeStamp);
            date_tmp = date_tmp(:,1:11);
            dates = union(dates,date_tmp,'rows');
        catch ME 
            warning('This stock is not in yahoo database');
            % I = [I,i];    
        end
    end

    % nå inneholder dates union av datoer 
    
    [~,order] = sort(datenum(dates));
    sortedDates = dates(order,:);
    dates = datetime(sortedDates,'InputFormat','dd-MM-yyyy'); 
    
    date_stock = datetime(date_stock,'InputFormat','dd-MM-yyyy');

    AdjClose_tt = timetable(date_stock,stock.adjClosePrice);

    for i=1:m
        try     
            tmp = get_yahoo_stockdata6(stock_names(i),start,stop,frequence);
            tmp_name = tmp.name;
            date_tmp = datestr(tmp.timeStamp);
            date_tmp = date_tmp(:,1:11);
            date_tmp = datetime(date_tmp,'InputFormat','dd-MM-yyyy');
            AdjClose_tmp_tt = timetable(date_tmp,tmp.adjClosePrice);
            AdjClose_tt = synchronize(AdjClose_tt,AdjClose_tmp_tt);
        catch ME 
            warning('This stock is not in yahoo database');
            I = [I,i];    
        end        
    end
    
end

if ~isempty(I)
    disp('Following stocks was not in yahoo database');
    disp(stock_names(I));
end

Adj_close = AdjClose_tt; 


% remove cases where NAN appears ?? 

end                                    


    






