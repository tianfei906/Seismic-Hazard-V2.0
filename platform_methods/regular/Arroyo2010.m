function[lny,sigma,tau,phi]=Arroyo2010(To,M,Rrup,adjfun)
% Syntax : Arroyo2010                                                       

%Arroyo, D., Garc�a, D., Ordaz, M., Mora, M. A., & Singh, S. K. (2010).
% Strong ground-motion relations for Mexican interplate earthquakes.
% Journal of Seismology, 14(4), 769-785.

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[0 5],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

if To>=0
    To=max(To,0.01); % PGA is associated to To as high as 0.01s
end

period  = [0.01 0.040 0.045 0.050 0.055 0.060 0.065 0.070 0.075 0.080 0.085 0.090 0.095 0.100 0.120 0.140 0.160 0.180 0.200 0.220 0.240 0.260 0.280 0.300 0.320 0.340 0.360 0.380 0.400 0.450 0.500 0.550 0.600 0.650 0.700 0.750 0.800 0.850 0.900 0.950 1.000 1.100 1.200 1.300 1.400 1.500 1.600 1.700 1.800 1.900 2.000 2.500 3.000 3.500 4.000 4.500 5.000];
T_lo    = max(period(period<=To));              % Identify the period that is below for the later interpolation
T_hi    = min(period(period>=To));              % Identify the period that is above for the later interpolation
index   = find(abs((period - T_lo)) < 1e-6);    % Identify the period from the ones evaluated in the paper

if T_lo==T_hi
    [lny,sigma,phi,tau] = gmpe(index,M,Rrup);
else
    [lny_lo,~,phi_lo,tau_lo] = gmpe(index,M,Rrup);
    [lny_hi,~,phi_hi,tau_hi] = gmpe(index+1,M,Rrup);
    x       = log([T_lo;T_hi]);
    Y_sa    = [lny_lo,lny_hi]';
    Y_phi   = [phi_lo,phi_hi]';
    Y_tau   = [tau_lo,tau_hi]';
    lny     = interp1(x,Y_sa,log(To))';
    phi     = interp1(x,Y_phi,log(To))';
    tau     = interp1(x,Y_tau,log(To))';
    sigma   = sqrt(phi.^2-tau.^2)';
    
end

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end


function [lny,sigma,phi,tau]=gmpe(index,Mw,Rrup)
[a1,a2,a3,a4,sigma,phi,tau] = getcoeffs(index);
ro2     = 1.4447*10^-5.*exp(2.3026.*Mw);
E11     = expint(a4.*Rrup);
E12     = expint(a4.*sqrt(Rrup.^2+ro2));
lny     = a1 + a2.*Mw + a3.*log((E11-E12)./ro2);


