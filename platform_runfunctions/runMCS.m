function[MRE,Cz]=runMCS(source,r0,IM,im,Nreal,ellip,hparam)

pd   = makedist('Normal');
t    = truncate(pd,-2,2);
zrnd = random(t,1,Nreal);
Cz   = []; % dummy variable
gmpe     = source.gmm;
NIM      = length(IM);
Nim      = size(im,1);
NMmin    = source.NMmin;
gmpefun  = gmpe.handle;
[param,rate] = source.pfun(r0,source,ellip,hparam);

%% HAZARD INTEGRAL
MRE   = zeros(Nim,NIM,Nreal);

for j=1:NIM
    [lnY,sigma] = gmpefun(IM(j),param{:});
    mu          = mean(lnY,1);
    smu         = std (lnY,0,1);
    lnzi        = log(im(:,j));
    
    MCS = zeros(Nim, Nreal);
    MU  = bsxfun(@plus,mu,zrnd'*smu)';
    for i = 1:Nim
        xhat = bsxfun(@times,lnzi(i)-MU,1./sigma);
        ccdf = 0.5*(1-erf(xhat/sqrt(2)));
        MCS(i,:) = NMmin* rate'*ccdf;
    end
    MRE(:,j,:)=MCS;
    
end
