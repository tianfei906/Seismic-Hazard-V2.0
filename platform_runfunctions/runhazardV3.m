function[lambda,MRE,MRD]=runhazardV3(im,IM,h,opt,source,Nsource,rho)

xyz        = gps2xyz(h.p,opt.ellipsoid);
[Nim,Ndim] = size(im);
rho        = min(rho,1);
ind        = selectsource(opt.MaxDistance,xyz,source);
sptr       = find(ind);
lambda     = zeros(Nim,Ndim,Nsource);
MRE        = nan(Nim,Nim,Nim,Nsource);
MRD        = nan(Nim,Nim,Nim,Nsource);

if opt.method==1
    for i=sptr
        source(i).media = h.value;
        [lambda(:,:,i),MRE(:,:,:,i),MRD(:,:,:,i)]=runsource1(source(i),xyz,h,IM,im,rho,opt,h.param);
    end
end

if opt.method==2
    for i=sptr
        source(i).media = h.value;
        [lambda(:,:,i),MRE(:,:,:,i),MRD(:,:,:,i)]=runsource2(source(i),xyz,h,IM,im,rho,opt,h.param,0);
    end
end

if opt.method==3
    for i=sptr
        source(i).media = h.value;
        [lambda(:,:,i),MRE(:,:,:,i),MRD(:,:,:,i)]=runsource2(source(i),xyz,h,IM,im,rho,opt,h.param,1);
    end
end

lambda = nansum(lambda,3);
MRE    = nansum(MRE   ,4);
MRD    = nansum(MRD   ,4);

function[lambda,MRE,MRD]=runsource1(source,r0,~,IM,im,rho,opt,hparam) %#ok<*DEFNU>

gmpe         = source.gmm;
[Nim0,Ndim]  = size(im);
NMmin        = source.NMmin;
gmpefun      = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);

switch source.gmm.type
    case 'regular' , Nscen = numel(param{1});
    case 'frn'     , Nscen = numel(param{5}{1});
end

%% HAZARD INTEGRAL
mu  = zeros(Nscen,Ndim);
sii = zeros(Nscen,Ndim);
for i=1:Ndim
    [mu(:,i),sii(:,i)] = gmpefun(IM(i),param{:});
end

sig   = zeros(Ndim,Ndim,Nscen);
for i=1:3
    for j=1:3
        sig(i,j,:)=rho(i,j)*sii(:,i).*sii(:,j);
    end
end

im1 = im(:,1);
im2 = im(:,2);
im3 = im(:,3);

Nim        = length(im1);
[X1,X2,X3] = meshgrid(im1,im2,im3);

if all(sig(:)==0)
    MRD = zeros(Nim,Nim,Nim);
    MRE = zeros(Nim,Nim,Nim);
else
    MRD = zeros(Nim^3,Nscen);
    MRE = zeros(Nim^3,Nscen);
    X = log([X1(:),X2(:),X3(:)]);
    J = 1./(X1(:).*X2(:).*X3(:));
    for i=1:Nscen
        MU   = mu(i,:);
        SIG  = sig(:,:,i);
        f    = mvnpdf(X,MU,SIG);     MRD(:,i) = NMmin*f.*J*rate(i);
        f    = mvncdf(-X,-MU,SIG);   MRE(:,i) = NMmin*f*rate(i);
    end

    MRD = reshape(sum(MRD,2),Nim,Nim,Nim);
    MRE = reshape(sum(MRE,2),Nim,Nim,Nim);
end
lambda = nan(Nim0,Ndim);

return

function[lambda,MRE,MRD]=runsource2(source,r0,h,IM,im,rho,opt,hparam,appc) %#ok<*DEFNU>

gmpe         = source.gmm;
[Nim0,Ndim]  = size(im);
NMmin        = source.NMmin;
gmpefun      = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);

switch source.gmm.type
    case 'regular' , Nscen = numel(param{1});
    case 'frn'     , Nscen = numel(param{5}{1});
end

%% MRD using mvnpdf
mu  = zeros(Nscen,Ndim);
sii = zeros(Nscen,Ndim);
for i=1:Ndim
    [mu(:,i),sii(:,i)] = gmpefun(IM(i),param{:});
end

sig   = zeros(Ndim,Ndim,Nscen);
for i=1:3
    for j=1:3
        sig(i,j,:)=rho(i,j)*sii(:,i).*sii(:,j);
    end
end

r    = exp(mean(diff(log(im))));
im   = [im;im(end,:).*(r.^[1;2;3])];
im1  = im(:,1);
im2  = im(:,2);
im3  = im(:,3);

Nim        = length(im1);
[X1,X2,X3] = meshgrid(im1,im2,im3);
if all(sig(:)==0)
    MRD = zeros(Nim,Nim,Nim);
else
    MRD = zeros(Nim^3,1);
    X = log([X1(:),X2(:),X3(:)]);
    J = 1./(X1(:).*X2(:).*X3(:));
    for i=1:Nscen
        MU    = mu(i,:);
        SIG   = sig(:,:,i);
        f     = mvnpdf(X,MU,SIG);
        MRD   = MRD+NMmin*f.*J*rate(i);
    end
    MRD = reshape(MRD,Nim,Nim,Nim);
end

%% Compute MRE at min(im1) and min(im2) MVN
if appc
    [Xo1,Xo2,Xo3] = meshgrid(im(1,1),im(1,2),im(1:Nim0,3));
    CCDF = zeros(Nim0,Nscen);
    X    = log([Xo1(:),Xo2(:),Xo3(:)]);
    parfor k=1:Nscen
        disp(k)
        MU   = mu(k,:);
        SIG  = sig(:,:,k);
        CCDF(:,k)= mvncdf(-X,-MU,SIG);
    end
    MRE0  = NMmin*CCDF*rate;
end
%% MRE using Trapezodal Rule
MRE     = NaN(Nim0,Nim0,Nim0);
logx1   = log(im1);
logx2   = log(im2);
logx3   = log(im3);
F       = X1.*X2.*X3.*MRD;
for i=1:Nim0
    xi = logx1(i:end);
    for j=1:Nim0
        xj = logx2(j:end);
        for k=1:Nim0
            xk = logx3(k:end);
            Fijk = F(j:end,i:end,k:end);
            MRE(j,i,k) = trapz(xi,trapz(xj,trapz(xk,Fijk,3),1));
        end
    end
end

% apply correction
if appc
    for k=1:Nim0
        if MRE0(k)~=0
            MRE(:,:,k)=MRE(:,:,k)*MRE0(k)/MRE(1,1,k);
        end
    end
end
MRD=MRD(1:Nim0,1:Nim0,1:Nim0);

%% scalar seismic hazard
lambda = nan(Nim0,Ndim);

