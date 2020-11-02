function plotCMS(fig,ax3,opt,cmsdata)

Rcenter     = mean(opt.Rbin,2);
Mcenter     = mean(opt.Mbin,2);

if isfield(cmsdata,'M')
    ch  = findall(fig,'tag','control_M'); ch.String = sprintf('%4.3g',cmsdata.M);
    ch  = findall(fig,'tag','control_R'); ch.String = sprintf('%4.3g',cmsdata.R);
else
    ch  = findall(fig,'tag','control_M'); ch.String = '';
    ch  = findall(fig,'tag','control_R'); ch.String = '';
end

ax1 = findall(fig,'tag','ax1');
ax2 = findall(fig,'tag','ax2');
ax4 = findall(fig,'tag','ax4');

%% ax1 Hazard Curve
delete(findall(ax1,'tag','haz'));
ax1.ColorOrderIndex=1;
plot(ax1,cmsdata.im,cmsdata.lambda,'.-','tag','haz');
plot(ax1,ax1.XLim,[1 1]/opt.Tr,'k--','tag','haz')
xlabel(ax1,'Sa(T*)','fontsize',8)
ylabel(ax1,'\lambda Sa(T*)','fontsize',8)


%% ax2 CMS plot
T    = cmsdata.T;
cms  = cmsdata.CMS(:,1);
cms1 = cmsdata.CMS(:,2);
cms2 = cmsdata.CMS(:,3);
rho  = cmsdata.RHO;
ax2.ColorOrderIndex=1;
delete(findall(ax2,'tag','cms'));
delete(findall(ax2,'tag','cmss'));
plot(ax2,T        ,cms,'.-','tag','cms')
plot(ax2,[T;nan;T],[cms1;nan;cms2],'.-','tag','cmss')
if ~isempty(cmsdata.CMSk)
    plot(ax2,T,cmsdata.CMSk,'color',[1 1 1]*0.76,'tag','cmss','handlevisibility','off');
end
L=legend(ax2,'CMS (\mu)','CMS(\mu\pm\sigma)');L.Box='off';

%% Correlation Model
delete(findall(ax4,'tag','rho'));
ax4.ColorOrderIndex=1;
plot(ax4,T,cmsdata.RHO,'.-','tag','rho')

%% ax3, Deaggregation
if isempty(cmsdata.dchart)
    ax3.Visible='off';
    set(ax3.Children,'Visible','off');
else
    dchart =cmsdata.dchart(:,:,1);
    bar3(ax3,Rcenter,dchart);
    set(ax3,...
        'xtick',1:2:length(Mcenter),...
        'xticklabel',Mcenter(1:2:end),...
        'ytick',Rcenter(1:2:end),...
        'projection','perspective',...
        'fontsize',8,...
        'visible','on',...
        'ylim',opt.Rbin([1,end]))
    
    xlabel(ax3,'Magnitude','fontsize',8);
    ylabel(ax3,'R (km)','fontsize',8);
    zlabel(ax3,'Hazzard Deagg','fontsize',8)
end
%% uicontext
cF=get(0,'format');
format long g
num  = [cmsdata.im,cmsdata.lambda];
Ncol = size(num,2);
data = num2cell([zeros(1,Ncol);num]);
data{1,1}=sprintf('Sa(T*=%g)',opt.Tcond);
data(1,2:Ncol)=repmat({'lambda'},1,Ncol-1);

c = uicontextmenu;
uimenu(c,'Label','Copy data','Callback',{@data2clipboard_uimenu,data});
uimenu(c,'Label','Undock','Callback'   ,{@figure2clipboard_uimenu,ax1});
set(ax1,'uicontextmenu',c);

num = [T,cms,cms1,cms2];
data = num2cell([zeros(1,4);num]);
data(1,:) = {'T(s)','CMS','CMS+SIG','CMS-SIG'};
c = uicontextmenu;
uimenu(c,'Label','Copy data','Callback',{@data2clipboard_uimenu,data});
uimenu(c,'Label','Undock','Callback'   ,{@figure2clipboard_uimenu,ax2});
set(ax2,'uicontextmenu',c);

c = uicontextmenu;
uimenu(c,'Label','Undock','Callback'   ,{@figure2clipboard_uimenu,ax3});
set(ax3,'uicontextmenu',c);

num = [T,rho];
data = num2cell([zeros(1,Ncol);num]);
data{1,1}='T(s)';
data(1,2:Ncol)=repmat({'rho(T,T*)'},1,Ncol-1);

c = uicontextmenu;
uimenu(c,'Label','Copy data','Callback',{@data2clipboard_uimenu,data});
uimenu(c,'Label','Undock','Callback'   ,{@figure2clipboard_uimenu,ax4});
set(ax4,'uicontextmenu',c);

format(cF);