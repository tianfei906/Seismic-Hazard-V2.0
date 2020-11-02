function cmsdata=runCMS_method2(sys,opt,h)

% set up data
Tcond       = opt.Tcond;
T           = opt.T;
Tr          = opt.Tr;
Rbin        = opt.Rbin;
Mbin        = opt.Mbin;
cfun        = opt.cfun;
pkl         = sys.weight(:,end);
Nmodels     = size(sys.branch,1);
NIM         = length(T);
muCMSk      = zeros(NIM,Nmodels);
SIGMAk      = zeros(NIM,Nmodels);
opt.IM      = Tcond;
col         = find(opt.IM>=0);
im1         = opt.im(:,col(1));
opt.im      = im1;
Tcond_ptr   = T==Tcond;

MRE = runlogictree1(sys,opt,h,1);
MRE = permute(MRE,[2 5 1 3 4]);
Sat = zeros(1,Nmodels);
RHO = zeros(length(T),Nmodels);
for i=1:Nmodels
    Sat(i)=robustinterp(MRE(:,i),opt.im,1/Tr,'loglog');
end

SaT  = exp(log(Sat)*pkl);
col  = find(opt.IM>=0);
im1  = repmat(opt.im(:,col(1)),1,length(T));
opt2 = opt;

for model_ptr  = 1:Nmodels
    branch  = sys.branch(model_ptr,1:3);
    sources = buildmodelin(sys,branch,opt);
    Nsource = length(sources);
    
    % compute Hazard Deagregation for T* at Return Period Tr
    im2     = Sat(model_ptr);
    opt2.im = im2;
    opt2.IM = Tcond;
    
    [deagg2,param] = runhazard2(im2,Tcond,h,opt2,sources,Nsource,1);
    funcCMS        = run_funcCMS(Rbin,Mbin,sources,deagg2,param);
    
    % compute GMPE prediction
    mu  = zeros(NIM,1);
    sig = zeros(NIM,1);
    for j=1:NIM
        [mu(j),sig(j)] = funcCMS.gmmfun(T(j),funcCMS.param{:});
    end
    
    % Step 4: compute e*
    eTs = (log(SaT)-mu(Tcond_ptr))/sig(Tcond_ptr);
    
    % Step 5: compute ebar
    rho     = zeros(size(T));
    methods = pshatoolbox_methods(4,cfun);
    func    = methods.func;
    Cond_param.opp       = 0;
    Cond_param.mechanism = funcCMS.mech;
    Cond_param.sof       = funcCMS.sof;
    Cond_param.M         = funcCMS.M;
    Cond_param.residual  = 'phi';
    Cond_param.direction = 'horizontal';
    
    for i=1:length(rho)
        rho(i)  = func(Tcond,T(i),Cond_param);
    end
    RHO(:,model_ptr)=rho;
    % Step 6: compute and stores cms
    muCMSk(:,model_ptr)  = mu+eTs*rho.*sig;
    SIGMAk(:,model_ptr)  = sig.*sqrt(1-rho.^2);
end

% COMPUTE MEAN CS USING LOGIC TREE WEIGHTS
lncms   = muCMSk*pkl;
sigCMS  = sqrt((SIGMAk.^2+(bsxfun(@minus,muCMSk,lncms).^2))*pkl);
epsCMS  = 1.0; % can be changed to something else;
lncmss1 = lncms+epsCMS*sigCMS;
lncmss2 = lncms-epsCMS*sigCMS;
cms     = exp(lncms);
cmsk    = exp(muCMSk);
cmss1   = exp(lncmss1);
cmss2   = exp(lncmss2);

%% builds output
cmsdata.dchart = [];
cmsdata.im     = im1(:,Tcond_ptr);
cmsdata.lambda = MRE;
cmsdata.T      = T;
cmsdata.CMS    = [cms,cmss1,cmss2];
cmsdata.CMSk   = cmsk;
cmsdata.RHO    = RHO;




