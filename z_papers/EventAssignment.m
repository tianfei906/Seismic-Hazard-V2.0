
%% fuente real
clearvars
clc
ellip=referenceEllipsoid('WGS84','km');

load mytestdata foci
[sys,opt] = loadPSHA('Peru_SLAB_Declust4.txt');
foci(any(isnan(foci),2),:)=[];

% MinF=min(foci);
% MaxF=max(foci);
% [x1,x2,x3]=meshgrid(...
%     linspace(-300,300,30),...
%     linspace(-150,100,30),...
%     linspace(-40,40,50));
% foci=[x1(:),x2(:),x3(:)];

Nc    = size(foci,1);
dmax  = 60;


vert    = gps2xyz(sys.area1.vert(1:end-1,:),ellip);
xyzm    = sys.area1.xyzm;
hypm    = sys.area1.hypm;
m       = mean(vert);
N       = size(vert, 1);
pv_mov  = xyzm-m;
covar   = pv_mov'*pv_mov/N;
[U,S,V] = svd(covar);
xv      = pv_mov*V;
xq      = (foci-m)*V;
xyzr    = (xyzm-m)*V;

n = (sys.area1.normal*V);
n = n./sign(n(:,3));

hyp_mid = (hypm-m)*V;
hyp_top = hyp_mid+dmax*n;
hyp_bot = hyp_mid-dmax*n;


FTOP    = scatteredInterpolant(hyp_top(:,1),hyp_top(:,2),hyp_top(:,3),'linear','linear');
FMID    = scatteredInterpolant(hyp_mid(:,1),hyp_mid(:,2),hyp_mid(:,3),'linear','linear');
FBOT    = scatteredInterpolant(hyp_bot(:,1),hyp_bot(:,2),hyp_bot(:,3),'linear','linear');

in0     = and(xq(:,3)>FBOT(xq(:,1),xq(:,2)),xq(:,3)<FTOP(xq(:,1),xq(:,2)));
in1     = inpolygon(xq(:,1),xq(:,2),xv(:,1),xv(:,2));
in      = and(in0,in1);


%% Source in WGS84
% close all
% gpsm = xyz2gps(xyzm,ellip);
% patch('faces',sys.area1.conn,'vertices',gpsm,'facecolor','y','facealpha',0.1)
% view([28,31])
% xlabel('Lon')
% ylabel('Lat')
% zlabel('Depth (km)')

%% Source in ECEF
% close all
% patch('faces',sys.area1.conn,'vertices',xyzm,'facecolor','none','facealpha',0.1,'edgecolor',[1 1 1]*0.75)
% 
% xlabel('x (km)')
% ylabel('y (km)')
% zlabel('z (km)')
% hold on
% plot3(m(1)+200*[0 V(1,1)],m(2)+200*[0 V(2,1)],m(3)+200*[0 V(3,1)],'r-')
% plot3(m(1)+200*[0 V(1,2)],m(2)+200*[0 V(2,2)],m(3)+200*[0 V(3,2)],'m-')
% plot3(m(1)+200*[0 V(1,3)],m(2)+200*[0 V(2,3)],m(3)+200*[0 V(3,3)],'b-')
% 
% axis equal
% view([170 -44])
% xlim([881.959098246353          1262.32719640586])
% ylim([-6364.13549623389         -6064.13549623389])
% zlim([-282.322633228242          202.882896104503])


%% Source in rotated coordinates

close all
hold on
patch('faces',sys.area1.conn,'vertices',xyzr,'facecolor','none','facealpha',0.1,'edgecolor',[1 1 1]*0.75)
patch('faces',sys.area1.conn,'vertices',xyzr-[0 0 60],'facecolor','none','facealpha',0.1,'edgecolor',[1 0 0]*0.75)
patch('faces',sys.area1.conn,'vertices',xyzr+[0 0 60],'facecolor','none','facealpha',0.1,'edgecolor',[0 1 1]*0.75)


% plot3(200*[0 1],200*[0 0],200*[0 0],'r-')
% plot3(200*[0 0],200*[0 1],200*[0 0],'m-')
% plot3(200*[0 0],200*[0 0],200*[0 1],'b-')

% plot3(xq( in,1),xq( in,2),xq( in,3),'.','color',[0 1 1]*0.90)
plot3(xq(~in,1),xq(~in,2),xq(~in,3),'.','color',[1 1 1]*0.90)

axis equal
xlabel('E1')
ylabel('E2')
zlabel('E3')

xlim([-300 300])
ylim([-100 105])
zlim([-90 180])




