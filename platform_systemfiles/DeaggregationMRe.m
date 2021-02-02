function varargout = DeaggregationMRe(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DeaggregationMRe_OpeningFcn, ...
    'gui_OutputFcn',  @DeaggregationMRe_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function DeaggregationMRe_OpeningFcn(hObject, ~, handles, varargin)
load icons_DeaggregationMR.mat c
handles.Exit_button.CData  = c{1};
handles.undock.CData       = c{2};
handles.sys    = varargin{1};
handles.opt    = varargin{2};
handles.h      = varargin{3};

% ------------ REMOVES PCE MODELS (AT LEAST FOR NOW) ----------------------
isREG = handles.sys.isREG;
[~,B]=setdiff(handles.sys.branch(:,2),isREG);
if ~isempty(B)
    handles.sys.branch(B,:)=[];
    handles.sys.weight(B,:)=[];
    handles.sys.weight(:,5)=handles.sys.weight(:,5)/sum(handles.sys.weight(:,5));
    warndlg('PCE Models removed from logic tree. Logic Tree weights were normalized')
    uiwait
end

% -------------------------------------------------------------------------
n=max(handles.sys.branch,[],1);
if not(strcmp(handles.opt.MagDiscrete{1},'uniform') && handles.opt.MagDiscrete{2}==0.1)
    handles.opt.MagDiscrete = {'uniform',0.1};
    for i=1:n(3)
        handles.sys.mrr2(i) = process_truncexp  (handles.sys.mrr2(i) , handles.opt.MagDiscrete);
        handles.sys.mrr3(i) = process_truncnorm (handles.sys.mrr3(i) , handles.opt.MagDiscrete);
        handles.sys.mrr4(i) = process_yc1985    (handles.sys.mrr4(i) , handles.opt.MagDiscrete);
        handles.sys.mrr6(i) = process_catalog   (handles.sys.mrr6(i) , handles.sys.area1(i),handles.opt.MagDiscrete);
    end
    for i=1:n(1)
        handles.sys.area1(i).rclust=process_rclust(handles.sys,handles.sys.area1(i),i);
    end
end
%--------------------------------------------------------------------------

handles.Rbin         = createObj('Rbin');
handles.Mbin         = createObj('Mbin');
handles.Ebin         = createObj('Ebin');
handles.returnperiod = createObj('returnperiods');
%--------------------------------------------------------------------------
Nmodels = size(handles.sys.branch,1);
handles.popreturn.String   = num2cell(handles.returnperiod);
handles.popreturn.Value    = 1;
handles.menu_branch.String = compose('Branch %i',1:Nmodels);
handles.menu_branch.Value  = 1;
handles.menu_source.String = [{'all sources'};handles.sys.labelG{1}];
handles.menu_source.Value  = 1;
handles.menu_site.String   = handles.h.id;
handles.menu_site.Value    = 1;
handles.IM_menu.String     = IM2str(handles.opt.IM);

handles = drawbars(handles);
handles = drawlegend(handles);
handles.bartitle.String='';
handles.bartitle2.String='';
rotate3d(handles.ax1)
xlabel(handles.ax,handles.IM_menu.String{1},'fontsize',10);
ylabel(handles.ax,'Exceedance Rate','fontsize',10);
plot(handles.ax,nan*[1 1],handles.ax.YLim,'.-','tag','haz1');
plot(handles.ax,nan*[1 1],handles.ax.YLim,'o' ,'tag','haz3');
plot(handles.ax,nan*[1 1],handles.ax.YLim,'k:','tag','line');

guidata(hObject, handles);

function varargout = DeaggregationMRe_OutputFcn(hObject, eventdata, handles)
varargout{1} = [];

function Exit_button_Callback(~, ~, ~)
close(gcf)

% -------- EDIT MENU ------------------------------------------------------
function Edit_Callback(~, ~, ~)

function defineMRebins_Callback(hObject, ~, handles)

[handles.Rbin,handles.Mbin,handles.Ebin]=setMRebins(handles.Rbin,handles.Mbin,handles.Ebin);
handles = drawbars(handles);
handles = drawlegend(handles);
guidata(hObject,handles)

% -------- PANNEL OPTIONS -------------------------------------------------
function popreturn_Callback(hObject, eventdata, handles)

function menu_branch_Callback(hObject, eventdata, handles)

function menu_source_Callback(hObject, eventdata, handles)

function menu_site_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>

function IM_menu_Callback(hObject, eventdata, handles)

% --------- AUXILIARY FUNCTIONS -------------------------------------------
function mouseClick(~,~,handles)

x      = getAbsCoords(handles.ax);
IM_ptr = interp1(handles.im,(1:length(handles.im))',x,'nearest','extrap');
im     = handles.im(IM_ptr);
handles.line.XData = im*[1 1];
handles.line.YData = handles.ax.YLim;

function [x, y] = getAbsCoords(h_ax)
crd = get(h_ax, 'CurrentPoint');
x = crd(2,1);
y = crd(2,2);

function run_Callback(hObject, ~, handles)

IM_ptr     = handles.IM_menu.Value;
ncols      = size(handles.opt.im,2);
if ncols==1
    im1 = handles.opt.im;
else
    im1 = handles.opt.im(:,IM_ptr);
end

ret_ptr    = handles.popreturn.Value;
model_ptr  = handles.menu_branch.Value;
source_ptr = handles.menu_source.Value;
site_ptr   = handles.menu_site.Value;
opt        = handles.opt;
branch     = handles.sys.branch;

if source_ptr == 1
    Nsource    = sum(handles.sys.Nsrc(:,branch(model_ptr,1)));
    source_ptr = 1:Nsource;
else
    Nsource = 1;
    source_ptr  = source_ptr-1;
end

IM    = opt.IM(IM_ptr);
h.id    = handles.h.id(site_ptr,:);
h.p     = handles.h.p(site_ptr,:);
h.param = handles.h.param;
h.value = handles.h.value(site_ptr,:);

sources = buildmodelin(handles.sys,branch(model_ptr,:),handles.opt);
sources = sources(source_ptr);

% computes hazard curve
opt.SourceDeagg='off';
lambda1 = runhazard1(im1,IM,h,opt,sources,Nsource,1);
lambda1 = permute(lambda1,[2,1,3,4]);
if all(lambda1==0)
    ch=findall(handles.ax,'tag','haz1'); ch.XData = [nan;nan]; ch.YData = [nan;nan];
    handles.bartitle.String='';
    handles.bartitle2.String='';
    return
end

% computes im values for deaggregation
im3     = robustinterp(lambda1,im1,1./handles.returnperiod(ret_ptr),'loglog');
deagg3  = runhazard3(im3,IM,h,opt,sources,Nsource,1,handles.Ebin);
deagg3  = vertcat(deagg3{1,1,1,:});

deagg3NC    = deagg3(:,5)*1/sum(deagg3(:,5))*1/handles.returnperiod(ret_ptr); % small correction
deagg3(:,5) = deagg3(:,5)*1/sum(deagg3(:,5))*1/handles.returnperiod(ret_ptr); % small correction

haz     = 1/handles.returnperiod(ret_ptr);
MRHEbar = sum(bsxfun(@times,deagg3(:,1:4),deagg3(:,5)),1)/haz;

handles.bartitle.String={...
    sprintf('Deaggregation for %s'     , handles.IM_menu.String{IM_ptr});...
    sprintf('Hazard Level   = %4.3e'   , haz);...
    sprintf('Return Period  = %g yr'   , 1/haz)};

handles.bartitle2.String={...
    sprintf('Mean R Zhyp M e:');...
    sprintf('R = %-4.3g km   Zhyp = %-4.3g km' , MRHEbar(2), MRHEbar(3));...
    sprintf('M = %-4.3g      e    = %4.3g'     , MRHEbar(1),MRHEbar(4))};

data2clipboard_uimenu([],[],MRHEbar)
ch=findall(handles.ax,'tag','haz1'); ch.XData = im1; ch.YData = lambda1;
ch=findall(handles.ax,'tag','haz3'); ch.XData = im3; ch.YData = sum(deagg3NC);
ch=findall(handles.ax,'tag','line'); ch.XData = im3*[1 1]; ch.YData = handles.ax.YLim;
handles = run_funcMRe(handles,deagg3);
guidata(hObject,handles)

function handles = drawbars(handles)

Rbin = handles.Rbin; Rwin = 1/2*(Rbin(:,2)+Rbin(:,1));
Mbin = handles.Mbin; Mwin = 1/2*(Mbin(:,2)+Mbin(:,1));
NR   = size(handles.Rbin,1);
NM   = size(handles.Mbin,1);
NE   = size(handles.Ebin,1);

dr = Rwin(2)-Rwin(1);
handles.ax1.NextPlot='replace';
btest=bar3(handles.ax1,Rwin,nan(NR,NM));
xlabel(handles.ax1,'Magnitude');
ylabel(handles.ax1,'R (km)');
zlabel(handles.ax1,'Hazzard Deagg');
set(handles.ax1,...
    'xtick',1:1:length(Mwin),...
    'xticklabel',Mwin,...
    'projection','perspective',...
    'ylim',[Rwin(1)-dr/2,Rwin(end)+dr/2],...
    'fontsize',8)
delete(btest);
handles.ax1.NextPlot='add';

b     = cell(NM,1);
for j=1:NM
    b{j} = bar3(handles.ax1,Rwin,nan(NR,NE),'stacked');
end

for i=1:NM
    for j=1:length(b{i})
        b{i}(j).XData=b{i}(j).XData+i-1;
        b{i}(j).FaceAlpha=0.7;
        
    end
end
handles.b=b;
ZLIM = max(handles.ax1.ZLim,0);
handles.ax1.ZLim=ZLIM;

function handles = drawlegend(handles)

Ebin = handles.Ebin;
NE   = size(handles.Ebin,1);

col  = parula(NE);
colormap(handles.ax1,col);

handles.ax3.YLim=[0 12];
handles.ax3.XLim=[0 0.7];
handles.ax3.Color='none';
handles.ax3.XColor='none';
handles.ax3.YColor='none';

delete(findall(handles.ax3,'tag','leg'));

for i=1:NE
    x = [0 0.2 0.2 0];
    y = [i-1 i-1 i-0.6 i-0.6]+12-NE;
    vert = [x;y]';
    patch('parent',handles.ax3,...
        'vertices',vert,...
        'faces',1:4,...
        'facecolor',col(i,:),...
        'facealpha',0.7,...
        'tag','leg')
    if isinf(Ebin(i,1))
        str = sprintf('e < %2.1f',Ebin(i,2));
    elseif isinf(Ebin(i,2))
        str = sprintf('%2.1f <  e',Ebin(i,1));
    else
        str = sprintf('%2.1f <  e < %2.1f',Ebin(i,1),Ebin(i,2));
    end
    text(handles.ax3,0.25,(i-0.8)+12-NE,str,'tag','leg','fontsize',8)
end

function undock_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax1)

function lessM_Callback(hObject, eventdata, handles)
Xo = compose('%g',mean(handles.Mbin,2));
nX = size(handles.Mbin,1);
IND= find(~ismember(handles.ax1.XTickLabel,''));
Xn = repmat({''},nX,1);
n  = max(diff(IND))+1;
if ~isempty(n)
    for i=1:n:nX
        Xn{i}=Xo{i};
    end
    handles.ax1.XTickLabel=Xn;
end

function moreM_Callback(hObject, eventdata, handles)
Xo = compose('%g',mean(handles.Mbin,2));
nX = size(handles.Mbin,1);
IND= find(~ismember(handles.ax1.XTickLabel,''));
Xn = repmat({''},nX,1);
n  = max(max(diff(IND))-1,1);
for i=1:n:nX
    Xn{i}=Xo{i};
end
handles.ax1.XTickLabel=Xn;

function lessR_Callback(hObject, eventdata, handles)
Yo = compose('%g',mean(handles.Rbin,2));
nY = size(handles.Rbin,1);
IND= find(~ismember(handles.ax1.YTickLabel,''));
Yn = repmat({''},nY,1);
n  = max(diff(IND))+1;
if ~isempty(n)
    for i=1:n:nY
        Yn{i}=Yo{i};
    end
    handles.ax1.YTickLabel=Yn;
end

function moreR_Callback(hObject, eventdata, handles)
Yo = compose('%g',mean(handles.Rbin,2));
nY = size(handles.Rbin,1);
IND= find(~ismember(handles.ax1.YTickLabel,''));
Yn = repmat({''},nY,1);
n  = max(max(diff(IND))-1,1);
for i=1:n:nY
    Yn{i}=Yo{i};
end
handles.ax1.YTickLabel=Yn;
