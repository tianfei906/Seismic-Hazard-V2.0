function[lny,sigma,tau,phi]=CY2014(To,M,Rrup,Rjb,Rx,Ztor,dip,Vs30,Z10,SOF,Vs30type,region,adjfun)
% Syntax : CY2014 Z10 SOF Vs30type region                                   

% Brian S.-J. Chiou and Robert R. Youngs (2014) Update of the Chiou and 
% Youngs NGA Model for the Average Horizontal Component of Peak Ground 
% Motion and Response Spectra. Earthquake Spectra: August 2014, Vol. 30, 
% No. 3, pp. 1117-1153.

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[0 10],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

%if ischar(Ztor),Ztor = 999;end
if ischar(Z10),Z10   = 999;end
Z10=abs(Z10);
if To>=0
    To      = max(To,0.001); %PGA is associated to To=0.01;
end
period = [-1 0.001 0.01 0.02 0.03 0.04 0.05 0.075 0.1 0.12 0.15 0.17 0.2 0.25 0.3 0.4 0.5 0.75 1 1.5 2 3 4 5 7.5 10];
T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

if T_lo==T_hi
    [lny,sigma,phi] = gmpe(index,M, Rrup, Rjb, Rx, Ztor, dip, SOF, Z10, Vs30, Vs30type, region);
    tau              = sqrt(sigma.^2-phi.^2);
else
    [lny_lo,sigma_lo,sig_lo] = gmpe(index,  M, Rrup, Rjb, Rx, Ztor, dip, SOF, Z10, Vs30,Vs30type, region);
    [lny_hi,sigma_hi,sig_hi] = gmpe(index+1,M, Rrup, Rjb, Rx, Ztor, dip, SOF, Z10, Vs30,Vs30type, region);
    x          = log([T_lo;T_hi]);
    Y_sa       = [lny_lo,lny_hi]';
    Y_sigma    = [sigma_lo,sigma_hi]';
    Y_sig      = [sig_lo,sig_hi]';
    lny        = interp1(x,Y_sa,log(To))';
    sigma      = interp1(x,Y_sigma,log(To))';
    phi        = interp1(x,Y_sig,log(To))';
    tau        = sqrt(sigma.^2-phi.^2);
end

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end

function[lny,sigma,sig]=gmpe(index,M, Rup, Rjb, Rx, Ztor, dip, SOF, Z10, Vs30,FVS30, reg)
dip=dip*pi()/180.0;
switch SOF
    case 'strike-slip',     frv = 0; fnm=0;
    case 'normal',          frv = 0; fnm=1;
    case 'normal-oblique',  frv = 0; fnm=1;
    case 'reverse',         frv = 1; fnm=0;
    case 'reverse-oblique', frv = 1; fnm=0;
    case 'unspecified',     frv = 0; fnm=0;
end

switch reg
    case 'global',     region=0;
    case 'california', region=1;
    case 'japan',      region=2;
    case 'china',      region=3;
    case 'italy',      region=4;
    case 'turkey',     region=5; 
end

if Rx(1)==-999
    HW = zeros(size(Rx));
else
    HW    = sign(Rx);
end
d_DPP = 0; % for median calculatio, d_DPP=0.

% Compute lnSa and sigma with user-defined period
period = [-1 0.001 0.01 0.02 0.03 0.04 0.05 0.075 0.1 0.12 0.15 0.17 0.2 0.25 0.3 0.4 0.5 0.75 1 1.5 2 3 4 5 7.5 10];
T      = period(index);
[lny, sigma,sig] = CY_2014_nga_sub (index,M, Rup, Rjb, Rx, Ztor, dip, frv, fnm, HW, Z10, Vs30, FVS30, region, d_DPP);
lnPGA            = CY_2014_nga_sub (2    ,M, Rup, Rjb, Rx, Ztor, dip, frv, fnm, HW, Z10, Vs30, FVS30, region, d_DPP);
ind = and(exp(lny)<exp(lnPGA),T<=0.3);
lny(ind)=lnPGA(ind);

function [ln_Sa, sigma,sig]=CY_2014_nga_sub (index,M, R_RUP, R_JB, Rx, Ztor, dip, F_RV, F_NM, HW, Z10, Vs30, Vs30type, region, d_DPP)

