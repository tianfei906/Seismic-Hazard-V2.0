function plotCPSfile(handles)

% Housekeeping
fig = findobj(allchild(groot), 'flat', 'type', 'figure', 'number', 1001);
if ~isempty(fig)
    close(fig);
end
    
delete(vertcat(handles.ax.Children))
set(handles.ax,'ColorOrderIndex',1,'Visible','off');

set(handles.ax1,'XLimMode','auto','YLimMode','auto');
set(handles.ax2,'XLimMode','auto','YLimMode','auto');
set(handles.ax3,'XLimMode','auto','YLimMode','auto');
set(handles.ax4,'XLimMode','auto','YLimMode','auto');
set(handles.ax5,'XLimMode','auto','YLimMode','auto');

plotmode = handles.uibuttongroup1.SelectedObject.String;

dolay=false;
switch plotmode
    case 'Basic plots'               , plotCPT1(handles); dolay=true;
    case 'Normalized plots'          , plotCPT2(handles); dolay=true;
    case 'Liquefaction Plots (BI16)' , plotCPT3(handles,'BI14'); dolay=true;
    case 'Liquefaction Plots (R15)'  , plotCPT3(handles,'R15'); dolay=true;
    case 'SBT'                       , plotCPT4(handles);
    case 'SBTn'                      , plotCPT5(handles);
    case 'randomplot'                , plotRANDOM(handles);              
end
val = handles.popupmenu1.Value;
zend=handles.cpt(val).z(end);
handles.ax1.YLim=[0 zend];
handles.ax2.YLim=[0 zend];
handles.ax3.YLim=[0 zend];
handles.ax4.YLim=[0 zend];
handles.ax5.YLim=[0 zend];

