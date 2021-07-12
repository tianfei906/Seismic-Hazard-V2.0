function [lambdaS] = BrayMacedo2017Ds(param,S,CAV,PGA,SA1,M,Pm,MRD,method)

%%  integration
Nim        = length(CAV);
[II,JJ,KK] = meshgrid(1:Nim,1:Nim,1:Nim);
im3 = [CAV(II(:)),PGA(JJ(:)),SA1(KK(:))];
Nm  = length(M);
[lnD,sig]  = deal(zeros(Nim^3,Nm));

% Shear Component
for i=1:Nm
    [lnD(:,i),sig(:,i)] = BMDs(param,im3,M(i),method);
end

% 3-way hazard
Nd      = length(S);
lnS     = log(S);
lambdaS = nan(Nm,Nd);
[X1,X2,X3] = meshgrid(CAV,PGA,SA1);

x1  = log(CAV);
x2  = log(PGA);
x3  = log(SA1);
J   = X1.*X2.*X3.*MRD;

for j=1:Nm
    lnDj  = reshape(lnD(:,j),Nim,Nim,Nim);
    sigj  = reshape(sig(:,j),Nim,Nim,Nim);
    Pmj   = Pm(:,:,:,j);
    
    for i = 1:Nd
        xhat    = (lnS(i)-lnDj)./sigj;
        ccdf    = 0.5*(1-erf(xhat/sqrt(2)));
        G       = ccdf.*J.*Pmj;
        lambdaS(j,i) = trapz(x1,trapz(x2,trapz(x3,G,3),1));
    end
end

lambdaS=sum(lambdaS,1,'omitnan');


function [lnDs,sigDs] = BMDs(param,im3,M,method)
Q       = param.Q;
B       = param.B;

CAVdp   = im3(:,1)/980.66;  % cm/s to g*sec
PGA     = im3(:,2);
Sa1     = im3(:,3);

switch method
    case 'BI14'
        LBS     = param.LBS1(M*ones(size(PGA)),PGA);
        HL      = param.HL1 (M*ones(size(PGA)),PGA);
    case 'R15'
        LBS     = param.LBS2(M*ones(size(PGA)),PGA);
        HL      = param.HL2 (M*ones(size(PGA)),PGA);
end

HL    = max(HL,0.1);
sigDs = 0.50;
lnDs      = -8.35+4.59*log(Q)-0.42*(log(Q))^2+0.072*LBS+0.58*log(tanh(HL/6))-0.02*B+0.84*log(CAVdp)+0.41*log(Sa1);
ind   = LBS>16;
lnDs(ind) = -7.48+4.59*log(Q)-0.42*(log(Q))^2+0.014*LBS(ind)+0.58*log(tanh(HL(ind)/6))-0.02*B+0.84*log(CAVdp(ind))+0.41*log(Sa1(ind));


