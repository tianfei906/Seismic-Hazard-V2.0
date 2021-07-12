function[lny,sigma,tau,phi]=SiberRisk2019(To,M,Rrup,Rhyp,Zhyp,Vs30,mechanism,adjfun)

% Syntax : SiberRisk2019 mechanism                                          

% To        = spectral period
% M         = moment magnitude
% rrup      = closest distance to fault rupture
% h         = focal depth (km)
% mechanism = 'interface' 'intraslab'
% region    = 'forearc','backarc','unkown'
% Vs30      = Shear wave velocity averaged over the upper 30 m

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[0 10],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

if To>=0
    To      = max(To,0.01); %PGA is associated to To=0.01;
end

period  = [-1 0.01 0.02  0.05  0.075  0.1  0.15  0.2  0.25  0.3  0.4  0.5  0.6  0.75  1  1.5  2  2.5  3  4  5  6  7.5  10];
T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

switch mechanism
    case 'interface', R=Rrup;
    case 'intraslab', R=Rhyp;
end

if T_lo==T_hi
    [lny,sigma,tau,phi] = gmpe(index,M,R,Zhyp,mechanism,Vs30);
else
    [lny_lo,sigma_lo,tau_lo] = gmpe(index,  M,R,Zhyp,mechanism,Vs30);
    [lny_hi,sigma_hi,tau_hi] = gmpe(index+1,M,R,Zhyp,mechanism,Vs30);
    x          = log([T_lo;T_hi]);
    Y_sa       = [lny_lo,lny_hi]';
    Y_sigma    = [sigma_lo,sigma_hi]';
    Y_tau      = [tau_lo,tau_hi]';
    lny        = interp1(x,Y_sa,log(To))';
    sigma      = interp1(x,Y_sigma,log(To))';
    tau        = interp1(x,Y_tau,log(To))';
    phi        = sqrt(sigma.^2-tau.^2);
end

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end


function [lny,sigma,tau,phi] = gmpe(index,M,R,Zhyp,mechanism,Vs30)

switch mechanism
    case 'interface', [lny,sigma,tau,phi] = gmpeinter(index,M,R,Vs30);
    case 'intraslab', [lny,sigma,tau,phi] = gmpeintra(index,M,R,Zhyp,Vs30);
end

function [lny,sigma,tau,phi] = gmpeinter(index,M,R,Vs30)
ind1      = M<7.0;
ind2      = and(M>=7,M<7.8);
ind3      = M>=7.8;
lny       = nan(size(M));
sigma     = nan(size(M));
tau       = nan(size(M));
phi       = nan(size(M));
if numel(Vs30)==1
    x         = [M,R,Vs30*ones(size(M))];
else
    x         = [M,R,Vs30];
end

if any(ind1), [lny(ind1),sigma(ind1),tau(ind1),phi(ind1)] = intermbin1(index,x(ind1,:)); end
if any(ind2), [lny(ind2),sigma(ind2),tau(ind2),phi(ind2)] = intermbin2(index,x(ind2,:)); end
if any(ind3), [lny(ind3),sigma(ind3),tau(ind3),phi(ind3)] = intermbin3(index,x(ind3,:)); end

function [lny,sigma,tau,phi]=intermbin1(index,x)

M      = x(:,1);
Rrup   = x(:,2);
Vs30   = x(:,3);

R1     = log(Rrup+10*exp(0.4*(M-6)));
R2     = (M-7.8).*R1;
Vs     = min(1000, Vs30); % (equation (8))

%DC1         vlin         b        th12
constants = [...
    0.041503750    410.50000000 -2.40100000   1.993
    0.200000000    865.10000000 -1.18600000    0.98
    0.200000000    865.10000000 -1.18600000    0.98
    0.200000000   1053.50000000 -1.34600000   1.288
    0.200000000   1085.70000000 -1.47100000   1.483
    0.200000000   1032.50000000 -1.62400000   1.613
    0.200000000    877.60000000 -1.93100000   1.882
    0.200000000    748.20000000 -2.18800000   2.076
    0.200000000    654.30000000 -2.38100000   2.248
    0.200000000    587.10000000 -2.51800000   2.348
    0.143682921    503.00000000 -2.65700000   2.427
    0.100000000    456.60000000 -2.66900000   2.399
    0.073696559    430.30000000 -2.59900000   2.273
    0.041503750    410.50000000 -2.40100000   1.993
    0.000000000    400.00000000 -1.95500000    1.47
    -0.05849625    400.00000000 -1.02500000   0.408
    -0.10000000    400.00000000 -0.29900000  -0.401
    -0.15503397    400.00000000  0.00000000  -0.723
    -0.20000000    400.00000000  0.00000000  -0.673
    -0.20000000    400.00000000  0.00000000  -0.627
    -0.20000000    400.00000000  0.00000000  -0.596
    -0.20000000    400.00000000  0.00000000  -0.566
    -0.20000000    400.00000000  0.00000000  -0.528
    -0.20000000    400.00000000  0.00000000  -0.504];

