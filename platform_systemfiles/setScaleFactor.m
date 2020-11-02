function varargout = setScaleFactor(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @setScaleFactor_OpeningFcn, ...
    'gui_OutputFcn',  @setScaleFactor_OutputFcn, ...
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

function setScaleFactor_OpeningFcn(hObject, eventdata, handles, varargin)

if nargin==5
    handles.pop1.String  = varargin{1}(1:end-1);
    opt                  = varargin{2};
    handles.check1.Value = opt.none;
    handles.pop1.Value   = find(strcmp(handles.pop1.String,opt.IMtarget));
    handles.e1.String    = sprintf('%g',opt.Period);
    handles.e2.String    = sprintf('%g',opt.Value);
    handles.e3.String    = sprintf('%g',opt.scaleMin);
    handles.e4.String    = sprintf('%g',opt.scaleMax);
    handles.e5.String    = sprintf('%g',opt.ssdMax);
    
    switch opt.none
        case 1
            handles.t1.Enable='off';
            handles.t2.Enable='off';
            handles.t5.Enable='off';
            handles.t6.Enable='off';
            handles.t7.Enable='off';
            handles.t3.Enable='off';
            handles.t4.Enable='off';
            handles.e1.Enable='off';
            handles.e2.Enable='off';
            handles.e3.Enable='off';
            handles.e4.Enable='off';
            handles.e5.Enable='off';
            handles.pop1.Enable='off';
        case 0
            handles.t1.Enable='on';
            handles.t2.Enable='on';
            handles.t5.Enable='on';
            handles.t6.Enable='on';
            handles.t7.Enable='on';
            handles.t3.Enable='on';
            handles.t4.Enable='on';
            handles.e1.Enable='on';
            handles.e2.Enable='on';
            handles.e3.Enable='on';
            handles.e4.Enable='on';
            handles.e5.Enable='on';
            handles.pop1.Enable='on';
    end
end

guidata(hObject, handles);
uiwait(handles.figure1);

function varargout = setScaleFactor_OutputFcn(hObject, eventdata, handles)
opt.none     = handles.check1.Value;
opt.IMtarget = handles.pop1.String{handles.pop1.Value};
opt.Period   = str2double(handles.e1.String);
opt.Value    = str2double(handles.e2.String);
opt.scaleMin = str2double(handles.e3.String);
opt.scaleMax = str2double(handles.e4.String);
opt.ssdMax   = str2double(handles.e5.String);
if isnan(opt.scaleMin),opt.scaleMin = 0;   end
if isnan(opt.scaleMax),opt.scaleMax = inf; end
if isnan(opt.ssdMax)  ,opt.ssdMax   = inf; end

varargout{1} = opt;
delete(handles.figure1)

function e1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>

function e2_Callback(hObject, eventdata, handles)

function e3_Callback(hObject, eventdata, handles)

function e4_Callback(hObject, eventdata, handles)

function e5_Callback(hObject, eventdata, handles)

function check1_Callback(hObject, eventdata, handles)

switch hObject.Value
    case 1
        handles.t1.Enable='off';
        handles.t2.Enable='off';
        handles.t5.Enable='off';
        handles.t6.Enable='off';
        handles.t7.Enable='off';
        handles.t3.Enable='off';
        handles.t4.Enable='off';
        handles.e1.Enable='off';
        handles.e2.Enable='off';
        handles.e3.Enable='off';
        handles.e4.Enable='off';
        handles.e5.Enable='off';
        handles.pop1.Enable='off';
    case 0
        handles.t1.Enable='on';
        handles.t2.Enable='on';
        handles.t5.Enable='on';
        handles.t6.Enable='on';
        handles.t7.Enable='on';
        handles.t3.Enable='on';
        handles.t4.Enable='on';
        handles.e1.Enable='on';
        handles.e2.Enable='on';
        handles.e3.Enable='on';
        handles.e4.Enable='on';
        handles.e5.Enable='on';
        handles.pop1.Enable='on';
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
% delete(hObject);

function pop1_Callback(hObject, eventdata, handles)
