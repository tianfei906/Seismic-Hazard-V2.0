function[deagg,param]=runhazard2(im,IM,h,opt,source)

xyz       = gps2xyz(h.p,opt.ellipsoid);

if isfield(opt,'dflag')
    dflag = opt.dflag;
else
    dflag = [true true false];
end

ind     = selectsource(opt.MaxDistance,xyz,source);
sptr    = find(ind);
Nsource = numel(source);
deagg   = cell(Nsource,1);
if nargout==2
    param  = cell(Nsource,1);
end

for i=sptr
    source(i).media=h.value;
    if nargout==1
        deagg{i}=           runsourceDeagg(source(i),xyz,IM,im,opt.ellipsoid,opt.Sigma,h.param,dflag);
    else
        [deagg{i},param{i}]=runsourceDeagg(source(i),xyz,IM,im,opt.ellipsoid,opt.Sigma,h.param,dflag);
    end
end

% patch to zero rate of scenarios with distance greater than opt.MaxDistance
for i=1:Nsource
    d   = deagg{i};
    if ~isempty(d)
        d(d(:,2)>opt.MaxDistance,3)=0;
        deagg{i}=d;
    end
end

return

function[deagg,param]=runsourceDeagg(source,r0,IM,im,ellip,sigma,hparam,dflag)

%% RATE OF EARTHQUAKES
NMmin = source.NMmin;
[param,rate] = source.pfun(r0,source,ellip,hparam);
std_exp   = 1;
sig_overw = 1;

t = makedist('normal');
if ~isempty(sigma)
    switch sigma{1}
        case 'overwrite', std_exp = 0; sig_overw = sigma{2}; 
        case 'truncate' , t = truncate(t,-inf,sigma{2});
    end
end

switch source.gmm.type
    case 'regular'
        Mag  = param{1};
        Rrup = param{2};
    case 'udm'
        Mag  = param{5};
        Rrup = param{6};
    case 'cond'
        Mag  = param{1};
        Rrup = param{2};
    case 'pce'
        Mag  = param{1};
        Rrup = param{2};        
    case 'frn'
        Mag  = param{6}{1};
        Rrup = param{6}{2};             
end

switch source.gmm.type
    case 'pce'
        switch func2str(source.gmm.handle)
            case 'PCE_nga'     ,[mu,sig] = medianPCEnga(IM,param{:});
            case 'PCE_bchydro' ,[mu,sig] = medianPCEbchydro(IM,param{:});
        end
        sig    = sig.^std_exp*sig_overw;
        xhat   = (log(im)-mu)./sig;
        ccdf   = 1-cdf(t,xhat);
        dsum   = [Mag,Rrup,mu];
        deagg  = [dsum(:,dflag),NMmin*ccdf.*rate];
        
        
    otherwise
        [mu,sig] = source.gmm.handle(IM,param{:});
        sig   = sig.^std_exp*sig_overw;
        xhat  = (log(im)-mu)./sig;
        ccdf   = 1-cdf(t,xhat);
        dsum  = [Mag,Rrup,mu];
        deagg = [dsum(:,dflag),NMmin*ccdf.*rate];
        if nargout==1
            deagg(deagg(:,3)==0,:)=[];
        end
end
