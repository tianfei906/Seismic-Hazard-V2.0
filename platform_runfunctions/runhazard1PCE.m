function[MRE]=runhazard1PCE(im,IM,h,opt,source,Nsource,site_selection)
% runs a single branch of the logic tree for GMM's of type 'pce'

RandType  = opt.PCE{1};
pce       = strcmp(opt.PCE{2},'PC');
mcs       = ~pce;
Nreal     = opt.PCE{3};
ae        = opt.ae;
xyz       = gps2xyz(h.p,ae);
Nsite     = size(xyz,1);
NIM       = length(IM);
Nim       = size(im,1);
MRE       = nan(Nsite,Nim,NIM,Nsource,Nreal);

ind  = zeros(Nsite,Nsource);
for i=site_selection
    ind(i,:)=selectsource(opt.maxdist,xyz(i,:),source);
end

% set random numer generator (rng)
s=rng;
rng(RandType);

for k=site_selection
    ind_k      = ind(k,:);
    sptr       = find(ind_k);
    xyzk       = xyz(k,:);
    media      = h.value(k,:);
   
    for i=sptr
        if pce, [MRE(k,:,:,i,:)]=runPCE(source(i),xyzk,IM,im,Nreal,opt,media);end
        if mcs, [MRE(k,:,:,i,:)]=runMCS(source(i),xyzk,IM,im,Nreal,opt,media);end
    end
end

% restores rng
rng(s);

return

