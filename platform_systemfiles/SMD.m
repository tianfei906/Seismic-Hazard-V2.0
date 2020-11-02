function varargout = SMD(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SMD_OpeningFcn, ...
    'gui_OutputFcn',  @SMD_OutputFcn, ...
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

function SMD_OpeningFcn(hObject, eventdata, handles, varargin)
load icons_SMD.mat c
handles.goma.CData        = c{1};
handles.Exit_button.CData = c{2};
handles.disp_legend.CData = c{3};
handles.setaxis.CData     = c{4};
handles.showDesign.CData  = c{5};

% creates list if IMs
W = what('platform_complements\comp_siberrisk');
F = dir([W.path,'\*.csv']);
handles.flatfile = fullfile(W.path,'flatFile.mat');
[~,B]=intersect({F.name},'flatFile.csv');
if ~isempty(B)
    F(B)=[];
end

[~,B]=intersect({F.name},'RotD50_0.05.csv');
handles.pop2.String = {F.name,'residuals'};
if ~isempty(B)
    handles.pop2.Value  = B;
else
    handles.pop2.Value  = 1;
end

handles.opt          = createObj('scalefactorSMD');
handles.dslib        = createObj('dslib');
handles.rspsetup     = createObj('rspmatch');

handles.optdspec.lambdauhs = [];
handles.optdspec.Tmax      = 10;

methods = pshatoolbox_methods(1);
[~,C1] = mGMPEsubgroup(8);  % Sa
[~,C2] = mGMPEsubgroup(14); % interface
[~,C3] = mGMPEsubgroup(15); % intraslab
C      = and(C1,or(C2,C3));
handles.gmpepop.String = {methods(C==1).label}';
handles.fun            = {methods(C==1).func}';

% loads database
handles.T=[0.01 0.02 0.03 0.05 0.075 0.1 0.15 0.2 0.25 0.3 0.4 0.5 0.75 1 1.5 2 3 4 5 6 7.5 10];
load(handles.flatfile,'m');
handles.m     = m;
handles.m.amp = ones(size(m,1),1);
handles.m.ssd = zeros(size(m,1),1);
handles.dispmode = 'Sa';
handles.evdata = [];
SMDsubset(handles);
SMDplot(handles)

% default axis properties
handles.xlab=xlabel(handles.ax1,'T(s)','fontsize',9);
handles.ylab=ylabel(handles.ax1,'Sa(g)','fontsize',9);
guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = SMD_OutputFcn(hObject, eventdata, handles)

varargout{1} = [];

function list1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
str  = handles.list1.String(hObject.Value);
Nm   = size(handles.m.EarthquakeName,1);
B    = false(Nm,1);
handles.evdata=[];
for i=1:length(str)
    B = or(B,strcmp(handles.m.EarthquakeName,str{i}));
end

% adds filters
Mmin=0;    if ~isempty(handles.Mmin.String);Mmin = str2double(handles.Mmin.String);end
Mmax=inf;  if ~isempty(handles.Mmax.String);Mmax = str2double(handles.Mmax.String);end
Rmin=0;    if ~isempty(handles.Rmin.String);Rmin = str2double(handles.Rmin.String);end
Rmax=inf;  if ~isempty(handles.Rmax.String);Rmax = str2double(handles.Rmax.String);end
Dmin=0;    if ~isempty(handles.Dmin.String);Dmin = str2double(handles.Dmin.String);end
Dmax=inf;  if ~isempty(handles.Dmax.String);Dmax = str2double(handles.Dmax.String);end
Vmin=-inf; if ~isempty(handles.Vmin.String);Vmin = str2double(handles.Vmin.String);end
Vmax=inf;  if ~isempty(handles.Vmax.String);Vmax = str2double(handles.Vmax.String);end
Fmin=datenum('1900-01-01'); if ~isempty(handles.Fmin.String);Fmin = datenum(handles.Fmin.String);end
Fmax=today;                 if ~isempty(handles.Fmax.String);Fmax = datenum(handles.Fmax.String);end

ind1 = and(handles.m.Mw        >= Mmin,handles.m.Mw       <=Mmax);
ind2 = and(handles.m.Rrup      >= Rmin,handles.m.Rrup     <=Rmax);
ind3 = and(handles.m.Depth     >= Dmin,handles.m.Depth    <=Dmax);
ind4 = and(handles.m.Vs30      >= Vmin,handles.m.Vs30     <=Vmax);
ind5 = and(handles.m.Starttime >= Fmin,handles.m.Starttime<=Fmax);

if handles.opt.none
    B    = (B.*ind1.*ind2.*ind3.*ind4.*ind5)==1;
else
    Amin   = handles.opt.scaleMin;
    Amax   = handles.opt.scaleMax;
    ssdmax = handles.opt.ssdMax;
    ind6   = and(handles.m.amp >=Amin,handles.m.amp<=Amax);
    ind7   = handles.m.ssd <=ssdmax;
    B      = (B.*ind1.*ind2.*ind3.*ind4.*ind5.*ind6.*ind7)==1;
end

handles.t.Data = [num2cell(handles.m.ID(B)),handles.m.Station(B),num2cell(handles.m.amp(B)),num2cell(handles.m.ssd(B))];
SMDplot(handles)
handles.count1.String=sprintf('Count: %g',length(handles.list1.Value));
handles.count2.String=sprintf('Count: %g',size(handles.t.Data,1));
guidata(hObject,handles)

function list2_Callback(hObject, eventdata, handles)

function pop2_Callback(hObject, eventdata, handles)
handles.gmpepop.Visible='off';
str = hObject.String{hObject.Value};

% residual axis
if strcmp(str,'residuals')
    handles.gmpepop.Visible='on';
    handles.ax1.YLim    = [-4 4];
    handles.ax1.YScale  = 'linear';
    handles.ylab.String = 'Residuals';
    handles.dispmode    = 'residual';
    
elseif any(strfind(str,'ratio')==1)
    handles.ax1.YLim    = [0 2];
    handles.ax1.XScale  = 'log';
    handles.ax1.YScale  = 'linear';
    str = regexp(str,'\_','split');
    handles.ylab.String = sprintf('%s / %s',str{2},str{3});
    handles.dispmode    = 'ratio';
else
    axis(handles.ax1,'auto')
    handles.ax1.XScale  = 'log';
    handles.ax1.YScale  = 'log';
    handles.dispmode    = 'Sa';
    handles.ylab.String = 'Sa(g)';
end
SMDplot(handles);

function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Mmin_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Mmax_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Rmin_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Rmax_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Dmin_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Dmax_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Vmin_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Vmax_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Fmin_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Fmax_Callback(hObject, eventdata, handles)
SMDsubset(handles);
SMDplot(handles)

function Exit_button_Callback(hObject, eventdata, handles)
close(gcf)

function HoldPlot_Callback(hObject, eventdata, handles)

function disp_legend_Callback(hObject, eventdata, handles)

function setaxis_Callback(hObject, eventdata, handles)
ax2Control(handles.ax1);

function goma_Callback(hObject, eventdata, handles)
delete(findall(handles.ax1,'type','line'))
handles.ax1.ColorOrderIndex=1;

function ax1_ButtonDownFcn(hObject, eventdata, handles)
str=handles.pop2.String{handles.pop2.Value};
if ~contains(str,'ratio') && ~contains(str,'residuals')
    switch handles.dispmode
        case 'Sa', handles.dispmode='Sd'; handles.ylab.String='Sd(cm)';
        case 'Sd', handles.dispmode='Sa'; handles.ylab.String='Sa(g)';
    end
    
    SMDplot(handles)
end
guidata(hObject,handles)

function File_Callback(hObject, eventdata, handles)

function Edit_Callback(hObject, eventdata, handles)

function Scaling_Callback(hObject, eventdata, handles)
handles.opt=setScaleFactor(handles.pop2.String,handles.opt);

To    = handles.opt.Period;
fname = handles.opt.IMtarget;
Np    = size(handles.m,1);

if handles.opt.none
    handles.m.amp=handles.m.amp.^0;
else
    IMo   = SMDreadspec(To,fname,1:Np);
    handles.m.amp=handles.opt.Value./IMo;
    
    if ~isempty(handles.dslib)
        IM    = SMDreadspec(handles.T,fname,1:Np);
        DS    = handles.dslib.fun(handles.T,handles.dslib.param{:});
        handles.m.ssd = sum((log(IM)-log(DS)).^2,2).^0.5;
    else
        handles.m.ssd = zeros(Np,1);
    end
end

SMDsubset(handles);
SMDplot(handles);
guidata(hObject,handles)

function ImportCMS_Callback(hObject, eventdata, handles)

[file,path,indx] = uigetfile('*.txt');
if indx==0,return,end
filename    = fullfile(path,file);
data        = dlmread(filename)';
handles.T   = data(1,:);
handles.CMS = data(2:3,:);
CMS         = handles.CMS;
[~,IND]     = min(abs(diff(CMS)));

handles.opt        = createObj('scalefactorSMD');
handles.opt.none   = 0;
handles.opt.Period = handles.T(IND);
handles.opt.Value  = mean(CMS(:,IND));
To    = handles.opt.Period;
fname = SMDcsvname(handles.opt.IMtype);
Np    = size(handles.m,1);
IMo   = SMDreadspec(To,fname,1:Np);
handles.m.amp=handles.opt.Value./IMo;

SMDsubset(handles);
SMDplot(handles);
guidata(hObject,handles);

function showDesign_Callback(hObject, eventdata, handles)
handles.dslib = DS(handles.dslib,handles.optdspec);
SMDplot(handles)
guidata(hObject,handles);

function gmpepop_Callback(hObject, eventdata, handles)
SMDplot(handles)

function Display_Callback(hObject, eventdata, handles)

function display_DS_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'on'  ,hObject.Checked='off';
    case 'off' ,hObject.Checked='on';
end
SMDplot(handles)

function display_CMS_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'on'  ,hObject.Checked='off';
    case 'off' ,hObject.Checked='on';
end
SMDplot(handles)

function t_CellSelectionCallback(hObject, eventdata, handles)

handles.evdata = eventdata.Indices;
SMDplot(handles,0);

function exportData_Callback(hObject, eventdata, handles)

[Eopt,exitmode] = SMDexport(handles.pop2.String(1:end-1));

if exitmode==0
    return
end

ptrs  = cell2mat(handles.t.Data(:,1))+1;
per   = handles.T;
fname = Eopt.imlist;
Nptr  = length(ptrs);
Nper  = length(per);
Nims  = length(fname);
scale = cell2mat(handles.t.Data(:,3));
if all(scale==1)
    scaled='no';
else
    scaled='yes';
end

IM(1:Nims) = struct('type',[],'scaled',scaled,'T',[],'val',[]);

for i=1:Nims
    IM(i).type   = fname{i};
    IM(i).T      = per;
    IM(i).val    = SMDreadspec(per,fname{i},ptrs); %#ok<*NASGU>
    IM(i).val    = bsxfun(@times,IM(i).val,scale);
end


ms   = handles.m(ptrs,:);
Mmin = str2double(handles.Mmin.String); if isnan(Mmin), Mmin=0; end
Rmin = str2double(handles.Rmin.String); if isnan(Rmin), Rmin=0; end
Dmin = str2double(handles.Dmin.String); if isnan(Dmin), Dmin=0; end
Vmin = str2double(handles.Vmin.String); if isnan(Vmin), Vmin=0; end

Mmax = str2double(handles.Mmax.String); if isnan(Mmax), Mmax=inf; end
Rmax = str2double(handles.Rmax.String); if isnan(Rmax), Rmax=inf; end
Dmax = str2double(handles.Dmax.String); if isnan(Dmax), Dmax=inf; end
Vmax = str2double(handles.Vmax.String); if isnan(Vmax), Vmax=inf; end

events.imtype    = handles.pop2.String{handles.pop2.Value};
events.mechanism = handles.uibuttongroup1.SelectedObject.String;
events.Mw        = [Mmin Mmax];
events.Rrup      = [Rmin Rmax];
events.Depth     = [Dmin Dmax];
events.Vs30      = [Vmin Vmax];
events.Date      = {handles.Fmin.String,handles.Fmax.String}; %#ok<STRNU>


eqk(1:Nptr,1) = struct('ID',[],'units',[],'scaled',scaled,'dt',[],'acc1',[],'acc2',[],'acc3',[],'vel1',[],'vel2',[],'vel3',[]);
if Eopt.acc || Eopt.vel
    for i=1:Nptr
        fn   = [ms.EarthquakeName{i},'.mat'];
        sta  = ms.fld{i};
        eq   = load(fn,sta);
        eq   = eq.(sta);
        eqk(i).ID    = ms.ID(i);
        eqk(i).units = eq.units;
        eqk(i).dt    = eq.dt;
        if Eopt.acc
            eqk(i).acc1  = eq.acc_1*scale(i);
            eqk(i).acc2  = eq.acc_2*scale(i);
            eqk(i).acc3  = eq.acc_3*scale(i);
        end
        
        if Eopt.vel
            ACC = [eq.acc_1;eq.acc_2;eq.acc_3]*scale(i);
            VEL = freqInt(eq.dt,ACC,1);
            eqk(i).vel1  = VEL(1,:);
            eqk(i).vel2  = VEL(2,:);
            eqk(i).vel3  = VEL(3,:);
        end
        
    end
end

save(Eopt.name,'IM','eqk','ms','events');

function RspMatchMenu_Callback(hObject, eventdata, handles)

function RspNMatchSetup_Callback(hObject, eventdata, handles)

handles.rspsetup = RspmatchSetup(handles.rspsetup);
guidata(hObject,handles);

function Run_Callback(hObject, eventdata, handles)

ptrs  = cell2mat(handles.t.Data(:,1))+1;
per   = handles.T;
Nptr  = length(ptrs);
Nper  = length(per);
ms    = handles.m(ptrs,:);
scale = cell2mat(handles.t.Data(:,3));
if all(scale==1)
    scaled='no';
else
    scaled='yes';
end

eqk(1:Nptr,1) = struct('ID',[],'units',[],'scaled',[],'dt',[],'T',[],...
    'acc1',[],'acc1m',[],'Sa1',[],'Sa1m',[],...
    'acc2',[],'acc2m',[],'Sa2',[],'Sa2m',[]);

xi    = 0.05;
T     = handles.T;%logsp(0.01,10,20);
fun   = handles.dslib(1).fun;
param = handles.dslib(1).param;
Q     = fun(T,param{:});

SCD = cd;
G     = what('platform_rspmatch');
FPATH = G.path;
cd(FPATH);
for i=1:Nptr
    fn   = [ms.EarthquakeName{i},'.mat'];
    sta  = ms.fld{i};
    eq   = load(fn,sta);
    eq   = eq.(sta);
    
    eqk(i).ID     = ms.ID(i);
    eqk(i).units  = 'g';
    eqk(i).scaled = scaled;
    eqk(i).dt     = eq.dt;
    eqk(i).T     = T;
    
    % runs rspmatch09 for component 1
    eqk(i).acc1  = eq.acc_1*scale(i)/9.81;
    eqk(i).acc1m = rspmatch(T,Q,eq.dt,eqk(i).acc1,handles.rspsetup,xi);
    eqk(i).SA1   = freqspec(eq.dt,eqk(i).acc1 ,T,xi);
    eqk(i).SA1m  = freqspec(eq.dt,eqk(i).acc1m,T,xi);

    % runs rspmatch09 for component 2
%     eqk(i).acc2  = eq.acc_2*scale(i)/9.81;
%     eqk(i).acc2m = rspmatch(T,Q,eq.dt,eqk(i).acc2,handles.rspsetup,xi);
%     eqk(i).SA2   = freqspec(eq.dt,eqk(i).acc2 ,T,xi);
%     eqk(i).SA2m  = freqspec(eq.dt,eqk(i).acc2m,T,xi);
end
cd(SCD);

handles.eqk=eqk;
guidata(hObject,handles)

function pushbutton10_Callback(hObject, eventdata, handles)

i=1;
f   = figure;
f.Position=[ 186   300   979   275];
ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);