COEFF = [
    2.8585   -1.0007   -0.0006    0.0086
    3.7584      -1.3747    0.0026003     0.056012
    4.0219      -1.4062    0.0023868      0.05618
    5.8318      -1.8093     0.004652     0.066113
    5.5996      -1.6881    0.0039492     0.067191
    4.4037      -1.3652    0.0021716     0.067846
    2.785     -0.90299  -0.00069554     0.059681
    1.1538     -0.46397    -0.003319     0.049478
    1.1057     -0.40783   -0.0036678     0.034971
    1.3769     -0.45954   -0.0033936     0.025822
    2.1931     -0.64822   -0.0016659    0.0082797
    2.197     -0.63308   -0.0019474   -0.0050161
    2.5026     -0.69443   -0.0018896    -0.017091
    2.8154     -0.76486   -0.0016614    -0.035051
    3.6588      -1.0255  -8.7817e-05     -0.05341
    3.5636      -1.1269   0.00038859     -0.07057
    2.585     -0.98532  -0.00077009    -0.077678
    1.9887     -0.93011   -0.0013142    -0.079776
    1.6246     -0.92468   -0.0013468    -0.081056
    1.0672     -0.93629    -0.001351    -0.077667
    0.61316     -0.93363   -0.0016741    -0.073873
    0.24277     -0.92394   -0.0018351    -0.071917
    0.063863     -0.99573   -0.0011714    -0.067652
    -0.49558      -1.0097   -0.0010115     -0.05813];

STDC   = [
    0.2961    0.6780
    0.39171      0.54345
    0.4274      0.52141
    0.52166      0.57482
    0.54515      0.55983
    0.50788      0.56662
    0.42725       0.5885
    0.40099      0.56928
    0.3775      0.55999
    0.34928        0.568
    0.32511      0.59914
    0.3049      0.62764
    0.29608      0.67794
    0.30703      0.67424
    0.32825      0.64185
    0.40866      0.55551
    0.40888      0.52037
    0.39213      0.49174
    0.39255      0.47197
    0.39402       0.4562
    0.37948      0.44871
    0.36356       0.4434
    0.35787      0.44022
    0.35152      0.44855];

DC1    = constants(index,1);
Vlin   = constants(index,2);
b      = constants(index,3);
th12   = constants(index,4);
th1    = COEFF(index,1);
th2    = COEFF(index,2);
th6    = COEFF(index,3);
th13   = COEFF(index,4);
n      = 1.18;
c      = 1.88;
th4    = 0.9;

%% FEVENT
% fpath
fpath   = th4*DC1 + th2*R1 + 0.1*R2 + th6*Rrup;

% fmag
fmag    = th4*(M-(7.8+DC1)).*(M<=(7.8+DC1)) + th13*(10-M).^2;

% fsite
crock = [4.2203   -1.35  -0.0012  -0.0135];
PGA1000 = exp(interPGARock(crock,x));
fsite   = (th12 * log(Vs/Vlin) + b*n*log(Vs/Vlin)).*ones(size(M));
fsite2  =  th12 * log(Vs/Vlin) - b*log(PGA1000 + c) + b*log(PGA1000 + c * ((Vs/Vlin) .^ n));
fsite(Vs30<=Vlin)=fsite2(Vs30<=Vlin);

% Now we have all parameters, calculate SA and export deviations
lny = th1 + fpath + fmag + fsite;
tau = STDC(index,1)*ones(size(M));
phi = STDC(index,2)*ones(size(M));
sigma = sqrt(phi.^2+tau.^2);

function [lny,sigma,tau,phi]=intermbin2(index,x)

% this is to fix an issue with the SIBER RISK model for intermediate
% magnitudes
xL = x; xL(:,1)=7;
xH = x; xH(:,1)=7.8;
[lnyL,sigmaL,tauL]=intermbin1(index,xL);
[lnyH,sigmaH,tauH]=intermbin3(index,xH);
lny   = (1-(x(:,1)-7)/(7.8-7.0)).*lnyL   + (x(:,1)-7)/(7.8-7.0).*lnyH;
sigma = (1-(x(:,1)-7)/(7.8-7.0)).*sigmaL + (x(:,1)-7)/(7.8-7.0).*sigmaH;
tau   = (1-(x(:,1)-7)/(7.8-7.0)).*tauL   + (x(:,1)-7)/(7.8-7.0).*tauH;
phi   = sqrt(sigma.^2-tau.^2);

