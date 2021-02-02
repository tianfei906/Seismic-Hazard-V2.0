%#ok<*DEFNU>
function varargout = RspmatchSetup(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RspmatchSetup_OpeningFcn, ...
    'gui_OutputFcn',  @RspmatchSetup_OutputFcn, ...
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

function RspmatchSetup_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

if nargin==3
    data=createObj('rspmatch');
else
    data=varargin{1};
    if isempty(data{1,3}),handles.checkbox2.Value=0;end
    if isempty(data{1,4}),handles.checkbox3.Value=0;end
    if isempty(data{1,5}),handles.checkbox4.Value=0;end
end
handles.uitable1.Data=data;
load icons_RspmatchSetup.mat c
handles.OpenManual.CData=c{1};
guidata(hObject, handles);

% UIWAIT makes RspmatchSetup wait for user response (see UIRESUME)
uiwait(handles.figure1);

function varargout = RspmatchSetup_OutputFcn(hObject, eventdata, handles)
data = get(handles.uitable1,'data');
varargout{1} = data;
delete(handles.figure1);

function uitable1_CellEditCallback(hObject, eventdata, handles) 

function SetDefault_Callback(hObject, eventdata, handles)
data=createObj('rspmatch');
handles.uitable1.Data=data;
handles.checkbox2.Value=1;
handles.checkbox3.Value=1;
handles.checkbox4.Value=1;
handles.checkbox2.Enable='on';
handles.checkbox3.Enable='on';
handles.checkbox4.Enable='on';
guidata(hObject, handles);

function checkbox1_Callback(hObject, eventdata, handles)

function checkbox2_Callback(hObject, eventdata, handles)
val  = hObject.Value;
data = handles.uitable1.Data;
if val==0
    handles.checkbox3.Value=0;
    handles.checkbox4.Value=0;
    for i=1:size(data,1)
        data{i,3}=[];
        data{i,4}=[];
        data{i,5}=[];
    end
end
handles.uitable1.Data=data;
handles.checkbox2.Enable='off';
handles.checkbox3.Enable='off';
handles.checkbox4.Enable='off';
guidata(hObject, handles);

function checkbox3_Callback(hObject, eventdata, handles)
val  = hObject.Value;
data = handles.uitable1.Data;
if val==0
    handles.checkbox4.Value=0;
    for i=1:size(data,1)
        data{i,4}=[];
        data{i,5}=[];
    end
end
handles.uitable1.Data=data;
handles.checkbox3.Enable='off';
handles.checkbox4.Enable='off';
guidata(hObject, handles);

function checkbox4_Callback(hObject, eventdata, handles)
val  = hObject.Value;
data = handles.uitable1.Data;
if val==0
    for i=1:size(data,1)
        data{i,5}=[];
    end
end
handles.uitable1.Data=data;
handles.checkbox4.Enable='off';
guidata(hObject, handles);

function OpenManual_Callback(hObject, eventdata, handles)
open('RSPMatch09_Manual.pdf')

function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
