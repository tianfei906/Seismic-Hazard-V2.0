function cmsdata=runCMS_method1(sys,opt,h)

% set up data
model_ptr   = opt.model_ptr;
Tcond       = opt.Tcond;
T           = opt.T;
Tr          = opt.Tr;
Rbin        = opt.Rbin;
Mbin        = opt.Mbin;
cfun        = opt.cfun;
UseMean     = opt.DeaggMean;

Nper        =numel(T);
Tcond_ptr   = T==Tcond;
im1         = opt.im;
branch      = sys.branch(model_ptr,1:3);
geom_ptr    = branch(1);
Nsource     = sum(sys.Nsrc(:,geom_ptr));

% compute seismic hazard for all Sa(T*)
sources = buildmodelin(sys,branch,opt);
lambda1 = runhazard1(im1,T,h,opt,sources,Nsource,1);
lambda1 = sum(lambda1,4,'omitnan');
lambda1 = permute(lambda1,[2 3 1]);

% compute Hazard Deagregation for T* at Return Period Tr
im2     = robustinterp(lambda1(:,Tcond_ptr),im1(:,Tcond_ptr),1/Tr,'loglog');
opt2    = opt;
opt2.im = im2;
opt2.IM = Tcond;

[deagg2,param] = runhazard2(im2,Tcond,h,opt2,sources);
cmsdata        = run_funcCMS(Rbin,Mbin,sources,deagg2,param,UseMean);

% compute UHS
uhs  = uhspectrum(opt.im,lambda1,1/Tr);

% compute GMPE prediction
muH  = zeros(size(uhs));
sigH = zeros(size(uhs));
tauH = zeros(size(uhs));
phiH = zeros(size(uhs));
for j=1:Nper
    [muH(j),sigH(j),tauH(j),phiH(j)] = cmsdata.gmmfun(T(j),cmsdata.param{:});
end

%% This is an ASSUMPTION to deal with old GMMs that do not provide error separation in tau and phi
if all(isnan(tauH)) && all(isnan(phiH))
    a   = 2/3;
    phiH = sigH/sqrt(1+a^2);
    tauH = sqrt(sigH.^2-phiH.^2);
end
%%

% Step 4: compute e*
eTs = (log(uhs(Tcond_ptr))-muH(Tcond_ptr))/sigH(Tcond_ptr);

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
sigCMS  = sigH.*sqrt(1-rho.^2);
epsCMS  = 1.0; % can be changed to something else;
lncms   = muH+eTs*rho.*sigH;
lncmss1 = lncms+epsCMS*sigCMS;
lncmss2 = lncms-epsCMS*sigCMS;
cms     = exp(lncms);
cmss1   = exp(lncmss1);
cmss2   = exp(lncmss2);

%% Computes Vertical CMS
cmsv=[];
if isfield(opt,'CMSvOptions')
    optCMSv =opt.CMSvOptions;
    
    if optCMSv(1)==3 && optCMSv(5)==2
        gmmvh  = opt.libGMMVH(optCMSv(3));
        switch optCMSv(3)
            case 1, param = [cmsdata.M,cmsdata.R,h.value,gmmvh.usp];  % Gulerce & Abrahamson, 2011
            case 2, param = {cmsdata.M,cmsdata.R};           % Garcia Soto & Jaimes, 2017
        end
        fun= gmmvh.handle;
        VH = zeros(Nper,1);
        for i=1:Nper
            VH(i)  = exp(fun(T(i)+3*1i,param{:}));
        end
        cmsv = cms.*VH;
    end
    
    if optCMSv(1)==3 && optCMSv(5)==3
        VH    = zeros(Nper,1);
        sigVH = zeros(Nper,1);
        tauVH = zeros(Nper,1);
        phiVH = zeros(Nper,1);
        gmmvh  = opt.libGMMVH(optCMSv(3));
        switch optCMSv(3)
            case 1, param = [cmsdata.M,cmsdata.R,h.value(1),gmmvh.usp];  % Gulerce & Abrahamson, 2011
            case 2, param = {cmsdata.M,cmsdata.R};           % Garcia Soto & Jaimes, 2017
        end
        
        fun = gmmvh.handle;
        
        rhoHVH = zeros(Nper,1);
        for i=1:Nper
            [lnVH,sigVH(i),tauVH(i),phiVH(i)]  = fun(T(i)+3*1i,param{:});
            VH(i)=exp(lnVH);
            [rhow,rhob]=corrHVH(T(i),Tcond);
            rhoHVH(i) = phiVH(i)*phiH(i)/(sigVH(i)*sigH(i))*rhow+...
                tauVH(i)*tauH(i)/(sigVH(i)*sigH(i))*rhob;
        end
        cmsv = cms.*VH.*exp(rhoHVH.*sigVH);
    end
end

%% build output
cmsdata.im     = im1(:,Tcond_ptr);
cmsdata.lambda = lambda1(:,Tcond_ptr);
cmsdata.T      = T;
cmsdata.CMS    = [cms,cmss1,cmss2];
cmsdata.CMSk   = [];
cmsdata.RHO    = rho;
cmsdata.UHS    = uhs;
cmsdata.sigCMS = sigCMS;
cmsdata.CMSv   = cmsv;

function [rhow,rhob]=corrHVH(T,T0,residual)

T  = max(T ,0.01);
T0 = max(T0,0.01);

TH = [0.01 0.05 0.1 0.15 0.2 0.3 0.4 0.5 0.75 1 2 3 4 5 10];
TV = [0.01 0.05 0.1 0.15 0.2 0.3 0.4 0.5 0.75 1 2 3 4 5 10];
[TH,TV]=meshgrid(TH,TV);

