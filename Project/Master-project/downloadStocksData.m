function downloadStocksData(Asset,Date1,Date2,interval)
% Author: Aitor Roca
% Version: 1.3
% 28-Jan-2018
% Retrieves historical stock data for the ticker symbols in Asset cell
% array (ticker symbol and yahoo stock exchange symbol), between the dates
% specified by Date1 (beginning) and Date2 (end) in the Matlab datenums
% format. The program returns the stock data in xls at '/Data' folder,
% giving the Date, Open, High, Low, Close, Volume, and Adjusted Close price
% adjusted for dividends and splits.
% 
% Example:
% Asset = {
%     'AAPL','';
%     'ANA','MC';
%     'BKIA','MC';
%     'CDR','MC';
%     'ENG','MC';
%     'GLD','';
%     'IAG','MC';
%     'LYXIB','MC';
%     'MT','AS';
%     'OHL','MC';
%     'ITX','MC';
%     'SAN','MC';
%     'TEF','MC'
%     };
% Asset = table(Asset(:,1), Asset(:,2), 'VariableNames', {'Symbol', 'SE'});
% Date1 = '26-Jan-2017';
% Date2 = '27-Jan-2018';
% interval = '1d';
% 
% downloadStocksData(Asset,Date1,Date2,interval)
mkdir Data;
addpath('./Data');
try
    waitPopUp = waitbar(0,'Connecting to Yahoo!...','Name','Yahoo! Stocks Data :: Aitor Roca',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
    setappdata(waitPopUp,'canceling',0)
    url = 'https://es.finance.yahoo.com/quote/LYXIB.MC/'; 
    r = matlab.net.http.RequestMessage;
    resp = send(r,url);
    setCookieFields = resp.getFields('Set-Cookie');
    if ~isempty(setCookieFields)
       % fetch all CookieInfos from Set-Cookie fields and add to request
       cookieInfos = setCookieFields.convert;
       r = r.addFields(matlab.net.http.field.CookieField([cookieInfos.Cookie]));
    end
    resp = r.send(url);
    webbody = resp.Body.Data;
    segments = strings(0);
    remain = webbody;
    while (remain ~= "")
       [token,remain] = strtok(remain, '<>');
       segments = [segments ; token];
    end
    pattern = {'"CrumbStore":{"crumb":"'};
    k = strfind(segments,pattern);
    kcell = find(~cellfun(@isempty,k));
    kvalue = k(kcell);
    idx = length(pattern{1}) + kvalue{1};
    crumb = segments{kcell,1}(idx:idx+10);
    link = 'https://query1.finance.yahoo.com/v7/finance/download/';
    period1 = sprintf('%i', posixtime(datetime(Date1)));
    period2 = sprintf('%i', posixtime(datetime(Date2)));
    for indice = 1 : height(Asset)
        if getappdata(waitPopUp,'canceling')
            break
        end
        ticker = Asset{indice,1}{1};
        se = Asset{indice,2}{1};
        % Update waitbar to display current ticker
        waitbar((indice-1)/height(Asset), waitPopUp, ...
            sprintf('Retrieving stock data for %s (%0.2f%%)', ...
            Asset{indice,1}{1}, (indice-1)*100/height(Asset)))
        %splits = strcat(link,ticker,se,'?period1=',period1,'&period2=', ...
        %   period2,'&interval=',interval,'&events=split&crumb=',crumb);
        %resp = r.send(splits);
        if (~strcmp(se,''))
            ticker = strcat(ticker,'.',se);     
        end
        history = strcat(link,ticker,'?period1=',period1,'&period2=', ...
            period2,'&interval=',interval,'&events=history&crumb=',crumb);
        resp = r.send(history);
        historyData = resp.Body.Data;
        if (isnumeric(historyData.AdjClose(1,1)) == 0)
            historyData.AdjClose = ...
                cellfun(@str2double,historyData.AdjClose(1:end),'un',0);
            historyData.Open = ...
                cellfun(@str2double,historyData.Open(1:end),'un',0);
            historyData.Close = ...
                cellfun(@str2double,historyData.Close(1:end),'un',0);
            historyData.High = ...
                cellfun(@str2double,historyData.High(1:end),'un',0);
            historyData.Low = ...
                cellfun(@str2double,historyData.Low(1:end),'un',0);
            historyData.Volume = ...
                cellfun(@str2num,historyData.Volume(1:end),'un',0);
        end
        filename = strcat('./Data/',ticker,'.xls');
        writetable(historyData,filename,'Sheet',1,'Range','A1')
        % update waitbar
        waitbar(indice/height(Asset),waitPopUp)
    end
catch
    warning('Error in downloadStocksData. Incorrect input');
end
delete(waitPopUp)    % close waitbar
end