function [R15] = cptR15(cpt, wt, Df,Mw, PGA)

Pa          = 101.3;           % Atmospheric pressure in kPa
d = cpt.z;
svo = cpt.svo;
s_vo= cpt.s_vo;
meanDr = mean(cpt.Dr,2);
ic = cpt.Ic;
d_d         = d(2)-d(1); % Spacing in depth
N = length(d);
Fr = cpt.Fr;
%% Evaluation of Liquefaction (Robertson 15)
% Demand
1;                        rd_rob      = 1-0.00765*d;
ind1 = and(9.15<d,d<=23); rd_rob(ind1)= 1.174-0.0267*d(ind1);
ind2 = and(23.0<d,d<=30); rd_rob(ind1)= 1.174-0.0267*d(ind1);
ind3 = d>30;              rd_rob(ind2)= 0.744-0.0080*d(ind2);
1;                        rd_rob(ind3)= 0.5;

CSR_rob  = 0.65*(rd_rob.*svo./s_vo)*PGA;

% Resistance
% CRR_bl for Robertosn is given in Ic section
k_c         = zeros([N,1]);
for i=1:N
    if ic(i)<=2.50
        if ic(i) <= 1.64 || ic(i)>1.64 && ic(i)<2.36 && Fr(i)<0.5
            k_c(i) = 1.0;
        elseif ic(i)<=2.5
            k_c(i) = 5.58*ic(i).^3-0.403*ic(i).^4-21.63*ic(i).^2+33.75*ic(i)-17.88;
            k_c(i) =min(k_c(i),2.0);
        end
    elseif ic(i)<=2.6
        k_c(i) = 6e-7*ic(i).^16.76;
        k_c(i) =min(k_c(i),2.0);
    else
        k_c(i) =1;%NaN;
    end
end

Qtncs      = cpt.Qtn.*k_c;
ind1 = and(~isnan(Qtncs),Qtncs<=50);
ind2 = and(~isnan(Qtncs),and(50<Qtncs,Qtncs<=160));
ind3 = or(Qtncs>160,isnan(Qtncs));
CRR_rob_bl=zeros(N,1);
CRR_rob_bl(ind1) = 0.833*Qtncs(ind1)/1000+0.05;
CRR_rob_bl(ind2) = 93*(Qtncs(ind2)/1000).^3+0.08;
CRR_rob_bl(ind3) = 0.5;

MSF_rob   = ones(N,1)*174./Mw.^2.56; MSF_rob(or(ic> 2.6,d<wt))=NaN;
Dr_km = cpt.Dr(:,3);
factor_ks = 1-Dr_km/200;
factor_ks(Dr_km<=40)=0.8;
factor_ks(Dr_km> 80)=0.6;
factor_ks(or(ic> 2.6,d<wt))=NaN;


Ksigma_rob =(s_vo/Pa).^(factor_ks-1);           Ksigma_rob(or(ic> 2.6,d<wt))=NaN;
CRR_rob    =(CRR_rob_bl.*Ksigma_rob).*MSF_rob; CRR_rob(or(ic> 2.6,d<wt),:)=NaN;

% Factor of Safety & Probability of Liquefaction
FS_rob = min(2,CRR_rob./CSR_rob);
Pl_rob = 100./(1+(FS_rob/0.9).^6.3);

R15.CSR=CSR_rob;
R15.CRR=CRR_rob;
R15.FS=FS_rob;
R15.PL=Pl_rob;

%% Post liquefaction volumetric strain (Z02)
NA = numel(Mw);
vol_st_R09_Z02 = zeros(N,NA);
for i=1:N
    for j=1:NA
        vol_st_R09_Z02(i,j) =volset(FS_rob(i,j),Qtncs(i),ic(i));
    end
end
R15.evol  = vol_st_R09_Z02;

%% LBS XCALCULATION
sh_rob=zeros(N,NA);
sum3=zeros(1,NA);
for i=1:NA
    for j=1:N
        wz1=1;
        if Df>d(j)
            wz1=0;
        end
        DR_prom=meanDr(j);
        sh_rob(j,i)=shearset(FS_rob(j,i),DR_prom,ic(j));
        sum3(i)=sum3(i)+sh_rob(j,i)/d(j)*wz1*d_d;
    end
end

R15.LBS=sum3;
R15.HL=sum(FS_rob<1)*d_d;

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
