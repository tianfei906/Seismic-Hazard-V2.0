function vout = RA2011(ky,Ts,kvmax,kmax,varargin)

% Rathje, E. M., & Antonakos, G. (2011). A unified model for predicting 
% earthquake-induced sliding displacements of rigid and flexible slopes.
% Engineering Geology, 122(1-2), 51-60.

im1=kvmax(1,:);
im2=kmax(:,1);

% Coefficients of 2GM displacement model
kj = ky./kmax;
a1 = -1.56;
a2 = -4.58;
a3 = -20.84;
a4 =  44.75;
a5 = -30.50;
a6 = -0.64;
a7 =  1.55;

lnd = a1+a2*kj+a3*kj.^2+a4*kj.^3+a5*kj.^4+a6*log(kmax)+a7*log(kvmax)+0.71*(Ts>0.5) + 1.42*Ts*(Ts<=0.5); % Eq.4
sig = 0.400+0.284*kj; 
sig = sig.*ones(size(lnd));

if nargin==4
   vout=[lnd,sig];
   return
end

d    = varargin{1};
dist = varargin{2};
Nd   = length(d);

switch dist
    case 'convolute'
        vout  = zeros(1,Nd);
        MRDk  = varargin{3};
        for k = 1:Nd
            xhat    = (log(d(k))-lnd)./sig;
            ccdf    = 0.5*(1-erf(xhat/sqrt(2)));
            vout(k) = trapz(im1,trapz(im2,ccdf.*MRDk));
        end
    case 'pdf'
        vout = lognpdf(d,lnd,sig);
    case 'cdf'
        vout = logncdf(d,lnd,sig);
    case 'ccdf'
        vout = 1-logncdf(d,lnd,sig);
end
