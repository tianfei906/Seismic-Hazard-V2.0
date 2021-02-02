function varargout = ScenarioBuilder2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ScenarioBuilder2_OpeningFcn, ...
    'gui_OutputFcn',  @ScenarioBuilder2_OutputFcn, ...
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

function ScenarioBuilder2_OpeningFcn(hObject, ~, handles, varargin)
handles.output = [];
load icons_ScenarioBuilder2.mat c jp

handles.t.Data                  = cell(0,9);
handles.resAll.CData            = c{1};
handles.ExitButton.CData        = c{2};
handles.go_1.CData              = c{3};
handles.go_2.CData              = c{4};
handles.go_3.CData              = c{5};
handles.go_4.CData              = c{6};
handles.wiz1.CData              = c{7};


% pre-proces input data
handles.sys        = varargin{1}; handles.branchmenu.String=compose('Branch %g',1:size(handles.sys.branch,1));
handles.opt        = varargin{2};
handles.h          = varargin{3};
handles.scenarios  = varargin{4};
handles.source     = varargin{5};
handles.pagenumber = 1;
handles.pages      = zeros(0,2);

% POPULATE TABLE WITH DATA
if ~isempty(handles.source)
    branch_ptr         = handles.source(1).branch;
    handles.branchmenu.Value =branch_ptr(1);
    
    Nscen              = size(handles.scenarios,1);
    handles.pages      = setDSHApages(Nscen);
    ind                = handles.pages(1,1):handles.pages(1,2);
    handles.t.Data     = num2cell(handles.scenarios(ind,1:9));
    handles.pagenumber = 1;
    
    handles.go_1.Enable='on';
    handles.go_2.Enable='on';
    handles.go_3.Enable='on';
    handles.go_4.Enable='on';
    handles.pagetext.String = sprintf('1 of %g',size(handles.pages,1));
end
guidata(hObject, handles);
uiwait(handles.figure1);

function varargout = ScenarioBuilder2_OutputFcn(~,~, handles)
    
varargout{1} = handles.scenarios;
varargout{2} = handles.source;

delete(handles.figure1)

function figure1_CloseRequestFcn(hObject, ~, ~)  %#ok<*DEFNU>
if isequal(get(hObject,'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
% delete(hObject);

function branchmenu_Callback(hObject, ~, handles)
brptr = handles.branchmenu.Value;
wipeDSHAmodel
handles.branchmenu.Value = brptr;
guidata(hObject,handles);

function wiz1_Callback(hObject, ~, handles)
bptr  = handles.branchmenu.Value;                           % branch pointer
gptr  = handles.sys.branch(bptr,1);                         % geometry pointer
slib  = handles.sys.labelG{gptr};
[sptr,tf] = listdlg('ListString',slib); % source pointer
if tf==0,return,end

% initializes Data
handles.source    = buildDSHAmodel2(handles.sys,handles.opt,handles.h,bptr,sptr);
handles.scenarios = sSCEN_list(handles.source);

% display magic
Nscen              = size(handles.scenarios,1);
handles.pages      = setDSHApages(Nscen);
ind                = handles.pages(1,1):handles.pages(1,2);
handles.t.Data     = num2cell(handles.scenarios(ind,:));
handles.pagenumber = 1;
handles.go_1.Enable='on';
handles.go_2.Enable='on';
handles.go_3.Enable='on';
handles.go_4.Enable='on';
handles.pagetext.String = sprintf('1 of %g',size(handles.pages,1));

guidata(hObject,handles)

% ---------------- FILE MENU ---------------------------------------------
function ExitButton_Callback(~,~, ~)
close(gcf)

function resAll_Callback(hObject, eventdata, handles) %#ok<INUSL>
wipeDSHAmodel
guidata(hObject,handles);

% ------------- TABLE EDIT ------------------------------------------------
function t_CellSelectionCallback(hObject, eventdata, handles)
if isempty(eventdata.Indices)
    return
end
guidata(hObject,handles)

function go_1_Callback(hObject, ~, handles)
handles.pagenumber = 1;
ind                = handles.pages(1,1):handles.pages(1,2);
handles.t.Data     = num2cell(handles.scenarios(ind,1:9));
handles.pagetext.String = sprintf('%g of %g',handles.pagenumber,size(handles.pages,1));
guidata(hObject,handles)

function go_2_Callback(hObject, ~, handles)
handles.pagenumber = max(handles.pagenumber-1,1);
ind                = handles.pages(handles.pagenumber,1):handles.pages(handles.pagenumber,2);
handles.t.Data     = num2cell(handles.scenarios(ind,1:9));
handles.pagetext.String = sprintf('%g of %g',handles.pagenumber,size(handles.pages,1));
guidata(hObject,handles)

function go_3_Callback(hObject, ~, handles)

NumPages           = size(handles.pages,1);
handles.pagenumber = min(handles.pagenumber+1,NumPages);
ind                = handles.pages(handles.pagenumber,1):handles.pages(handles.pagenumber,2);
handles.t.Data     = num2cell(handles.scenarios(ind,1:9));
handles.pagetext.String = sprintf('%g of %g',handles.pagenumber,size(handles.pages,1));
guidata(hObject,handles)

function go_4_Callback(hObject, ~, handles)

handles.pagenumber = size(handles.pages,1);
ind                = handles.pages(end,1):handles.pages(end,2);
handles.t.Data     = num2cell(handles.scenarios(ind,1:9));
handles.pagetext.String = sprintf('%g of %g',handles.pagenumber,size(handles.pages,1));
guidata(hObject,handles)
