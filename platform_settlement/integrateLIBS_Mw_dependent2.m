function hd=integrateLIBS_Mw_dependent2(fun,s,param,im,deagg)

%% Compute term P(M|im)
lambda = zeros(size(deagg));
for i=1:length(deagg)
    lambda(i)=sum(deagg{i}(:,3),'omitnan');
end
M         = unique(deagg{1}(:,1))';
Nm         = numel(M);
Pm         = zeros(numel(deagg),Nm);
for i=1:numel(deagg)
    d = deagg{i};
    for k=1:Nm
        Pm(i,k)=sum(d(d(:,1)==M(k),3));
    end
end
Pm = Pm./sum(Pm,2);
Pm(isnan(Pm))=0;

% Integrate hazard
[m,pga]   = meshgrid(M,im);
[lnD,sig] = fun(param,pga,m);
lnS       = log(s);
Nd        = length(s);
hd        = nan(Nm,Nd);

for j=1:Nm
    lnDj  = lnD(:,j);
    sigj  = sig(:,j);
    Pmj   = Pm (:,j);
    
    for i = 1:Nd
        xhat    = (lnS(i)-lnDj)./sigj;
        ccdf    = 0.5*(1-erf(xhat/sqrt(2)));
        G       = ccdf.*Pmj;
        hd(j,i) = -trapz(lambda,G);
    end
end
hd =sum(hd,1,'omitnan');

