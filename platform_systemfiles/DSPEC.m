function varargout = DSPEC(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DSPEC_OpeningFcn, ...
    'gui_OutputFcn',  @DSPEC_OutputFcn, ...
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

function DSPEC_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>

load icons_DSPEC.mat c

handles.Exit_button.CData = c{1};
handles.form1             = c{2};
handles.form2             = c{3};
handles.disp_legend.CData = c{4};
handles.ax2Limits.CData   = c{5};
handles.runDSPEC.CData    = c{6};
handles.showDesign.CData  = c{7};
handles.undock.CData      = c{8};
handles.switchmode.CData  = handles.form1;
handles.displaymode       = 1;
handles.xlab=xlabel(handles.ax1,'T(s)' ,'fontsize',9);
handles.ylab=ylabel(handles.ax1,'Sa(g)','fontsize',9);
handles.specmode          = 'sa';

handles.scen.Data  = cell(0,6);
handles.sys        = varargin{1};
handles.opt        = varargin{2};
handles.h          = varargin{3};
handles.optdspec   = varargin{4};
handles.dslib      = createObj('dslib');

handles.string1 = [compose('Branch %i',1:size(handles.sys.branch,1)),'Mean','Percentile 50'];
handles.string2 = handles.sys.labelG{1}';

handles.site_pop.String    = handles.h.id;
handles.display_pop.String = handles.string1;
handles.plotfun            = @plotSPEC1;

xlabel(handles.ax1,'T(s)')
ylabel(handles.ax1,'Sa(g)')

handles.SPEC      = [];
handles.MRZ       = [];
%% fills table
guidata(hObject, handles);

% uiwait(handles.figure1);
function varargout = DSPEC_OutputFcn(hObject, eventdata, handles)
varargout{1} = [];

function site_pop_Callback(hObject, eventdata, handles)
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1)

function display_pop_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1)

function runDSPEC_Callback(hObject, eventdata, handles)

slist = 1:length(handles.h.id);
[handles.SPEC,handles.MRZ] = runDSPECtree(handles.sys,handles.opt,handles.optdspec,handles.h,slist);
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1);
guidata(hObject,handles)

function Exit_button_Callback(hObject, eventdata, handles)
delete(handles.figure1)

function disp_legend_Callback(hObject, eventdata, handles)

ch=findall(handles.figure1,'type','legend');
if isempty(ch)
    return
end
switch hObject.Value
    case 1, ch.Visible='off';
    case 0, ch.Visible='on';ch.Location='northeast';
end

function check1_Callback(hObject, eventdata, handles)
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1)

function undock_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax1)

function File_Callback(hObject, eventdata, handles)

function Edit_Callback(hObject, eventdata, handles)

function Options_Callback(hObject, eventdata, handles)
oldOpt = handles.optdspec;
newOpt = DSPECoptions(oldOpt);

if structcmp(oldOpt,newOpt)==0
    handles.optdspec = newOpt;
    handles.SPEC = [];
    handles.MRZ  = [];
    handles.scen.Data=cell(0,6);
    delete(findall(handles.ax1,'tag','speclines'));
    
    oldPeriod = oldOpt.periods;
    newPeriod = newOpt.periods;
    
    % recalculates UHS if control periods have changed
    if numel(oldPeriod)~=numel(newPeriod) || any(oldPeriod~=newPeriod)
        opt    = handles.opt;
        opt.IM = handles.optdspec.periods;
        Nsites = length(handles.h.id);
        [handles.optdspec.im,handles.optdspec.lambdauhs]=runUHS(handles.sys,opt,handles.h,1:Nsites);
    end
    handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1)
    drawnow
end
guidata(hObject,handles)

function ax2Limits_Callback(hObject, eventdata, handles)
ax2Control(handles.ax1);

function switchmode_Callback(hObject, eventdata, handles)
switch handles.displaymode
    case 1, handles.displaymode=2;
        handles.check1.String='Show Branches';
        handles.switchmode.CData=handles.form2;
        handles.scen.ColumnName{2}='Branch';
        handles.display_pop.Value  = 1;
        handles.display_pop.String = handles.string2;
        handles.plotfun = @plotSPEC2;

    case 2, handles.displaymode=1;
        handles.check1.String='Controlling Sources Only';
        handles.switchmode.CData=handles.form1;
        handles.scen.ColumnName{2}='Mechanism';
        handles.display_pop.Value  = 1;
        handles.display_pop.String = handles.string1;
        handles.plotfun = @plotSPEC1;
end
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1);
guidata(hObject,handles)

function listbox1_Callback(hObject, eventdata, handles)

function showDesign_Callback(hObject, eventdata, handles)
handles.dslib = DS(handles.dslib,handles.optdspec);
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1)
guidata(hObject,handles)

function checkbox4_Callback(hObject, eventdata, handles)
handles.plotfun(handles.SPEC,handles.MRZ,handles.optdspec,handles.dslib,handles.ax1)

function samode_Callback(hObject, eventdata, handles)

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
