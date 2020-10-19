function stock = get_yahoo_stockdata6(ticker,d1,d2,freq)
% function stock = get_yahoo_stockdata6(ticker,d1,d2,freq)
%
% Updated from v4 when in May 2017, yahoo went and changed how stock data
% was shown on web pages. 
%
% INPUTS:
%
% ticker  <-- Yahoo ticker symbol for desired security. This can be a char
%             string for a single stock, or data can be retrieved for
%             multiple stocks by using a cellstr array.
%
% d1      <-- start date for data. Can be a matlab datenumber, date string,
%             or datetime. Default = 100 days ago
%
% d2      <-- end date for data. Can be a matlab datenumber, date string,
%             or datetime. Default = today
%
% freq    <-- data frequency 'd' (daily), 'w' (weekly), or 'm' (monthly).
%             Default = 'd'
%
% OUTPUT:
%
% stock  <-- matlab data structure with output data.
%
% Examples:
%
%  Get data for the past 100 days.
%  stock = get_yahoo_stockdata('goog');
%  stock = get_yahoo_stockdata({'goog', 'aapl', 'fb'});
%
%  Get data from 01-Mar-2008 to now.
%  stock = get_yahoo_stockdata('goog','01-Mar-2008');
%
%  Get data for the past 5 years.
%  stock = get_yahoo_stockdata('goog', now-5*365, datetime(clock));
%
%  Get data for specific date range, but weekly instead of daily
%  stock = get_yahoo_stockdata({'goog', 'aapl', 'fb'},'01-Jan-2009','01-Apr-2010','w');
%
% Captain Awesome, March 2020

%% Check inputs -----------------------------------------------------------

dtFormat = 'yyyy-MM-dd';

if nargin<4
  freq = 'd';
end
if nargin<3
  d2 = datetime(clock);
end
if nargin<2
  d1 = d2 - days(100);
end

if ~isdatetime(d1)
  d1 = datetime(floor(datenum(d1)), 'ConvertFrom', 'datenum');
end

if ~isdatetime(d2)
  d2 = datetime(floor(datenum(d2)), 'ConvertFrom', 'datenum');
end

% Shift dates to market closing time.
d1 = dateshift(d1, 'start', 'day');
d2 = dateshift(d2, 'start', 'day');

d1.Format = dtFormat;
d2.Format = dtFormat;

ticker = string(upper(ticker));

if d1>d2
  error('bad date order');
end

if isempty(ticker)
  error('No ticker given.');
end

freq = lower(char(freq));

if ismember(freq,{'daily','day','d'})
  freq = 'd';
elseif ismember(freq,{'weekly','week','w','wk'})
  freq = 'wk';
elseif ismember(freq,{'monthly','month','mmowk','mo','m'})
  freq = 'mo';  
else
  error(['data frequency not recognized: ',freq]);
end

%% Deal with multiple ticker inputs ---------------------------------------

if length(ticker)>1
  stock = arrayfun(@(x) get_yahoo_stockdata6(x,d1,d2,freq),...
    ticker, 'uniformoutput', true);
  return
end

%% Initialize stock data structure output ---------------------------------

ticker = char(ticker);

clear stock
stock.ticker         = ticker;
stock.name           = '';
stock.exchange       = '';
stock.timeZone       = '';
stock.currency       = '';
stock.marketCap      = NaN;
stock.dataSource     = 'Yahoo Finance';
stock.updateTime     = datetime(clock);
stock.errorMsg       = '';
stock.dataFreq       = freq;
stock.dateRange      = 'N/A';
stock.priceRange     = 'N/A';
stock.lastPrice      = 'N/A';
stock.avg10DayVolume = NaN;
stock.dividends      = [];
stock.splits         = [];

stock.varnotes={...
% Variable          Units   Description                     Format 
  'timeStamp',     '[EST]', 'Date of stock quote',          'yyyy-MM-dd';...
  'openPrice',     '[$]',   'Opening price of stock',          '%.2f';...
  'highPrice',     '[$]',   'High price of stock',             '%.2f';...
  'lowPrice',      '[$]',   'Low price of stock',              '%.2f';...
  'closePrice',    '[$]',   'Closing price of stock',          '%.2f';...
  'adjClosePrice', '[$]',   'Adjusted close price of stock',   '%.2f';...
  'volume',        '[-]',   'Trading volume',                  '%.0f'};

