function [BI14] = cptBI14(cpt, wt, Df,Mw, PGA)

Pa          = 101.3;           % Atmospheric pressure in kPa
d = cpt.z;
svo = cpt.svo;
s_vo= cpt.s_vo;
qc1ncs = cpt.qc1ncs;
ic = cpt.Ic;
C_o=2.8;
meanDr = mean(cpt.Dr,2);
d_d         = d(2)-d(1); % Spacing in depth
%% Evaluation of Liquefaction (B&I 14)
% Demand
NA      = length(Mw);
alpha_z = -1.012-1.126*sin(d/11.73+5.133);
beta_z  = 0.106+0.118*sin(d/11.28+5.142);
rd      = min(1,exp(alpha_z+beta_z*Mw));
CSR     = 0.65*rd.*(svo./s_vo*PGA);

% Resistance
CRR_bl = exp(qc1ncs/113+(qc1ncs/1000).^2-(qc1ncs/140).^3+((qc1ncs/137).^4)-C_o);  CRR_bl(or(ic>2.6,d<wt))=NaN;
MSF    = 1+((min(2.2,1.09+(qc1ncs/180).^3))-1).*(8.64*exp(-Mw/4)-1.325);          MSF  (or(ic>2.6,d<wt),:)=NaN;
Csigma = min(0.3,max(0,1./(37.3-8.27*(qc1ncs).^0.264)));                          Csigma (or(ic>2.6,d<wt),:)=NaN;
Ksigma = min(1.1,1-Csigma.*log(s_vo/Pa));                                         Ksigma(or(ic>2.6,d<wt),:)=NaN;
CRR    =((CRR_bl.*Ksigma)*ones(1,NA)).*MSF;                                       CRR(or(ic>2.6,d<wt),:)=NaN;

% Factor of Safety
FS       = min(2,CRR./CSR);
CSR_bl   = CSR./(MSF.*Ksigma);
Co       = 2.6;
Slnr     = 0.2;
Pl       = 100* (1-normcdf((qc1ncs/113+(qc1ncs/1000).^2-(qc1ncs/140).^3+(qc1ncs/137).^4-Co-log(CSR_bl))/Slnr,0,1));
Pl(or(ic>2.6,d<wt))=NaN;

BI14.CSR=CSR;
BI14.CRR=CRR;
BI14.CRR751atm=CRR_bl;
BI14.Ksigma=Ksigma;
BI14.FS =FS;
BI14.PL =Pl;
%% Added by JM for LIBS derivate respect to PGA
% Ac=BI14.CRR;
% Cc=BI14.CSR/PGA;
% Bc=Ac/Cc;
Bc=CRR./(CSR/PGA);
N  = numel(d);
shder=zeros(N,NA);
sum3=zeros(1,NA);
for i=1:NA
    for j=1:N
        wz1=1;
        if Df>d(j)
            wz1=0;
        end
        DR_prom=meanDr(j);
        shder(j,i)=shearsetder(FS(j,i),DR_prom,ic(j),Bc(j,i),PGA(i));%shearset(FS(j,i),DR_prom,ic(j));
        sum3(i)=sum3(i)+shder(j,i)/d(j)*wz1*d_d;
    end
end

%% Post liquefaction volumetric strain (Z02)
NA = numel(Mw);
N  = numel(d);
vol_st_BI16_Z02 = zeros(N,NA);

for i=1:N
    for j=1:NA
        vol_st_BI16_Z02(i,j)=volset(FS(i,j),qc1ncs(i),ic(i));
    end
end

BI14.evol = vol_st_BI16_Z02;%list of volumetric strains in percentage

%% LBS CALCULATION
sh=zeros(N,NA);
sum2=zeros(1,NA);
for i=1:NA
    for j=1:N
        wz1=1;
        if Df>d(j)
            wz1=0;
        end
        DR_prom=meanDr(j);
        sh(j,i)=shearset(FS(j,i),DR_prom,ic(j));
        sum2(i)=sum2(i)+sh(j,i)/d(j)*wz1*d_d;
    end
end

BI14.LBS=sum2;
BI14.HL=sum(FS<1)*d_d;
end

function [ev] = volset(FS,qc1ncs,ic)

ev=0;
if FS<=0.5 && qc1ncs>=33 && qc1ncs<=200
    ev=102*(qc1ncs)^-0.82;
end

if FS>0.5 && FS<0.65 && qc1ncs>=33 && qc1ncs<=147
    ev=102*(qc1ncs)^-0.82;
end

if FS>0.5 && FS<0.65 && qc1ncs>147 && qc1ncs<=200
    ev=2411*(qc1ncs)^-1.45;
end

if FS>=0.65 && FS<0.75 && qc1ncs>=33 && qc1ncs<=110
    ev=102*(qc1ncs)^-0.82;
end

if FS>=0.65 && FS<0.75 && qc1ncs>110 && qc1ncs<=200
    ev=1701*(qc1ncs)^-1.42;
end

