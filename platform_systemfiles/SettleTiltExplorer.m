function varargout = SettleTiltExplorer(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SettleTiltExplorer_OpeningFcn, ...
    'gui_OutputFcn',  @SettleTiltExplorer_OutputFcn, ...
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

function SettleTiltExplorer_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

load icons_SettleTiltExplorer.mat c
handles.DiscretizeMButtonbutton.CData = c{1};
handles.Book.CData    = c{2};
handles.undock1.CData = c{3};
handles.undock2.CData = c{3};

methods = pshatoolbox_methods(6);
handles.func = {methods.func};
handles.STpop.String = {methods.label};
handles.STpop.Value  = 1;

% Write xlabel and ylabel
handles.plotmodeax2='ccdf';
handles.ax1XLABEL=xlabel(handles.ax1,'CAV (cm/s)');
handles.ax1YLABEL=ylabel(handles.ax1,'S (mm)');
handles.ax2XLABEL=xlabel(handles.ax2,'s (mm)');
handles.ax2YLABEL=ylabel(handles.ax2,'ccdf');

if nargin==3
    handles.site_pop.String='Default_LIQ.txt';
    handles=popSettleModel(handles,'Default_LIQ.txt');
else
end
plotSettle(handles)

guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = SettleTiltExplorer_OutputFcn(hObject, eventdata, handles) %#ok<*INUSD>
varargout{1} = [];

function site_pop_Callback(hObject, eventdata, handles)

function handles=popSettleModel(handles,filename)

if nargin==2
    param=loadsiteLIBS(filename);
    handles.param = param;
    handles.B    .String = sprintf('%g',param.B   );
    handles.L    .String = sprintf('%g',param.L   );
    handles.Df   .String = sprintf('%g',param.Df  );
    handles.Q    .String = sprintf('%g',param.Q(1));
    [~,handles.bType.Value]= intersect(handles.bType.String,param.type);
    handles.wt   .String = sprintf('%g',param.wt  );
    handles.table2.Data = num2cell(param.Data(1:30,:));
end

handles.text1.Visible='off'; handles.e1.Visible='off';
handles.text2.Visible='off'; handles.e2.Visible='off';
handles.text3.Visible='off'; handles.e3.Visible='off';
handles.text4.Visible='off'; handles.e4.Visible='off';

str  = func2str(handles.func{handles.STpop.Value});

switch str
    case 'LIBS_BrayMacedo2017Ds'
        handles.text1.Visible = 'on';
        handles.text2.Visible = 'on';
        handles.text3.Visible = 'on';
        handles.text4.Visible = 'on';
        handles.e1.Visible    = 'on';
        handles.e2.Visible    = 'on';
        handles.e3.Visible    = 'on';
        handles.e4.Visible    = 'on';
        
        handles.text1.String  = 'Mag';
        handles.text2.String  = 'PGA';
        handles.text3.String  = 'Sa1 (g)';
        handles.text4.String  = 'CAVdp (cm/s)';
        handles.e1.String     = 7.5;
        handles.e2.String     = 0.45;
        handles.e3.String     = 0.90;
        handles.e4.String     = 200;
    case 'LIBS_BrayMacedo2017Dv'
        handles.text1.Visible = 'on';
        handles.text2.Visible = 'on';
        handles.e1.Visible    = 'on';
        handles.e2.Visible    = 'on';
        handles.text1.String  = 'Mag';
        handles.text2.String  = 'PGA';
        handles.e1.String     = 7.5;
        handles.e2.String     = 0.25;
        
    case 'LIBS_Hutabartat2020De'
        handles.text1.Visible = 'on';
        handles.text2.Visible = 'on';
        handles.e1.Visible    = 'on';
        handles.e2.Visible    = 'on';
        handles.text1.String  = 'Mag';
        handles.text2.String  = 'PGA';
        handles.e1.String     = 7.5;
        handles.e2.String     = 0.25;        
        
        
    case 'LIBS_Bullock2018'
        handles.text1.Visible = 'on';
        handles.e1.Visible    = 'on';
        
        handles.text1.String  = 'CAV (cm/s)';
        handles.e1.String     = 200;        
    case 'LIBT_Bullock2018e'
        handles.text1.Visible = 'on';
        handles.e1.Visible    = 'on';
        
        handles.text1.String  = 'CAV (cm/s)';
        handles.e1.String     = 200;
    case 'LIBT_Bullock2018s'
        handles.text1.Visible = 'on';
        handles.text2.Visible = 'on';
        handles.e1.Visible    = 'on';
        handles.e2.Visible    = 'on';
        
        handles.text1.String  = 'CAV (cm/s)';
        handles.text2.String  = 'VGI (cm/s)';
        handles.e1.String     = 200;
        handles.e2.String     = 200;
end

function []=plotSettle(handles)

param.B    = str2double(handles.B.String);
param.L    = str2double(handles.L.String);
param.Df   = str2double(handles.Df.String);
param.Q    = str2double(handles.Q.String);
param.type = handles.bType.String{handles.bType.Value};
param.wt   = str2double(handles.wt.String);
param.Data = handles.param.Data;
param.CPT  = handles.param.CPT;
param.LAY  = handles.param.LAY;
str        = func2str(handles.func{handles.STpop.Value});
switch str
    case 'LIBS_BrayMacedo2017Ds'
        s     = logsp(1,1000,200);
        M     = str2double(handles.e1.String);
        PGA   = str2double(handles.e2.String); 
        Sa1   = str2double(handles.e3.String);
        CAV   = str2double(handles.e4.String); 
        [LBS,HL] = calc_LBS_FS (param.Data, param.wt, param.Df,M, PGA);
        param.LBS=LBS;
        param.HL =HL;
        im0       = logsp(1,2000,150); % CAV (cm/s)
        [lny0,sig0] = LIBS_BrayMacedo2017Ds(param,Sa1,im0);
        [mu,sig]    = LIBS_BrayMacedo2017Ds(param,Sa1,CAV);
        handles.ax1XLABEL.String='CAV (m/s)';
        handles.ax1YLABEL.String='S (mm)';
        handles.ax2XLABEL.String='s (mm)';
        
    case 'LIBS_BrayMacedo2017Dv'
        s     = logsp(1,1000,200);
        M     = str2double(handles.e1.String);
        PGA   = str2double(handles.e2.String); 
        im0   = logsp(0.01,1,150); % pga (g)
        m0    = M*ones(size(im0));
        [lny0,sig0] = LIBS_BrayMacedo2017Dv(param,im0,m0);
        [mu,sig]    = LIBS_BrayMacedo2017Dv(param,PGA,M);
        handles.ax1XLABEL.String='PGA (g)';
        handles.ax1YLABEL.String='S (mm)';
        handles.ax2XLABEL.String='s (mm)';        
        
    case 'LIBS_Hutabarat2020De'
        s     = logsp(1,1000,200);
        M     = str2double(handles.e1.String);
        PGA   = str2double(handles.e2.String); 
        im0   = logsp(0.01,1,150); % pga (g)
        m0    = M*ones(size(im0));
        [lny0,sig0] = LIBS_Hutabarat2020De(param,im0,m0);
        [mu,sig]    = LIBS_Hutabarat2020De(param,PGA,M);
        handles.ax1XLABEL.String='PGA (g)';
        handles.ax1YLABEL.String='S (mm)';
        handles.ax2XLABEL.String='s (mm)';                
        
    case 'LIBS_Bullock2018'
        s           = logsp(1,1000,200);
        cav         = str2double(handles.e1.String);
        im0       = logsp(1,2000,150); % CAV (cm/s)
        [lny0,sig0] = LIBS_Bullock2018(param,im0);
        [mu,sig]    = LIBS_Bullock2018(param,cav);
        handles.ax1XLABEL.String='CAV (m/s)';
        handles.ax1YLABEL.String='S (mm)';
        handles.ax2XLABEL.String='s (mm)';
    case 'LIBT_Bullock2018e'
        s           = logsp(0.01,10,200);
        cav         = str2double(handles.e1.String);
        im0       = logsp(1,2000,150); % CAV (cm/s)
        [lny0,sig0] = LIBT_Bullock2018e(param,im0);
        [mu,sig]    = LIBT_Bullock2018e(param,cav);
        handles.ax1XLABEL.String='CAV (m/s)';
        handles.ax1YLABEL.String='\theta (°)';
        handles.ax2XLABEL.String='\theta (°)';
    case 'LIBT_Bullock2018s'
        s           = logsp(0.01,10,200);
        im0         = logsp(1,2000,150); % CAV (cm/s)
        cav         = str2double(handles.e1.String);
        vgi0        = str2double(handles.e2.String);
        [lny0,sig0] = LIBT_Bullock2018s(param,im0,vgi0);
        [mu,sig]    = LIBT_Bullock2018s(param,cav,vgi0);
        handles.ax1XLABEL.String='CAV (m/s)';
        handles.ax1YLABEL.String='\theta (°)';
        handles.ax2XLABEL.String='\theta (°)';
end

switch handles.plotmodeax2
    case 'pdf'  , Y   =   normpdf(log(s),mu,sig);  handles.ax2YLABEL.String='pdf';
    case 'cdf'  , Y   =   normcdf(log(s),mu,sig);  handles.ax2YLABEL.String='cdf';
    case 'ccdf' , Y   = 1-normcdf(log(s),mu,sig);  handles.ax2YLABEL.String='ccdf';
end


handles.ax1.XLim=[im0(1) im0(end)];

delete(findall(handles.ax1,'tag','curves'))
handles.ax1.ColorOrderIndex=1; plot(handles.ax1,im0,exp(lny0)     ,'','tag','curves','DisplayName','\mu')
handles.ax1.ColorOrderIndex=1; plot(handles.ax1,im0,exp(lny0-sig0),'--','tag','curves','DisplayName','\mu\pm\sigma')
handles.ax1.ColorOrderIndex=1; plot(handles.ax1,im0,exp(lny0+sig0),'--','tag','curves','HandleVisibility','off')
Leg=legend(handles.ax1);
Leg.Box      = 'off';
Leg.Location = 'NorthWest';

c2 = uicontextmenu;
uimenu(c2,'Label','Copy data','Callback'  ,{@data2clipboard_uimenu,num2cell([im0(:),exp([lny0-sig0;lny0;lny0+sig0])'])});
set(handles.ax1,'uicontextmenu',c2);

delete(findall(handles.ax2,'tag','curves'))
handles.ax2.ColorOrderIndex=1;
plot(handles.ax2,s,Y,'tag','curves','HandleVisibility','off')

c3 = uicontextmenu;
uimenu(c3,'Label','Copy data','Callback'  ,{@data2clipboard_uimenu,num2cell([s(:),Y(:)])});
set(handles.ax2,'uicontextmenu',c3);

% ---------------------- building properties ------------------------------

function B_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
plotSettle(handles)

function L_Callback(hObject, eventdata, handles)
plotSettle(handles)

function Df_Callback(hObject, eventdata, handles)
plotSettle(handles)

function Q_Callback(hObject, eventdata, handles)
if isempty(hObject.String)
    handles.numStories.Enable='on';
else
    handles.numStories.Enable='off';
end
plotSettle(handles)

function bType_Callback(hObject, eventdata, handles)
plotSettle(handles)

function wt_Callback(hObject, eventdata, handles)
plotSettle(handles)

% --------------- Settlement / Tilt Model ---------------------------------
function STpop_Callback(hObject, eventdata, handles)
popSettleModel(handles);
plotSettle(handles)

function e1_Callback(hObject, eventdata, handles)
plotSettle(handles)

function e2_Callback(hObject, eventdata, handles)
plotSettle(handles)

function e3_Callback(hObject, eventdata, handles)
plotSettle(handles)

function e4_Callback(hObject, eventdata, handles)
plotSettle(handles)

% --------------- Other ---------------------------------------------------
function DiscretizeMButtonbutton_Callback(hObject, eventdata, handles)
switch handles.plotmodeax2
    case 'pdf'  , handles.plotmodeax2='cdf';
    case 'cdf'  , handles.plotmodeax2='ccdf';
    case 'ccdf' , handles.plotmodeax2='pdf';
end
plotSettle(handles)
guidata(hObject,handles)

function undock1_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax1)

function undock2_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax2)

function Book_Callback(hObject, eventdata, handles)
val     = handles.STpop.Value;
methods = pshatoolbox_methods(6,val);
if ~isempty(methods.ref)
    try
        web(methods.ref,'-browser')
    catch
    end
end
