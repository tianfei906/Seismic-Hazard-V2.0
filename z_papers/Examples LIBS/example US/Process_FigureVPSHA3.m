clearvars
close all
open('VPSHA3_Example.fig')

ch=findall(gcf,'type','patch');
delete(findall(gcf,'type','line'))

co=[         0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];



ch(1).FaceColor=co(4,:);ch(1).Vertices(:,1)=ch(1).Vertices(:,1)/980.66;
ch(2).FaceColor=co(5,:);ch(2).Vertices(:,1)=ch(2).Vertices(:,1)/980.66;
ch(3).FaceColor=co(2,:);ch(3).Vertices(:,1)=ch(3).Vertices(:,1)/980.66;
ch(4).FaceColor=co(1,:);ch(4).Vertices(:,1)=ch(4).Vertices(:,1)/980.66;
set(ch,'EdgeColor',[1 1 1]*0.8)
set(gcf,'position',[  403   317   400   338])
set(gca,'xtick',10.^[-4:1],'xlim',[1e-3 3],'ytick',10.^[-4:0],'position',[0.176153846 0.1780473 0.672435 0.70257])
xlabel('CAV_{dp} (g\cdots)')
ylabel('PGA (g)')
box off
L=legend('> 0.00 g','> 0.01 g','> 0.16 g','> 0.50 g');
L.Title.String='SA1';
L.Box='off';
L.Location='best';

text(0.03,1,1,'(d)','fontsize',11)
set(gca,'ztick',10.^[-4:1:0],'zlim',[1e-5 2e0])
set(gca,'XMinorTick','off','YMinorTick','off','ZMinorTick','off')