stock.timeStamp     = [];
stock.openPrice     = [];
stock.highPrice     = [];
stock.lowPrice      = [];
stock.closePrice    = [];
stock.volume        = [];
stock.adjClosePrice = [];

 
%% Retrieve data from yahoo finance ---------------------------------------

% Yahoo finance uses a unix serial date number, so will have to convert to
% that.  That's a UNIX timestamp -- the number of seconds since January 1, 1970.
unix_epoch = datenum(1970,1,1,0,0,0);
d1u = floor(num2str((datenum(d1) - unix_epoch)*86400));
d2u = floor(num2str((datenum(d2) - unix_epoch)*86400));

site = strcat('https://finance.yahoo.com/quote/',ticker,'/history?',...
  'period1=',d1u,'&period2=',d2u,'&interval=1',freq,'&filter=history&',...
  'frequency=1',freq);

try
  txt = webread(site);
catch
  warning(['stock data download failed: ',ticker]);
  stock.errorMsg=['Could not read data from website (',datestr(now,0),'): ',ticker];
  return
end

%% Extract Some Meta-Data -------------------------------------------------
% There is lots more in the section that could be extracted but just taking
% a few key things.

if contains(txt, '"QuoteSummaryStore"')
  Q = strsplit(txt, '"QuoteSummaryStore"');
  Q = strsplit(Q{2}, '"FinanceConfigStore"');
  Q = Q{1};
  Q = erase(Q,':{"quoteType":{');

  Q = textscan(Q,'%s', 'delimiter',',');
  Q = Q{1};
  
  id = find(contains(Q,'longName'), 1, 'first');
  if ~isempty(id)
    stock.name = erase(Q{id},{'"longName":"','"'});
  end
  
  id = find(contains(Q,'exchange'), 1, 'first');
  if ~isempty(id)
    stock.exchange = erase(Q{id},{'"exchange":"','"'});
  end
  
  id = find(contains(Q,'exchangeTimezoneShortName'), 1, 'first');
  if ~isempty(id)
    stock.timeZone = erase(Q{id},{'"exchangeTimezoneShortName":"','"'});
  end  
  
  id = find(contains(Q,'"currency":"'), 1, 'first');
  if ~isempty(id)
    stock.currency = erase(Q{id},{'"currency":"','"'});
  end  
  
  id = find(contains(Q,'marketCap'), 1, 'first');
  if ~isempty(id)
    stock.marketCap = erase(Q{id},{'"marketCap":{"raw":','"'});
    stock.marketCap = str2num(stock.marketCap);
  end
  
  clear id Q
  
end

%% Check that this is the right ticker data -------------------------------
C = strsplit(txt,'Ta(start) ')';

for k = 1:length(C)
  
  s = C{k};
  
  if contains(s, 'ticker=' , 'IgnoreCase', true)
    t = strsplit(s,'ticker=');
    t = t{2};
    t = textscan(t,'%s');
    t = t{1}{1};
    if ~strcmp(t, ticker)
      error('ticker mismatch');
    end
    break
  end
  clear s
  
end

clear k C

%% Get data from 'Historical Prices' section ------------------------------

C = strsplit(txt,'"HistoricalPriceStore":{"prices":[');

if length(C)==1
  % In this case all the data was displayed to the screen and there was no
  % extra data in "HistoricalPriceStore"
  
  priceData = [];
  divData = [];
  splitData = [];
  