function [a1,a2,a3,a4,sigma,phi,tau]=getcoeffs(index)
COEFF   =   [
    2.4862 0.9392 0.5061 0.0150 0.3850 -0.0181 0.7500 0.5882 0.4654
    3.8123 0.8636 0.5578 0.0150 0.3962 -0.0254 0.8228 0.6394 0.5179
    4.0440 0.8489 0.5645 0.0150 0.3874 -0.0285 0.8429 0.6597 0.5246
    4.1429 0.8580 0.5725 0.0150 0.3731 -0.0181 0.8512 0.6740 0.5199
    4.3092 0.8424 0.5765 0.0150 0.3746  0.0004 0.8583 0.6788 0.5253
    4.3770 0.8458 0.5798 0.0150 0.4192 -0.0120 0.8591 0.6547 0.5563
    4.5185 0.8273 0.5796 0.0150 0.3888 -0.0226 0.8452 0.6607 0.5270
    4.4591 0.8394 0.5762 0.0150 0.3872 -0.0346 0.8423 0.6594 0.5241
    4.5939 0.8313 0.5804 0.0150 0.3775 -0.0241 0.8473 0.6685 0.5205
    4.4832 0.8541 0.5792 0.0150 0.3737 -0.0241 0.8421 0.6664 0.5148
    4.5062 0.8481 0.5771 0.0150 0.3757 -0.0138 0.8344 0.6593 0.5115
    4.4648 0.8536 0.5742 0.0150 0.4031 -0.0248 0.8304 0.6415 0.5273
    4.3940 0.8580 0.5712 0.0150 0.4097   0.0040 0.8294 0.6373 0.5309
    4.3391 0.8620 0.5666 0.0150 0.3841 -0.0045 0.8254 0.6477 0.5116
    4.0505 0.8933 0.5546 0.0150 0.3589 -0.0202 0.7960 0.6374 0.4768
    3.5599 0.9379 0.5350 0.0150 0.3528 -0.0293 0.7828 0.6298 0.4650
    3.1311 0.9736 0.5175 0.0150 0.3324 -0.0246 0.7845 0.6409 0.4523
    2.7012 1.0030 0.4985 0.0150 0.3291 -0.0196 0.7717 0.6321 0.4427
    2.5485 0.9988 0.4850 0.0150 0.3439 -0.0250 0.7551 0.6116 0.4428
    2.2699 1.0125 0.4710 0.0150 0.3240 -0.0205 0.7431 0.6109 0.4229
    1.9130 1.0450 0.4591 0.0150 0.3285 -0.0246 0.7369 0.6039 0.4223
    1.7181 1.0418 0.4450 0.0150 0.3595 -0.0220 0.7264 0.5814 0.4356
    1.4039 1.0782 0.4391 0.0150 0.3381 -0.0260 0.7209 0.5865 0.4191
    1.1080 1.1038 0.4287 0.0150 0.3537 -0.0368 0.7198 0.5787 0.4281
    1.0652 1.0868 0.4208 0.0150 0.3702 -0.0345 0.7206 0.5719 0.4384
    0.8319 1.1088 0.4142 0.0150 0.3423 -0.0381 0.7264 0.5891 0.4250
    0.4965 1.1408 0.4044 0.0150 0.3591 -0.0383 0.7255 0.5808 0.4348
    0.3173 1.1388 0.3930 0.0150 0.3673 -0.0264 0.7292 0.5800 0.4419
    0.2735 1.1533 0.4067 0.0134 0.3956 -0.0317 0.7272 0.5653 0.4574
    0.0990 1.1662 0.4127 0.0117 0.3466 -0.0267 0.7216 0.5833 0.4249
    -0.0379 1.2206 0.4523 0.0084 0.3519 -0.0338 0.7189 0.5788 0.4265
    -0.3512 1.2445 0.4493 0.0076 0.3529 -0.0298 0.7095 0.5707 0.4215
    -0.6897 1.2522 0.4421 0.0067 0.3691 -0.0127 0.7084 0.5627 0.4304
    -0.6673 1.2995 0.4785 0.0051 0.3361 -0.0192 0.7065 0.5756 0.4096
    -0.7154 1.3263 0.5068 0.0034 0.3200 -0.0243 0.7070 0.5830 0.3999
    -0.7015 1.2994 0.5056 0.0029 0.3364 -0.0122 0.7092 0.5778 0.4113
    -0.8581 1.3205 0.5103 0.0023 0.3164 -0.0337 0.6974 0.5766 0.3923
    -0.9712 1.3375 0.5201 0.0018 0.3435 -0.0244 0.6906 0.5596 0.4047
    -1.0970 1.3532 0.5278 0.0012 0.3306 -0.0275 0.6923 0.5665 0.3980
    -1.2346 1.3687 0.5345 0.0007 0.3264 -0.0306 0.6863 0.5632 0.3921
    -1.2600 1.3652 0.5426 0.0001 0.3194 -0.0183 0.6798 0.5608 0.3842
    -1.7687 1.4146 0.5342 0.0001 0.3336 -0.0229 0.6701 0.5471 0.3871
    -2.1339 1.4417 0.5263 0.0001 0.3445 -0.0232 0.6697 0.5422 0.3931
    -2.4122 1.4577 0.5201 0.0001 0.3355 -0.0231 0.6801 0.5544 0.3939
    -2.5442 1.4618 0.5242 0.0001 0.3759 -0.0039 0.6763 0.5343 0.4146
    -2.8509 1.4920 0.5220 0.0001 0.3780 -0.0122 0.6765 0.5335 0.4159
    -3.0887 1.5157 0.5215 0.0001 0.3937 -0.0204 0.6674 0.5197 0.4187
    -3.4884 1.5750 0.5261 0.0001 0.4130 -0.0208 0.6480 0.4965 0.4164
    -3.7195 1.5966 0.5255 0.0001 0.3967 -0.0196 0.6327 0.4914 0.3985
    -4.0141 1.6162 0.5187 0.0001 0.4248 -0.0107 0.6231 0.4726 0.4062
    -4.1908 1.6314 0.5199 0.0001 0.3967 -0.0133 0.6078 0.4721 0.3828
    -5.1104 1.7269 0.5277 0.0001 0.4302 -0.0192 0.6001 0.4530 0.3936
    -5.5926 1.7515 0.5298 0.0001 0.4735 -0.0319 0.6029 0.4375 0.4148
    -6.1202 1.8077 0.5402 0.0001 0.4848 -0.0277 0.6137 0.4405 0.4273
    -6.5318 1.8353 0.5394 0.0001 0.5020 -0.0368 0.6201 0.4376 0.4393
    -6.9744 1.8685 0.5328 0.0001 0.5085 -0.0539 0.6419 0.4500 0.4577
    -7.1389 1.8721 0.5376 0.0001 0.5592 -0.0534 0.6701 0.4449 0.5011];
a1     = COEFF(index,1);
a2     = COEFF(index,2);
a3     = COEFF(index,3);
a4     = COEFF(index,4);
sigma  = COEFF(index,7);
phi    = COEFF(index,8);
tau    = COEFF(index,9);