% Coefficients
c2=[ 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06 1.06];
c4=[ -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1 -2.1];
c4_a=[ -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5];
c_RB =[50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50];
c8 =[0.2154 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0991 0.1982 0.2154 0.2154 0.2154 0.2154 0.2154 0.2154 0.2154 0.2154];
c8_a =[0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695 0.2695];
c1 =[2.3549 -1.5065 -1.5065 -1.4798 -1.2972 -1.1007 -0.9292 -0.6580 -0.5613 -0.5342 -0.5462 -0.5858 -0.6798 -0.8663 -1.0514 -1.3794 -1.6508 -2.1511 -2.5365 -3.0686 -3.4148 -3.9013 -4.2466 -4.5143 -5.0009 -5.3461];
c1_a =[0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1650 0.1645 0.1168 0.0732 0.0484 0.0220 0.0124];
c1_b =[-0.0626 -0.2550 -0.2550 -0.2550 -0.2550 -0.2550 -0.2550 -0.2540 -0.2530 -0.2520 -0.2500 -0.2480 -0.2449 -0.2382 -0.2313 -0.2146 -0.1972 -0.1620 -0.1400 -0.1184 -0.1100 -0.1040 -0.1020 -0.1010 -0.1010 -0.1000];
c1_c =[-0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1650 -0.1645 -0.1168 -0.0732 -0.0484 -0.0220 -0.0124];
c1_d =[0.0626 0.2550 0.2550 0.2550 0.2550 0.2550 0.2550 0.2540 0.2530 0.2520 0.2500 0.2480 0.2449 0.2382 0.2313 0.2146 0.1972 0.1620 0.1400 0.1184 0.1100 0.1040 0.1020 0.1010 0.1010 0.1000];
c_n =[3.3024 16.0875 16.0875 15.7118 15.8819 16.4556 17.6453 20.1772 19.9992 18.7106 16.6246 15.3709 13.7012 11.2667 9.1908 6.5459 5.2305 3.7896 3.3024 2.8498 2.5417 2.1488 1.8957 1.7228 1.5737 1.5265];
c_m =[5.4230 4.9993 4.9993 4.9993 4.9993 4.9993 4.9993 5.0031 5.0172 5.0315 5.0547 5.0704 5.0939 5.1315 5.1670 5.2317 5.2893 5.4109 5.5106 5.6705 5.7981 5.9983 6.1552 6.2856 6.5428 6.7415];
c3 =[2.3152 1.9636 1.9636 1.9636 1.9636 1.9636 1.9636 1.9636 1.9636 1.9795 2.0362 2.0823 2.1521 2.2574 2.3440 2.4709 2.5567 2.6812 2.7474 2.8161 2.8514 2.8875 2.9058 2.9169 2.9320 2.9396];
c5 =[5.8096 6.4551 6.4551 6.4551 6.4551 6.4551 6.4551 6.4551 6.8305 7.1333 7.3621 7.4365 7.4972 7.5416 7.5600 7.5735 7.5778 7.5808 7.5814 7.5817 7.5818 7.5818 7.5818 7.5818 7.5818 7.5818];
c_HM =[3.0514 3.0956 3.0956 3.0963 3.0974 3.0988 3.1011 3.1094 3.2381 3.3407 3.4300 3.4688 3.5146 3.5746 3.6232 3.6945 3.7401 3.7941 3.8144 3.8284 3.8330 3.8361 3.8369 3.8376 3.8380 3.8380];
c6 =[0.4407 0.4908 0.4908 0.4925 0.4992 0.5037 0.5048 0.5048 0.5048 0.5048 0.5045 0.5036 0.5016 0.4971 0.4919 0.4807 0.4707 0.4575 0.4522 0.4501 0.4500 0.4500 0.4500 0.4500 0.4500 0.4500];
c7 =[0.0324 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0352 0.0160 0.0062 0.0029 0.0007 0.0003];
c7_b =[0.0097 0.0462 0.0462 0.0472 0.0533 0.0596 0.0639 0.0630 0.0532 0.0452 0.0345 0.0283 0.0202 0.0090 -0.0004 -0.0155 -0.0278 -0.0477 -0.0559 -0.0630 -0.0665 -0.0516 -0.0448 -0.0424 -0.0348 -0.0253];
c8_b =[5.0000 0.4833 0.4833 1.2144 1.6421 1.9456 2.1810 2.6087 2.9122 3.1045 3.3399 3.4719 3.6434 3.8787 4.0711 4.3745 4.6099 5.0376 5.3411 5.7688 6.0723 6.5000 6.8035 7.0389 7.4666 7.7700];
c9 =[0.3079 0.9228 0.9228 0.9296 0.9396 0.9661 0.9794 1.0260 1.0177 1.0008 0.9801 0.9652 0.9459 0.9196 0.8829 0.8302 0.7884 0.6754 0.6196 0.5101 0.3917 0.1244 0.0086 0.0000 0.0000 0.0000];
c9_a =[0.1000 0.1202 0.1202 0.1217 0.1194 0.1166 0.1176 0.1171 0.1146 0.1128 0.1106 0.1150 0.1208 0.1208 0.1175 0.1060 0.1061 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000];
c9_b =[6.5000 6.8607 6.8607 6.8697 6.9113 7.0271 7.0959 7.3298 7.2588 7.2372 7.2109 7.2491 7.2988 7.3691 6.8789 6.5334 6.5260 6.5000 6.5000 6.5000 6.5000 6.5000 6.5000 6.5000 6.5000 6.5000];
c11 =[0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000];
c11_b=[ -0.3834 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4536 -0.4440 -0.3539 -0.2688 -0.1793 -0.1428 -0.1138 -0.1062 -0.1020 -0.1009 -0.1003 -0.1001 -0.1001 -0.1000 -0.1000];
c_g1 =[-0.001852 -0.007146 -0.007146 -0.007249 -0.007869 -0.008316 -0.008743 -0.009537 -0.009830 -0.009913 -0.009896 -0.009787 -0.009505 -0.008918 -0.008251 -0.007267 -0.006492 -0.005147 -0.004277 -0.002979 -0.002301 -0.001344 -0.001084 -0.001010 -0.000964 -0.000950];
c_g2 =[-0.007403 -0.006758 -0.006758 -0.006758 -0.006758 -0.006758 -0.006758 -0.006190 -0.005332 -0.004732 -0.003806 -0.003280 -0.002690 -0.002128 -0.001812 -0.001274 -0.001074 -0.001115 -0.001197 -0.001675 -0.002349 -0.003306 -0.003566 -0.003640 -0.003686 -0.003700];
c_g3 =[4.3439 4.2542 4.2542 4.2386 4.2519 4.2960 4.3578 4.5455 4.7603 4.8963 5.0644 5.1371 5.1880 5.2164 5.1954 5.0899 4.7854 4.3304 4.1667 4.0029 3.8949 3.7928 3.7443 3.7090 3.6632 3.6230];
phi1 =[-0.7936 -0.5210 -0.5210 -0.5055 -0.4368 -0.3752 -0.3469 -0.3747 -0.4440 -0.4895 -0.5477 -0.5922 -0.6693 -0.7766 -0.8501 -0.9431 -1.0044 -1.0602 -1.0941 -1.1142 -1.1154 -1.1081 -1.0603 -0.9872 -0.8274 -0.7053];
phi2 =[-0.0699 -0.1417 -0.1417 -0.1364 -0.1403 -0.1591 -0.1862 -0.2538 -0.2943 -0.3077 -0.3113 -0.3062 -0.2927 -0.2662 -0.2405 -0.1975 -0.1633 -0.1028 -0.0699 -0.0425 -0.0302 -0.0129 -0.0016 0.0000 0.0000 0.0000];
phi3 =[-0.008444 -0.007010 -0.007010 -0.007279 -0.007354 -0.006977 -0.006467 -0.005734 -0.005604 -0.005696 -0.005845 -0.005959 -0.006141 -0.006439 -0.006704 -0.007125 -0.007435 -0.008120 -0.008444 -0.007707 -0.004792 -0.001828 -0.001523 -0.001440 -0.001369 -0.001361];
phi4 =[5.410000 0.102151 0.102151 0.108360 0.119888 0.133641 0.148927 0.190596 0.230662 0.253169 0.266468 0.265060 0.255253 0.231541 0.207277 0.165464 0.133828 0.085153 0.058595 0.031787 0.019716 0.009643 0.005379 0.003223 0.001134 0.000515];
phi5 =[0.0202 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0010 0.0040 0.0100 0.0340 0.0670 0.1430 0.2030 0.2770 0.3090 0.3210 0.3290 0.3300];
phi6 =[300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300];
tau1 =[0.3894 0.4000 0.4000 0.4026 0.4063 0.4095 0.4124 0.4179 0.4219 0.4244 0.4275 0.4292 0.4313 0.4341 0.4363 0.4396 0.4419 0.4459 0.4484 0.4515 0.4534 0.4558 0.4574 0.4584 0.4601 0.4612];
tau2 =[0.2578 0.2600 0.2600 0.2637 0.2689 0.2736 0.2777 0.2855 0.2913 0.2949 0.2993 0.3017 0.3047 0.3087 0.3119 0.3165 0.3199 0.3255 0.3291 0.3335 0.3363 0.3398 0.3419 0.3435 0.3459 0.3474];
sigma1 =[0.4785 0.4912 0.4912 0.4904 0.4988 0.5049 0.5096 0.5179 0.5236 0.5270 0.5308 0.5328 0.5351 0.5377 0.5395 0.5422 0.5433 0.5294 0.5105 0.4783 0.4681 0.4617 0.4571 0.4535 0.4471 0.4426];
sigma2 =[0.3629 0.3762 0.3762 0.3762 0.3849 0.3910 0.3957 0.4043 0.4104 0.4143 0.4191 0.4217 0.4252 0.4299 0.4338 0.4399 0.4446 0.4533 0.4594 0.4680 0.4681 0.4617 0.4571 0.4535 0.4471 0.4426];
sigma3 =[0.7504 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.7999 0.7997 0.7988 0.7966 0.7792 0.7504 0.7136 0.7035 0.7006 0.7001 0.7000 0.7000 0.7000];
sigma2_JP=[ 0.3918 0.4528 0.4528 0.4551 0.4571 0.4642 0.4716 0.5022 0.523 0.5278 0.5304 0.531 0.5312 0.5309 0.5307 0.531 0.5313 0.5309 0.5302 0.5276 0.5167 0.4917 0.4682 0.4517 0.4167 0.3755];
gamma_JP_IT=[ 2.2306 1.5817 1.5817 1.5740 1.5544 1.5502 1.5391 1.4804 1.4094 1.3682 1.3241 1.3071 1.2931 1.3150 1.3514 1.4051 1.4402 1.5280 1.6523 1.8872 2.1348 3.5752 3.8646 3.7292 2.3763 1.7679];
gamma_Wn =[0.3350 0.7594 0.7594 0.7606 0.7642 0.7676 0.7739 0.7956 0.7932 0.7768 0.7437 0.7219 0.6922 0.6579 0.6362 0.6049 0.5507 0.3582 0.2003 0.0356 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000];
phi1_JP=[ -0.7966 -0.6846 -0.6846 -0.6681 -0.6314 -0.5855 -0.5457 -0.4685 -0.4985 -0.5603 -0.6451 -0.6981 -0.7653 -0.8469 -0.8999 -0.9618 -0.9945 -1.0225 -1.0002 -0.9245 -0.8626 -0.7882 -0.7195 -0.6560 -0.5202 -0.4068];
phi5_JP=[ 0.9488 0.4590 0.4590 0.4580 0.4620 0.4530 0.4360 0.3830 0.3750 0.3770 0.3790 0.3800 0.3840 0.3930 0.4080 0.4620 0.5240 0.6580 0.7800 0.9600 1.1100 1.2910 1.3870 1.4330 1.4600 1.4640];
phi6_JP=[ 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800 800];

