function[deagg,param]=runhazard2full(im,IM,h,opt,source,Nsource,site_selection,OV)

xyz       = gps2xyz(h.p,opt.ae);
Nsite     = size(xyz,1);
NIM       = length(IM);
Nim       = size(im,1);
ind       = zeros(Nsite,length(source));

if isfield(opt,'dflag')
    dflag = opt.dflag;
else
    dflag = [true true false];
end

for i=site_selection
    ind(i,:)=selectsource(opt.maxdist,xyz(i,:),source);
end

deagg  = cell(Nsite,Nim,NIM,Nsource);
if nargout==2
    param  = cell(Nsite,Nim,NIM,Nsource);
end

for k=site_selection
    ind_k      = ind(k,:);
    sptr       = find(ind_k);
    xyzk       = xyz(k,:);
    media      = h.value(k,:);
    for i=sptr
        if nargout==1
            deagg(k,:,:,i)=runsourceDeagg(source(i),xyzk,IM,im,media,opt,dflag);
        else
            [deagg(k,:,:,i),param{k,:,:,i}]=runsourceDeagg(source(i),xyzk,IM,im,media,opt,dflag);
        end
    end
end

% % patch to zero rate of scenarios with distance greater than opt.maxdist
% for i=1:numel(deagg)
%     d   = deagg{i};
%     if ~isempty(d)
%         d(d(:,2)>opt.maxdist,3)=0;
%         deagg{i}=d;
%     end
% end

return

function[deagg,param]=runsourceDeagg(source,xyz,IM,im,media,opt,dflag)

%% RATE OF EARTHQUAKES
NIM   = length(IM);
Nim   = size(im,1);
NMmin = source.NMmin;
ae          = opt.ae;
strunc      = opt.strunc;
PHI         = strunc(4);
maxdist     = opt.maxdist;
dip         = source.dip;
W           = source.width;
Rmetric     = source.gmm.Rmetric;

[M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate]=source.pfun(xyz,source,Rmetric,maxdist,ae);
param = gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,source.gmm);
rate=rate(:);
%% HAZARD INTEGRAL
deagg     = cell(Nim,NIM);

switch source.gmm.type
    case 5
        for j=1:NIM
            switch func2str(source.gmm.handle)
                case 'PCE_nga'     ,[mu,sig] = medianPCEnga(IM(j),param{:});
                case 'PCE_bchydro' ,[mu,sig] = medianPCEbchydro(IM(j),param{:});
            end
            sig = sig.^strunc(2)*strunc(3);
            imj = im(:,j);
            for i=1:Nim
                xhat        = (log(imj(i))-mu)./sig;
                ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
                ccdf        = ccdf.*(ccdf>0);
                dsum        = [M,Rrup,mu];
                deagg{i,j}  = [dsum(:,dflag),NMmin*ccdf.*rate];
            end
        end
        
    otherwise
        for j=1:NIM
            [mu,sig] = source.gmm.handle(IM(j),param{:});
            sig = sig.^strunc(2)*strunc(3);
            imj = im(:,j);
            for i=1:Nim
                xhat        = (log(imj(i))-mu)./sig;
                ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
                ccdf        = ccdf.*(ccdf>0);
                dsum        = [M,Rrup,mu];
                deagg{i,j}  = [dsum(:,dflag),NMmin*ccdf.*rate];
            end
        end        
end

return
