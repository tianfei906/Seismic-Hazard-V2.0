function varargout = GMM_explorer(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GMM_explorer_OpeningFcn, ...
    'gui_OutputFcn',  @GMM_explorer_OutputFcn, ...
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

function GMM_explorer_OpeningFcn(hObject, eventdata, handles, varargin)
load icons_GMM_explorer.mat c
handles.goma.CData        = c{1};
handles.Exit_button.CData = c{2};
handles.HoldPlot.CData    = c{3};
handles.disp_legend.CData = c{4};
handles.setaxis.CData     = c{5};
handles.openbook.CData    = c{6};

handles.SUB       = createObj('interfaceEQ');
handles.SC        = createObj('crustalEQ');
handles.SITE      = createObj('siteGMM');

% --------------------------------------------------------
me       = pshatoolbox_methods(1);
gmpetype = {me.type}';
B1       = strcmp(gmpetype,'regular');
B2       = strcmp(gmpetype,'cond');
B        = or(B1,B2);
handles.me_reg = me(B1==1);
handles.me_con = me(B2==1);
handles.me = me(B==1);
% --------------------------------------------------------
handles.GMPEselect.String = {handles.me.label}';
ch           = get(handles.panel2,'children');
tag          = char(ch.Tag);
handles.text = flipud(find(ismember(tag(:,1),'t')));
handles.edit = flipud(find(ismember(tag(:,1),'e')));

% initialize data to fill plot
handles.selectedrow   = [];
handles.epsilon       = 0;
handles.uitable1.Data = cell(0,2);
handles.paramlist     = cell(0,2);
handles.ptrs          = zeros(0,18);
handles.ImageAlpha    = 0.2;

% called from SeismicHazard toolbox
if nargin==4
    GMPE = varargin{1}.sys.gmmlib;
    GMPE(ismember({GMPE.type},'pce')) = [];
    GMPE(ismember({GMPE.type},'udm')) = [];
    %GMPE(ismember({GMPE.type},'cond'))= [];
    GMPE(ismember({GMPE.type},'frn')) = [];
    Nj = length(GMPE);
    if Nj>0
        for j=1:Nj
            gmpe = GMPE(j,:);
            handles.uitable1.Data(end+1,:)={gmpe.label,func2str(gmpe.handle)};
            % Builds paramlist and ptrs list
            [param,ptrs]                = mGMPEusp(gmpe,handles.SUB,handles.SC,handles.SITE);
            handles.paramlist(end+1,:) = {gmpe.label,param};
            handles.ptrs(end+1,:)      = ptrs;
        end
        handles=CellSelectAction(handles,1);
    else
        handles = mGMPEdefault(handles);
    end
else
    handles = mGMPEdefault(handles);
end
plotgmpe(handles)
axis(handles.ax1,'auto')
handles.targetIM.String  = IM2str(handles.IM);
handles.targetIM.Visible = 'off';

% Validation Figures
D = what('validationfigures');
D = dir(fullfile(D.path,'*.png'));
ind = contains({D.name},handles.me(1).str);
D   = D(ind);
if ~isempty(D)
    names = regexp(strrep({D.name}','.png',''),'\_','split');
    names = vertcat(names{:});
    names = str2double(names(:,2));
    [~,ind]= sort(names);
    D      = D(ind);
end
handles.path2figures=D;
guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = GMM_explorer_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>

varargout{1} = [];

function GMPEselect_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>

D = what('Validationfigures');
D = dir(fullfile(D.path,'*.png'));
[~,val]=intersect({handles.me.label},handles.GMPEselect.String{handles.GMPEselect.Value});

ind = contains({D.name},sprintf('%s_',handles.me(val).str));
D   = D(ind);
if ~isempty(D)
    names = regexp(strrep({D.name}','.png',''),'\_','split');
    names = vertcat(names{:});
    names = str2double(names(:,2));
    [~,ind]= sort(names);
end
handles.path2figures=D(ind);


if handles.plotgmpetype.Value<7
    handles.ax1.Color=[1 1 1];
    ch=get(handles.panel2,'children');
    set(ch(handles.text),'Visible','off')
    set(ch(handles.edit),'Visible','off','Style','edit');
    handles = mGMPEdefault(handles);
    plotgmpe(handles)
else
    handles.targetIM.Value =1;
    handles.targetIM.String={handles.path2figures.name};
    plotgmpe(handles)
end
guidata(hObject,handles)

function GMPEselect_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Exit_button_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_button (see GCBO)

% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)

function File_Callback(hObject, eventdata, handles)

function Library_Callback(hObject, eventdata, handles)

function AddNew_Callback(hObject, eventdata, handles)

gmpeid = handles.GMPEselect.String{handles.GMPEselect.Value};
prompt={'Label'};
name='GMPE';
numlines=1;
defaultanswer={gmpeid};
answer=inputdlg(prompt,name,numlines,defaultanswer);

if isempty(answer)
    return
end

[param,ptrs]               = mGMPEgetparam(handles);
handles.paramlist(end+1,:) = {handles.fun,param};
handles.ptrs(end+1,:)      = ptrs;
handles.uitable1.Data(end+1,:) = {answer{1},func2str(handles.fun)};
guidata(hObject,handles)

function UpdateModel_Callback(hObject, eventdata, handles)
if isempty(handles.selectedrow)
    return
end

val = handles.selectedrow;
prompt={'Update GMPE Name'};
name='GMPE'; numlines=1;
defaultanswer={handles.uitable1.Data{val,1}};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    return
end
handles.uitable1.Data{val,1} = answer{1};
[param,ptrs]                 = mGMPEgetparam(handles);
handles.ptrs(val,:)          = ptrs;
un                           = handles.paramlist{val,2};
handles.paramlist(val,:)     = {handles.fun,un,param};
guidata(hObject,handles)

function LoadList_Callback(hObject, eventdata, handles)

function Save_Callback(hObject, eventdata, handles)

[filename, pathname] = uiputfile('*.txt','Save as');
if isnumeric(filename)
    return
end
fname = [pathname,filename];
fid = fopen(fname,'w');
list  = handles.uitable1.Data(:,1);
param = handles.paramlist;
for i=1:size(list,1)
    fprintf(fid,'gmpe %g %s\n',i,list{i});
    fprintf(fid,'@%s\n',func2str(param{i,1}));
    fprintf(fid,'%g\n',param{i,2});
    par = param{i,3};
    for j=1:length(par)
        e = par{j};
        if isnumeric(e)
            fprintf(fid,'%g\n',e);
        else
            fprintf(fid,'%s\n',e);
        end
    end
    if i<size(list,1)
        fprintf(fid,'\n');
    end
end
fclose(fid);
if ispc,winopen(fname);end

function RemoveSelection_Callback(hObject, eventdata, handles)
if isempty(handles.selectedrow)
    return
end
val                          = handles.selectedrow;
handles.uitable1.Data(val,:) = [];
handles.ptrs(val,:)          = [];
handles.paramlist(val,:)     = [];
handles.selectedrow          = [];
guidata(hObject,handles)

function e1_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e2_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles);
plotgmpe(handles)
guidata(hObject,handles)

function e3_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e4_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e5_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e6_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e7_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e8_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e9_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e10_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e11_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e12_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e13_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e14_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e15_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e16_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function e17_Callback(hObject, eventdata, handles)
% mGMPEcheck_param(handles)
plotgmpe(handles)
guidata(hObject,handles)

function PlotOptions_Callback(hObject, eventdata, handles)

function openbook_Callback(hObject, eventdata, handles)
val = handles.GMPEselect.Value;
if ~isempty(handles.me(val).ref)
    try
        web(handles.me(val).ref,'-browser')
    catch
    end
end

function grouplist_Callback(hObject, eventdata, handles)

function grouplist_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uitable1_CellSelectionCallback(hObject, eventdata, handles)
if isempty(eventdata.Indices)
    return
end
ind  = eventdata.Indices(1);
handles = CellSelectAction(handles,ind);

D = what('Validationfigures');
D = dir(fullfile(D.path,'*.png'));
[~,val]=intersect({handles.me.label},handles.GMPEselect.String{handles.GMPEselect.Value});

ind = contains({D.name},sprintf('%s_',handles.me(val).str));
D   = D(ind);
if ~isempty(D)
    names = regexp(strrep({D.name}','.png',''),'\_','split');
    names = vertcat(names{:});
    names = str2double(names(:,2));
    [~,ind]= sort(names);
end
handles.path2figures=D(ind);
handles.targetIM.Visible='on';
switch handles.plotgmpetype.Value
    case 1,handles.targetIM.Visible='off';
    case 7,handles.targetIM.String={handles.path2figures.name};
end
plotgmpe(handles)
handles.selectedrow=ind;

guidata(hObject,handles)

function handles=CellSelectAction(handles,ind)

vals = handles.ptrs(ind,:);
handles.GMPEselect.Value = vals(end);
ch=get(handles.panel2,'children');
set(ch(handles.text),'Visible','off')
set(ch(handles.edit),'Visible','off','Style','edit');
handles = mGMPEdefault(handles);

paramlist= handles.paramlist{ind,2};
for i=1:length(paramlist)
    fn = ['e',num2str(i)];
    if isnumeric(paramlist{i}) && strcmp(handles.(fn).Style,'edit')
        handles.(fn).String=num2str(paramlist{i});
    else
        handles.(fn).Value=vals(i);
    end
end

function targetIM_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uitable1_CellEditCallback(hObject, eventdata, handles)

guidata(hObject,handles)

function UndockAxis_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax1)

function showepsilon_Callback(hObject, eventdata, handles)

prompt={'Enter epsilon values'};
name='epsilon';
numlines=[1 50];
defaultanswer={strtrim(sprintf('%g ',handles.epsilon'))};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if isempty(answer)
    epsilon = 0;
else
    epsilon =eval(['[',answer{1},']']);
end
handles.epsilon = epsilon;
plotgmpe(handles)
guidata(hObject,handles)

function GMPEselect_ButtonDownFcn(hObject, eventdata, handles)

fn = {'All','PGA','PGV','PGD','CAV','AI','VGI','SA','SV','SD','V/H','NGA-West1 (2008)','NGA-West2 (2014)','Subduction Interface','Intermediate Depth','Crustal'};
[indx,tf] = listdlg('PromptString','Select GMMs','SelectionMode','single','ListString',fn);
if tf==0,return;end
if indx==9,return;end
str = mGMPEsubgroup(handles.me,indx);
handles.GMPEselect.String=str;
handles.GMPEselect.Value=1;

ch=get(handles.panel2,'children');
set(ch(handles.text),'Visible','off')
set(ch(handles.edit),'Visible','off','Style','edit');
handles = mGMPEdefault(handles);

D = what('Validationfigures');
D = dir(fullfile(D.path,'*.png'));
[~,val]=intersect({handles.me.label},handles.GMPEselect.String{handles.GMPEselect.Value});
ind = contains({D.name},sprintf('%s_',handles.me(val).str));
D = D(ind);
if ~isempty(D)
    names = regexp(strrep({D.name}','.png',''),'\_','split');
    names = vertcat(names{:});
    names = str2double(names(:,2));
    [~,ind]= sort(names);
end

handles.path2figures=D(ind);
plotgmpe(handles)
guidata(hObject,handles)

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
delete(hObject);

function Edit_Callback(hObject, eventdata, handles)

function defaultscenarios_Callback(hObject, eventdata, handles)

[handles.SUB,handles.SC,handles.SITE]=defaultEarthquakes(handles.SUB,handles.SC,handles.SITE);
ch=get(handles.panel2,'children');
set(ch(handles.text),'Visible','off')
set(ch(handles.edit),'Visible','off','Style','edit');
handles = mGMPEdefault(handles);
guidata(hObject,handles)

function disp_legend_Callback(hObject, eventdata, handles)

ch=findall(handles.figure1,'type','legend');
if ~isempty(ch)
    switch hObject.Value
        case 0, ch.Visible='off';
        case 1, ch.Visible='on';
    end
end

function CopyData_Callback(hObject, eventdata, handles)
ch=flipud(findall(handles.ax1,'type','line'));
L=findall(handles.figure1,'type','legend');
Nc = length(ch);
format short g
Data =ch(1).XData;
for i=1:Nc
    disp(L.String{i});
    Data=[Data;ch(i).YData];
end
disp(Data')

function setaxis_Callback(hObject, eventdata, handles)
ax2Control(handles.ax1);

function HoldPlot_Callback(hObject, eventdata, handles)

function plotgmpetype_Callback(hObject, eventdata, handles)
delete(findall(handles.ax1,'type','line'))
handles.ax1.Color=[1 1 1];
handles.ax1.ColorOrderIndex=1;
axis(handles.ax1,'auto')
handles.ax1.XScale='log';
handles.ax1.YScale='log';
handles.ax1.XTickMode='auto';
handles.ax1.YTickMode='auto';
handles.targetIM.Value=1;
handles.HoldPlot.Value=0;

switch hObject.Value
    case 1
        handles=mGMPEdefault(handles);
        handles.targetIM.Visible='off';
        handles.targetIM.String=IM2str(handles.IM);
    case 2
        handles=mGMPEdefault(handles);
        handles.ax1.YScale='linear';
        handles.targetIM.Visible='off';
        handles.targetIM.String=IM2str(handles.IM);
    case 3
        handles=mGMPEdefault(handles);
        handles.targetIM.Visible='off';
        handles.targetIM.String=IM2str(handles.IM);
    case 4
        handles=mGMPEdefault(handles);
        handles.targetIM.Visible='on';
        handles.targetIM.String=IM2str(handles.IM);
    case 5
        handles=mGMPEdefault(handles);
        handles.ax1.XScale='linear';
        handles.targetIM.Visible='on';
        handles.targetIM.String=IM2str(handles.IM);
    case 6
        handles=mGMPEdefault(handles);
        handles.ax1.XScale='linear';
        handles.targetIM.Visible='on';
        handles.targetIM.String=IM2str(handles.IM);
    case 7
        handles=mGMPEdefault(handles);
        handles.ax1.Color='none';
        handles.targetIM.String={handles.path2figures.name};
        handles.targetIM.Visible='on';
end
plotgmpe(handles)


function targetIM_Callback(hObject, eventdata, handles)
plotgmpe(handles)
guidata(hObject,handles)

function goma_Callback(hObject, eventdata, handles)
delete(findall(handles.ax1,'type','line'))
handles.ax1.ColorOrderIndex=1;

function OpenValidation_Callback(hObject, eventdata, handles)
[~,B]=intersect({handles.me.label},handles.GMPEselect.String{handles.GMPEselect.Value});
str = handles.me(B).str;
fname = sprintf('GMMValidation_%s.m',str);
edit(fname)