if region==2
    sigma2=sigma2_JP;
    phi1=phi1_JP;
    phi5=phi5_JP;
    phi6=phi6_JP;
end
c2=c2(index);
c4=c4(index);
c4_a=c4_a(index);
c_RB=c_RB(index);
c8=c8(index);
c8_a=c8_a(index);
c1=c1(index);
c1_a=c1_a(index);
c1_b=c1_b(index);
c1_c=c1_c(index);
c1_d=c1_d(index);
c_n=c_n(index);
c_m=c_m(index);
c3=c3(index);
c5=c5(index);
c_HM=c_HM(index);
c6=c6(index);
c7=c7(index);
c7_b=c7_b(index);
c8_b=c8_b(index);
c9=c9(index);
c9_a=c9_a(index);
c9_b=c9_b(index);
c11=c11(index);
c11_b=c11_b(index);
c_g1=c_g1(index);
c_g2=c_g2(index);
c_g3=c_g3(index);
phi1=phi1(index);
phi2=phi2(index);
phi3=phi3(index);
phi4=phi4(index);
phi5=phi5(index);
phi6=phi6(index);
tau1=tau1(index);
tau2=tau2(index);
sigma1=sigma1(index);
sigma2=sigma2(index);
sigma3=sigma3(index);
% sigma2_JP=sigma2_JP(index);
gamma_JP_IT=gamma_JP_IT(index);
gamma_Wn=gamma_Wn(index);
% phi1_JP=phi1_JP(index);
% phi5_JP=phi5_JP(index);
% phi6_JP=phi6_JP(index);