function [lny,sigma,tau,phi]=intermbin3(index,x)

M      = x(:,1);
Rrup   = x(:,2);
Vs30   = x(:,3);

R1     = log(Rrup+10*exp(0.4*(M-6)));
R2     = (M-7.8).*R1;
Vs     = min(1000, Vs30); % (equation (8))

%DC1         vlin         b
%DC1         vlin         b        th12
constants = [...
    0.041503750    410.50000000 -2.40100000   1.993
    0.200000000    865.10000000 -1.18600000    0.98
    0.200000000    865.10000000 -1.18600000    0.98
    0.200000000   1053.50000000 -1.34600000   1.288
    0.200000000   1085.70000000 -1.47100000   1.483
    0.200000000   1032.50000000 -1.62400000   1.613
    0.200000000    877.60000000 -1.93100000   1.882
    0.200000000    748.20000000 -2.18800000   2.076
    0.200000000    654.30000000 -2.38100000   2.248
    0.200000000    587.10000000 -2.51800000   2.348
    0.143682921    503.00000000 -2.65700000   2.427
    0.100000000    456.60000000 -2.66900000   2.399
    0.073696559    430.30000000 -2.59900000   2.273
    0.041503750    410.50000000 -2.40100000   1.993
    0.000000000    400.00000000 -1.95500000    1.47
    -0.05849625    400.00000000 -1.02500000   0.408
    -0.10000000    400.00000000 -0.29900000  -0.401
    -0.15503397    400.00000000  0.00000000  -0.723
    -0.20000000    400.00000000  0.00000000  -0.673
    -0.20000000    400.00000000  0.00000000  -0.627
    -0.20000000    400.00000000  0.00000000  -0.596
    -0.20000000    400.00000000  0.00000000  -0.566
    -0.20000000    400.00000000  0.00000000  -0.528
    -0.20000000    400.00000000  0.00000000  -0.504];

COEFF = [
    -0.8918   -0.0713   -0.0106    0.0545
    0.53352     -0.54456   -0.0078797      0.12313
    -0.48204     -0.26861   -0.0098407      0.13169
    1.9237     -0.76789   -0.0075882      0.13196
    1.5041     -0.59012   -0.0090855      0.13768
    -0.48532    -0.065866    -0.012475      0.13987
    0.34064     -0.23841    -0.010523      0.13301
    1.3559     -0.49635   -0.0076015      0.11929
    0.58826     -0.31526   -0.0087989       0.1292
    1.0246     -0.42051   -0.0077957      0.11268
    0.43352     -0.27816   -0.0083886     0.093931
    0.59769     -0.31592   -0.0080508     0.071573
    1.6542     -0.57863   -0.0064936     0.055027
    2.6101     -0.83083   -0.0050158      0.03858
    1.9862     -0.73376   -0.0056349     0.014188
    -0.30446     -0.26848   -0.0095586   -0.0051832
    -0.4291     -0.29582   -0.0092015     -0.06358
    -0.20535     -0.41707   -0.0079822    -0.092978
    -0.71083     -0.33363   -0.0088125     -0.11844
    -1.3008     -0.30422   -0.0088164     -0.13459
    -2.0335     -0.22439   -0.0095334     -0.13213
    -2.0468     -0.28076   -0.0095811     -0.13494
    -2.9278     -0.13529    -0.010102     -0.15498
    -4.2008     0.064429    -0.011563     -0.15134];

STDC   = [
    0.2961    0.6780
    0.39171      0.54345
    0.4274      0.52141
    0.52166      0.57482
    0.54515      0.55983
    0.50788      0.56662
    0.42725       0.5885
    0.40099      0.56928
    0.3775      0.55999
    0.34928        0.568
    0.32511      0.59914
    0.3049      0.62764
    0.29608      0.67794
    0.30703      0.67424
    0.32825      0.64185
    0.40866      0.55551
    0.40888      0.52037
    0.39213      0.49174
    0.39255      0.47197
    0.39402       0.4562
    0.37948      0.44871
    0.36356       0.4434
    0.35787      0.44022
    0.35152      0.44855];

