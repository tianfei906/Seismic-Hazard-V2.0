function[MRD,Pm]=runlogictree3V(sys,opt,h,rho,mechlist)

Nsites   = size(h.p,1);
Nim      = size(opt.im,1);
Nbranch  = size(sys.branch,1);
Nsource  = max(sum(sys.Nsrc,1));
MRD      = zeros(Nsites,Nim,Nim,Nim,Nsource,Nbranch);
Pm       = cell(Nsites,Nsource,Nbranch);


for k=1:Nbranch
    fprintf('%g\n',k/Nbranch)
    source  = buildmodelin(sys,sys.branch(k,:),opt);
    for i=1:Nsites
        hi.p     = h.p(i,:);
        hi.param = h.param;
        hi.value = h.value(i,:);
        [MRD(i,:,:,:,:,k),Pm(i,:,k)]=runMRD3(opt.im,opt.IM,hi,opt,source,Nsource,rho,mechlist);
    end
end
