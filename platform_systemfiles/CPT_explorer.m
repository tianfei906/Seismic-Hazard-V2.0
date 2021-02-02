function varargout = CPT_explorer(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CPT_explorer_OpeningFcn, ...
    'gui_OutputFcn',  @CPT_explorer_OutputFcn, ...
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


function CPT_explorer_OpeningFcn(hObject, eventdata, handles, varargin)

handles.ax = findall(handles.figure1,'type','axes');
[handles.reg1,handles.reg2]=getSBTn;

handles.param = varargin{1};
Ncpt          = numel(handles.param);
handles.popupmenu1.String=compose('Site %g',1:Ncpt);
for i=1:Ncpt
    wt = handles.param(i).wt;
    Df = handles.param(i).Df;
    handles.cpt(i) = interpretCPT_4(handles.param(i).Data,wt,Df);
end

plotCPSfile(handles)
guidata(hObject, handles);

% uiwait(handles.figure1);

function varargout = CPT_explorer_OutputFcn(hObject, eventdata, handles) %#ok<*INUSD>
varargout{1} = [];

function popupmenu1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
plotCPSfile(handles)

function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles) %#ok<*INUSL>
plotCPSfile(handles)

function M_Callback(hObject, eventdata, handles)
plotCPSfile(handles)

function PGA_Callback(hObject, eventdata, handles)
plotCPSfile(handles)

function undock_Callback(hObject, eventdata, handles)

fig=figure(1001);
fig.Position=[271   320   795   304];
ax(1)=subplot(1,5,1);
ax(2)=subplot(1,5,2);
ax(3)=subplot(1,5,3);
ax(4)=subplot(1,5,4);
ax(5)=subplot(1,5,5);
set(ax,'ydir','reverse')
for ii=1:5
    str = sprintf('ax%g',ii);
    axi = handles.(str);
    ax(ii).XLim   = axi.XLim;
    ax(ii).YLim   = axi.YLim;
    ax(ii).YTick  = axi.YTick;
    ax(ii).XLabel = axi.XLabel;
    ax(ii).YLabel = axi.YLabel;
    ax(ii).Title  = axi.Title;
    
    ch = findall(axi,'type','patch');
    for i=1:length(ch)
        copyobj(ch(i),ax(ii))
    end
    
    ch = findall(axi,'type','line');
    for i=1:length(ch)
        copyobj(ch(i),ax(ii))
    end
    ax(ii).Layer='top';
    
  
end
