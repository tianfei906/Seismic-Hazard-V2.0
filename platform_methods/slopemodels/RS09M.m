function[vout]=RS09M(ky,~,im,M,varargin)

% Rathje, E. M., & Saygili, G. (2009). Probabilistic assessment of 
% earthquake-induced sliding displacements of natural slopes. Bulletin 
% of the New Zealand Society for Earthquake Engineering, 42(1), 18.

%%
im    = max(im,ky+eps);
aratio = ky./im;
a1 =  4.89;
a2 = -4.85;
a3 = -19.64;
a4 =  42.49;
a5 = -29.06;
a6 =  0.72;
a7 =  0.89;

lnEDP = a1+a2*(aratio)+a3*(aratio).^2+a4*(aratio).^3+a5*(aratio).^4+a6*log(im)+a7*(M-6); 
std   = 0.732+0.789*(aratio)-0.539*(aratio).^2;
sig   = std.*ones(size(lnEDP));

if nargin==4
   vout=[lnEDP,sig];
   return
end

y    = varargin{1};
dist = varargin{2};
if strcmp(dist,'pdf')
    vout = lognpdf(y,lnEDP,sig);
elseif strcmp(dist,'cdf')
    vout = logncdf(y,lnEDP,sig);
elseif strcmp(dist,'ccdf')
    vout = 1-logncdf(y,lnEDP,sig);
end
