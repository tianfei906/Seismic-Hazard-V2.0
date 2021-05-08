function[deagg]=runhazard3(im,IM,h,opt,source,Ebin)

ellipsoid = opt.ellipsoid;
xyz       = gps2xyz(h.p,ellipsoid);
sigma     = opt.Sigma;

ind     = selectsource(opt.MaxDistance,xyz,source);
sptr    = find(ind);
Nsource = numel(source);
deagg   = cell(Nsource,1);
for i=sptr
    source(i).media = h.value;
    deagg{i}  = runsourceDeagg(source(i),xyz,IM,im,ellipsoid,sigma,h.param);
end

% patch to zero rate of scenarios with distance greater than opt.MaxDistance
for i=1:numel(deagg)
    d   = deagg{i};
    if ~isempty(d)
        d(d(:,2)>opt.MaxDistance,3)=0;
        deagg{i}=d;
    end
end

return

function[deagg]=runsourceDeagg(source,r0,T,im,ellip,sigma,hparam)

gmm    = source.gmm;
NMmin  = source.NMmin;
[param,rate_MR] = source.pfun(r0,source,ellip,hparam);

%% HAZARD INTEGRAL
std_exp   = 1;
sig_overw = 1;
t = makedist('normal');
if ~isempty(sigma)
    switch sigma{1}
        case 'overwrite', std_exp = 0; sig_overw = sigma{2};
        case 'truncate',  t = truncate(t,-6,sigma{2});
    end
else
    t = truncate(t,-6,6);
end

% 2D integral
[mu,sig] = source.gmm.handle(T,param{:});
sig      = sig.^std_exp*sig_overw;
xhat     = (log(im)-mu)./sig;
ccdf     = 1-cdf(t,xhat);
lam2     = sum(NMmin*ccdf.*rate_MR);
epsilon  = linspace(-6,6,101)';
ep1      = epsilon(1:end-1);
ep2      = epsilon(2:end);
epsilon  = 1/2*(ep1+ep2);
Neps     = length(epsilon);

if sig_overw == 1
    rate_e   = cdf(t,ep2)-cdf(t,ep1);
end

if sig_overw ~= 1
    rate_e = zeros(1,Neps);
    rate_e(epsilon==sig_overw)=1;
end

Zhyp = nan(size(param{1}));
switch gmm.type
    case 'regular'
    Mag      = param{1};
    Rup      = param{2};
    if source.gmm.Rmetric(8)
        Zhyp = param{3};
    end
    case 'udm'
    Mag      = param{5};
    Rup      = param{6};
    case 'cond'
    Mag      = param{5};
    Rup      = param{6};
    case 'frn'
    Mag      = param{7}{1};
    Rup      = param{7}{2};
end

NMR    = numel(Mag);
[II,JJ]= meshgrid(1:NMR,1:Neps);
II     = II'; JJ = JJ'; II = II(:); JJ = JJ(:);

rate     = rate_MR(II).*rate_e(JJ);
lnSa     = mu(II)+sig(II).*epsilon(JJ);
ccdf     = (lnSa>=log(im));
deagg    = [Mag(II),Rup(II),Zhyp(II),epsilon(JJ),NMmin*ccdf.*rate]; %that will provide the rates for all possible combinations of M, D, and epsilon

deagg(deagg(:,5)==0,:)=[];
deagg(:,5)=deagg(:,5)/sum(deagg(:,5))*lam2;

return