if FS>=0.75 && FS<0.85 && qc1ncs>=33 && qc1ncs<=80
    ev=102*(qc1ncs)^-0.82;
end

if FS>=0.75 && FS<0.85 && qc1ncs>80 && qc1ncs<=200
    ev=1690*(qc1ncs)^-1.46;
end

if FS>=0.85 && FS<0.95 && qc1ncs>=33 && qc1ncs<=60
    ev=102*(qc1ncs)^-0.82;
end
if FS>=0.85 && FS<0.95 && qc1ncs>60 && qc1ncs<=200
    ev=1430*(qc1ncs)^-1.48;
end

if FS>=0.95 && FS<1.05 && qc1ncs>=33 && qc1ncs<=200
    ev=64*(qc1ncs)^-0.93;
end

if FS>=1.05 && FS<1.15 && qc1ncs>=33 && qc1ncs<=200
    ev=11*(qc1ncs)^-0.65;
end

if FS>=1.15 && FS<1.25 && qc1ncs>=33 && qc1ncs<=200
    ev=9.7*(qc1ncs)^-0.69;
end

if FS>=1.25 && FS<1.35 && qc1ncs>=33 && qc1ncs<=200
    ev=7.6*(qc1ncs)^-0.71;
end

if FS>=1.35 && FS<2.0 && qc1ncs>=33 && qc1ncs<=200
    ev=7.6*(qc1ncs)^-0.71;
end

if FS>=2
    ev=0;
    
end

if ic>=2.6
    ev=0;
    
end

end
function [sh] = shearset(FS,DR,ic)

sh=0;
if DR<=45 && FS<0.81
    sh=51.2;
end

if DR<=45 && FS>=0.81 && FS<=1.0
    sh=250*(1-FS)+3.5;
end

if DR<=45 && FS>=1.0 && FS<=2.0
    sh=3.31*FS^-7.97;
end


if DR>45&& DR<=55 && FS<=0.72
    sh=34.1;
end

if DR>45&& DR<=55 && FS>=0.72 && FS<=2.0
    sh=4.22*FS^-6.39;
end

if DR>55&& DR<=65 && FS<=0.66
    sh=22.7;
end

if DR>55&& DR<=65 && FS>=0.66 && FS<=2.0
    sh=3.58*FS^-4.42;
end

if DR>65&& DR<=75 && FS<=0.59
    sh=14.5;
end

if DR>65&& DR<=75 && FS>=0.59 && FS<=2.0
    sh=3.20*FS^-2.89;
end

if DR>75&& DR<=85 && FS<=0.56
    sh=10;
end

if DR>75&& DR<=85 && FS>=0.56 && FS<=2.0
    sh=3.22*FS^-2.08;
end

if DR>85&& DR<=95 && FS<=0.70
    sh=6.2;
end

if DR>85&& DR<=95 && FS>=0.70 && FS<=2.0
    sh=3.26*FS^-1.80;
end
if FS>=2
    sh=0;
    
end
if ic>=2.6
    sh=0;
    
end
end

%%
function [dersh] = shearsetder(FS,DR,ic,Bc,PGA)

dersh=0;
if DR<=45 && FS<0.81
    dersh=0;%51.2
end

if DR<=45 && FS>=0.81 && FS<=1.0
    dersh=250*Bc/PGA^2;%250*(1-FS)+3.5;
end

if DR<=45 && FS>=1.0 && FS<=2.0
    dersh=3.31*Bc^-7.97*7.97*PGA^6.97;%3.31*FS^-7.97;
end


if DR>45&& DR<=55 && FS<=0.72
    dersh=0;%34.1;
end

if DR>45&& DR<=55 && FS>=0.72 && FS<=2.0
    dersh=4.22*Bc^-6.39*6.39*PGA^5.39;%4.22*FS^-6.39;
end

if DR>55&& DR<=65 && FS<=0.66
    dersh=0;%22.7;
end

if DR>55&& DR<=65 && FS>=0.66 && FS<=2.0
    dersh=3.58*Bc^-4.42*4.42*PGA^3.42;%3.58*FS^-4.42;
end

if DR>65&& DR<=75 && FS<=0.59
    dersh=0;%14.5;
end

if DR>65&& DR<=75 && FS>=0.59 && FS<=2.0
    dersh=3.20*Bc^-2.89*2.89*PGA^1.89;%3.20*FS^-2.89;
end

if DR>75&& DR<=85 && FS<=0.56
    dersh=0;%10;
end

if DR>75&& DR<=85 && FS>=0.56 && FS<=2.0
    dersh=3.22*Bc^-2.08*2.08*PGA^1.08;%3.22*FS^-2.08;
end

if DR>85&& DR<=95 && FS<=0.70
    dersh=0;%6.2;
end

if DR>85&& DR<=95 && FS>=0.70 && FS<=2.0
    dersh=3.26*Bc^-1.80*1.80*PGA^0.80;%3.26*FS^-1.80;
end
if FS>=2
    dersh=0;%0;
    
end
if ic>=2.6
    dersh=0;%0;
    
end
end
