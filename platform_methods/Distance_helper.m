clearvars

Ztor = 2;
dip  = 45;
W    = 5;
Z25  = 5;
x    = 5;

xsource = [0 W*cosd(-dip)];
ysource = [0 W*sind(-dip)]-Ztor;

Wp = Ztor/sind(dip);
xp = Ztor/tand(dip);
xq = Ztor*tand(dip);
xr = (Wp+W)/cosd(dip)-xp;

xrb1 = 0;
xrb2 = W*cosd(dip);

% Rx
Rx = x;

% Rjb
if x<0 || x> xrb2
    [Rjb,ind]=min(abs(x-[xrb1,xrb2]));
if ind==1
    prj=[xrb1 x];
else
    prj=[xrb2 x];
end
else
    Rjb =0;
    prj=[nan nan];
end 

% Rrup
if x<=xq
    prup   = [xsource(1),ysource(1)];
elseif and(xq<x,x<xr)
    wx = cosd(dip)*(x(1)+xp);
    prup = [wx*cosd(dip)-xp,-wx*sind(dip)];
else
    prup = [xsource(2),xsource(2)];
end
Rrup = norm(prup-[x,0]);

close all
ax=axes;
hold on
plot(ax,xsource,ysource,'k','linewidth',2)
plot(ax,[x,prup(1)],[0 prup(2)],'k:')
axis equal
ax.YLim=ax.YLim+[-1 1];
plot(ax,ax.XLim,[0 0],'k:')
plot(ax,[0 0],[-Ztor 1],'k:')
plot(ax,xsource([2 2]),[ysource(2)	 1],'k:')
plot(ax,[x x],[0 1],'k:')
plot(ax,ax.XLim,-[Z25 Z25],'b--')
plot(ax,x,0,'k^','markerfacecolor','y','markersize',9)

xc = x/2;          Lq = x;   plot(xc+[-Lq/2 Lq/2],[0.8 0.8],'k.-')
xc = (x+prj(1))/2; Lq = Rjb; plot(xc+[-Lq/2 Lq/2],[0.4 0.4],'k.-')
title(sprintf('Rrup=%3.3g,  Rjb=%3.3g,  Rx=%3.3g',Rrup,Rjb,Rx))