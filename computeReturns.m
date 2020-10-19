function rets = computeReturns(prices,dates,returnType)
if isempty(dates)
    dates = (1:size(prices,1));
end
switch returnType
    case 'l'
        rets = tick2ret(prices, dates, 'Continuous');
    case 's'
        rets = tick2ret(prices, dates, 'Simple');
end 
 
rets = rets; 

end