function[deagg,param]=runhazard2(im,IM,h,opt,source,Nsource,site_selection,OV)

xyz       = gps2xyz(h.p,opt.ellipsoid);
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
    ind(i,:)=selectsource(opt.MaxDistance,xyz(i,:),source);
end

deagg  = cell(Nsite,Nim,NIM,Nsource);
if nargout==2
    param  = cell(Nsite,Nim,NIM,Nsource);
end
for k=site_selection
    ind_k      = ind(k,:);
    sptr       = find(ind_k);
    xyzk       = xyz(k,:);
    valuek     = h.value(k,:);
    for i=sptr
        source(i).media=valuek;
        if nargout==1
            deagg(k,:,:,i)=runsourceDeagg(source(i),xyzk,IM,im,opt.ellipsoid,opt.Sigma,h.param,dflag);
        else
            [deagg(k,:,:,i),param{k,:,:,i}]=runsourceDeagg(source(i),xyzk,IM,im,opt.ellipsoid,opt.Sigma,h.param,dflag);
        end
    end
end


return

function[deagg,param]=runsourceDeagg(source,r0,IM,im,ellip,sigma,hparam,dflag)

%% RATE OF EARTHQUAKES
NIM   = length(IM);
Nim   = size(im,1);
NMmin = source.NMmin;
[param,rate] = source.pfun(r0,source,ellip,hparam);

%% HAZARD INTEGRAL
deagg     = cell(Nim,NIM);
std_exp   = 1;
sig_overw = 1;
PHI       = 0;
if ~isempty(sigma)
    switch sigma{1}
        case 'overwrite', std_exp = 0; sig_overw = sigma{2};
        case 'truncate' , PHI = 0.5*(1-erf(sigma{2}/sqrt(2)));
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
        for j=1:NIM
            switch func2str(source.gmm.handle)
                case 'PCE_nga'     ,[mu,sig] = medianPCEnga(IM(j),param{:});
                case 'PCE_bchydro' ,[mu,sig] = medianPCEbchydro(IM(j),param{:});
            end
            sig = sig.^std_exp*sig_overw;
            imj = im(:,j);
            for i=1:Nim
                xhat        = (log(imj(i))-mu)./sig;
                ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
                ccdf        = ccdf.*(ccdf>0);
                dsum        = [Mag,Rrup,mu];
                deagg{i,j}  = [dsum(:,dflag),NMmin*ccdf.*rate];
            end
        end
        
    otherwise
        for j=1:NIM
            [mu,sig] = source.gmm.handle(IM(j),param{:});
            
            % convert geomean to maxdir, this code is only temporary
            %--------------------------------------
            amp = gm2max(IM(j));
            mu  = mu+log(amp);
            %--------------------------------------
            
            sig = sig.^std_exp*sig_overw;
            imj = im(:,j);
            for i=1:Nim
                xhat        = (log(imj(i))-mu)./sig;
                ccdf        = (0.5*(1-erf(xhat/sqrt(2)))-PHI)*1/(1-PHI);
                ccdf        = ccdf.*(ccdf>0);
                dsum        = [Mag,Rrup,mu];
                deagg{i,j}  = [dsum(:,dflag),NMmin*ccdf.*rate];
            end
        end        
end

return

