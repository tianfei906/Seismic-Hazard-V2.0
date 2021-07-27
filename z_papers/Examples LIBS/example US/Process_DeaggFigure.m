clearvars
close all
w1  = open('DeaggMR1.fig');
w2  = open('DeaggMR2.fig');
ax1 = findall(w1,'type','axes');zlabel(ax1,'Settlement-Deagg(%)');
ax2 = findall(w2,'type','axes');zlabel(ax2,'Settlement-Deagg(%)');

fig=figure;
fig.Position=[373   363   903   303];
n1=copyobj(ax1, fig); n1.ZLim=[0 15];
n2=copyobj(ax2, fig); n2.ZLim=[0 15];

close(w1);
close(w2);

n1.Position=[ 0.13 0.11 0.375 0.815];
n2.Position=[ 0.53 0.11 0.375 0.815];

text(n1,1,1,15,'(c)')
text(n2,1,1,15,'(d)')

n1.XTickLabelRotation=0;
n2.XTickLabelRotation=0;

n1.YTickLabelRotation=0;
n2.YTickLabelRotation=0;

grid(n1,'off')
grid(n2,'off')