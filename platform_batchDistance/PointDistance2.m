function[]=PointDistance2(sys,opt,h)

z     = 15;
RArad = 20;
dip   = 45*pi/180;
p     = h.p;
x     = h.p(:,1);
ae    = opt.ae;
maxdist = opt.maxdist;

%% Numerical calculations
xsource = linspace(0,RArad*cos(dip),1000);
zsource = linspace(-z,-z-RArad*sin(dip),1000);
Rrup2   = zeros(size(x));
Rjb2    = zeros(size(x));
for i=1:numel(Rrup2)
   dist = sqrt((x(i)-xsource).^2+zsource.^2);
   Rrup2(i)=min(dist);
   
   dist = sqrt((x(i)-xsource).^2);
   Rjb2(i)=min(dist);   
   Rx2 = abs(x);
end
Ztor2 = ones(size(x))*z;

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
    [~,rrup,~,rjb,~,~,~,ztor,]=source.pfun(xyz,source,Rmetric,maxdist,ae);
    Rrup(i) = rrup(1);
    Rjb(i)  = rjb(1);
    Rx(i)   = NaN;
    Ztor(i) = ztor(1);
end

figure
subplot(2,2,1), 
% hold on
% axis equal, box on,grid on
% plot(xsource,zsource,'k','linewidth',2)
% plot(10*cosd(45),-15-10*sind(45),'ro','linewidth',2)
plot(x,x*0,'r.','linewidth',2)
plot(x,Rrup ,'b.-',x,Rrup2,'r.') ,xlabel('x'), title('Rrup')
subplot(2,2,2), plot(x,Rjb  ,'b.-',x,Rjb2 ,'r.') ,xlabel('x'), title('Rjb')
subplot(2,2,3), plot(x,Rx   ,'b.-',x,Rx2  ,'r.')   ,xlabel('x'), title('Rx')
subplot(2,2,4), plot(x,Ztor ,'b.-',x,Ztor2,'r.') ,xlabel('x'), title('Ztor'), ylim([0,25])




