function varargout = SMDexport(varargin)
%#ok<*DEFNU>
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SMDexport_OpeningFcn, ...
    'gui_OutputFcn',  @SMDexport_OutputFcn, ...
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

function SMDexport_OpeningFcn(hObject, eventdata, handles, varargin)

handles.imlist.String= varargin{1};
handles.exitmode = 1;

guidata(hObject, handles);
uiwait(handles.figure1);
function varargout = SMDexport_OutputFcn(hObject, eventdata, handles)

Eopt.name    = handles.fname.String;
Eopt.imlist  = handles.imlist.String(handles.imlist.Value);
Eopt.acc     = handles.acc.Value;
Eopt.vel     = handles.vel.Value;
varargout{1} = Eopt;
varargout{2} = handles.exitmode;
close(gcf)

function fname_Callback(hObject, eventdata, handles) 

function imlist_Callback(hObject, eventdata, handles)

function acc_Callback(hObject, eventdata, handles)

function vel_Callback(hObject, eventdata, handles)

function accept_Callback(hObject, eventdata, handles)
handles.exitmode=1;
guidata(hObject,handles)
close(gcf)
function cancel_Callback(hObject, eventdata, handles)
handles.exitmode=0;
guidata(hObject,handles)
close(gcf)

function fname_ButtonDownFcn(hObject, eventdata, handles)

[FileName,PathName,FILTERINDEX] =  uiputfile('*.mat','Ground Motion output file'); %#ok<*ASGLU>
if FILTERINDEX==0
    return
end
handles.fname.String=fullfile(PathName,FileName);


function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
% delete(hObject);
