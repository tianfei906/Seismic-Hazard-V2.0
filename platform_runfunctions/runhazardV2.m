function[lambda,MRE,MRD]=runhazardV2(im,IM,h,opt,source,Nsource,rho,varargin)

xyz        = gps2xyz(h.p,opt.ellipsoid);
[Nim,Ndim] = size(im);
rho        = min(rho,1);
ind        = selectsource(opt.MaxDistance,xyz,source);
sptr       = find(ind);
lambda     = zeros(Nim,Ndim,Nsource);
MRE        = nan(Nim,Nim,Nsource);
MRD        = nan(Nim,Nim,Nsource);

if nargin==7
    if opt.method==1
        for i=sptr
            source(i).media = h.value;
            [lambda(:,:,i),MRE(:,:,i),MRD(:,:,i)]=runsource1(source(i),xyz,IM,im,rho,opt,h.param);
        end
    end
    
    if opt.method==2
        for i=sptr
            source(i).media = h.value;
            [lambda(:,:,i),MRE(:,:,i),MRD(:,:,i)]=runsource2(source(i),xyz,IM,im,rho,opt,h.param);
        end
    end
    
    if opt.method==3
        for i=sptr
            source(i).media = h.value;
            [lambda(:,:,i),MRE(:,:,i),MRD(:,:,i)]=runsource3(source(i),xyz,h,IM,im,rho,opt,h.param);
        end
    end
    lambda = nansum(lambda,3);
    MRE    = nansum(MRE   ,3);
    MRD    = nansum(MRD   ,3);
end

if nargin==8 % this option runs only the sources listed in varargin{1}, this is used in the PSDA GUI to pre-compute vector-valued hazard
    mechlist=varargin{1};
    for i=sptr
        if any(source(i).numgeom(1)==mechlist)
            source(i).media = h.value;
            [lambda(:,:,i),MRE(:,:,i),MRD(:,:,i)]=runsource1(source(i),xyz,IM,im,rho,opt,h.param);
        end
    end
end

return

function[lambda,MRE,MRD]=runsource1(source,r0,IM,im,rho,opt,hparam) %#ok<*DEFNU>

gmpe        = source.gmm;
[Nim0,ncols]= size(im);
Nim         = 40;
NMmin       = source.NMmin;
gmpefun     = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);

%% HAZARD INTEGRAL
[mu1,sig1] = gmpefun(IM(1),param{:});
[mu2,sig2] = gmpefun(IM(2),param{:});

if ncols==1
    im1 = im(:,1);
    im2 = im(:,1);
else
    im1 = im(:,1);
    im2 = im(:,2);
end

% this trick is to compute MRE accurately using the 2D Simpson's rule
% The goal is to evaluate MRE = int(int(MRD(x,y),x,im1,inf),y,im2,inf)
% ------------------------------------------------------------------------
pd=makedist('normal',0,1);
nsig   = 6;
if ~isempty(opt.Sigma) && strcmp(opt.Sigma{1},'overwrite')
    sig1=sig1*opt.Sigma{2};
    sig2=sig2*opt.Sigma{2};
end

maxIM1  = max(max(exp(mu1+nsig*sig1)),1e2*max(im1));
maxIM2  = max(max(exp(mu2+nsig*sig2)),1e2*max(im2));
im1     = logsp(im1(1),maxIM1,Nim)';
im2     = logsp(im2(1),maxIM2,Nim)';
Nim     = length(im1);
[X1,X2] = meshgrid(im1,im2);

mu1   = permute(mu1  ,[2 3 1]);
sig1  = permute(sig1 ,[2 3 1]);
mu2   = permute(mu2  ,[2 3 1]);
sig2  = permute(sig2 ,[2 3 1]);
rate  = permute(rate ,[2 3 1]);

if all(sig1==0) && all(sig2==0)
    on  = ones(Nim0,Nim0);
    MRD = zeros(Nim0,Nim0);
    MRE = zeros(Nim0,Nim0);
    Nscen = size(rate,3);
    for i=1:Nscen
        MREi = NMmin*rate(i)*on;
        MREi(:,log(im(:,1))>mu1(i))=0;
        MREi(log(im(:,2))>mu2(i),:)=0;
        MRE = MRE+MREi;
    end
