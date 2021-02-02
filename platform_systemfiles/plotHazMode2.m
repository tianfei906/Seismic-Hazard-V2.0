function [str,tit]=plotHazMode2(fig,haz,opt,MRE,labelG,mech,idx,brnames)

ax1          = findall(fig,'tag','ax1');
ax2          = findall(fig,'tag','ax2');
site_menu    = findall(fig,'tag','site_menu'); 
IM_select    = findall(fig,'tag','IM_select');
po_region    = findall(fig,'tag','po_region');
SecondaryColor = findall(fig,'tag','ColorSecondaryLines');

source_ptr = po_region.Value;
site       = site_menu.Value;
IM_ptr     = IM_select.Value;

%% -------------  initialization ----------------------------------
if size(opt.im,2)==1
    im  = opt.im';
else
    im  = opt.im(:,IM_ptr)';
end

delete(findall(ax1,'tag','scenario'));
delete(findall(ax2,'type','line'));
delete(findall(ax2,'tag','histogram'));
ax2.ColorOrderIndex = 1;

%% -------------  compute lambda1 and lambda0 ----------------------------
model_ptr = haz.sbh(1);

if haz.dbt(2)==0
    lambda1   = MRE(site,:,IM_ptr,:,model_ptr);
    lambda1   = permute(lambda1,[4,2,1,3]);
    lambda0   = nansum(lambda1,1);
end

if haz.sbh(2)==1
    NOTNAN    = ~isnan(lambda1(:,1));
    lambda1   = lambda1(NOTNAN,:);
end

if haz.sbh(3)==1
    lambda1   = [...
        nansum(lambda1(mech{source_ptr}==1,:),1);
        nansum(lambda1(mech{source_ptr}==2,:),1);
        nansum(lambda1(mech{source_ptr}==3,:),1);
        nansum(lambda1(mech{source_ptr}==4,:),1);
        nansum(lambda1(mech{source_ptr}==5,:),1);
        nansum(lambda1(mech{source_ptr}==6,:),1);
        nansum(lambda1(mech{source_ptr}==7,:),1);
        ];
    NOTNAN    = (sum(lambda1,2)>0);
    lambda1   = lambda1(NOTNAN,:);
end

switch haz.dbt(3)
    case 0
        y0 = lambda0;
        y1 = lambda1;
    case 1
        y0 = 1-exp(-lambda0*haz.dbt(4));
        y1 = 1-exp(-lambda1*haz.dbt(4));
end

%% -------------  plot hazard--------------------------------------
y0(y0<0)=nan;
plot(ax2,im',y0','.-','ButtonDownFcn',{@myfun,fig,haz},'tag','lambda0');

y1(y1<0)=nan;
if isempty(y1)
    y1=nan(size(im));
end

VIS = 'off';
if or(haz.sbh(2),haz.sbh(3))
    VIS = 'on';
end

switch SecondaryColor.Value
    case 0,plot(ax2,im',y1','-','ButtonDownFcn',{@myfun,fig,haz},'tag','lambda1','visible',VIS)
    case 1,plot(ax2,im',y1','-','color',[1 1 1]*0.76,'ButtonDownFcn',{@myfun,fig,haz},'tag','lambda1','visible',VIS)
end

%% -------------  xlabel & ylabel ----------------------------------
if iscell(IM_select.String)
    xlabel(ax2,addIMunits(IM_select.String{IM_ptr}),'fontsize',8)
else
    xlabel(ax2,addIMunits(IM_select.String),'fontsize',8)
end

switch find(haz.dbt(1:3))
    case 1,ylabel(ax2,'Mean Rate of Exceedance','fontsize',8)
    case 2,ylabel(ax2,'Mean Rate Density','fontsize',8)
    case 3,ylabel(ax2,'Probability of Exceedance','fontsize',8)
end

%% -------------  legend  -----------------------------------------
str = {'Total'};
tit = brnames(model_ptr,4);

if haz.sbh(2)==1
    labelG = labelG{source_ptr}(NOTNAN);
    str = [str;labelG];
end

if haz.sbh(3)==1
    mechs = {'Interface';'Intraslab';'Crustal';'System';'Slab';'Fault';'Grid'};
    str = [str;mechs(NOTNAN)];
end

%%  -------------  ui context menu ------------------------------------------
IMstr = IM_select.String{IM_ptr};
notnan=find(~isnan(sum(lambda1,2)));

if haz.sbh(2)==0 && haz.sbh(3)==0
    data1  = num2cell([zeros(1,2);[im',y0']]);
else
    Ncol  = size(y0,1)+1+length(notnan);
    data1  = num2cell([zeros(1,Ncol);[im',y0',y1(notnan,:)']]);
end

data1{1,1}=IMstr;
data1(1,2:end)=str(1:end);
data2 = haz2ret(data1);
c2 = uicontextmenu;
uimenu(c2,'Label','Copy data (IM-Hazard)','Callback'         ,{@data2clipboard_uimenu,data1});
uimenu(c2,'Label','Copy data (Return Period -IM)','Callback' ,{@data2clipboard_uimenu,data2});
uimenu(c2,'Label','Undock','Callback'           ,{@figure2clipboard_uimenu,ax2});
uimenu(c2,'Label','Undock & compare','Callback' ,{@figurecompare_uimenu,ax2});
set(ax2,'uicontextmenu',c2);

function[]=myfun(hObject, eventdata, fig,haz) %#ok<INUSL>

H=datacursormode(fig);
set(H,'enable','on','DisplayStyle','window','UpdateFcn',{@gethazarddata,haz.dbt(1)});
w = findobj('Tag','figpanel');
set(w,'Position',[ 409   485   150    60]);

function output_txt = gethazarddata(~,event_obj,dbt)


pos = get(event_obj,'Position');

if dbt==1
    output_txt = {...
        ['IM   : ',num2str(pos(1),4)],...
        ['Rate : ',num2str(pos(2),4)],...
        ['T    : ',num2str(1/pos(2),4),' years']};
end

if dbt==0
    output_txt = {...
        ['IM             : ',num2str(pos(1),4)],...
        ['P(IM>im|t) : ',num2str(pos(2),4)]};
end
