function [lny,sigma,tau,phi] = MAL2020(To,M,Rrup,Rjb,HWeffect,dip,Vs30,func,varargin)
% Syntax : MAL2020 HWeffect handle {param}                               

%% Median GMPE model for CAV (Shallow Crustal)
% Macedo, J., Abrahamson, N., & Liu, C. (2020). New Scenario-Based Cumulative Absolute 
% Velocity Models for Shallow Crustal Tectonic Settings.
% Bulletin of the Seismological Society of America.

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[nan nan],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

%% Model Coefficients
c1  =  1.79;
c2  =  0.67;
c3  =  0.57;
c4  = -0.47;
c5  = -0.0026;
c6  = 0.17;
tau = 0.17;
phi = 0.26;
sig = sqrt(tau^2+phi^2);

%% Median GMPE model for CAV (Shallow Crustal)
[lnPGA,sPGA]  = func(0,varargin{:}); % evaluates GMM for PGA

if dip>30
    T1 = (90-dip)/45;
else
    T1=60/45;
end

T2 = 1+0.2*(M-6.5)-0.8*(M-6.5).^2;
T2(M>=6.5)=1;
T2(M<=5.5)=0;

T5 = 1-Rjb/15;
T5(Rjb==0) =1;
T5(Rjb>=15)=0;

switch HWeffect
    case 'include', FHW=1;
    case 'exclude', FHW=0;
end

% evaluates conditional GMM
lny   = c1 + c2*lnPGA + c3*M + c4*log(Vs30) + c5*log(Rrup) +c6*FHW*T1*(T2.*T5);
sigma = sqrt(sig^2+c2^2*sPGA.^2);

% unit conversion
lny = lny+log(units);