DC1    = constants(index,1);
Vlin   = constants(index,2);
b      = constants(index,3);
th12   = constants(index,4);
th1    = COEFF(index,1);
th2    = COEFF(index,2);
th6    = COEFF(index,3);
th13   = COEFF(index,4);
n      = 1.18;
c      = 1.88;
th4    = 0.9;

% fpath
fpath   = th4*DC1 + th2*R1 + 0.1*R2 + th6*Rrup;

% fmag
fmag    = th4*(M-(7.8+DC1)).*(M<=(7.8+DC1)) + th13*(10-M).^2;

% fsite
crock = [ -8.21677623550771          1.60930573170652       -0.0261932902411916          0.21421294347105];
PGA1000 = exp(interPGARock(crock,x));
fsite   = (th12 * log(Vs/Vlin) + b*n*log(Vs/Vlin)).*ones(size(M));
fsite2  =  th12 * log(Vs/Vlin) - b*log(PGA1000 + c) + b*log(PGA1000 + c * ((Vs/Vlin) .^ n));
fsite(Vs30<=Vlin)=fsite2(Vs30<=Vlin);

% Now we have all parameters, calculate SA and export deviations
lny = th1 + fpath + fmag + fsite;
tau = STDC(index,1)*ones(size(M));
phi = STDC(index,2)*ones(size(M));
sigma = sqrt(phi.^2+tau.^2);

function[lny] = interPGARock(coef,x)

M      = x(:,1);
Rrup   = x(:,2);
R1     = log(Rrup+10*exp(0.4*(M-6)));
R2     = (M-7.8).*R1;


th1    = coef(1);
th2    = coef(2);
th6    = coef(3);
th13   = coef(4);


DC1    = 0.2;
th12   = 0.98;

Vlin   = 865.1;
b      = -1.186;
n      = 1.18;
th4    = 0.9;

fsite  = th12*log(1000/Vlin)+b*n*log(1000/Vlin);
fmag   = 0.9*(M-(7.8+DC1)).*(M<=(7.8+DC1)) + th13*(10-M).^2;
lny    = th1 + th4*DC1+th2*R1+0.1*R2+th6*Rrup+fmag+fsite;

function [lny,sigma,tau,phi] = gmpeintra(index,M,Rhyp,Zhyp,Vs30)

x      = [M Rhyp Zhyp Vs30*ones(size(M))];
R1     = log(Rhyp+10*exp(0.4*(M-6)));
R2     = (M-7.8).*R1;
Vs     = min(1000, Vs30); % (equation (8))

      %DC1         vlin         b        th12
constants = [...
    0.041503750    410.50000000 -2.40100000   1.993
    0.200000000    865.10000000 -1.18600000    0.98
    0.200000000    865.10000000 -1.18600000    0.98
    0.200000000   1053.50000000 -1.34600000   1.288
    0.200000000   1085.70000000 -1.47100000   1.483
    0.200000000   1032.50000000 -1.62400000   1.613
    0.200000000    877.60000000 -1.93100000   1.882
    0.200000000    748.20000000 -2.18800000   2.076
    0.200000000    654.30000000 -2.38100000   2.248
    0.200000000    587.10000000 -2.51800000   2.348
    0.143682921    503.00000000 -2.65700000   2.427
    0.100000000    456.60000000 -2.66900000   2.399
    0.073696559    430.30000000 -2.59900000   2.273
    0.041503750    410.50000000 -2.40100000   1.993
    0.000000000    400.00000000 -1.95500000    1.47
    -0.05849625    400.00000000 -1.02500000   0.408
    -0.10000000    400.00000000 -0.29900000  -0.401
    -0.15503397    400.00000000  0.00000000  -0.723
    -0.20000000    400.00000000  0.00000000  -0.673
    -0.20000000    400.00000000  0.00000000  -0.627
    -0.20000000    400.00000000  0.00000000  -0.596
    -0.20000000    400.00000000  0.00000000  -0.566
    -0.20000000    400.00000000  0.00000000  -0.528
    -0.20000000    400.00000000  0.00000000  -0.504];

