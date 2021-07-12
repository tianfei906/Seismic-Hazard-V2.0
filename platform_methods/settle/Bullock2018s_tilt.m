function [logTilt,sigma]=Bullock2018s_tilt(param,cav,vgi)

% input cav in cm/s
% input vgi in cm/s

B   = param.B;
L   = param.L;
q   = param.Q;
Df  = param.Df;

LPC = strcmpi(param.LAY.LPC,'Y');
th1 = param.LAY.th1;
th2 = param.LAY.th2;
N1  = param.LAY.N1;
N2  = param.LAY.N2;

N   = param.LAY.N160';
Hs  = param.LAY.thick';
Ds  = param.LAY.d2mat';

switch param.type
    case 'Masonry',             a=455;
    case 'Reinforced-Concrete', a=455;
    case 'Timber',              a= 51;
    case 'Steel',               a=242;
end

h   = q*1000/(9.81*a);  % building height in me
Mst = a*B*L*h;          % building weight in kg
numStories = round(h/3.41);

% coefficients
alp0	=-4.353;
alp1	=-0.329;
alp2	=-0.252;
alp3	=-0.036;
alp4	=-0.43;
alp5	=-0.121;
alp6	=0.003;
alp7	=0.026;
alp8	=-0.082;
alp9	=0.314;
alp10	=0.472;
alp11	=-0.02;
alp12	=0.234;
alp13	=0.404;
gam0	=0.066;
gam1	=0.165;
kap0	=2.383;
kap1	=1.491;
kap2	=-0.168;
kap3	=-0.327;
kap4	=0.087;
sigma = sqrt(0.548^2+0.1^2);

% Check 1
inTopB = nan*zeros(1,10);
isCut = nan*zeros(1,10);
isnotCut = nan*zeros(1,10);
thickness = nan*zeros(1,10);
thickness_above_cut = nan*zeros(1,10);
maxThick = nan*zeros(1,10);
for i = 1:10
    if Ds(i)+0.5*Hs(1)>B
        isCut(i)=1;
        isnotCut(i)=1-isCut(i);
    else
        isCut(i)=0;
        isnotCut(i)=1-isCut(i);
    end
    thickness(i)=Hs(i);
    thickness_above_cut(i)=max(B-(Ds(i)-0.5*Hs(i)),0);
    maxThick(i)=max(isCut(i)*thickness_above_cut(i), isnotCut(i)*thickness(i));
    if maxThick(i)>0
        inTopB(i)=1;
    else
        inTopB(i)=0;
    end
end

% Check2
bothExist = nan*zeros(1,9);
adjacent = nan*zeros(1,9);
addLayer = nan*zeros(1,9);
for i = 1:9
    if Hs(i)>0
        if Hs(i)>0
            bothExist(i)=1;
        else
            bothExist(i)=0;
        end
    else
        bothExist(i)=0;
    end
    
    if Ds(i+1)-0.5*Hs(i+1)==Ds(i)+0.5*Hs(i)
        adjacent(i)=1;
    else
        adjacent(i)=0;
    end
    
    if bothExist(i)==1
        if adjacent(i)==0
            addLayer(i)=1;
        else
            addLayer(i)=0;
        end
    else
        addLayer(i)=0;
    end
end
% NS1B=sum(inTopB);
% if sum(isCut)==0
%     NNS1B_bottom_of_B=1;
% else
%     NNS1B_bottom_of_B=0;
% end

% if Ds(1)-0.5*Hs(1)==0
%     NNS1B_surface = 0;
% else
%     NNS1B_surface =1;
% end
%
% NNS1B_intermediate=sum(addLayer);

if  N(1)<17.2
    FLoose1 = 1;
else
    FLoose1 = 0;
end

HS1B=sum(maxThick);
maxHS1B=th2;
NNS1B_NS1B=N2/N1;

logTilt_num=alp0+alp1*log(q)+alp2*log(B)^2+alp3*L/B+alp4*log(L/B)+alp5*log(Df)+(alp6*log(vgi)+alp7*log(cav))*HS1B+alp8*Ds(1)+alp9*FLoose1+alp10*min(Mst/(10^6),1)+alp11*(0.7*h/B)*(Mst/(10^6))+alp12*log(vgi)+alp13*log(cav);
if numStories ==1
    temp = h;
else
    temp=0.7*h;
end
logTilt_adj=logTilt_num+gam0+gam1*log(temp);
logTilt=logTilt_adj+kap0+kap1*LPC+kap2*th1+kap3*maxHS1B+kap4*NNS1B_NS1B;





