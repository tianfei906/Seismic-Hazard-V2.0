clearvars
close all
w1  = open('DeaggMR1.fig');
w2  = open('DeaggMR2.fig');
ax1 = findall(w1,'type','axes');
ax2 = findall(w2,'type','axes');

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