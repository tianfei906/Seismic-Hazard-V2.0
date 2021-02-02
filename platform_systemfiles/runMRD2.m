function[MRD]=runMRD2(im,IM,h,opt,source,Nsource,rho,varargin)

xyz    = gps2xyz(h.p,opt.ellipsoid);
Nim    = size(im,1);
rho    = min(rho,1);
ind    = selectsource(opt.MaxDistance,xyz,source);
sptr   = find(ind);
MRD    = nan(Nim,Nim,Nsource);

if nargin==7
    for i=sptr
        source(i).media = h.value;
        MRD(:,:,i)  =runsource(source(i),xyz,IM,im,rho,opt,h.param);
    end
else % this option runs only the sources listed in varargin{1}, this is used in the PSDA & LIBS to pre-compute vector-valued hazard
    mechlist=varargin{1};
    for i=sptr
        if any(source(i).numgeom(1)==mechlist)
            source(i).media = h.value;
            MRD(:,:,i)  =runsource(source(i),xyz,IM,im,rho,opt,h.param);
        end
    end
end

function[MRD]=runsource(source,r0,IM,im,rho,opt,hparam)

gmpe         = source.gmm;
NMmin        = source.NMmin;
gmpefun      = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);
[mu1,sig1]   = gmpefun(IM(1),param{:});
[mu2,sig2]   = gmpefun(IM(2),param{:});

NIM   = numel(IM);
Nscen = numel(mu1);
mu    = [mu1,mu2];
sig   = zeros(NIM,NIM,Nscen);
sig(1,1,:)=sig1.^2;
sig(2,1,:)=rho*sig1.*sig2;
sig(1,2,:)=rho*sig1.*sig2;
sig(2,2,:)=sig2.^2;

im1 = im(:,1);
im2 = im(:,2);

if ~isempty(opt.Sigma) && strcmp(opt.Sigma{1},'overwrite')
    sig1=sig1*opt.Sigma{2};
    sig2=sig2*opt.Sigma{2};
end

Nim     = length(im1);
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
