function [lnD,sig] = pseudoProbaBM(param,CAV,PGA,SA1,M,method)

%%  integration
Nim        = length(CAV);
[II,JJ,KK] = meshgrid(1:Nim,1:Nim,1:Nim);
im3 = [CAV(II(:)),PGA(JJ(:)),SA1(KK(:))];
Nm  = length(M);
[mu1,s1]  = deal(zeros(Nim^3,Nm));

% Shear Component
for i=1:Nm
    [mu1(:,i),s1(:,i)] = BMDs(param,im3,M(i),method);
end

% Volumetric Component
[m,pga]  = meshgrid(M,PGA);
[mu2,s2] = libs_Juang2013Dv(param,pga,m);
mu2      = mu2(JJ(:),:);
s2       = s2(JJ(:),:);

% Settlement superposition
v1     = s1.^2;
v2     = s2.^2;
meanS  = exp(mu1+v1/2)+exp(mu2+v2/2);
varS   =(exp(v1)-1).*exp(2*mu1+v1)+(exp(v2)-1).*exp(2*mu2+v2);

% syms muS vS meanS varS real
% eqns = [exp(muS+vS/2)-meanS,(exp(vS)-1)*exp(2*muS+vS)-varS]; S = solve(eqns,[muS vS]); mu3  = S.muS;  sig3 = sqrt(S.vS);
meanS2 = meanS.^2;
lnD    = log(meanS2./(meanS2 + varS).^(1/2));
sig    = sqrt(log((meanS2 + varS)./meanS2));


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
lnDs  = -8.35+4.59*log(Q)-0.42*(log(Q))^2+0.072*LBS+0.58*log(tanh(HL/6))-0.02*B+0.84*log(CAVdp)+0.41*log(Sa1);
ind   = LBS>16;
lnDs(ind) = -7.48+4.59*log(Q)-0.42*(log(Q))^2+0.014*LBS(ind)+0.58*log(tanh(HL(ind)/6))-0.02*B+0.84*log(CAVdp(ind))+0.41*log(Sa1(ind));


