function[SPEC,MRZ]=runDSPEC1(T0,periods,h,opt,source,Nsource,epsilon,site_selection)


xyz    = gps2xyz(h.p,opt.ae);
Nsite  = size(xyz,1);
NIM    = length(periods);
ind    = zeros(Nsite,length(source));

for i=site_selection
    ind(i,:)=selectsource(opt.maxdist,xyz(i,:),source);
end

SPEC = nan(Nsite,NIM,Nsource);
MRZ  = nan(Nsite,8  ,Nsource);
for k=site_selection
    ind_k      = ind(k,:);
    sptr       = find(ind_k);
    xyzk       = xyz(k,:);
    media      = h.value(k,:);
    for i=sptr
        if any(source(i).gmm.T>=0)
            [SPEC(k,:,i),MRZ(k,:,i)]=runsource(source(i),xyzk,periods,T0,opt,epsilon,media);
        end
    end
end

return

function [SPEC,MRZ]=runsource(source,xyz,im,IM,opt,epsilon,media)

NIM      = length(im);
SPEC     = zeros(1,NIM);
ae       = opt.ae;
maxdist  = opt.maxdist;
dip      = source.dip;
W        = source.width;
Rmetric  = source.gmm.Rmetric;
Rmetric([1,2,8])=1;
[M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,~,C]=source.pfun(xyz,source,Rmetric,maxdist,ae);
param = gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,source.gmm);
MRZ   = [M,Rrup,Rhyp,Zhyp,C];


%% DEFINES SCENARIO
mu = source.gmm.handle(IM,param{:});
[~,ind]=max(mu);
B  = mGMPEdspec(source.gmm,param);
switch source.gmm.type
    case 'frn'
        Ndepend=length(B);
        for ii=1:Ndepend
            for i=1:length(B{ii})
                if B{ii}(i)
                    param{4+ii}{i}=param{4+ii}{i}(ind);
                end
            end
        end
    otherwise
        for i=1:length(B)
            if B(i)==1 && isnumeric(param{i})
                param{i}=param{i}(ind);
            end
        end
end
MRZ = [MRZ(ind,:),ind];
MRZ(5:7)=xyz2gps(MRZ(:,5:7),ae);

%% COMPUTES RESPONSE SPECTRUM OF CONTROLLING SCENARIOAS

for j=1:NIM
    [mu,sig] = source.gmm.handle(im(j),param{:});
    SPEC(j)  = exp(mu+epsilon*sig);
end
