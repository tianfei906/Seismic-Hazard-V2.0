function[MRE,MREPCE]=runlogictree1T(sys,opt,h,sitelist)

%% variable initialization
im        = opt.im;
IM        = opt.IM;
site      = [gps2xyz(h.p(sitelist,:),opt.ae),h.value(sitelist,:)];
maxdist   = opt.maxdist;
ae        = opt.ae;
Nsites    = size(site,1);
Nim       = size(im,1);
NIM       = length(IM);
strunc    = opt.strunc;
sdeagg    = opt.SourceDeagg;
Nsource   = max(sum(sys.Nsrc,1))^sdeagg;
Nbranch   = size(sys.branch,1);

%% branch groups with same geometry and M-R relation
umr   = unique(sys.branch(:,[1,3]),'rows','stable');
Numr  = size(umr,1);
[~,b] = intersect(sys.branch(:,[1,3]),umr,'rows');
mlist = [b,[b(2:end)-1;Nbranch]];
mdims   = [Nim,NIM,Nsource,mlist(1,2)];
%% run logic tree
MRE     = nan (Nsites,Nim,NIM,Nsource,Nbranch);
if ~isempty(sys.isREG)
    for j=1:Numr
        jj = mlist(j,1):mlist(j,2);
        sources = buildmodelin(sys,sys.branch(jj,:),opt);
        Rmetric = any(vertcat(sources(1).gmm.Rmetric),1);
        
        for i=1:Nsites
            MRE(i,:,:,:,jj) = runhazard1T(im,IM,sources,site(i,:),maxdist,strunc,mdims,Rmetric,sdeagg,ae);
            if mod(i,100)==0
                disp(i)
            end
        end
%         save MRE7 MRE
%         1
    end
end


MREPCE  = cell(1,Nbranch);
for i=sys.isPCE
    sources = buildmodelin(sys,sys.branch(i,:),opt);
    MREPCE{i}=runhazard1PCE(im,IM,h,opt,sources,Nsource,sitelist);
end


