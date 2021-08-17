function[deagg,param]=runhazard2(im,IM,h,opt,source)

xyz   = gps2xyz(h.p,opt.ae);
media = h.value;
if isfield(opt,'dflag')
    dflag = opt.dflag;
else
    dflag = [true true false];
end

ind     = selectsource(opt.maxdist,xyz,source);
sptr    = find(ind);
Nsource = numel(source);
deagg   = cell(Nsource,1);
if nargout==2
    param  = cell(Nsource,1);
end


for i=sptr
    if nargout==1
        deagg{i}=           runsourceDeagg(source(i),im,IM,xyz,media,opt,dflag);
    else
        [deagg{i},param{i}]=runsourceDeagg(source(i),im,IM,xyz,media,opt,dflag);
    end
end

% patch to zero rate of scenarios with distance greater than opt.maxdist
for i=1:Nsource
    d   = deagg{i};
    if ~isempty(d)
        d(d(:,2)>opt.maxdist,3)=0;
        deagg{i}=d;
    end
end

return

function[deagg,param]=runsourceDeagg(source,im,IM,xyz,media,opt,dflag)

%% RATE OF EARTHQUAKES
ae      = opt.ae;
maxdist = opt.maxdist;
NMmin   = source.NMmin;
Rmetric = source.gmm.Rmetric;
dip     = source.dip;
W       = source.width;
strunc  = opt.strunc;
PHI     = strunc(4);

[M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate]=source.pfun(xyz,source,Rmetric,maxdist,ae);
param = gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,source.gmm);

switch source.gmm.type
    case 'pce'
        switch func2str(source.gmm.handle)
            case 'PCE_nga'     ,[mu,sig] = medianPCEnga(IM,param{:});
            case 'PCE_bchydro' ,[mu,sig] = medianPCEbchydro(IM,param{:});
        end
        sig      = sig.^strunc(2)*strunc(3);
        xhat   = (log(im)-mu)./sig;
        ccdf   = 1-cdf(t,xhat);
        dsum   = [M,Rrup,mu];
        deagg  = [dsum(:,dflag),NMmin*ccdf.*rate];
        
        
    otherwise
        [mu,sig] = source.gmm.handle(IM,param{:});
        sig      = sig.^strunc(2)*strunc(3);
        xhat     = (log(im)-mu)./sig;
        ccdf     = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
        ccdf     = ccdf.*(ccdf>0);
        dsum     = [M,Rrup,mu];
        deagg    = [dsum(:,dflag),NMmin*ccdf.*rate(:)];
        if nargout==1
            deagg(deagg(:,3)==0,:)=[];
        end
end
