function[MRD]=runlogictree2V(sys,opt,h,rho,mechlist)

Nsites   = size(h.p,1);
Nim      = size(opt.im,1);
Nbranch  = size(sys.branch,1);
Nsource  = max(sum(sys.Nsrc,1));
MRD      = zeros(Nsites,Nim,Nim,Nsource,Nbranch);
site     = [gps2xyz(h.p,opt.ae),h.value];

for k=1:Nbranch
    fprintf('%g\n',k/Nbranch)
    source  = buildmodelin(sys,sys.branch(k,:),opt);
    for i=1:Nsites
        
        MRD(i,:,:,:,k)=runMRD2(opt.im,opt.IM,site(i,:),opt,source,Nsource,rho,mechlist);
    end
end
