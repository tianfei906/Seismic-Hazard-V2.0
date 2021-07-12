function[LAY]=cpt2layer(param,res) %#ok<*INUSD>

LAY.raw = res;
ztop = res(1:end-1,1);
zbot = res(2:end,1);
%%%
addid = find(zbot<=param.Df);
ztopnew=ztop(addid(end)+1:end);
zbotnew=zbot(addid(end)+1:end);

if(param.Df>ztopnew(1))
    ztopnew(1)=param.Df;
end
ztop=ztopnew;
zbot=zbotnew;
%%%
zmid = 1/2*(ztop+zbot);
h    = zbot-ztop;
N    = size(ztop,1);
Ic   = zeros(N,1);

for i=1:N
    ind = and(ztop(i)<=param.CPT.z,param.CPT.z<zbot(i));
    Ic(i)  = mean(param.CPT.Ic(ind),'omitnan');
end

%% Finds susceptible layer
wt   = param.wt;
scr = find((zbot>wt).*(Ic<2.6));%susceptible layers
% nscrt=find(or((zbot<=wt),(Ic>2.6)));%non ssuceptible layers
% nscrt250=find((zbot-ztop>0.25).*or((zbot<=wt),(Ic>2.6)));%non-susceptible layers with tickness>250mm
%test=find((zbot>wt).*(ztop<wt).*(zbot-ztop>0.25).*or((zbot<=wt),(Ic>2.6)))%
scr = scr(1);    % susceptible crust pointer
% nscr = 1:scr-1 ; % non-susceptible crust pointer

%% Low permeability cap present above top susceptible layer
% t1=wt;
ds1=ztop(scr(1));% depth of top susceptible layer
nscrtop=find((zbot>wt).*(ztop<=wt).*(h>0.25).*(Ic>2.6));% Find a layer with the top boundary above the water table and the botom boundary below the water table, and ask if the tickness is higher than 0.25 m and Ic>2.6
nscrtop1=find((zbot>wt).*(ztop<ds1).*(h>0.25).*(Ic>2.6), 1);% Find the layers below the water table, above the first suceptible layer depth (ds1), with tickness larger than 0.25m and Ic>2.6

if isempty(nscrtop1)% if we find a layer below the water table and above the first suceptible layer with a tickeness > 0.25m and Ic>2.6, there is a crust!
    LAY.LPC = 'N';
else
    LAY.LPC = 'Y';
end

if isempty(nscrtop)% if we find a layer with the top part above the water table, the bottom part below, the tickness>0.25m, and the Ic>2.6, then there is a crust!
    za=wt;
else
    za=zbot(nscrtop);
    LAY.LPC   = 'Y';
end

%% Non-susceptible crust thickness, za, favor revisar.
LAY.th1= za; % this is the za to be used in the ejecta evaluation

%% % Maximum continuous thickness of susceptible material in top B
nscrtopB=find((zbot>wt).*(ztop<param.B).*(zbot-ztop>0.25).*(Ic>2.6));% Find the layers below the water table, above the depth B, with tickness larger than 0.25m and Ic>2.6

if isempty(nscrtopB)
    LAY.th2=param.B;
else
    % if we have a nonsuceptible layer in the top B with a tickness>0.25, the continuum liquefiable tickness is the distance from the top of the first non liquefiable layer with tickness>0.25 to the water table
    LAY.th2 = abs(wt-ztop(nscrtopB(1)));
end
%% % Maximum continuous thickness of susceptible material in top 10m (this is to calculate zb used in ejecta)
nscrtop10=find((zbot>za).*(ztop<10).*(zbot-ztop>0.25).*(Ic>2.6));% Find the layers below za, above 10m, with tickness larger than 0.25m and Ic>2.6

if isempty(nscrtop10)
    LAY.th3=10;
else
    % if we have a nonsuceptible layer in the top 10m with a tickness>0.25,
    % the continuum liquefiable tickness is the distance from the top of
    % the first non liquefiable layer with tickness>0.25 to the the depth
    % that corrsponds to za
    LAY.th3 = abs(za-ztop(nscrtop10(1)));
end


%% Number of susceptible layers in top B
scrtopB=find((zbot>wt).*(ztop<param.B).*(Ic<2.6));% Find the layers below the water table, above the depth B, and Ic<2.6
if isempty(scrtopB)
    LAY.N1=0;
else
    LAY.N1=size(scrtopB,1) ;
end

%% Number of non-susceptible layers in top B
if isempty(nscrtopB)
    LAY.N2=0;
else
    LAY.N2=size(nscrtopB,1) ;
end

%% Average tip resistance
LAY.meth  = 'CPT';    % Soil profile testing method
LAY.N160  = nan(1,N);
LAY.qc1N  = nan(1,N);
for i=1:N
    ind = and(param.CPT.z>=ztop(i),param.CPT.z<=zbot(i));
    LAY.qc1N(i)=mean(param.CPT.Qtn(ind),'omitnan');
end

%% Thickness of layer i (m)
LAY.thick = h';

%% Depth from bottom of foundation to center of layer
LAY.d2mat = zmid'-param.Df;
