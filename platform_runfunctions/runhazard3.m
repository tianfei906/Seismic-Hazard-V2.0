function[deagg]=runhazard3(im,IM,h,opt,source,Ebin)

ae      = opt.ae;
xyz     = gps2xyz(h.p,ae);
ind     = selectsource(opt.maxdist,xyz,source);
sptr    = find(ind);
Nsource = numel(source);
deagg   = cell(Nsource,1);
media   = h.value;
for i=sptr
    deagg{i}  = runsourceDeagg(source(i),xyz,im,IM,media,opt);
end

% patch to zero rate of scenarios with distance greater than opt.maxdist
for i=1:numel(deagg)
    d   = deagg{i};
    if ~isempty(d)
        d(d(:,2)>opt.maxdist,3)=0;
        deagg{i}=d;
    end
end

return

function[deagg]=runsourceDeagg(source,xyz,im,IM,media,opt)

ae      = opt.ae;
strunc  = opt.strunc;
NMmin   = source.NMmin;
Rmetric = source.gmm.Rmetric;
maxdist = opt.maxdist;
dip     = source.dip;
W       = source.width;
Rmetric(8)=1;
[M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate_MR]=source.pfun(xyz,source,Rmetric,maxdist,ae);
param = gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,source.gmm);
rate_MR = rate_MR(:);

%% HAZARD INTEGRAL
std_exp   = strunc(2);
sig_overw = strunc(3);
t = truncate(opt.pd,-6,6);
if strunc(1)==2 %'truncate'
    PHI = strunc(4);
    t   = truncate(t,-6,-norminv(PHI));
end

% 2D integral
[mu,sig] = source.gmm.handle(IM,param{:});
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

NMR    = numel(M);
[II,JJ]= meshgrid(1:NMR,1:Neps);
II     = II'; JJ = JJ'; II = II(:); JJ = JJ(:);

rate     = rate_MR(II).*rate_e(JJ);
lnSa     = mu(II)+sig(II).*epsilon(JJ);
ccdf     = (lnSa>=log(im));
deagg    = [M(II),Rrup(II),Zhyp(II),epsilon(JJ),NMmin*ccdf.*rate]; %that will provide the rates for all possible combinations of M, D, and epsilon

deagg(deagg(:,5)==0,:)=[];
deagg(:,5)=deagg(:,5)/sum(deagg(:,5))*lam2;

return

