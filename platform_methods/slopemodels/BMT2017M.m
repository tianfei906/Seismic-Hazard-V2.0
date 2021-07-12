function[vout]=BMT2017M(ky,Ts,im,M,varargin)

% Bray, J. D., Macedo, J., & Travasarou, T. (2017). Simplified procedure 
% for estimating seismic slope displacements for subduction zone 
% earthquakes. Journal of Geotechnical and Geoenvironmental Engineering, 
% 144(3), 04017124.

%% FROM JON'S SPREADSHEET
if Ts<0.1
    lnd = -5.864-3.353*log(ky)-0.390*(log(ky))^2+0.538*log(ky)*log(im)+3.060*log(im)-0.225*(log(im)).^2-9.421*Ts+0.55*M;
else
    lnd = -6.896-3.353*log(ky)-0.390*(log(ky))^2+0.538*log(ky)*log(im)+3.060*log(im)-0.225*(log(im)).^2+3.801*Ts+0.55*M-0.803*Ts^2;
end

sig   = 0.73;

if nargin==4
   vout=[lnd,sig];
   return
end

y     = varargin{1};
dist  = varargin{2};

if strcmp(dist,'pdf')
    vout = normpdf((log(y)-lnd)/sig);
elseif strcmp(dist,'cdf')
    vout = normcdf((log(y)-lnd)/sig);
elseif strcmp(dist,'ccdf')
    vout = 1-normcdf((log(y)-lnd)/sig);
end

% if Ts<0.7
%     Pzero = 1-normcdf(-2.640-3.200*log(ky)-0.170*log(ky)^2-0.490*Ts*log(ky)+2.094*Ts+2.908*log(im),0,1);
% else
%     Pzero = 1-normcdf(-3.531-4.783*log(ky)-0.342*log(ky)^2-0.300*Ts*log(ky)-0.672*Ts+2.658*log(im),0,1);
% end
% 
% if Ts<0.1
%     lnd = -5.864-3.353*log(ky)-0.390*(log(ky))^2+0.538*log(ky)*log(im)+3.060*log(im)-0.225*(log(im)).^2-9.421*Ts+0.55*M;
% else
%     lnd = -6.896-3.353*log(ky)-0.390*(log(ky))^2+0.538*log(ky)*log(im)+3.060*log(im)-0.225*(log(im)).^2+3.801*Ts+0.55*M-0.803*Ts^2;
% end
% 
% sig   = 0.73;
% 
% if nargin==4
%    vout=[lnd,sig];
%    return
% end
% 
% y0    = 0.5;
% y     = max(varargin{1},y0);
% dist  = varargin{2};
% 
% if strcmp(dist,'pdf')
%     if y > y0
%         vout = (1-Pzero).*normpdf((log(y)-lnd)/sig);
%     elseif y==y0
%         vout = Pzero/y0;
%     end
%     
% elseif strcmp(dist,'cdf')
%     if y >= y0
%         vout = Pzero + (1-Pzero).*normcdf((log(y)-lnd)/sig);
%     elseif y==y0
%         vout = Pzero;
%     end
% elseif strcmp(dist,'ccdf')
%     if y >= y0
%         vout = 1- (Pzero + (1-Pzero).*normcdf((log(y)-lnd)/sig));
%     elseif y==y0
%         vout = 1-Pzero;
%     end
% end


