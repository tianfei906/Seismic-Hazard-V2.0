function[MRE]=runhazard1T(im,IM,sources,site,maxdist,strunc,mdims,Rmetric,sdeagg,ae)

ind = find(selectsource(maxdist,site(1:3),sources));

if sdeagg
    MRE       = zeros(mdims([3 1 2 4]));
    for i=ind
        MRE(i,:,:,:)=runsource(im,IM,sources(i),site,maxdist,strunc,Rmetric,ae);
    end
    MRE = permute(MRE,[2 3 1 4]);
else
    MRE       = zeros(mdims([1 2 4]));
    for i=ind
        MRE = MRE+runsource(im,IM,sources(i),site,maxdist,strunc,Rmetric,ae);
    end    
    MRE = permute(MRE,[1 2 4 3]);
end

end

function MRE=runsource(im,IM,source,site,maxdist,strunc,Rmetric,ae)

%% MAGNITUDE RATE OF EARTHQUAKES

NIM    = length(IM);
Nim    = size(im,1);
NMmin  = source.NMmin;
xyz    = site(1:3);
media  = site(4:end);
Ngmm   = numel(source.gmm);
dip    = source.dip;
W      = source.width;
MRE    = nan([Nim,NIM,Ngmm]);
PHI    = strunc(4);

[M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate]=source.pfun(xyz,source,Rmetric,maxdist,ae);
if isempty(M)
    return
end
for k = 1:Ngmm
    param = gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,source.gmm(k));
    fun   = source.gmm(k).handle;
    for j=1:NIM
        [mu,sig] = fun(IM(j),param{:});
        sig = sig.^strunc(2)*strunc(3);
        imj = im(:,j);
        for i=1:Nim
            x           = imj(i);
            xhat        = (log(x)-mu)./sig;
            ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
            deagg       = ccdf.*(ccdf>0);
            MRE(i,j,k)  = NMmin*rate*deagg;
        end
    end
end
end


