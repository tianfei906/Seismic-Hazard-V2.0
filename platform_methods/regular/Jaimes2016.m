function[lny,sigma,tau,phi]=Jaimes2016(To,M,Rrup,adjfun)
% Syntax : Jaimes2016                                                       

%Jaimes, M.A., Lermo, J. y Garc�a-Soto, A. (2016). Ground-Motion Prediction Model from Local Earthquakes
%of the Mexico Basin at the Hill Zone of Mexico City, Bulletin of the Seismological Society of America,
%106(6), 2532-2544

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
    To      = max(To,0.001); %PGA is associated to To=0.001;
end
period  = [-1 0.001 0.01 0.02 0.03 0.04 0.05 0.08 0.10 0.12 0.15 0.17 0.20 0.25 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00 4.00 5.00 7.50 10.00];
T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

if T_lo==T_hi
    [lny,sigma] = gmpe(index,M,Rrup);
else
    [lny_lo,sigma_lo] = gmpe(index,  M,Rrup);
    [lny_hi,sigma_hi] = gmpe(index+1,M,Rrup);
    x          = log([T_lo;T_hi]);
    Y_sa       = [lny_lo,lny_hi]';
    Y_sigma    = [sigma_lo,sigma_hi]';
    lny        = interp1(x,Y_sa,log(To))';
    sigma      = interp1(x,Y_sigma,log(To))';
end

tau   = nan(size(M));
phi   = nan(size(M));

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end



function [lny,sigma]=gmpe(index,M,Rrup)
DATA = [
-9.2425  3.0726 -1.30 -0.0115 0.79
-5.9024  3.2013 -1.30 -0.0316 1.05
-5.8904  3.1992 -1.30 -0.0315 1.05
-5.8955  3.1981 -1.30 -0.0317 1.05
-5.8768  3.2248 -1.30 -0.0339 1.07
-6.1057  3.3126 -1.30 -0.0328 1.09
-5.9225  3.2973 -1.30 -0.0355 1.13
-5.5666  3.3725 -1.30 -0.0445 1.23
-5.3886  3.3471 -1.30 -0.0489 1.23
-4.4134  3.0590 -1.30 -0.0501 1.18
-4.5527  3.1159 -1.30 -0.0501 1.13
-4.4688  3.0444 -1.30 -0.0448 1.11
-4.8389  3.1510 -1.30 -0.0392 1.07
-4.6435  2.9370 -1.30 -0.0198 0.98
-4.9727  2.8882 -1.30 -0.0092 0.90
-5.6202  2.9602 -1.30 -0.0057 0.78
-6.2649  3.0069 -1.30 -0.0036 0.70
-7.5119  3.1248 -1.30 -0.0024 0.60
-8.2369  3.2187 -1.30 -0.0056 0.59
-10.0150 3.5280 -1.30 -0.0004 0.51
-10.7760 3.5746 -1.30  0.0014 0.53
-11.4350 3.5005 -1.30  0.0039 0.55
-11.9930 3.5312 -1.30 -0.0017 0.56
-12.4270 3.5710 -1.30 -0.0060 0.59
-12.7590 3.5194 -1.30 -0.0113 0.65
-12.9800 3.4714 -1.30 -0.0122 0.68];

C       = DATA(index,:);
lny     = C(1)+ C(2)*M + C(3)*log(Rrup) + C(4)*Rrup;
sigma   = C(5)*ones(size(M));