else
    
    xhat  = (log(X1)-mu1)./sig1;
    fSa1  = 1./(X1.*sig1).*pdf(pd,xhat);
    mu21  = mu2 + rho*sig2.*xhat;          % eq 6
    sig21 = sig2.*sqrt(1-rho^2);           % eq 7
    xhat2 = (log(X2)-mu21)./sig21;         % eq 5
    fSa2  = 1./(X2.*sig21).*pdf(pd,xhat2);
    MRD   = NMmin*nansum(fSa1.*fSa2.*rate,3);  % eq 3
    MRE   = zeros(Nim,Nim);

    for i=1:Nim-1
        for j=1:Nim-1
            xi       = X1(j,i:end);
            xj       = X2(j:end,i);
            MRE(j,i) = trapz(xi,trapz(xj,MRD(j:end,i:end),1));
        end
    end
    [Xo1,Xo2] =meshgrid(im(:,1),im(:,2));
    MRD = interp2(log(X1),log(X2),MRD,log(Xo1),log(Xo2),'spline',nan);
    MRE = interp2(log(X1),log(X2),MRE,log(Xo1),log(Xo2),'spline',nan);
end

% scalar seismic hazard
lambda = zeros(Nim0,2);
for i=1:Nim0
    x       = im(i,1);
    xhat    = (log(x)-mu1)./sig1;
    ccdf1   = 1-cdf(pd,xhat);
    deagg1  = ccdf1.*rate;
    
    x       = im(i,2);
    xhat    = (log(x)-mu2)./sig2;
    ccdf2   = 1-cdf(pd,xhat);
    deagg2  = ccdf2.*rate;
    lambda(i,:) = NMmin*nansum([deagg1,deagg2],3);
end

return

function[lambda,MRE,MRD]=runsource2(source,r0,IM,im,rho,opt,hparam)

gmpe        = source.gmm;
[Nim0,ncols]= size(im);
NMmin       = source.NMmin;
gmpefun     = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);

%% HAZARD INTEGRAL
[mu1,sig1] = gmpefun(IM(1),param{:});
[mu2,sig2] = gmpefun(IM(2),param{:});

NIM   = numel(IM);
Nscen = numel(mu1);
mu    = [mu1,mu2];
sig   = zeros(NIM,NIM,Nscen);
sig(1,1,:)=sig1.^2;
sig(2,1,:)=rho*sig1.*sig2;
sig(1,2,:)=rho*sig1.*sig2;
sig(2,2,:)=sig2.^2;

if ncols==1
    im1 = im(:,1);
    im2 = im(:,1);
else
    im1 = im(:,1);
    im2 = im(:,2);
end

pd=makedist('normal',0,1);
if ~isempty(opt.Sigma) && strcmp(opt.Sigma{1},'overwrite')
    sig1=sig1*opt.Sigma{2};
    sig2=sig2*opt.Sigma{2};
end

Nim     = length(im1);
[X1,X2] = meshgrid(im1,im2);

if all(sig1==0) && all(sig2==0)
    MRD = zeros(Nim,Nim);
    MRE = zeros(Nim,Nim);
else
    MRD = zeros(Nim^2,1);
    MRE = zeros(Nim^2,1);
    X = log([X1(:),X2(:)]);
    J = 1./(X1(:).*X2(:));
    for i=1:Nscen
        MU    = mu(i,:);
        SIG   = sig(:,:,i);
        f     = mvnpdf(X,MU,SIG);
        MRD   = MRD+NMmin*f.*J*rate(i);
        
        f     = mvncdf(-X,-MU,SIG);
        MRE   = MRE+NMmin*f.*rate(i);
    end
    MRD = reshape(MRD,Nim,Nim);
    MRE = reshape(MRE,Nim,Nim);
end


% scalar seismic hazard
lambda = zeros(Nim0,2);
mu1   = permute(mu1  ,[2 3 1]);
sig1  = permute(sig1 ,[2 3 1]);
mu2   = permute(mu2  ,[2 3 1]);
sig2  = permute(sig2 ,[2 3 1]);
rate  = permute(rate ,[2 3 1]);