COEFF = [ 
    9.4883   -2.2739    0.0006   -0.0231    0.0166
    9.6015   -2.3934    0.0029    0.0344    0.0100
    9.2429   -2.2959    0.0023    0.0348    0.0098
   10.6457   -2.5926    0.0045    0.0507    0.0069
   10.8335   -2.5777    0.0046    0.0547    0.0066
   10.0787   -2.3576    0.0035    0.0483    0.0083
    9.6341   -2.2164    0.0024    0.0326    0.0117
   10.0086   -2.2204    0.0015    0.0082    0.0132
   10.6508   -2.3172    0.0014   -0.0110    0.0145
   10.1013   -2.1622    0.0004   -0.0252    0.0156
    9.1958   -1.9105   -0.0009   -0.0478    0.0156
    9.8249   -2.0531   -0.0002   -0.0639    0.0160
    9.7357   -2.0543   -0.0005   -0.0739    0.0177
    9.2701   -2.0290   -0.0008   -0.0803    0.0209
    8.7818   -1.9835   -0.0010   -0.0910    0.0202
    6.5746   -1.5511   -0.0040   -0.1081    0.0211
    5.6669   -1.4401   -0.0047   -0.1140    0.0210
    6.0691   -1.6271   -0.0033   -0.1196    0.0210
    5.9356   -1.6839   -0.0028   -0.1193    0.0200
    5.3385   -1.7151   -0.0020   -0.1112    0.0181
    5.3536   -1.8451   -0.0012   -0.1045    0.0175
    5.5401   -1.9939   -0.0002   -0.0973    0.0167
    5.2248   -2.0580    0.0003   -0.0861    0.0160
    5.2858   -2.2550    0.0018   -0.0704    0.0154];

STDC   = [
    0.2831    0.5228
    0.1574    0.4513
    0.1302    0.4008
    0.1263    0.4041
    0.1503    0.4253
    0.1562    0.4248
    0.1351    0.4577
    0.1647    0.4762
    0.1479    0.4980
    0.1390    0.5265
    0.1568    0.5461
    0.1249    0.6030
    0.1469    0.6043
    0.2230    0.5662
    0.3233    0.4863
    0.3189    0.4375
    0.2918    0.4220
    0.2721    0.4111
    0.2675    0.3922
    0.2579    0.3707
    0.2533    0.3630
    0.2459    0.3644
    0.2296    0.3697
    0.2093    0.3842];
  
DC1    = constants(index,1);
Vlin   = constants(index,2);
b      = constants(index,3);
th12   = constants(index,4);
th1    = COEFF(index,1);
th2    = COEFF(index,2);
th6    = COEFF(index,3);
th13   = COEFF(index,4);
th11   = COEFF(index,5);
n      = 1.18;
c      = 1.88;
th4    = 0.9;

%% FEVENT
% fpath
fpath   = th4*DC1 + th2*R1 + 0.1*R2 + th6*Rhyp;

% fmag
fmag    = th4*(M-(7.8+DC1)).*(M<=(7.8+DC1)) + th13*(10-M).^2;

% fsite
crock = [ 12.8894   -3.1431    0.0057    0.0525    0.0063];
PGA1000 = exp(intraPGARock(crock,x));
fsite   = (th12 * log(Vs/Vlin) + b*n*log(Vs/Vlin)).*ones(size(M));
fsite2  =  th12 * log(Vs/Vlin) - b*log(PGA1000 + c) + b*log(PGA1000 + c * ((Vs/Vlin) .^ n));
fsite(Vs30<=Vlin)=fsite2(Vs30<=Vlin);

% fdepth
fdepth = th11.*(min(Zhyp,120)-60);

% Now we have all parameters, calculate SA and export deviations
lny = th1 + fpath + fmag + fsite + fdepth;
tau = STDC(index,1)*ones(size(M));
phi = STDC(index,2)*ones(size(M));
sigma = sqrt(phi.^2+tau.^2);

function[lny] = intraPGARock(coef,x)

% To        = spectral period
% M         = moment magnitude
% rrup      = closest distance to fault rupture
% h         = focal depth (km)
% mechanism = 'interface' 'intraslab'
% region    = 'forearc','backarc','unkown'
% Vs30      = Shear wave velocity averaged over the upper 30 m


M      = x(:,1);
Rhyp   = x(:,2);
Zh     = x(:,3);
R1     = log(Rhyp+10*exp(0.4*(M-6)));
R2     = (M-7.8).*R1;


th1    = coef(1);
th2    = coef(2);
th6    = coef(3);
th13   = coef(4);
th11   = coef(5);

DC1    = 0.2;
th12   = 0.98;

Vlin   = 865.1;
b      = -1.186;
n      = 1.18;
th4    = 0.9;

fdepth = th11*(min(Zh,120)-60);
fpath  = th4*DC1+th2*R1+0.1*R2+th6*Rhyp;
fsite  = th12*log(1000/Vlin)+b*n*log(1000/Vlin);
fmag   = 0.9*(M-(7.8+DC1)).*(M<=(7.8+DC1)) + th13*(10-M).^2;

lny    = th1 + fpath+fmag+fsite+fdepth;