function [cpt] = interpretCPT_4(Data, wt, Df)
%% SOIL LIQUEFACTION TRIGGERING EVALUATION
% This MATLAB code estimates liquefaction triggering based on Boulanger &
% Idriss (2014) method. It also estimates Relative Density according to
% Boualanger ad Idriss (2008), Kulhawy and Mayne (1990)
% and Jamiolkowsky (2001)
% Create a Microsoft Excel File (*.xls) with:
%       * Depth in "m" in column "A"
%       * qc in "MPa" in column "B"
%       * fs in "MPa" in column "C"
%       * u2 in "MPa" in column "D"`
% Make the name of the excel file, the name of the CPT
%Data = xlsread('CPT_processed.xlsx');

%% Input Parameters
d_in        = Data(1:end,1);%Data(:,1);
qc_in       = Data(1:end,2);%Data(:,2);
fs_in       = Data(1:end,3);%Data(:,3)/1000;
u2_in       = Data(1:end,4);%Data(:,4)/1000;
N3          = size(Data,1);
a           = 0.58;            % Net Area Ratio
uw_awt      = 18;              % Assume Unit Weight above WT
cfc         = 0.07;            % Cfc for site specific Ic-FC relationship (0.07 for chch)
Pa          = 101.3;           % Atmospheric pressure in kPa
g_w         = 9.81;            % Unit Weight of water
d_d         = d_in(2)-d_in(1); % Spacing in depth

%% Add points above the first measured point if neccessary
N_ex = 0;
if d_in(1)>=d_d
    N_ex = fix((d_in(1)/d_d)-1);
end

N     = N_ex + N3;    % Number of rows in each vector for the rest of analysis
ISNAN = ones(N,1);
ISNAN(1:N_ex) = NaN;
d   = (1:N)'*d_d;
qc  = [zeros(N_ex,1);qc_in]; qc(qc==0)=0.001;
fs  = [zeros(N_ex,1);fs_in]; fs(fs==0)=0.0001;
u2  = [zeros(N_ex,1);u2_in]; u2(u2==0)=0.00001;
cpt.z  = d;
cpt.qc = qc;%Mpa
cpt.fs = fs;%Mpa
cpt.u2 = u2*1000;%kpa

%% Calculate state of stresses
% Unit Weight from Robertson (2010)
qt         = (1000*qc + 1000*u2*(1-a)).*ISNAN;
Rf         = (1000*fs./qt*100).*ISNAN;
g_r        = max(15,g_w*(0.27*log10(Rf)+0.36*log10(qt/Pa)+1.236)).*ISNAN;
g_r(1:N_ex)= uw_awt;

svo    = cumsum(d_d.*g_r);
u      = max(g_w*(d-wt),0);
s_vo   = svo-u;
cpt.qt = qt;%kpa
cpt.u0 = u;%kpa
cpt.Rf = Rf;
[~,cpt.SBT] = getSBT(cpt.Rf,cpt.qc/0.1);  % question here
cpt.svo=svo;%kpa
cpt.s_vo=s_vo;%kpa

%% Estimation of Ic and Robertson Parameters
c_n     = zeros([N,1]);
Qtn     = zeros([N,1]);
Fr      = zeros([N,1]);
ic      = zeros([N,1]);
n_exp   = zeros([N,1]);
delta_n = zeros([N,1])+1;
n_ini   = zeros([N,1])+0.5;

for i = 1:N
    while delta_n(i) > 1e-3
        c_n(i)     = min(1.7,(Pa/s_vo(i)).^n_ini(i));
        Qtn(i)     = ((qt(i)-svo(i))/Pa)*c_n(i);
        Fr(i)      = 100*1000*fs(i)/(qt(i)-svo(i));
        ic(i)      = ((3.47-log10(Qtn(i))).^2+(1.22+log10(Fr(i))).^2).^0.5;
        n_exp(i)   = min(1,0.381*(ic(i))+0.05*(s_vo(i)/Pa)-0.15);
        delta_n(i) = abs(n_exp(i) - n_ini(i));
        n_ini(i)   = n_exp(i);
    end
end

cpt.Qt  = (qt-svo)./s_vo;
cpt.Qtn = Qtn;
cpt.Fr  = Fr;
cpt.Ic  = ic;
cpt.Bq  = (cpt.u2-cpt.u0)./(cpt.qt-svo);
[~,~,cpt.SBTn] = getSBTn(cpt.Fr,cpt.Qtn);  % Confirm

%% Idriss and Boulanger Parameters (2014)
qcn         = (qt/Pa);
qc1n        = zeros([N,1]);
d_qc1n      = zeros([N,1]);
qc1ncs      = zeros([N,1]);
cn          = zeros([N,1]);
cn_g        = zeros([N,1])+0.5;     % Initial guess
delta_cn    = zeros([N,1])+0.5;     % Initial guess
toler_cn    = 0.01;
app_fc      = zeros([N,1]);
for i = 1:N
    if ic(i)<=2.6 %added by JM to make it consistent with cliq
        app_fc(i)   = 80*(ic(i)+cfc)-137;
    else
        app_fc(i)=0;
    end
    if app_fc(i) <0
        app_fc(i) = 0;
    elseif isnan(app_fc(i))
        app_fc(i) = NaN;
    elseif app_fc(i) >100
        app_fc(i)=100;
    end
end

for i = 1:N
    while delta_cn(i) > toler_cn
        qc1n(i)     = qcn(i)*cn_g(i);
        d_qc1n(i)   = (11.9+qc1n(i)/14.6)*exp(1.63-9.7/(app_fc(i)+2)-(15.7/(2+app_fc(i))).^2);
        qc1ncs(i)   = qc1n(i) + d_qc1n(i);
        cn(i)       = min(1.7,(Pa/s_vo(i)).^(1.338-0.249*(qc1ncs(i)).^0.264));
        delta_cn(i) = abs(cn(i) - cn_g(i));
        cn_g(i)     = cn(i);
    end
    
    if qc1ncs(i)>254% added by JM to make it consistent with Cliq
        qc1ncs(i)=254;
    end
end

cpt.qc1ncs=qc1ncs;

%% Relative Denisty
% Correlation 1: Idriss and Boulanger (2008)
% Correlation 2: Jamiolkowsky (2001)
% Correlation 3: Kulhawy & Mayne
bx      = 0.675;        % Compressibility factor (0.525,0.675,0.825 for high, medium and low compressibility)
Qc      = 1.0;          % Compresibility factor (1.1 for high  0.9 for low compressibility)
OCR     = 1.1;          % assumed OCR
Qocr    = OCR^0.18;     %OCR Factor (OCR^.18)
Qa      = 1.0;          % Age Factor 1.2+0.05log(t/100)

Dr_ib  = 100*(0.478*(qc1ncs).^0.264 - 1.063);                   Dr_ib(or(ic> 2.6,d<wt)) = NaN;
Dr_j   = 100*(0.268*log((qt/Pa)./(s_vo/Pa).^0.5)-bx);           Dr_j(or(ic> 2.6,d<wt))  = NaN;
Dr_km  = 100*(((qt/Pa)./(s_vo/Pa).^0.5)/(305*Qc*Qocr*Qa)).^0.5; Dr_km(or(ic> 2.6,d<wt)) = NaN;

cpt.Dr =[Dr_ib,Dr_j,Dr_km];