% response spectra
set(ax1,'xscale','log','yscale','log','box','on','xlim',[0.01 10],'NextPlot','add','fontsize',8)
set(ax2,'box','on','NextPlot','add','fontsize',8)
set(ax3,'box','on','NextPlot','add','fontsize',8)

% data
eqk   = handles.eqk;
T     = eqk(i).T;
dt    = eqk(i).dt;
time  = dt*(0:numel(eqk(i).acc1)-1);

acc   = eqk(i).acc1;
accm  = eqk(i).acc1m;

vel   = freqInt(time,eqk(i).acc1  * 9.81,1);
velm  = freqInt(time,eqk(i).acc1m * 9.81,1);

xlabel(ax1,'T(s)');
ylabel(ax1,'Sa(g)');
xlabel(ax2,'time/time(end)');
ylabel(ax2,'acc(g)');
xlabel(ax3,'time/time(end)');
ylabel(ax3,'acc(g)');

fun   = handles.dslib(1).fun;
param = handles.dslib(1).param;
Q     = fun(T,param{:});
plot(ax1,T,Q,'k','linewidth',1,'DisplayName','Target Spectra')
ax1.ColorOrderIndex=1;
plot(ax1,T,eqk(i).SA1 ,'DisplayName',sprintf('Seed ID:%g',eqk(i).ID))
plot(ax1,T,eqk(i).SA1m,'-','DisplayName',sprintf('Modified ID:%g',eqk(i).ID))

% plot(ax2,time/time(end),acc /max(abs(acc))   ,'DisplayName',sprintf('Seed ID:%g',eqk(i).ID))
% plot(ax2,time/time(end),accm/max(abs(accm)) ,'-','DisplayName',sprintf('Modified ID:%g',eqk(i).ID))

plot(ax2,time/time(end),vel /max(abs(vel))   ,'DisplayName',sprintf('Seed ID:%g',eqk(i).ID))
plot(ax2,time/time(end),velm/max(abs(velm)) ,'-','DisplayName',sprintf('Modified ID:%g',eqk(i).ID))

plot(ax3,time/time(end),cumsum(acc.^2 )/sum(acc.^2 ),'DisplayName',sprintf('Seed ID:%g',eqk(i).ID))
plot(ax3,time/time(end),cumsum(accm.^2)/sum(accm.^2 ),'-','DisplayName',sprintf('Modified ID:%g',eqk(i).ID))
