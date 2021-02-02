function [varargout] = libs_Juang2013Dv(param,PGA,M,varargin)

z      = param.CPT.z*1000;
dz     = mean(diff(z));        % Confirm units
lnd    = zeros(size(PGA));
sig    = zeros(size(PGA));
mu_M   = 1.0451;
d_M    = 0.3175;
sig_M  = mu_M*d_M;

for i=1:numel(lnd)
    m   = M(i);
    pga = PGA(i);
    
    % BI14 Triggering 
    tr = cptBI14(param.CPT, param.wt, param.Df,m,pga);
    ev = tr.evol/100; ev(isnan(ev))=0;
    PL = tr.PL/100;   PL(isnan(PL))=0;

    mu_P   = trapz(z,ev.*PL);
    sig_P  = trapz(z,dz*(ev.^2).*PL.*(1-PL));
    
    mu_a   = mu_M*mu_P;
    sig_a  = sqrt(mu_M^2*sig_P^2+sig_M^2*mu_P^2+sig_M^2*sig_P^2);
    d_a    = sig_a/mu_a;
    lnd(i) = log(mu_a/sqrt(1+d_a^2)); 
    sig(i) = sqrt(log(1+d_a^2));

end
lnd(isnan(lnd))=-inf;
sig(isnan(sig))= eps;


if nargin==3
    varargout{1}=lnd;
    varargout{2}=sig;
    return
end

y     = varargin{1};
dist  = varargin{2};
if strcmp(dist,'pdf')
    varargout{1} = normpdf((log(y)-lnd)./sig);
elseif strcmp(dist,'cdf')
    varargout{1} = normcdf((log(y)-lnd)./sig);
elseif strcmp(dist,'ccdf')
    varargout{1} = 1-normcdf((log(y)-lnd)./sig);
end