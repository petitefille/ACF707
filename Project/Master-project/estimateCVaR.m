function [VaR,CVaR,CVaR_dev]=estimateCVaR(scen,w,alpha)

nr = size(w,2);
dim = size(scen,1);
k = ceil(alpha*dim);		

CVaR = zeros(nr, 1);

for i = 1:nr					
	z = -scen*w(:,i);
	z = sort(z);
    mu=mean(z);
    for j=1:size(z,2)
        zz(:,j)=z(:,j)-mu(j);
    end
    VaR(i,1)=z(k);
    (k - dim*alpha)*z(k);
	if k < dim					
		CVaR(i) = ((k - S*alpha)*z(k) + sum(z(k+1:S)))/(S*(1 - alpha));
        CVaR_dev(i) = ((k - S*alpha)*zz(k) + sum(zz(k+1:S)))/(S*(1 - alpha));
	else
		CVaR(i) = z(k);
	end
end

