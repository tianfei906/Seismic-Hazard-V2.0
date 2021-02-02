function[MRD,Pm]=runMRD3(im,IM,h,opt,source,Nsource,rho,varargin)

xyz    = gps2xyz(h.p,opt.ellipsoid);
Nim    = size(im,1);
rho    = min(rho,1);
ind    = selectsource(opt.MaxDistance,xyz,source);
sptr   = find(ind);
MRD    = nan(Nim,Nim,Nim,Nsource);
Pm     = cell(1,Nsource);


if nargin==7
    for i=sptr
        source(i).media = h.value;
        MRD(:,:,:,i)=runsource(source(i),xyz,IM,im,rho,opt,h.param);
    end
else % this option runs only the sources listed in varargin{1}, this is used in the PSDA & LIBS to pre-compute vector-valued hazard
    mechlist=varargin{1};
    for i=sptr
        if any(source(i).numgeom(1)==mechlist)
            source(i).media = h.value;
            [MRD(:,:,:,i),Pm{i}]=runsource(source(i),xyz,IM,im,rho,opt,h.param);
        end
    end
end


function[MRD,Pm]=runsource(source,r0,IM,im,rho,opt,hparam) %#ok<*DEFNU>

gmpe         = source.gmm;
[Nim0,Ndim]  = size(im);
NMmin        = source.NMmin;
gmpefun      = gmpe.handle;
[param,rate] = source.pfun(r0,source,opt.ellipsoid,hparam);

switch source.gmm.type
    case 'regular' , M = param{1};
    case 'frn'     , M = param{5}{1};
end
Nscen   = numel(M);

[Mk,~,B]= unique(M,'stable');
Nmk     = length(Mk);

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
    MRD  = zeros(Nim^3,1);
    MRDm = zeros(Nim^3,Nmk);
    X = log([X1(:),X2(:),X3(:)]);
    J = 1./(X1(:).*X2(:).*X3(:));
    for i=1:Nscen
        MU    = mu(i,:);
        SIG   = sig(:,:,i);
        f     = mvnpdf(X,MU,SIG);
        MRD   = MRD+NMmin*f.*J*rate(i);
    end
    MRD = reshape(MRD,Nim,Nim,Nim);
    MRD = MRD(1:Nim0,1:Nim0,1:Nim0);
end

%% Computation of P(M|im2) term
if 0
    for kk=1:Nmk
        scenk = find(B==kk)';
        for i=scenk
            MU    = mu(i,:);
            SIG   = sig(:,:,i);
            f     = mvnpdf(X,MU,SIG);
            MRDm(:,kk) = MRDm(:,kk) + NMmin*f.*J*rate(i);
        end
    end
    
    Pm      = NaN(Nim0,Nmk);
    logx1   = log(im1);
    logx2   = log(im2);
    logx3   = log(im3);
    
    for kk=1:Nmk
        MRDmk   = reshape(MRDm(:,kk),Nim,Nim,Nim);
        F       = X1.*X2.*X3.*MRDmk;
        for j=1:Nim0
            xj = logx2(j:end);
            Fijk = F(j:end,:,:);
            Pm(j,kk) = trapz(logx1,trapz(xj,trapz(logx3,Fijk,3),1));
        end
    end
    Pm  = Pm./sum(Pm,2);
end
%% Computation of P(M|im1,im2,im3) term
if 1
    for kk=1:Nmk
        scenk = find(B==kk)';
        for i=scenk
            MU    = mu(i,:);
            SIG   = sig(:,:,i);
            f     = mvnpdf(X,MU,SIG);
            MRDm(:,kk) = MRDm(:,kk) + NMmin*f.*J*rate(i);
        end
    end
    
    Pm     = NaN(Nim0,Nim0,Nim0,Nmk);
    logx1   = log(im1);
    logx2   = log(im2);
    logx3   = log(im3);
    tic
    for l=1:Nmk
        F  = X1.*X2.*X3.*reshape(MRDm(:,l),Nim,Nim,Nim);
        for i=1:Nim0
            xi = logx1(i:end);
            for j=1:Nim0
                xj = logx2(j:end);
                for k=1:Nim0
                    xk = logx3(k:end);
                    Fijk = F(j:end,i:end,k:end);
                    Pm(j,i,k,l) = trapz(xi,trapz(xj,trapz(xk,Fijk,3),1));
                end
            end
        end
    end
    toc
    Pm  = Pm./sum(Pm,4);
end

