function [lny,sigma,tau,phi] = ML2021(To,M,~,mechanism,Vs30,func,varargin)
% Syntax : ML2021 mechanism handle {param}                              

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[nan nan],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    [lny,sigma,tau,phi] = func(To,varargin{:});
    return
end

%% Model Coefficients

switch mechanism
    case 'interface'
        a0  = 2.37;
        a1  = 0.62;
        a2  = 0.41;
        a3  = -0.27;
        a4  = 0.14;
        tau = 0.14;
        phi = 0.25;
        sig = sqrt(tau^2+phi^2);

    case 'intraslab'
        a0  = 1.50;
        a1  = 0.63;
        a2  = 0.49;
        a3  = -0.23;
        a4  = 0.12;
        tau = 0.17;
        phi = 0.25;
        sig = sqrt(tau^2+phi^2);
end

%% Median GMPE model for CAV (Subdiction)
[lnPGA,sPGA]  = func(0,varargin{:}); % evaluates GMM for PGA
[lnSA1,sSa1]  = func(1,varargin{:}); % evaluates GMM for Sa(T=1)
rho           = 0.464; % BChydro Correlation model, rho=corr_BCHhydro2016(1,0);

% evaluates conditional GMM
lny   = a0 + a1*lnPGA + a2*M + a3*log(Vs30) + a4*lnSA1;
COV   = rho*sPGA.*sSa1;
sigma = sqrt(sig^2+sPGA.^2*a1^2+sSa1.^2*a4^2+2*COV*a1*a4); % pending

% unit conversion
lny = lny+log(units);