% fmag
term6=c2.*(M-6);
term7=(c2-c3)/c_n*log(1+exp(c_n.*(c_m-M)));

% Distance Scaling and attenuation term
term8=c4.*log(R_RUP+c5.*cosh(c6.*max(M-c_HM,0)));
term9=(c4_a-c4)*log(sqrt(R_RUP.^2+c_RB.^2));
term10=(c_g1+c_g2./(cosh(max(M-c_g3,0)))).*R_RUP;

term10b=(c_g1+c_g2./(cosh(max(M-c_g3,0)))).*R_RUP;
if region == 2 || region == 4
    term10a = gamma_JP_IT.*term10;
    term10(M>6)=term10a(M>6);
    term10(M>=6.9)=term10b(M>=6.9);
end
if region == 3
    term10 = gamma_Wn.* term10;
end

% Style of faulting term
term2=(c1_a+c1_c./(cosh(2.*max(M-4.5,0)))).*F_RV;
term3=(c1_b+c1_d./cosh(2.*max(M-4.5,0))).*F_NM;

% Ztor term
if F_RV==1
    E_Ztor = (max(2.704-1.226.*max(M-5.849,0),0)).^2;
else
    E_Ztor = (max(2.673-1.136.*max(M-4.970,0),0)).^2;
end

