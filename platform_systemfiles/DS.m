function varargout = DS(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DS_OpeningFcn, ...
    'gui_OutputFcn',  @DS_OutputFcn, ...
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

function DS_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

ch  = get(handles.uipanel1,'children'); tag  = char(ch.Tag);
handles.text = flipud(find(ismember(tag(:,1),'t')));
handles.edit = flipud(find(ismember(tag(:,1),'e')));
handles.xlab=xlabel(handles.ax1,'T(s)' ,'fontsize',9);
handles.ylab=ylabel(handles.ax1,'Sa(g)','fontsize',9);
handles.specmode = 'sa';

handles.dslib = createObj('dslib');
handles.listbox1.String=cell(0,1);

if nargin==5
    handles.dslib    = varargin{1};
    handles.optdspec = varargin{2};
    handles.listbox1.String={handles.dslib.label}';
    
    if isempty(handles.optdspec.lambdauhs)
        [~,b]=intersect(handles.codelist.String,'UHS');
        handles.codelist.String(b)=[];
    end
else
    [~,b]=intersect(handles.codelist.String,'UHS');
    handles.codelist.String(b)=[];
    handles.optdspec.Tmax = 10;
end


val = handles.codelist.Value;
ds_default(handles,val);
ds_plot(handles)
guidata(hObject, handles);
uiwait(handles.figure1);

function varargout = DS_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.dslib;
close(handles.figure1)

function codelist_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
ds_default(handles,handles.codelist.Value);
ds_plot(handles)

function e1_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e2_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e3_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e4_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e5_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e6_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e7_Callback(hObject, eventdata, handles)
ds_plot(handles)

function e8_Callback(hObject, eventdata, handles)
ds_plot(handles)

function[]=ds_default(handles,val)

ch=get(handles.uipanel1,'children');
txt=ch(handles.text);
edi=ch(handles.edit);

set(txt,'Visible','off','String','X')
set(edi,'Visible','off','Style','edit');

switch val
    case 1 % NCh433 Of.2009
        set(txt(1:4),'visible','on')
        set(edi(1:4),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='Category';
        txt(3).String='Zone';
        txt(4).String='Soil';
        
        edi(1).String='NCh433';
        edi(2).Style='popupmenu'; edi(2).Value=1; edi(2).String={'A','B','C','D'};
        edi(3).Style='popupmenu'; edi(3).Value=1; edi(3).String={'1','2','3'};
        edi(4).Style='popupmenu'; edi(4).Value=1; edi(4).String={'I','II','III','IV'};
        
    case 2 % NCh2369 Of.2003
        set(txt(1:6),'visible','on')
        set(edi(1:6),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='Category';
        txt(3).String='Zone';
        txt(4).String='Soil';
        txt(5).String='Damping';
        txt(6).String='R factor';
        
        edi(1).String='NCh2369';
        edi(2).Style='popupmenu'; edi(2).Value=1; edi(2).String={'C1','C2','C3'};
        edi(3).Style='popupmenu'; edi(3).Value=1; edi(3).String={'1','2','3'};
        edi(4).Style='popupmenu'; edi(4).Value=1; edi(4).String={'I','II','III','IV'};
        edi(5).Style='popupmenu'; edi(5).Value=1; edi(5).String={'0.02','0.03','0.05'};
        edi(6).Style='popupmenu'; edi(6).Value=1; edi(6).String={'1','2','3','4','5'};
        
    case 3 % NCh2745 Of.2003
        set(txt(1:3),'visible','on')
        set(edi(1:3),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='Zone';
        txt(3).String='Soil';
        
        edi(1).String='NCh2745';
        edi(2).Style='popupmenu'; edi(2).Value=1; edi(2).String={'1','2','3'};
        edi(3).Style='popupmenu'; edi(3).Value=1; edi(3).String={'I','II','III'};
        
    case 4 % MCD 2014
        set(txt(1:4),'visible','on')
        set(edi(1:4),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='Zone';
        txt(3).String='Soil';
        txt(4).String='CI';
        
        edi(1).String='MDC';
        edi(2).Style='popupmenu'; edi(2).Value=1; edi(2).String={'1','2','3'};
        edi(3).Style='popupmenu'; edi(3).Value=1; edi(3).String={'I','II','III','IV'};
        edi(4).Style='popupmenu'; edi(4).Value=1; edi(4).String={'I','II'};
        
    case 5 % SENCICO
        set(txt(1:4),'visible','on')
        set(edi(1:4),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='Category';
        txt(3).String='Zone';
        txt(4).String='Soil';
        
        edi(1).String='SENCICO';
        edi(2).Style='popupmenu'; edi(2).Value=1; edi(2).String={'A1','A2','B','C','D'};
        edi(3).Style='popupmenu'; edi(3).Value=1; edi(3).String={'1','2','3','4'};
        edi(4).Style='popupmenu'; edi(4).Value=1; edi(4).String={'S0','S1','S2','S3'};
        
    case 6 % AASTHO-LRFD 2017
        set(txt(1:5),'visible','on')
        set(edi(1:5),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='PGA(g)';
        txt(3).String='Ss(g)';
        txt(4).String='S1(1)';
        txt(5).String='Soil';
        
        edi(1).String='AASTHO';
        edi(2).String=0.2;
        edi(3).String=0.5;
        edi(4).String=0.4;
        edi(5).Style='popupmenu'; edi(5).Value=1; edi(5).String={'A','B','C','D','E'};
        
    case 7 % UHS
        set(txt(1:3),'visible','on')
        set(edi(1:3),'visible','on')
        
        txt(1).String='Label';
        txt(2).String='Return Period';
        txt(3).String='Avg. Type';
       
        edi(1).String='UHS';
        edi(2).String=475;
        edi(3).Style='popupmenu'; edi(3).Value=1; edi(3).String={'Mean','Percentile 50'};
        
end

function[]=ds_plot(handles)

delete(findall(handles.ax1,'tag','dsline'))
[fun,~,param] = ds_getparam(handles);

switch func2str(fun)
    case 'builduhs'
        optdspec = handles.optdspec;
        T     = optdspec.periods;
        SA    = builduhs(T,param{:},optdspec);
        
    otherwise
        T     = 0:0.01:handles.optdspec.Tmax;
        SA    = fun(T,param{:});
end

switch handles.specmode
    case 'sa'
        plot(handles.ax1,T,SA,'tag','dsline');
        handles.ylab.String='Sa(g)';
    case 'sd'
        Nsa   = size(SA,1);
        OM    = 2*pi./repmat(T,Nsa,1);
        SD    = 981*SA./(OM.^2);
        plot(handles.ax1,T,SD,'tag','dsline');
        handles.ylab.String='Sd(cm)';
end

function[fun,label,param]=ds_getparam(handles)

ch=get(handles.uipanel1,'children');
handles.ax1.ColorOrderIndex=1;
edi=ch(handles.edit);

val = handles.codelist.Value;

switch val
    case 1 % NCh433 Of.2009
        fun      = @NCh433;
        label    = edi(1).String;
        category = edi(2).String{edi(2).Value};
        zone     = str2double(edi(3).String{edi(3).Value});
        soil     = edi(4).String{edi(4).Value};
        param    = {category,zone,soil};
        
    case 2 % NCh2369 Of.2003
        fun      = @NCh2369;
        label    = edi(1).String;
        category = edi(2).String{edi(2).Value};
        zone     = str2double(edi(3).String{edi(3).Value});
        soil     = edi(4).String{edi(4).Value};
        damping  = str2double(edi(5).String{edi(5).Value});
        Rfactor  = str2double(edi(6).String{edi(6).Value});
        param    = {category,zone,soil,damping,Rfactor};
        
    case 3 % NCh2745 Of.2003
        fun      = @NCh2745;
        label    = edi(1).String;
        zone     = str2double(edi(2).String{edi(2).Value});
        soil     = edi(3).String{edi(3).Value};
        param    = {zone,soil};
        
    case 4 % MCD 2014
        fun      = @MdC;
        label    = edi(1).String;
        zone     = str2double(edi(2).String{edi(2).Value});
        soil     = edi(3).String{edi(3).Value};
        CI       = edi(4).String{edi(4).Value};
        param    = {zone,soil,CI};
        
    case 5 % SENCICO
        fun      = @SENCICO;
        label    = edi(1).String;
        category = edi(2).String{edi(2).Value};
        zone     = str2double(edi(3).String{edi(3).Value});
        soil     = edi(4).String{edi(4).Value};
        param    = {category,zone,soil};
        
    case 6 % AASTHO-LRFD 2017
        fun      = @AASHTO;
        label    = edi(1).String;
        PGA      = str2double(edi(2).String);
        SS       = str2double(edi(3).String);
        S1       = str2double(edi(4).String);
        soil     = edi(5).String{edi(5).Value};
        param    = {PGA,SS,S1,soil};
        
    case 7 % UHS
        fun      = @builduhs;
        label    = edi(1).String;
        Ret      = str2double(edi(2).String);
        Avg      = edi(3).String{edi(3).Value};
        param    = {Ret,Avg};
end

function listbox1_Callback(hObject, eventdata, handles)
if isempty(handles.listbox1.String)
    return
end
label = handles.dslib(hObject.Value).label;
fun   = handles.dslib(hObject.Value).fun;
param = handles.dslib(hObject.Value).param;

switch func2str(fun)
    case 'NCh433'   , val=1; handles.codelist.Value=1;
    case 'NCh2369'  , val=2; handles.codelist.Value=2;
    case 'NCh2745'  , val=3; handles.codelist.Value=3;
    case 'MdC'      , val=4; handles.codelist.Value=4;
    case 'SENCICO'  , val=5; handles.codelist.Value=5;
    case 'AASHTO'   , val=6; handles.codelist.Value=6;
    case 'builduhs' , val=7; handles.codelist.Value=7;
end
ds_default(handles,val);
ds_custom (handles,val,label,param);
ds_plot   (handles)

function[]=ds_custom(handles,val,label,param)

ch=get(handles.uipanel1,'children');
edi=ch(handles.edit);

edi(1).String=label;

switch val
    case 1 % NCh433 Of.2009
        [~,edi(2).Value]=intersect(edi(2).String,param{1});
        [~,edi(3).Value]=intersect(edi(3).String,num2str(param{2}));
        [~,edi(4).Value]=intersect(edi(4).String,param{3});
        
    case 2 % NCh2369 Of.2003
        [~,edi(2).Value]=intersect(edi(2).String,param{1});
        [~,edi(3).Value]=intersect(edi(3).String,num2str(param{2}));
        [~,edi(4).Value]=intersect(edi(4).String,param{3});
        [~,edi(5).Value]=intersect(edi(5).String,num2str(param{4}));
        [~,edi(6).Value]=intersect(edi(6).String,num2str(param{5}));
        
    case 3 % NCh2745 Of.2003
        [~,edi(2).Value]=intersect(edi(2).String,num2str(param{1}));
        [~,edi(3).Value]=intersect(edi(3).String,param{2});
        
    case 4 % MCD 2014
        [~,edi(2).Value]=intersect(edi(2).String,num2str(param{1}));
        [~,edi(3).Value]=intersect(edi(3).String,param{2});
        [~,edi(4).Value]=intersect(edi(4).String,param{3});
        
    case 5 % SENCICO
        [~,edi(2).Value]=intersect(edi(2).String,param{1});
        [~,edi(3).Value]=intersect(edi(3).String,num2str(param{2}));
        [~,edi(4).Value]=intersect(edi(4).String,param{3});
        
    case 6 % AASTHO-LRFD 2017
        edi(2).String = num2str(param{1});
        edi(3).String = num2str(param{2});
        edi(4).String = num2str(param{3});
        [~,edi(5).Value]=intersect(edi(5).String,param{4});
        
    case 7 % UHS
        edi(2).String    = num2str(param{1});
        [~,edi(3).Value] = intersect(edi(3).String,param{2});
end

function ax1_ButtonDownFcn(hObject, eventdata, handles)

switch handles.specmode
    case 'sa'
        handles.specmode='sd';
        ch = findall(handles.ax1,'type','line');
        for i=1:length(ch)
            T  = ch(i).XData;
            Sa = ch(i).YData;
            T(T==0)=1e-6;
            om = 2*pi./T;
            Sd = (Sa*981)./(om.^2);
            ch(i).YData=Sd;
        end
        handles.ylab.String='Sd(cm)';
    case 'sd'
        handles.specmode='sa';
        ch = findall(handles.ax1,'type','line');
        for i=1:length(ch)
            T  = ch(i).XData;
            T(T==0)=1e-6;
            Sd = ch(i).YData;
            om = 2*pi./T;
            Sa = Sd.*(om.^2) / 981;
            ch(i).YData=Sa;
        end
        handles.ylab.String='Sa(g)';
end

guidata(hObject,handles)

function add_Callback(hObject, eventdata, handles)
[fun,label,param]=ds_getparam(handles);
if isempty(handles.listbox1.Value)
    handles.listbox1.Value=1;
end
if isempty(handles.dslib)
    handles.dslib(1,1) = struct('label',label,'fun',fun,'param',{param});
else
    handles.dslib(end+1,1)= struct('label',label,'fun',fun,'param',{param});
end
handles.listbox1.String={handles.dslib.label}';
guidata(hObject,handles)

function update_Callback(hObject, eventdata, handles)
[fun,label,param]=ds_getparam(handles);
handles.dslib(handles.listbox1.Value,1)=struct('label',label,'fun',fun,'param',{param});
handles.listbox1.String{handles.listbox1.Value}=label;
guidata(hObject,handles)

function delete_Callback(hObject, eventdata, handles)
if isempty(handles.listbox1.String)
    return
end
val=handles.listbox1.Value;
handles.listbox1.Value=1;
handles.dslib(val,:)=[];
handles.listbox1.String={handles.dslib.label}';
guidata(hObject,handles)

function listbox1_ButtonDownFcn(hObject, eventdata, handles)

function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
% delete(hObject);
