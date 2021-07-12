function varargout = SARA_ACTIVE_FAULTS(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SARA_ACTIVE_FAULTS_OpeningFcn, ...
    'gui_OutputFcn',  @SARA_ACTIVE_FAULTS_OutputFcn, ...
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

function SARA_ACTIVE_FAULTS_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = [];
handles.GoogleEarthOpt  = GEOptions('default');

load icons_SARA_ACTIVE_FAULTS c %jp
handles.addNew.CData       = c{1};
handles.crossdb.CData      = c{2};
handles.play.CData         = c{5};
handles.update_GEmap.CData = c{6};
handles.d_square.CData     = c{9};
handles.undock.CData       = c{10};



load sara-active-faults data
data(isnan(vertcat(data.b_val)))=[];

handles.data=data;
handles.xy=[];
handles.in=[];
handles.opt.Image    ='peru.mat';
handles.opt.Boundary ='PER_adm1.shp';
default_maps(handles.figure1,handles.opt,handles.ax1)
plotSARA(handles.ax1,handles.data)
akZoom(handles.ax1);
guidata(hObject, handles);

% uiwait(handles.figure1);
function varargout = SARA_ACTIVE_FAULTS_OutputFcn(hObject, eventdata, handles)
varargout{1} = [];

function[]=plotSARA(ax,data)

X = horzcat(data.X);
Y = horzcat(data.Y);

delete(findall(ax,'tag','line'))
plot(ax,X,Y,'r-','tag','line')

function update_GEmap_Callback(hObject, eventdata, handles)

if ~exist('api_Key.mat','file')
    warndlg('You must use an API key to authenticate each request to Google Maps Platform APIs. For additional information, please refer to http://g.co/dev/maps-no-account')
    return
end

a=1;
if ispc
    a=system('ping -n 1 www.google.com');
elseif isunix
    a=system('ping -c 1 www.google.com');
end
if a==1
    fprintf('Warning: No Internet Access found\n');
    return
end

opt=handles.GoogleEarthOpt;
caxis(handles.ax1);
gmap=plot_google_map(...
    'Axis',handles.ax1,...
    'Height',640,...
    'Width',640,...
    'Scale',2,...
    'MapType',opt.MapType,...
    'Alpha',opt.Alpha,...
    'ShowLabels',opt.ShowLabels,...
    'autoAxis',0,...
    'refresh',0,...
    'Color',opt.Color);

gmap.Tag='gmap';
ch = findall(handles.ax1,'Tag','gmap');
if length(ch)>1
    delete(ch(1))
    ch(1)=[];
end
try %#ok<TRYNC>
    uistack(gmap,'bottom');
    handles.ax1.Layer='top';
end
guidata(hObject,handles)

function d_square_Callback(hObject, eventdata, handles)

ch1=findall(handles.figure1,'Style','pushbutton','Enable','on'); set(ch1,'Enable','inactive');
ch2=findall(handles.figure1,'type','uimenu','Enable','on'); set(ch2,'Enable','off');

XYLIM1     = get(handles.ax1,{'xlim','ylim'});
p  = grid2C(handles.ax1,'square');

XYLIM2 = get(handles.ax1,{'xlim','ylim'});
set(handles.ax1,{'xlim','ylim'},XYLIM1);
akZoom(handles.ax1);
set(handles.ax1,{'xlim','ylim'},XYLIM2);
handles.xy = p.Vertices(:,[1,2]);

set(ch1,'Enable','on')
set(ch2,'Enable','on')
guidata(hObject, handles);

function Boundary_check_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
ch = findall(handles.ax1,'tag','shape1');
if isempty(ch)
    return
end
switch hObject.Value
    case 0, ch.Visible='off';
    case 1, ch.Visible='on';
end

function listbox1_Callback(hObject, eventdata, handles)

function addNew_Callback(hObject, eventdata, handles)

if isempty(handles.xy)
    return
end

xq   = horzcat(handles.data.X)';
yq   = horzcat(handles.data.Y)';
xv   = handles.xy(:,1);
yv   = handles.xy(:,2);
INAN = 1+cumsum(isnan(xq));
INAN(isnan(xq))=NaN;
in_old = handles.in;
in_new = inpolygon(xq,yq,xv,yv);
in_new = unique(INAN(in_new),'stable');
in     = unique([in_old;in_new]);
handles.listbox1.String={handles.data(in).id_seg};
handles.in = in;
t1         = getTables(handles);
guidata(hObject,handles)

function undock_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu([],[],handles.ax1)

function disp_grid_Callback(hObject, eventdata, handles)
switch hObject.Value
    case 0,handles.ax1.XGrid='off';handles.ax1.YGrid='off';
    case 1,handles.ax1.XGrid='on'; handles.ax1.YGrid='on';
end

function disp_terrain_Callback(hObject, eventdata, handles)
ch=findall(handles.ax1,'tag','gmap');
switch hObject.Value
    case 0,ch.Visible='off';
    case 1,ch.Visible='on';
end

function crossdb_Callback(hObject, eventdata, handles)
handles.listbox1.String=' ';
delete(findall(handles.ax1,'tag','patchselect'))
handles.xy=[];
handles.in=[];
guidata(hObject,handles)

function edit1_Callback(hObject, eventdata, handles)

function t1=getTables(handles)

in = handles.in;
Ns = numel(in);
t1 = cell(Ns,1);
t2 = cell(Ns,1);


for i=1:Ns
    
    d = handles.data(in(i));
    
    % source geometry
    label = strrep(sprintf('%s-ID%g',d.id_seg,d.ogc_fid),' ','');
    style = d.rup_type;
    switch style
        case'dextral'           ,style='strike-slip';
        case'sinistral'         ,style='strike-slip';
        case'dextral-normal'    ,style='normal';
        case'sinistral-normal'  ,style='normal';
        case'normal-dextral'    ,style='normal';
        case'normal-sinistral'  ,style='normal';
        case'reverse-dextral'   ,style='reverse';
        case'reverse-sinistral' ,style='reverse';
        case'dextral-reverse'   ,style='reverse';
        case'sinistral-reverse' ,style='reverse';
        case'strikeslip-reverse',style='strike-slip';
        case'reverse-strikeslip',style='reverse';
        case'strikeslip-normal' ,style='strike-slip';
        case'normal-strikeslip' ,style='normal';
        case'strikeslip'        ,style='strike-slip';
        case'None'              ,style='strike-slip';
    end
    
    
    RA    = handles.popupmenu1.String{handles.popupmenu1.Value};
    GMPEptr = str2double(handles.edit2.String);
    dip   = d.dip;
    usd   = d.upp_sd;
    lsd   = d.low_sd;
    lmax  = str2double(handles.edit3.String);
    vertices=unique([d.X(1:end-1);d.Y(1:end-1)]','rows','stable')';
    vertices=num2str(vertices(:)');
    vertices= strrep(vertices,'  ',' ');
    strpat =  'area1 %s %s %s %s %g %g %g %g %g %g %g %g %s %s';
    str    = sprintf(strpat,label,'crustal',style,RA,0,   GMPEptr,dip,usd,lsd,lmax,0,0,'rigid',vertices);
    t1{i}  = str;
    
    % magnitude scaling relation
    s     = d.slip_rate;
    a     = d.a_val;
    b     = d.b_val;
    Mmin  = d.min_mag;
    Mmax  = d.max_mag;
    
    if handles.popupmenu2.Value==2
        W       = (lsd-usd)/sind(dip);
        L       = d.length_km;
        Area    = W*L;
        ramodel = handles.popupmenu1.Value;
        Adef    = rupRelation(d.max_mag,0,ramodel);
        if Area<Adef
            mi   = linspace(3,9,100);
            Ai   = rupRelation(mi,0,ramodel);
            Mmax = max(ceil(interp1(Ai,mi,Area)*100)/100,Mmin);
        end
    end
    
    if handles.popupmenu3.Value==1
        str    = sprintf('truncexp %-s SR %g %g %g %g',label,s,b,Mmin,Mmax);
        t2{i}  = str;        
    else
        NMmin = 10^(a-b*Mmin);
        str    = sprintf('truncexp %-s NM %g %g %g %g',label,NMmin,b,Mmin,Mmax);
        t2{i}  = str;
    end
end
clc
disp(t1);
disp(t2);
data2clipboard_uimenu(1,1,[t1;t2])

function edit2_Callback(hObject, eventdata, handles)

function edit3_Callback(hObject, eventdata, handles)

function popupmenu1_Callback(hObject, eventdata, handles)

function popupmenu2_Callback(hObject, eventdata, handles)

function popupmenu3_Callback(hObject, eventdata, handles)