% if all(Ztor == 999)
%     Ztor = E_Ztor;
% end

delta_ZTOR=Ztor-E_Ztor;

term4=(c7+c7_b./cosh(2.*max(M-4.5,0))).*delta_ZTOR;

% Hanging wall term
if  Rx(1)==-999
    term12=0;
else
    term12=c9.*HW.*cos(dip).*(c9_a+(1-c9_a).*tanh(Rx./c9_b)).*(1-sqrt(R_JB.^2+Ztor.^2)./(R_RUP+1));
end

% Basin Depth term
% Z1.0 (m) ~ Vs30 (m/s) relationship
if region ~= 2 % in California and non-Japan region
    z_1= exp(-7.15./4.*log((Vs30.^4+570.94.^4)./(1360.^4+570.94.^4)));
else
    z_1= exp(-5.23./2.*log((Vs30.^2+412.39.^2)./(1360.^2+412.39.^2)));
end

if Z10 ==999
    d_Z1 = 0;
else
    d_Z1=Z10.*1000-z_1; % ojo aca, Z10 se ingresa en km, internamente se convierte a m
end

% Dip term
term5=(c11+c11_b./cosh(2.*max(M-4.5,0))).*(cos(dip).^2);

% Directivity
term11=c8.*max(1-max(R_RUP-40,0)./30,0).*min(max(M-5.5,0)./0.8,1).*exp(-c8_a.*(M-c8_b).^2).*d_DPP;
term1=c1;

ln_yrefij=term1+term2+term3+term4+term5+term6+term7+term8+term9+term10+term11+term12;

yrefij=exp(ln_yrefij);

% Site response
term14=phi1.*min(log(Vs30/1130),0);
term15=phi2.*(exp(phi3.*(min(Vs30,1130)-360))-exp(phi3.*(1130-360))).*log((yrefij+phi4)./phi4);
term16=phi5.*(1-exp(-d_Z1./phi6));

Sa= yrefij.*exp(term14+term15+term16);
ln_Sa=log(Sa);

% Compute standard deviation
switch Vs30type
    case 'measured', Finferred=0; Fmeasured=1;
    case 'inferred', Finferred=1; Fmeasured=0;
end

NL0=phi2.*(exp(phi3.*(min(Vs30,1130)-360))-exp(phi3.*(1130-360))).*(yrefij./(yrefij+phi4));
sig = (sigma1+(sigma2 - sigma1)./1.5.*(min(max(M,5),6.5)-5)).*sqrt((sigma3.*Finferred + 0.7.* Fmeasured) + (1+NL0).^2);

tau = tau1 + (tau2-tau1)./1.5 .* (min(max(M,5),6.5)-5);
sigma=sqrt((1+NL0).^2.*tau.^2+sig.^2);
