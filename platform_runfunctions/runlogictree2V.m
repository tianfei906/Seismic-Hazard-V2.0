function[MRD]=runlogictree2V(sys,opt,h,rho,mechlist)

site     = h.p;
VS30     = h.VS30;
ShearMod = opt.ShearModulus;

% figure out MRD size
Nsites  = size(site,1);
Nim     = size(opt.im,1);
Nbranch = size(sys.branch,1);
Nsource = max(sum(sys.Nsrc,1));
MRD     = zeros(Nsites,Nim,Nim,Nsource,Nbranch);


for k=1:Nbranch
    fprintf('%g\n',k/Nbranch)
    source  = buildmodelin(sys,sys.branch(k,:),ShearMod);
    for i=1:Nsites
        [~,~,MRD(i,:,:,:,k)]=runhazardV1(opt.im,opt.IM,site(i,:),VS30(i),opt,source,Nsource,rho,mechlist);
    end
end
