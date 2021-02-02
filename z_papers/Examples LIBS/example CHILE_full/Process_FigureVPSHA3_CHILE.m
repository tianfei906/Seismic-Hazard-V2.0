clearvars
close all
open('VPSHA3_Example_CHILE.fig')

ch=findall(gcf,'type','patch');
delete(findall(gcf,'type','line'))

co=[0    0.4470    0.7410
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
set(gca,'xlim',[1e-3 3],'zlim',[1e-5 1e1],'zminortick','off')
set(gca,'xtick',10.^(-3:1:3),'ztick',10.^(-6:2:0),'ytick',10.^(-5:2:1))

xlabel('CAV_{dp} (g\cdots)')
ylabel('PGA (g)')
box off
L=legend('> 1e-5 g','> 0.01 g','> 0.20 g','> 1.20 g');
L.Title.String='SA1';
L.Box='off';
L.Location='best';

text(0.03,1,1,'(c)')

