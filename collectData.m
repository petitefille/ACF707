function [AdjClose,assetNames]=collectData(start,stop,duration,frequence,m,indexName,NAN) 


start = datenum(start,'dd/mm/yyyy'); 
stop = datenum(stop,'dd/mm/yyyy'); % 737624

if strcmp(indexName,'DAX') % returns 1 if true 
    [~,assetNames]=xlsread('DAX.xlsx');
    indexLink='^GDAXI';
end

indexData = get_yahoo_stockdata6(indexLink,start,stop,frequence);
n = length(assetNames);

if ~isempty(m) % hvis m er spesifisert
    % m = max; % sett m lik maks
    assetNames = assetNames(1:m);
else
    m = n;
end

K = [];
finalData = [];
dates = [];

datesIndex = datestr(indexData.timeStamp);
datesIndex = datesIndex(:,1:11); 
nrObs = length(indexData.timeStamp);

if NAN == 1
    try
        tmp = get_yahoo_stockdata6(assetNames(1),start,stop,frequence);
        n_tmp = length(tmp.timeStamp);
        dates_tmp = datestr(tmp.timeStamp);
        dates_tmp = dates_tmp(:,1:11);
        dates = intersect(dates_tmp,datesIndex,'rows');
    catch ME 
        warning('Asset does not exist in yahoo database'); % ha med hvilken stokk
        K = [K,1];    
    end
    for i = 2:m
        try
            tmp = get_yahoo_stockdata6(assetNames(i),start,stop,frequence);
            dates_tmp = datestr(tmp.timeStamp);
            dates_tmp = dates_tmp(:,1:11);
            dates = intersect(dates,dates_tmp,'rows');
        catch ME 
            warning('This stock is not in yahoo database');
            K = [K,i];    
        end
    end
    
    % nå inneholder dates alle felles datoer 
    
    [~,order] = sort(datenum(dates));
    sortedDates = dates(order,:);
    dates = datetime(sortedDates,'InputFormat','dd-MM-yyyy');

    datesIndex = datetime(datesIndex,'InputFormat','dd-MM-yyyy');
    AdjClose_data = [];
    for j=1:length(dates);
        com_pos = find(datesIndex == dates(j));
        AdjClose_data = [AdjClose_data; indexData.adjClosePrice(com_pos)];
    end
    
    finalData = [finalData,AdjClose_data];
    
    for i=1:m
        try     
            tmp = get_yahoo_stockdata6(assetNames(i),start,stop,frequence);
            tmp_name = tmp.name;
            dates_tmp = datestr(tmp.timeStamp);
            dates_tmp = dates_tmp(:,1:11);
            dates_tmp = datetime(dates_tmp,'InputFormat','dd-MM-yyyy');
            AdjClose_tmp = [];
            for j=1:length(dates)
                    com_pos_tmp = find(dates_tmp == dates(j));
                    AdjClose_tmp = [AdjClose_tmp; tmp.adjClosePrice(com_pos_tmp)];
            end
            finalData = [finalData,AdjClose_tmp];
        catch ME 
            warning('This stock is not in yahoo database');
            K = [K,i];    
        end        
    end
    
    AdjClose_tt = array2timetable(finalData,'RowTimes',dates);
    
else % NAN = 0 => union
   
end

if ~isempty(K)
    disp('Following assets were not in yahoo database');
    disp(assetNames(K));
end

AdjClose = AdjClose_tt; 

end                                    


    






