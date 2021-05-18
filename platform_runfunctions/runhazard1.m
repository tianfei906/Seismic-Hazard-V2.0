function[MRE]=runhazard1(im,IM,h,opt,source,Nsource,site_selection)
% runs a single branch of the logic tree for GMM's of type 'regular','cond','udm'

xyz    = gps2xyz(h.p,opt.ellipsoid);
Nsite  = size(xyz,1);
NIM    = length(IM);
Nim    = size(im,1);
ind    = zeros(Nsite,length(source));

for i=site_selection
    ind(i,:)=selectsource(opt.MaxDistance,xyz(i,:),source);
end

switch opt.SourceDeagg
    case 'on'
        MRE       = nan(Nsite,Nim,NIM,Nsource);
        for k=site_selection
            ind_k      = ind(k,:);
            sptr       = find(ind_k);
            xyzk       = xyz(k,:);
            valuek      = h.value(k,:);
            for i=sptr
                source(i).media = valuek;
                MRE(k,:,:,i)=runsource(source(i),xyzk,IM,im,opt,h.param);
            end
        end
    case 'off'
        MRE       = zeros(Nsite,Nim,NIM);
        for k=site_selection
            fprintf('%g\n',k)
            ind_k      = ind(k,:);
            sptr       = find(ind_k);
            xyzk       = xyz(k,:);
            valuek     = h.value(k,:);
            for i=sptr
                source(i).media=valuek;
                dMRE = runsource(source(i),xyzk,IM,im,opt,h.param);
                dMRE = permute(dMRE,[3,1,2]);
                dMRE(isnan(dMRE))=0;
                MRE(k,:,:)= MRE(k,:,:)+dMRE;
            end
        end
end

return

function MRE=runsource(source,r0,IM,im,opt,hparam)

%% MAGNITUDE RATE OF EARTHQUAKES
ellip        = opt.ellipsoid;
sigma        = opt.Sigma;
MaxDistance  = opt.MaxDistance;

NIM          = length(IM);
Nim          = size(im,1);
NMmin        = source.NMmin;
[param,rate] = source.pfun(r0,source,ellip,hparam);

rate(param{2}>MaxDistance)=0;

MRE          = zeros(Nim,NIM);
std_exp      = 1;
sig_overw    = 1;

PHI       = 0;
if ~isempty(sigma)
    switch sigma{1}
        case 'overwrite', std_exp = 0; sig_overw = sigma{2};
        case 'truncate' , PHI = 0.5*(1-erf(sigma{2}/sqrt(2)));
    end
end

for j=1:NIM
    [mu,sig,tau,phi] = source.gmm.handle(IM(j),param{:}); %#ok<ASGLU>
    sig = sig.^std_exp*sig_overw;
    imj = im(:,j);
    
    for i=1:Nim
        x           = imj(i);
        xhat        = (log(x)-mu)./sig;
        ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
        deagg       = ccdf.*rate.*(ccdf>0);
        MRE(i,j)    = NMmin*nansum(deagg);
    end
end

