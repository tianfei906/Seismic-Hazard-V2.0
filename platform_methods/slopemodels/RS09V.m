function vout = RS09V(ky,~,pgv,pga,varargin)

% Rathje, E. M., & Saygili, G. (2009). Probabilistic assessment of 
% earthquake-induced sliding displacements of natural slopes. Bulletin 
% of the New Zealand Society for Earthquake Engineering, 42(1), 18.

im1=pgv(1,:);
im2=pga(:,1);

% pgv must be input in cm/s
kj = ky./pga;
a1 = -1.56;
a2 = -4.58;
a3 = -20.84;
a4 =  44.75;
a5 = -30.50;
a6 = -0.64;
a7 =  1.55;

lnd = a1+a2*kj+a3*kj.^2+a4*kj.^3+a5*kj.^4+a6*log(pga) +a7*log(pgv); 
sig = 0.405+0.524*kj;
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
        MRD   = varargin{3};
        for k = 1:Nd
            xhat    = (log(d(k))-lnd)./sig;
            ccdf    = 0.5*(1-erf(xhat/sqrt(2)));
            vout(k) = trapz(im1,trapz(im2,ccdf.*MRD));
        end
    case 'pdf'
        vout = lognpdf(d,lnd,sig);
    case 'cdf'
        vout = logncdf(d,lnd,sig);
    case 'ccdf'
        vout = 1-logncdf(d,lnd,sig);
end
