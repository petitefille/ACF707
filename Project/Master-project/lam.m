function lam=lam(kk)
%Helper function, calculates the flattop kernel weights
lam = (abs(kk)>=0).*(abs(kk)<0.5)+2*(1-abs(kk)).*(abs(kk)>=0.5).*(abs(kk)<=1);
end