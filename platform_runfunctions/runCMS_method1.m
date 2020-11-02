function cmsdata=runCMS_method1(sys,opt,h)

% set up data
model_ptr   = opt.model_ptr;
Tcond       = opt.Tcond;
T           = opt.T;
Tr          = opt.Tr;
Rbin        = opt.Rbin;
Mbin        = opt.Mbin;
cfun        = opt.cfun;

Tcond_ptr   = T==Tcond;
col         = find(opt.IM>=0);
im1         = repmat(opt.im(:,col(1)),1,length(T));
branch      = sys.branch(model_ptr,1:3);
geom_ptr    = branch(1);
Nsource     = sum(sys.Nsrc(:,geom_ptr));

% compute seismic hazard for all Sa(T*)
sources = buildmodelin(sys,branch,opt);
lambda1 = runhazard1(im1,T,h,opt,sources,Nsource,1);
lambda1 = sum(lambda1,4);
lambda1 = permute(lambda1,[2 3 1]);

% compute Hazard Deagregation for T* at Return Period Tr
im2     = robustinterp(lambda1(:,Tcond_ptr),im1(:,Tcond_ptr),1/Tr,'loglog');
opt2    = opt;
opt2.im = im2;
opt2.IM = Tcond;

[deagg2,param] = runhazard2(im2,Tcond,h,opt2,sources,Nsource,1);
cmsdata        = run_funcCMS(Rbin,Mbin,sources,deagg2,param);

% compute UHS
uhs  = uhspectrum(opt.im,lambda1,1/Tr);

% compute GMPE prediction
mu  = zeros(size(uhs));
sig = zeros(size(uhs));
for j=1:length(T)
    [mu(j),sig(j)] = cmsdata.gmmfun(T(j),cmsdata.param{:});
end

% Step 4: compute e*
eTs = (log(uhs(Tcond_ptr))-mu(Tcond_ptr))/sig(Tcond_ptr);

% Step 5: compute ebar
rho     = zeros(size(T));
methods = pshatoolbox_methods(4,cfun);
func    = methods.func;
Cond_param.opp       = 0;
Cond_param.mechanism = cmsdata.mech;
Cond_param.sof       = cmsdata.sof;
Cond_param.M         = cmsdata.M;
Cond_param.residual  = 'phi';
Cond_param.direction = 'horizontal';

for i=1:length(rho)
    rho(i)  = func(Tcond,T(i),Cond_param);
end

% Step 6: compute cms
sigCMS  = sig.*sqrt(1-rho.^2);
epsCMS  = 1.0; % can be changed to something else;
lncms   = mu+eTs*rho.*sig;
lncmss1 = lncms+epsCMS*sigCMS;
lncmss2 = lncms-epsCMS*sigCMS;
cms     = exp(lncms);
cmss1   = exp(lncmss1);
cmss2   = exp(lncmss2);

%% build output
cmsdata.im     = im1(:,Tcond_ptr);
cmsdata.lambda = lambda1(:,Tcond_ptr);
cmsdata.T      = T;
cmsdata.CMS    = [cms,cmss1,cmss2];
cmsdata.CMSk   = [];
cmsdata.RHO    = rho;
cmsdata.UHS    = uhs;
cmsdata.sigCMS = sigCMS;


