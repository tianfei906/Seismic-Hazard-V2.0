function[]=BatchDistance5(sys,opt,h)

zt    = 25;
W     = 15*sqrt(2);
delta = 45*pi/180;
p     = h.p;
x     = h.p(:,1);
y     = h.p(:,2);
z     = h.p(:,3);
ae    = opt.ae;
maxdist = opt.maxdist;


%% Numerical calculations
xsource = linspace(0,W*cos(delta),200);
ysource = linspace(-5,5          ,200);
[xsource,ysource]=meshgrid(xsource,ysource);
xsource=xsource(:);
ysource=ysource(:);
zsource=-zt-xsource*tan(delta);

Rrup2 = zeros(size(x));
Rjb2  = zeros(size(x));
for i=1:numel(Rrup2)
   dist = sqrt((x(i)-xsource).^2+(y(i)-ysource).^2+(z(i)-zsource).^2);
   Rrup2(i)=min(dist);
   
   dist = sqrt((x(i)-xsource).^2+(y(i)-ysource).^2);
   Rjb2(i)=min(dist);   
   Rx2 = x;
end
Ztor2 = ones(size(x))*zt;

%% SeismicHazard Calculations
Rrup    = zeros(size(x));
Rjb     = zeros(size(x));
Rx      = zeros(size(x));
Ztor    = zeros(size(x));
source  = buildmodelin(sys,sys.branch(1,:),opt);
Rmetric = true(1,11);
Nsites  = length(x);

for i=1:Nsites
    xyz    = gps2xyz(p(i,:),ae);
    [~,rrup,~,rjb,rx,~,~,ztor,]=source.pfun(xyz,source,Rmetric,maxdist,ae);
    Rrup(i) = rrup(1);
    Rjb(i)  = rjb(1);
    Rx(i)   = rx(1);
    Ztor(i) = ztor(1);
end

figure
subplot(2,2,1), plot(x,Rrup ,'b',x,Rrup2,'r.') ,xlabel('x'), title('Rrup')
subplot(2,2,2), plot(x,Rjb  ,'b',x,Rjb2 ,'r.') ,xlabel('x'), title('Rjb')
subplot(2,2,3), plot(x,Rx   ,'b',x,Rx2  ,'r.')   ,xlabel('x'), title('Rx')
subplot(2,2,4), plot(x,Ztor ,'b',x,Ztor2,'r.') ,xlabel('x'), title('Ztor')




