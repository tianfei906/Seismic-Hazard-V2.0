function[]=BatchDistance4(sys,opt,h)

z     = 25;
W     = 15*sqrt(2);
delta = -45*pi/180;
p     = h.p;
ellip = opt.ellipsoid;
media = h.value;
x     = h.p(:,2);

% Numerical calculations
xsource = linspace(0,   -W*cos(delta),1000);
ysource = linspace(-z,-z+W*sin(delta),1000);

Rrup2 = zeros(size(x));
Rjb2  = zeros(size(x));
for i=1:numel(Rrup2)
   dist = sqrt((x(i)-xsource).^2+ysource.^2);
   Rrup2(i)=min(dist);
   
   dist = sqrt((x(i)-xsource).^2);
   Rjb2(i)=min(dist);   
   Rx2 = -x;
end
Ztor2 = ones(size(x))*z;

%% SeismicHazard Calculations
Rrup  = zeros(size(x));
Rjb   = zeros(size(x));
Rx    = zeros(size(x));
Ztor  = zeros(size(x));

source = buildmodelin(sys,sys.branch(1,:),opt);
source.gmm.Rmetric=true(size(source.gmm.Rmetric));
Nsites = length(x);
for i=1:Nsites
    r0    = gps2xyz(p(i,:),ellip);
    source.media=media(i,:);
    param = source.pfun(r0,source,ellip,h.param,1);
    
    Rrup(i) = param(1);
    Rjb(i)  = param(2);
    Rx(i)   = param(3);
    Ztor(i) = param(4);

end

figure
subplot(2,2,1),
% hold on
% axis equal
% plot([0 W*cos(delta)],[-z -z-W*sin(delta)],'k','linewidth',2)
plot(x,Rrup ,'b',x,Rrup2,'r.') ,xlabel('x')  , title('Rrup')
subplot(2,2,2), plot(x,Rjb  ,'b',x,Rjb2 ,'r.') ,xlabel('x')  , title('Rjb')
subplot(2,2,3), plot(x,Rx   ,'b',x,Rx2  ,'r.')   ,xlabel('x'), title('Rx')
subplot(2,2,4), plot(x,Ztor ,'b',x,Ztor2,'r.') ,xlabel('x')  , title('Ztor')