else
  % In this case only some data was initially displayed and the rest was
  % put in this "HistoricalPriceStore" section and a script would display
  % it as the user scrolled down.
  
  C = strsplit(C{2},'},');
  
  n         = length(C);
  priceData = NaN(n,7);  % stock data
  divData   = NaN(n,3);  % dividend data
  splitData = NaN(n,3);  % split events
  
  for k = 1:n
    
    s = C{k};
    
    if length(s)<13
      continue
    end  
    
    if strcmp(s(1:13),'"eventsData":')
      break    
    end
    
    if contains(s, '"splitRatio"', 'IgnoreCase', true)

      x = textscan(s,['{"date":%f "numerator":%f "denominator":%f%*s'],...
        'delimiter',',','TreatAsEmpty','null');
    
      if sum(cellfun('isempty',x))
        error('badness');
      end
      
      splitData(k,:) = cell2mat(x);
      clear x   
    
    
    elseif strcmp(s(1:8),'{"date":')
      x = textscan(s,['{"date":%f "open":%f "high":%f "low":%f "close":%f "volume":%f "adjclose":%f}'],...
        'delimiter',',','TreatAsEmpty','null');
      
      if sum(cellfun('isempty',x))
        error('badness');
      end
      
      priceData(k,:) = cell2mat(x);
      clear x
    
    elseif strcmp(s(1:10),'{"amount":')
      x = textscan(s,['{"amount":%f,"date":%f,"type":"DIVIDEND","data":%f'],...
        'delimiter','','TreatAsEmpty','null');
      
      if sum(cellfun('isempty',x))
        error('badness');
      end
      
      divData(k,:) = cell2mat(x);
      clear x
      
    end
    
    clear s
    
  end
  clear n k
  
  % data columns: date, open, high, low, close, volume, adjclose
  priceData(isnan(priceData(:,1)),:) = [];
  %priceData(:,1) = datenum(datetime(priceData(:,1),'ConvertFrom','posixtime'));
  priceData = sortrows(priceData,1);
  
  % ddate columns: Amount, date, data
  divData(isnan(divData(:,1)),:) = [];
  %divData(:,2) = datenum(datetime(divData(:,2),'ConvertFrom','posixtime'));
  divData = sortrows(divData,2);
  
  %sdata columns: Date numerator demonitor
  splitData(isnan(splitData(:,1)),:) = [];
  %splitData(:,1) = datenum(datetime(splitData(:,1),'ConvertFrom','posixtime'));
  splitData = sortrows(splitData,2);
  
end

%% Assign data to output structure ----------------------------------------

if isempty(divData)
  stock.dividends = [];
else
  stock.dividends.timeStamp = datetime(divData(:,2),'ConvertFrom','posixtime');
  stock.dividends.timeStamp.Format = dtFormat;
  stock.dividends.amount = divData(:,1);
end

if isempty(splitData)
  stock.splits = [];
else
  stock.splits.timeStamp = datetime(splitData(:,1),'ConvertFrom','posixtime');
  stock.splits.timeStamp.Format = dtFormat;
  stock.splits.numerator = splitData(:,2);
  stock.splits.denominator = splitData(:,3);
end

if isempty(priceData)
  stock.errorMsg=['No data found in stock data download (',datestr(now,0),'): ',ticker];
  warning(['No data found in stock data download: ',ticker]);
  return
end

% stock.varnotes={...
% % Variable          Units   Description                     Format 
%   'timeStamp',     '[EST]', 'Date of stock quote',          'yyyy-MM-dd';...
%   'openPrice',     '[$]',   'Opening price of stock',          '%.2f';...
%   'highPrice',     '[$]',   'High price of stock',             '%.2f';...
%   'lowPrice',      '[$]',   'Low price of stock',              '%.2f';...
%   'closePrice',    '[$]',   'Closing price of stock',          '%.2f';...
%   'adjClosePrice', '[$]',   'Adjusted close price of stock',   '%.2f';...
%   'volume',        '[-]',   'Trading volume',                  '%.0f'};

stock.timeStamp      = datetime(priceData(:,1),'ConvertFrom','posixtime');
stock.timeStamp.Format = dtFormat;
stock.openPrice     = priceData(:,2);
stock.highPrice     = priceData(:,3);
stock.lowPrice      = priceData(:,4);
stock.closePrice    = priceData(:,5);
stock.volume        = priceData(:,6);
stock.adjClosePrice = priceData(:,7);

if ~isempty(stock.openPrice)
  stock.dateRange = [char(stock.timeStamp(1)), ' to ', char(stock.timeStamp(end))];
  stock.priceRange = sprintf('$%.2f to $%.2f',min(stock.lowPrice), max(stock.highPrice));
  stock.lastPrice = sprintf('$%.2f', stock.closePrice(end));
  if length(stock.openPrice) < 10
    stock.avg10DayVolume = mean(stock.volume);
  else
    stock.avg10DayVolume = mean(stock.volume(end-9:end));
  end
end


end % function get_yahoo_stockdata3