%% plots automatic layering
if dolay
    lay = handles.param.LAY.raw(2:end-1)';
    for i=1:5
        axlabel=sprintf('ax%g',i);
        ax =handles.(axlabel);
        XL = ax.XLim;
        XX = repmat([XL NaN],length(lay),1)';
        ZZ = [lay' lay' lay'*NaN]';
        plot(ax,XX(:),ZZ(:),'-','color',[1 1 1]*0.75);
        ax.XLim=XL;
    end
end

function plotCPT1(handles)
val = handles.popupmenu1.Value;
handles.ax1.Visible='on';
handles.ax2.Visible='on';
handles.ax3.Visible='on';
handles.ax4.Visible='on';
handles.ax5.Visible='on';

wt  = handles.param(1).wt;
cpt = handles.cpt(val);
z   = cpt.z;

% plots mode1
gray = [1 1 1]*0.26;
plot(handles.ax1,cpt.qt/1000  , z,'color',gray)
plot(handles.ax2,cpt.Rf  , z,'color',gray)
plot(handles.ax3,cpt.u2  , z,'color',gray)
plot(handles.ax4,cpt.Ic  , z,'color',gray)
plotSBT(handles.ax5,cpt.SBT , z)

ylabel(handles.ax1,'Depth (m)','fontweight','bold')
title(handles.ax1,'Cone Resistance'),    xlabel(handles.ax1,'qt(MPa)')
title(handles.ax2,'Friction Ratio'),     xlabel(handles.ax2,'Rf(%)')
title(handles.ax3,'Pore Pressure'),      xlabel(handles.ax3,'u(kPa)')
title(handles.ax4,'SBT Plot'),           xlabel(handles.ax4,'Ic(SBT)')
title(handles.ax5,'Soil Behaviour Type'),xlabel(handles.ax5,'SBT(Robertson et al. 1986)')
handles.ax3.XLimMode='auto';
handles.ax4.XLim(1)=0;
handles.ax5.XLim   =[0 10];

set(handles.ax1.Children,'Visible',handles.ax1.Visible)
set(handles.ax2.Children,'Visible',handles.ax2.Visible)
set(handles.ax3.Children,'Visible',handles.ax3.Visible)
set(handles.ax4.Children,'Visible',handles.ax4.Visible)
set(handles.ax5.Children,'Visible',handles.ax5.Visible)

%plots groundwater level
handles.ax3.ColorOrderIndex=1; plot(handles.ax3,cpt.u0, z)
handles.ax3.ColorOrderIndex=1; plot(handles.ax3,handles.ax3.XLim,wt*[1 1],'--')

function plotCPT2(handles)
val = handles.popupmenu1.Value;
handles.ax1.Visible='on';
handles.ax2.Visible='on';
handles.ax3.Visible='on';
handles.ax4.Visible='on';
handles.ax5.Visible='on';

cpt = handles.cpt(val);
z   = cpt.z;

% plots mode1
gray = [1 1 1]*0.26;
plot(handles.ax1,cpt.Qtn , z,'color',gray)
plot(handles.ax2,cpt.Fr  , z,'color',gray)
plot(handles.ax3,cpt.Bq  , z,'color',gray)
plot(handles.ax4,cpt.Ic  , z,'color',gray)
plotSBT(handles.ax5,cpt.SBTn, z)

ylabel(handles.ax1,'Depth (m)','fontweight','bold')
title(handles.ax1,'Cone Resistance'),    xlabel(handles.ax1,'Qtn')
title(handles.ax2,'Friction Ratio'),     xlabel(handles.ax2,'Fr(%)')
title(handles.ax3,'Pore Pressure'),      xlabel(handles.ax3,'Bq')
title(handles.ax4,'SBTn Plot'),          xlabel(handles.ax4,'Ic(Robertson 1990)')
title(handles.ax5,'Soil Behaviour Type'),xlabel(handles.ax5,'SBTn(Robertson 1990)')
%handles.ax3.XLim=[-0.5 1.6];
handles.ax4.XLim(1)=0;
handles.ax5.XLim   =[0 10];

set(handles.ax1.Children,'Visible',handles.ax1.Visible)
set(handles.ax2.Children,'Visible',handles.ax2.Visible)
set(handles.ax3.Children,'Visible',handles.ax3.Visible)
set(handles.ax4.Children,'Visible',handles.ax4.Visible)
set(handles.ax5.Children,'Visible',handles.ax5.Visible)

function plotCPT3(handles,fld)
val = handles.popupmenu1.Value;
cpt = handles.cpt(val);
z   = cpt.z;
wt  = handles.param.wt;
Df  = handles.param.Df;
Mw  = str2double(handles.M.String);
PGA = str2double(handles.PGA.String);

switch fld
    case 'BI14', LIQ = cptBI14(cpt, wt, Df,Mw, PGA);
    case 'R15' , LIQ = cptR15(cpt, wt, Df,Mw, PGA);
end


handles.ax1.Visible='on';
handles.ax2.Visible='on';
handles.ax3.Visible='on';
handles.ax4.Visible='on';
handles.ax5.Visible='on';

% ax1
gray = [1 1 1]*0.26;
plot(handles.ax1,LIQ.CRR, z,'color',gray)
plot(handles.ax1,LIQ.CSR, z,'color',[1 0 0]);

handles.ax1.XLim=[0 0.6];
ylabel(handles.ax1,'Depth (m)','fontweight','bold')
title(handles.ax1,'CRR plot'),    xlabel(handles.ax1,'CRR & CSR')

%ax2
zm = z(end);
Z= [0 0 zm zm];
P=patch(handles.ax2,'XData',[0.0 0.7 0.7 0.0],'YData',Z); P.FaceColor=[255 0   0 ]/255; P.EdgeColor='none';P.FaceAlpha=0.5;
P=patch(handles.ax2,'XData',[0.7 0.8 0.8 0.7],'YData',Z); P.FaceColor=[255 153 51]/255; P.EdgeColor='none';P.FaceAlpha=0.5;
P=patch(handles.ax2,'XData',[0.8 1.0 1.0 0.8],'YData',Z); P.FaceColor=[255 255 0 ]/255; P.EdgeColor='none';P.FaceAlpha=0.5;
P=patch(handles.ax2,'XData',[1.0 1.2 1.2 1.0],'YData',Z); P.FaceColor=[146 208 80]/255; P.EdgeColor='none';P.FaceAlpha=0.5;
P=patch(handles.ax2,'XData',[1.2 2.0 2.0 1.2],'YData',Z); P.FaceColor=[0   176 80]/255; P.EdgeColor='none';P.FaceAlpha=0.5;
plot(handles.ax2,LIQ.FS, z,'color',gray)
handles.ax2.XLim=[0 2];
handles.ax2.Layer='top';
title(handles.ax2,'FS plot'), xlabel(handles.ax2,'Factor of Safety')

% ax3
plot(handles.ax3,cpt.Ic  , z,'color',gray)
title(handles.ax3,'Ic plot'), xlabel(handles.ax3,'Ic')

% ax4
plot(handles.ax4,LIQ.evol, z,'color',gray)
title(handles.ax4,'Volumetric Strain'), xlabel(handles.ax4,'e_{vol} (%)')
% ax5
plot(handles.ax5,LIQ.PL, z,'color',gray)
handles.ax5.XLim=[0 100];
title(handles.ax5,'PL plot'), xlabel(handles.ax5,'Prob. of Liquefaction (%)')

function plotCPT4(handles)
val = handles.popupmenu1.Value;
handles.ax6.Visible='on';
COL = [255	0	0
    191	143	0
    0	153	153
    123	123	123
    180	198	231
    84	130	53
    198	224	180
    255	255	0
    191	143	0]/255;

cpt = handles.cpt(val);
Pa2 = 0.1;          % MPa

for i=1:9
    REG=handles.reg1{i};
    Np = size(REG,1);
    patch(handles.ax6,'faces',1:Np,'vertices',REG,'facecolor',COL(i,:),'facealpha',0.5,'edgecolor','w');
end

xlabel(handles.ax6,'Friction Ratio, Rf','fontweight','bold')
ylabel(handles.ax6,'Cone Resistance, qc/Pa','fontweight','bold')
scatter(handles.ax6,cpt.Rf,cpt.qc/Pa2,15,cpt.SBT,'filled')
text(handles.ax6,[0.3 7 2 1 0.5 0.3 0.21 3 7],[3 1.5 3 10 20 90 500 500 300],{'1','2','3','4','5','6','7','8','9'},'fontweight','bold')
handles.ax6.Layer='top';

function plotCPT5(handles)
val = handles.popupmenu1.Value;
handles.ax7.Visible='on';
handles.ax8.Visible='on';
xlabel(handles.ax7,'Fr(%)','fontweight','bold')
ylabel(handles.ax7,'Qt'   ,'fontweight','bold')
xlabel(handles.ax8,'B_q'  ,'fontweight','bold')
ylabel(handles.ax8,'Qt'   ,'fontweight','bold')

COL = [255	0	0
    191	143	0
    0	153	153
    123	123	123
    180	198	231
    84	130	53
    198	224	180
    255	255	0
    191	143	0]/255;

cpt = handles.cpt(val);
% Pa2 = 0.1;          % MPa

for i=1:9
    REG=handles.reg1{i};
    Np = size(REG,1);
    patch(handles.ax7,'faces',1:Np,'vertices',REG,'facecolor',COL(i,:),'facealpha',0.5,'edgecolor','w');
end

for i=1:7
    REG=handles.reg2{i};
    Np = size(REG,1);
    patch(handles.ax8,'faces',1:Np,'vertices',REG,'facecolor',COL(i,:),'facealpha',0.5,'edgecolor','w');
end

scatter(handles.ax7,cpt.Fr,cpt.Qt,15,cpt.SBTn,'filled')
scatter(handles.ax8,cpt.Bq,cpt.Qt,15,cpt.SBTn,'filled')
text(handles.ax7,[0.3 7 2 1 0.5 0.3 0.21 3 7]  ,[3 1.5 3 10 20 90 500 500 300],{'1','2','3','4','5','6','7','8','9'},'fontweight','bold')
text(handles.ax8,[1.2 0.5 0.6 0.4 0.2 0.1 0.1 ],[3 1.5 8.0 30 50 100 400 ],{'1','2','3','4','5','6','7'},'fontweight','bold')

handles.ax7.Layer='top';
handles.ax8.Layer='top';

function plotRANDOM(handles)

handles.ax1.Visible='on'; plot(handles.ax1,rand(10,1),rand(10,1))
handles.ax2.Visible='on'; plot(handles.ax2,rand(10,1),rand(10,1))
handles.ax3.Visible='on'; plot(handles.ax3,rand(10,1),rand(10,1))
handles.ax4.Visible='on'; plot(handles.ax4,rand(10,1),rand(10,1))
handles.ax5.Visible='on'; plot(handles.ax5,rand(10,1),rand(10,1))

