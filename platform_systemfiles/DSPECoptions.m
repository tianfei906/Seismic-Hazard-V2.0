function varargout = DSPECoptions(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DSPECoptions_OpeningFcn, ...
                   'gui_OutputFcn',  @DSPECoptions_OutputFcn, ...
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

function DSPECoptions_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

optdspec= varargin{1};
handles.primaryIM.String = sprintf('%g',optdspec.primaryIM);
handles.epsilon.String   = sprintf('%g',optdspec.epsilon);
handles.periods.String   = num2cell(optdspec.periods)';
switch optdspec.GRMmax
    case 1
        handles.radiobutton1.Value=1; 
        handles.uitable1.Enable = 'off';
    case 0
        handles.radiobutton2.Value=1; 
        handles.uitable1.Enable = 'on';
end
handles.uitable1.Data=optdspec.userMmax;

% static properties
handles.Tmax    = optdspec.Tmax;
handles.weights = optdspec.weights;
handles.branch  = optdspec.branch;
handles.im      = optdspec.im;
handles.lambdauhs = optdspec.lambdauhs;

guidata(hObject, handles);
uiwait(handles.figure1);

function varargout = DSPECoptions_OutputFcn(hObject, eventdata, handles) 

optdspec.primaryIM = str2double(handles.primaryIM.String);
optdspec.epsilon   = str2double(handles.epsilon.String);
optdspec.periods   = str2double(handles.periods.String);
optdspec.GRMmax    = handles.radiobutton1.Value;
optdspec.userMmax  = handles.uitable1.Data;
optdspec.periods   = optdspec.periods(:)';    % forces row vector
optdspec.periods(isnan(optdspec.periods))=[]; % deletes NaN resulting from empty rows

% static properties
optdspec.Tmax      = handles.Tmax; 
optdspec.weights   = handles.weights; 
optdspec.branch    = handles.branch; 
optdspec.im        = handles.im;
optdspec.lambdauhs = handles.lambdauhs;

varargout{1} = optdspec;
close(handles.figure1)

function epsilon_Callback(hObject, eventdata, handles) %#ok<*DEFNU>

function primaryIM_Callback(hObject, eventdata, handles)

function checkbox1_Callback(hObject, eventdata, handles)

function periods_Callback(hObject, eventdata, handles)

function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)

switch handles.radiobutton1.Value
    case 1, handles.uitable1.Enable='off';
    case 0, handles.uitable1.Enable='on';
end

function restoredefault_Callback(hObject, eventdata, handles)
IM = [0.01 0.012 0.015 0.02 0.025 0.03 0.04 0.05 0.06 0.075 0.1 0.12 0.15 0.2 0.25 0.3 0.4 0.5 0.6 0.75 0.85 1 1.2 1.5 2 2.5 3 3.5 4 5 6 7.5 8.5 10 ];
IM= IM(IM<=handles.Tmax);
handles.periods.String = num2cell(IM)';

function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
% delete(hObject);
