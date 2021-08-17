function[MRE]=runhazard1(im,IM,h,opt,source,Nsource,site_selection)


xyz    = gps2xyz(h.p,opt.ae);
Nsite  = size(xyz,1);
NIM    = length(IM);
Nim    = size(im,1);
ind    = zeros(Nsite,length(source));

for i=site_selection
    ind(i,:)=selectsource(opt.maxdist,xyz(i,:),source);
end

switch opt.SourceDeagg
    case true
        MRE       = nan(Nsite,Nim,NIM,Nsource);
        for k=site_selection
            ind_k      = ind(k,:);
            sptr       = find(ind_k);
            xyzk       = xyz(k,:);
            valuek      = h.value(k,:);
            for i=sptr
                MRE(k,:,:,i)=runsource(source(i),xyzk,im,IM,valuek,opt);
            end
        end
    case false
        MRE       = zeros(Nsite,Nim,NIM);
        for k=site_selection
            ind_k      = ind(k,:);
            sptr       = find(ind_k);
            xyzk       = xyz(k,:);
            valuek     = h.value(k,:);
            for i=sptr
                dMRE = runsource(source(i),xyzk,im,IM,valuek,opt);
                dMRE = permute(dMRE,[3,1,2]);
                dMRE(isnan(dMRE))=0;
                MRE(k,:,:)= MRE(k,:,:)+dMRE;
            end
        end
end

return

function MRE=runsource(source,xyz,im,IM,media,opt)

%% MAGNITUDE RATE OF EARTHQUAKES
ae        = opt.ae;
strunc    = opt.strunc;
PHI       = strunc(4);
maxdist   = opt.maxdist;
NIM       = length(IM);
Nim       = size(im,1);
NMmin     = source.NMmin;
dip       = source.dip;
W         = source.width;
Rmetric   = source.gmm.Rmetric;
[M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate]=source.pfun(xyz,source,Rmetric,maxdist,ae);
param = gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,source.gmm);

MRE     = zeros(Nim,NIM);
strunc  = opt.strunc;

for j=1:NIM
    [mu,sig] = source.gmm.handle(IM(j),param{:});
    sig = sig.^strunc(2)*strunc(3);
    imj = im(:,j);
    
    for i=1:Nim
        x           = imj(i);
        xhat        = (log(x)-mu)./sig;
        ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
        deagg       = ccdf.*(ccdf>0);
        MRE(i,j)    = NMmin*rate*deagg;
    end
end

