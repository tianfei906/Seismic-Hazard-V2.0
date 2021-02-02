function [lny,sigma,tau,phi] = MAB2019(To,M,Rrup,mechanism,region,Vs30,func,varargin)

% Syntax : MAB2019 mechanism region handle {param}                       

% Arias Intensity Conditional Scaling Ground?Motion Models for Subduction Zones 
% Jorge Macedo; Norman Abrahamson; Jonathan D. Bray
% Bulletin of the Seismological Society of America (2019) 109 (4): 1343–1357.
% https://doi.org/10.1785/0120180297

% Conditional Model for Arias Intensity
% M         = Moment magnitude
% func      = function handle to Sa model
% mechanism = 1 for interface earthquakes
%             2 for intraslab earthquakes
% un        = units of IM
% Vs30      = Avg. Shear wave velocity
% varargin  = input parameters that follow T in the matlab function that
%              runs the Sa GMPE

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[nan nan],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

switch mechanism
    case 'interface'
        switch region
            case 'global'       , c1 = 0.85; c2 =-0.36; c3 = 0.53; c4 = 1.54; c5 = 0.17; phi = 0.30; tau = 0.18; sig= sqrt(tau^2+phi^2);
            case 'japan'        , c1 = 0.98; c2 =-0.38; c3 = 0.53; c4 = 1.54; c5 = 0.17; phi = 0.30; tau = 0.16; sig= sqrt(tau^2+phi^2);
            case 'taiwan'       , c1 = 0.75; c2 =-0.35; c3 = 0.53; c4 = 1.54; c5 = 0.17; phi = 0.27; tau = 0.15; sig= sqrt(tau^2+phi^2);
            case 'south-america', c1 = 0.95; c2 =-0.36; c3 = 0.53; c4 = 1.54; c5 = 0.17; phi = 0.32; tau = 0.19; sig= sqrt(tau^2+phi^2);
            case 'new-zeeland'  , c1 = 0.82; c2 =-0.36; c3 = 0.53; c4 = 1.54; c5 = 0.17; phi = 0.28; tau = 0.17; sig= sqrt(tau^2+phi^2);
        end

    case 'intraslab'
        switch region
            case 'global'       , c1 = -0.74; c2 =-0.24; c3 = 0.66; c4 = 1.58; c5 = 0.14; phi = 0.28; tau = 0.16; sig= sqrt(tau^2+phi^2);
            case 'japan'        , c1 = -0.22; c2 =-0.32; c3 = 0.66; c4 = 1.58; c5 = 0.14; phi = 0.26; tau = 0.15; sig= sqrt(tau^2+phi^2);
            case 'taiwan'       , c1 = -1.02; c2 =-0.20; c3 = 0.66; c4 = 1.58; c5 = 0.14; phi = 0.29; tau = 0.17; sig= sqrt(tau^2+phi^2);
            case 'south-america', c1 = -0.75; c2 =-0.24; c3 = 0.66; c4 = 1.58; c5 = 0.14; phi = 0.30; tau = 0.14; sig= sqrt(tau^2+phi^2);
            case 'new-zeeland'  , c1 = -0.84; c2 =-0.22; c3 = 0.66; c4 = 1.58; c5 = 0.14; phi = 0.30; tau = 0.13; sig= sqrt(tau^2+phi^2);
        end
end

[lnPGA,sPGA]  = func(0,varargin{:}); % evaluates GMM for PGA
[lnSa1,sSa1]  = func(1,varargin{:}); % evaluates GMM for Sa(T=1)
rho           = 0.464; % BChydro Correlation model, rho=corr_BCHhydro2016(1,0);

% evaluates conditional GMM
lny   = c1+c2*log(Vs30)+c3*M+c4*lnPGA+c5*lnSa1;
COV   = rho*sPGA.*sSa1;
sigma = sqrt(sig^2+c4^2*sPGA.^2+c5^2*sSa1.^2+2*COV*c4*c5);

% unit conversion
lny = lny+log(units);