for i=1:Nim0
    x       = im(i,1);
    xhat    = (log(x)-mu1)./sig1;
    ccdf1   = 1-cdf(pd,xhat);
    deagg1  = ccdf1.*rate;
    x       = im(i,2);
    xhat    = (log(x)-mu2)./sig2;
    ccdf2   = 1-cdf(pd,xhat);
    deagg2  = ccdf2.*rate;
    lambda(i,:) = NMmin*nansum([deagg1,deagg2],3);
end

return

function[lambda,MRE,MRD]=runsource3(source,r0,h,IM,im,rho,opt,hparam)

gmpe         = source.gmm;
[Nim,ncols]  = size(im);
NMmin        = source.NMmin;
gmpefun      = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);

%% MRD using mvnpdf
[mu1,sig1] = gmpefun(IM(1),param{:});
[mu2,sig2] = gmpefun(IM(2),param{:});

NIM   = numel(IM);
Nscen = numel(mu1);
mu    = [mu1,mu2];
sig   = zeros(NIM,NIM,Nscen);
sig(1,1,:)=sig1.^2;
sig(2,1,:)=rho*sig1.*sig2;
sig(1,2,:)=rho*sig1.*sig2;
sig(2,2,:)=sig2.^2;

if ncols==1
    im1 = im(:,1);
    im2 = im(:,1);
else
    im1 = im(:,1);
    im2 = im(:,2);
end

if ~isempty(opt.Sigma) && strcmp(opt.Sigma{1},'overwrite')
    sig1=sig1*opt.Sigma{2};
    sig2=sig2*opt.Sigma{2};
end

[X1,X2] = meshgrid(im1,im2);

if all(sig1==0) && all(sig2==0)
    MRD = zeros(Nim,Nim);
else
    MRD = zeros(Nim^2,1);
    X = log([X1(:),X2(:)]);
    J = 1./(X1(:).*X2(:));
    for i=1:Nscen
        MU    = mu(i,:);
        SIG   = sig(:,:,i);
        f     = mvnpdf(X,MU,SIG);
        MRD   = MRD+NMmin*f.*J*rate(i);
    end
    MRD = reshape(MRD,Nim,Nim);
end

%% MRE using Gauss Copula
MRE      = NaN(Nim,Nim);
RHO      = [1,rho;rho,1];
deaggMin = runhazard2(0,IM(1),h,opt,source,1,1); deaggMin = deaggMin{1}(:,3);
deagg1   = runhazard2(im(:,1),IM(1),h,opt,source,1,1); deagg1 = horzcat(deagg1{:}); deagg1=deagg1(:,3:3:end)./deaggMin;
deagg2   = runhazard2(im(:,2),IM(2),h,opt,source,1,1); deagg2 = horzcat(deagg2{:}); deagg2=deagg2(:,3:3:end)./deaggMin;

for i=1:Nim
    for j=1:Nim
        prob       = [deagg1(:,i),deagg2(:,j)];
        prob_unif  = mvncdf(norminv(prob),[0,0],RHO);
        deagg_unif = prob_unif.*deaggMin.*(prob_unif>=0);
        MRE(j,i)   = sum(deagg_unif);
    end
end

%% scalar seismic hazard
pd     = makedist('normal',0,1);
lambda = zeros(Nim,2);
mu1    = permute(mu1  ,[2 3 1]);
sig1   = permute(sig1 ,[2 3 1]);
mu2    = permute(mu2  ,[2 3 1]);
sig2   = permute(sig2 ,[2 3 1]);
rate   = permute(rate ,[2 3 1]);

for i=1:Nim
    x       = im(i,1);
    xhat    = (log(x)-mu1)./sig1;
    ccdf1   = 1-cdf(pd,xhat);
    deagg1  = ccdf1.*rate;
    x       = im(i,2);
    xhat    = (log(x)-mu2)./sig2;
    ccdf2   = 1-cdf(pd,xhat);
    deagg2  = ccdf2.*rate;
    lambda(i,:) = NMmin*nansum([deagg1,deagg2],3);
end


