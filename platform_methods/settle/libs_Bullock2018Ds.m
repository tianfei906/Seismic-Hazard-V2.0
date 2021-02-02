function [varargout] = libs_Bullock2018Ds(param,cav,varargin)

% cav must be input in cm/s
B     = param.B;
L     = param.L;
Df    = param.Df;
Q     = param.Q(1);
LPC   = strcmpi(param.LAY.LPC,'Y');
qc1N  = param.LAY.qc1N;
Hs    = param.LAY.thick;
Ds    = param.LAY.d2mat;

if 1 % coefficients
    switch param.type
        case 'Masonry',             a=455;
        case 'Reinforced-Concrete', a=455;
        case 'Timber',              a= 51;
        case 'Steel',               a=242;
    end
    
    h   = Q*1000/(9.81*a);  % building height in me
    Mst = a*B*L*h;          % building weight in kg
    a0	= 1.0000;
    a1  =-0.0360;
    %sig = 0.6746;
    sig = 0.33; % Whatsapp conversation with Jorge
    b0	= 0.3026;
    b1	=-0.0205;
    c0	= 1.3558;
    c1	=-0.1340;
    d0	=-1.3446;
    d1	= 0.2303;
    d2	= 0.4189;
    e0	=-0.8727;
    e1	= 0.1137;
    e2	=-0.0947;
    e3	=-0.2148;
    f0	=-0.0137;
    f1	= 0.0021;
    f2	= 0.1703;
    s1	= 0.4973;
end

fS      = a0+a1*(qc1N-112.4); fS(qc1N< 112.4)=a0; fS(qc1N>=140.2)=a0+27.8*a1;
fH      = b0*Hs.*exp(b1*(max(Ds,2).^2-4));
He      = heaviside(Hs-1+eps);
Lterm   = He.*fS.*fH;
% [~,ind] = max(Lterm);
fso     = sum(Lterm) + (c0+c1*log(cav))*LPC;
fq      = (d0+d1*log(min(cav,1000)))*log(Q)*exp(d2*min(0,B-max(Ds(1),2)));
fA      = (e0+e1*log(max(cav,1500)))*(log(B))^2+e2*(L/B)+e3*Df;
fh      = (f0+f1*log(min(cav,1000)))*(0.7*h)^2+f2*min(Mst/(10^6),1);
%Hs1     = Hs(ind);

lnLIBS  = fso+fq+fA+fh+s1*log(cav);


if nargin<=3
    varargout{1}=lnLIBS;
    varargout{2} =sig;
    return
end

y    = varargin{1};
dist = varargin{2};
if strcmp(dist,'pdf')
    varargout{1} = lognpdf(y,lnLIBS,sig);
elseif strcmp(dist,'cdf')
    varargout{1} = logncdf(y,lnLIBS,sig);
elseif strcmp(dist,'ccdf')
    varargout{1} = 1-logncdf(y,lnLIBS,sig);
end