rhoW=[ -0.389 -0.312 -0.326 -0.317 -0.331 -0.332 -0.325 -0.353 -0.311 -0.259 -0.130 -0.094 -0.116 -0.152 0.030
    -0.324 -0.273 -0.328 -0.310 -0.318 -0.301 -0.287 -0.303 -0.271 -0.216 -0.109 -0.073 -0.099 -0.139 0.067
    -0.264 -0.173 -0.358 -0.344 -0.330 -0.274 -0.233 -0.243 -0.205 -0.165 -0.072 -0.027 -0.043 -0.079 0.063
    -0.286 -0.180 -0.291 -0.417 -0.380 -0.311 -0.273 -0.269 -0.208 -0.173 -0.070 -0.020 -0.047 -0.067 0.043
    -0.311 -0.216 -0.258 -0.325 -0.439 -0.348 -0.299 -0.300 -0.233 -0.180 -0.074 -0.038 -0.056 -0.077 0.033
    -0.347 -0.269 -0.234 -0.240 -0.289 -0.450 -0.377 -0.370 -0.296 -0.236 -0.097 -0.065 -0.077 -0.102 0.014
    -0.352 -0.291 -0.221 -0.200 -0.219 -0.333 -0.466 -0.431 -0.338 -0.277 -0.137 -0.106 -0.104 -0.144 0.011
    -0.346 -0.296 -0.204 -0.162 -0.183 -0.269 -0.361 -0.493 -0.398 -0.327 -0.166 -0.141 -0.147 -0.185 -0.005
    -0.287 -0.250 -0.160 -0.105 -0.119 -0.176 -0.232 -0.329 -0.483 -0.396 -0.217 -0.168 -0.170 -0.204 -0.020
    -0.247 -0.216 -0.126 -0.086 -0.095 -0.140 -0.175 -0.258 -0.350 -0.443 -0.236 -0.191 -0.194 -0.206 -0.058
    -0.162 -0.108 -0.049 -0.057 -0.072 -0.098 -0.131 -0.193 -0.226 -0.254 -0.318 -0.220 -0.247 -0.324 -0.260
    -0.115 -0.060 -0.004 -0.018 -0.017 -0.055 -0.066 -0.151 -0.176 -0.208 -0.210 -0.254 -0.255 -0.324 -0.330
    -0.080 -0.019 0.046 -0.003 -0.020 -0.044 -0.041 -0.138 -0.152 -0.173 -0.151 -0.125 -0.295 -0.343 -0.407
    -0.072 -0.009 0.061 0.009 -0.009 -0.009 -0.032 -0.112 -0.098 -0.122 -0.119 -0.060 -0.224 -0.396 -0.511
    -0.083 -0.020 0.042 -0.013 -0.061 -0.085 -0.086 -0.199 -0.196 -0.179 -0.163 -0.071 -0.205 -0.309 -0.577];

% inter-event (between)
rhoB=[-0.193 -0.156 -0.210 -0.320 -0.339 -0.314 -0.257 -0.147 -0.162 -0.061 -0.087 -0.016 0.036 -0.018 -0.249
    -0.087 -0.068 -0.192 -0.306 -0.259 -0.238 -0.150 -0.036 -0.077 0.043 -0.001 0.045 0.106 0.063 -0.002
    -0.072 -0.016 -0.186 -0.305 -0.325 -0.216 -0.144 -0.047 -0.091 0.044 -0.028 0.058 0.100 0.017 -0.265
    -0.110 -0.048 -0.159 -0.314 -0.382 -0.292 -0.253 -0.157 -0.168 -0.033 -0.080 0.030 0.101 0.027 -0.341
    -0.145 -0.101 -0.145 -0.287 -0.413 -0.321 -0.282 -0.173 -0.175 -0.072 -0.117 -0.021 0.035 -0.065 -0.390
    -0.216 -0.165 -0.163 -0.249 -0.369 -0.418 -0.379 -0.239 -0.233 -0.163 -0.179 -0.073 -0.015 -0.070 -0.315
    -0.237 -0.157 -0.108 -0.196 -0.331 -0.350 -0.416 -0.308 -0.300 -0.218 -0.231 -0.143 -0.088 -0.127 -0.413
    -0.205 -0.131 -0.061 -0.166 -0.289 -0.300 -0.382 -0.351 -0.358 -0.264 -0.286 -0.224 -0.126 -0.148 -0.420
    -0.187 -0.188 -0.061 -0.114 -0.235 -0.223 -0.242 -0.231 -0.370 -0.276 -0.338 -0.303 -0.219 -0.171 -0.365
    -0.167 -0.247 0.018 -0.070 -0.176 -0.204 -0.210 -0.224 -0.258 -0.245 -0.286 -0.261 -0.226 -0.226 -0.375
    -0.230 -0.325 -0.080 0.006 -0.061 -0.147 -0.200 -0.167 -0.254 -0.241 -0.361 -0.339 -0.304 -0.232 -0.437
    -0.262 -0.302 -0.168 -0.166 -0.199 -0.169 -0.242 -0.223 -0.348 -0.302 -0.349 -0.358 -0.252 -0.204 -0.292
    -0.209 -0.268 -0.129 -0.118 -0.175 -0.160 -0.297 -0.258 -0.303 -0.253 -0.346 -0.303 -0.181 -0.161 -0.266
    -0.345 -0.362 -0.247 -0.240 -0.354 -0.287 -0.367 -0.309 -0.323 -0.275 -0.402 -0.324 -0.198 -0.200 -0.366
    -0.268 -0.301 -0.289 -0.250 -0.268 -0.192 0.019 0.062 0.014 0.039 -0.182 -0.074 -0.037 -0.087 -0.171];

rhow = interp2(TH,TV,rhoW,T0,T,'spline');
rhob = interp2(TH,TV,rhoB,T0,T,'spline');


