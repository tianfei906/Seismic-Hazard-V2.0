function varargout = UHSOptions(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UHSOptions_OpeningFcn, ...
    'gui_OutputFcn',  @UHSOptions_OutputFcn, ...
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

function UHSOptions_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

if nargin==4
    param = varargin{1};
    mod1 = param(8);
   
    handles.pan1_1.Value=param(1);
    handles.pan1_2.Value=param(2);
    handles.pan1_3.Value=param(3);
    handles.pan1_4.String=sprintf('%g',param(4));
    handles.pan1_5.Value=param(5);
    handles.pan1_6.String=compose('Branch %g',1:param(6));
    handles.pan1_6.Value=param(7);
    if mod1
        handles.mod1.Value=1;
        handles.mod2.Value=0;
        handles.pan1_1.Enable='on';
        handles.pan1_2.Enable='on';
        handles.pan1_3.Enable='on';
        handles.pan1_4.Enable='on';
        handles.pan1_5.Enable='on';
        handles.pan1_6.Enable='off';
    else
        handles.mod1.Value=0;
        handles.mod2.Value=1;
        handles.pan1_1.Enable='off';
        handles.pan1_2.Enable='off';
        handles.pan1_3.Enable='off';
        handles.pan1_4.Enable='off';
        handles.pan1_5.Enable='off';
        handles.pan1_6.Enable='on';        
    end
end

switch handles.pan1.SelectedObject.String
    case 'Percentile'
        handles.pan1_4.Enable='on';
    otherwise
        handles.pan1_4.Enable='off';
end

guidata(hObject, handles);
uiwait(handles.figure1);

function varargout = UHSOptions_OutputFcn(hObject, eventdata, handles)

param = [...
    handles.pan1_1.Value,...
    handles.pan1_2.Value,...
    handles.pan1_3.Value,...
    str2double(handles.pan1_4.String),...
    handles.pan1_5.Value,...
    length(handles.pan1_6.String),...
    handles.pan1_6.Value,...
    handles.mod1.Value];

varargout{1} = param;
delete(handles.figure1)

function pan1_1_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>

function pan1_2_Callback(hObject, eventdata, handles)

function pan1_3_Callback(hObject, eventdata, handles)

function pan1_4_Callback(hObject, eventdata, handles)

val = str2double(hObject.String);
val = min(max(val,0),100);
hObject.String=sprintf('%g',val);
guidata(hObject,handles)

function pan1_5_Callback(hObject, eventdata, handles)

function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
% delete(hObject);

function pan1_SelectionChangedFcn(hObject, eventdata, handles)

switch handles.pan1.SelectedObject.String
    case 'Percentile'
        handles.pan1_4.Enable='on';
    otherwise
        handles.pan1_4.Enable='off';
end

function pan1_6_Callback(hObject, eventdata, handles)

function mod1_Callback(hObject, eventdata, handles)

switch hObject.Value
    case 1
        handles.mod2.Value=0;
        handles.pan1_1.Enable='on';
        handles.pan1_2.Enable='on';
        handles.pan1_3.Enable='on';
        handles.pan1_4.Enable='on';
        handles.pan1_5.Enable='on';
        handles.pan1_6.Enable='off';
    case 0
        handles.mod2.Value=1;
        handles.pan1_1.Enable='off';
        handles.pan1_2.Enable='off';
        handles.pan1_3.Enable='off';
        handles.pan1_4.Enable='off';
        handles.pan1_5.Enable='off';
        handles.pan1_6.Enable='on';
end

function mod2_Callback(hObject, eventdata, handles)

switch hObject.Value
    case 1
        handles.mod1.Value=0;
        handles.pan1_1.Enable='off';
        handles.pan1_2.Enable='off';
        handles.pan1_3.Enable='off';
        handles.pan1_4.Enable='off';
        handles.pan1_5.Enable='off';
        handles.pan1_6.Enable='on';
    case 0
        handles.mod1.Value=1;
        handles.pan1_1.Enable='on';
        handles.pan1_2.Enable='on';
        handles.pan1_3.Enable='on';
        handles.pan1_4.Enable='on';
        handles.pan1_5.Enable='on';
        handles.pan1_6.Enable='off';
end