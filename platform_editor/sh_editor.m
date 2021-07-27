function varargout = sh_editor(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @sh_editor_OpeningFcn, ...
    'gui_OutputFcn',  @sh_editor_OutputFcn, ...
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

function sh_editor_OpeningFcn(hObject, eventdata, handles, varargin)
SS=get(0,'screensize');
handles.figure1.Position(1:2)=(SS(3:4)-handles.figure1.Position(3:4))/2;
tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'top');
handles.tab0   = uitab('Parent', tgroup,'tag','tab0', 'Title', 'Templates');
handles.tab1   = uitab('Parent', tgroup,'tag','tab1', 'Title', 'Real Values');
handles.tab2   = uitab('Parent', tgroup,'tag','tab2', 'Title', 'Logic Tree');
handles.tab3   = uitab('Parent', tgroup,'tag','tab3', 'Title', 'Sources');
handles.tab4   = uitab('Parent', tgroup,'tag','tab4', 'Title', 'Gmpes');
handles.tab5   = uitab('Parent', tgroup,'tag','tab5', 'Title', 'M-R relations');
handles.tab6   = uitab('Parent', tgroup,'tag','tab6', 'Title', 'Sites');
handles.tab8   = uitab('Parent', tgroup,'tag','tab8', 'Title', 'Validation');
handles.tab9   = uitab('Parent', tgroup,'tag','tab9', 'Title', 'Events');
handles.tab10  = uitab('Parent', tgroup,'tag','tab10', 'Title', 'PSDA');
handles.tab11  = uitab('Parent', tgroup,'tag','tab11', 'Title', 'LIBS');

%Place panels into each tab
pos=get(handles.P0,'position');
set(handles.P0 ,'Parent',handles.tab0);
set(handles.P1 ,'Parent',handles.tab1 ,'Position',pos);
set(handles.P2 ,'Parent',handles.tab2 ,'Position',pos);
set(handles.P3 ,'Parent',handles.tab3 ,'Position',pos);
set(handles.P4 ,'Parent',handles.tab4 ,'Position',pos);
set(handles.P5 ,'Parent',handles.tab5 ,'Position',pos);
set(handles.P6 ,'Parent',handles.tab6 ,'Position',pos);
set(handles.P8 ,'Parent',handles.tab8 ,'Position',pos);
set(handles.P9 ,'Parent',handles.tab9 ,'Position',pos);
set(handles.P10,'Parent',handles.tab10,'Position',pos);
set(handles.P11,'Parent',handles.tab11,'Position',pos);

handles.P3_str = [handles.P3_t1;handles.P3_t2;handles.P3_t3;handles.P3_t4;handles.P3_t5;handles.P3_t6;handles.P3_t7];
handles.P3_edi = [handles.P3_e1;handles.P3_e2;handles.P3_e3;handles.P3_e4;handles.P3_e5;handles.P3_e6;handles.P3_e7];
handles.P4_str = [handles.P4_t0;handles.P4_t1;handles.P4_t2;handles.P4_t3;handles.P4_t4;handles.P4_t5;handles.P4_t6;handles.P4_t7;handles.P4_t8;handles.P4_t9;handles.P4_t10];
handles.P4_edi = [handles.P4_e0;handles.P4_e1;handles.P4_e2;handles.P4_e3;handles.P4_e4;handles.P4_e5;handles.P4_e6;handles.P4_e7;handles.P4_e8;handles.P4_e9;handles.P4_e10];

handles.P3_tableindex  = 1;
handles.P3_vertexindex = 1;
handles.P2_index1=[];
handles.P2_index2=[];
handles.P2_index3=[];

% c1=double(imresize(imread('Open.png'),[30 30]))/255;
load sh_images c1 c2 c3 c4 c5 c6 c7
handles.P0_open.CData            = c1;
handles.P0_new.CData             = c2;
handles.P0_proceed.CData         = c3;
handles.P0_openDrivingFile.CData = c4;
handles.P0_saveas.CData          = c5;
handles.P3_deletevertex.CData    = c6;
handles.P3_addvertex.CData       = c7;
fid=fopen('cache.txt','r'); data = textscan(fid,'%s','delimiter','\n'); data = data{1}; fclose(fid);
handles.P0_list.String=data;

handles.cb1=colorbar('peer',handles.P3_ax1,'location','eastoutside','visible','off');
guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = sh_editor_OutputFcn(hObject, eventdata, handles)
varargout{1} = [];

% ------------------- P0: Templates -------------------------------------
function P0_list_Callback(hObject, eventdata, handles)

if strcmp(get(gcf,'selectiontype'),'open')
    fname = hObject.String{hObject.Value};
    handles=importmodel(handles,fname);
end
guidata(hObject,handles)

function P0_open_Callback(hObject, eventdata, handles)

if isfield(handles,'defaultpath_others')
    [filename,pathname,FILTERINDEX]=uigetfile(fullfile(handles.defaultpath_others,'*.txt'),'select file');
else
    [filename,pathname,FILTERINDEX]=uigetfile(fullfile(pwd,'*.txt'),'select file');
    
end
if FILTERINDEX==0,return;end

D=what('platform_realvalues');
CACHE = fullfile(D.path,'cache.txt');
fid=fopen(CACHE,'r'); data = textscan(fid,'%s','delimiter','\n'); data = data{1}; fclose(fid);
%%
newdata=unique([filename;data],'stable');
fid=fopen(CACHE,'w');
Nmax = min(numel(newdata),15);
for i=1:Nmax-1
    fprintf(fid,'%s\n',newdata{i});
end
fprintf(fid,'%s',newdata{Nmax});
fclose(fid);

%%
handles.defaultpath_others=pathname;

fname   = fullfile(pathname,filename);
handles = importmodel(handles,fname);
guidata(hObject,handles)

function P0_openDrivingFile_Callback(hObject, eventdata, handles)
if isfield(handles,'sys')
    winopen(handles.sys.filename)
end

function P0_new_Callback(hObject, eventdata, handles)
D       = what('platform_realvalues');
fname   = fullfile(D.path,'DefaultModel.txt');
handles = importmodel(handles,fname);
guidata(hObject,handles)

function P0_saveas_Callback(hObject, eventdata, handles)
sh_saveas(handles)

function [handles]=importmodel(handles,fname)
[handles.sys,handles.opt,handles.h]=sh_readPSHA(fname);
handles=populate_sheditor(handles);

% ------------------- P1: Real Values -------------------------------------
function P1_PCErealizations_Callback(hObject, eventdata, handles) %#ok<*DEFNU>

function P1_dsha1_Callback(hObject, eventdata, handles)

function P1_dsha3_Callback(hObject, eventdata, handles)

function P1_dsha4_Callback(hObject, eventdata, handles)

function P1_dsha2_Callback(hObject, eventdata, handles)

function P1_IM_Callback(hObject, eventdata, handles)
oldIM=handles.opt.IM;
newIM=str2IM(hObject.String);

if numel(oldIM)~=numel(newIM) || all(oldIM==newIM)==false
    handles.opt.IM=newIM;
    handles.opt.im=createObj(1,newIM);
    handles.P1_imtable.Data=num2cell(handles.opt.im);
    handles.P1_imtable.ColumnName=hObject.String(:)';
end

guidata(hObject,handles)

function P1_projection_Callback(hObject, eventdata, handles)

function P1_boundary_Callback(hObject, eventdata, handles)

function P1_image_Callback(hObject, eventdata, handles)

function P1_shermodulus_Callback(hObject, eventdata, handles)

function P1_maxdist_Callback(hObject, eventdata, handles)

function P1_clusters2_Callback(hObject, eventdata, handles)

function P1_SourceDeagg_Callback(hObject, eventdata, handles)

function P1_clusters1_Callback(hObject, eventdata, handles)
switch hObject.Value
    case 0,handles.P1_clusters2.Enable='off';
    case 1,handles.P1_clusters2.Enable='on';
end

function P1_GP2_Callback(hObject, eventdata, handles)

function P1_UNI2_Callback(hObject, eventdata, handles)

function P1_IS2_Callback(hObject, eventdata, handles)

function P1_sigmaTR2_Callback(hObject, eventdata, handles)

function P1_sigmaOW2_Callback(hObject, eventdata, handles)

function P1_uibuttongroup4_SelectionChangedFcn(hObject, eventdata, handles)

handles.P1_IS2.Enable='off';
handles.P1_GP2.Enable='off';
handles.P1_UNI2.Enable='off';

switch handles.P1_uibuttongroup4.SelectedObject.String
    case 'Important Sampling', handles.P1_IS2.Enable  ='on';
    case 'Gaussian Points'   , handles.P1_GP2.Enable  ='on';
    case 'Uniform Bins'      , handles.P1_UNI2.Enable ='on';
end

function P1_uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
handles.P1_sigmaOW2.Enable='off';
handles.P1_sigmaTR2.Enable='off';

switch handles.P1_uibuttongroup3.SelectedObject.String
    case 'Overwrite Sigma', handles.P1_sigmaOW2.Enable='on';
    case 'Truncate Sigma' , handles.P1_sigmaTR2.Enable='on';
end

function P1_NSamples_Callback(hObject, eventdata, handles)
NSamples=str2double(hObject.String);
handles.opt.im=createObj(1,str2IM(handles.P1_IM.String),NSamples);
handles.P1_imtable.Data=num2cell(handles.opt.im);
guidata(hObject,handles)

function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)

NSample = str2double(handles.P1_NSamples.String);
NIM = numel(handles.opt.IM);
switch hObject.String
    case 'default limits'
        handles.opt.immode=1;
        handles.opt.im = createObj(1,handles.opt.IM,NSample);
        handles.P1_imtable.ColumnEditable=false(1,NIM);
        handles.P1_imtable.Data=num2cell(handles.opt.im);
        handles.P1_imtable.BackgroundColor=[1 1 1;0.94 0.94 0.94];
        handles.P1_imtable.RowName='numbered';
    case 'user defined limits'
        handles.opt.immode=2;
        handles.radiobutton12.Value=1;
        handles.P1_imtable.ColumnEditable=true(1,NIM);
        handles.P1_imtable.Data=num2cell(handles.opt.im([1,end],:));
        handles.P1_imtable.BackgroundColor=[1 1 0.7];
        handles.P1_imtable.RowName={'Min','Max'};
    case 'user defined list'
        handles.opt.immode=3;
        handles.P1_imtable.ColumnEditable=true(1,NIM);
        handles.P1_imtable.Data=num2cell(handles.opt.im);
        handles.P1_imtable.BackgroundColor=[1 1 0.7];
        handles.P1_imtable.RowName='numbered';
end

guidata(hObject,handles)

function P1_imtable_CellEditCallback(hObject, eventdata, handles)

if handles.opt.immode==2
    data = cell2mat(handles.P1_imtable.Data);
    NSample = str2double(handles.P1_NSamples.String);
    NIM = size(data,2);
    for i=1:NIM
        immin = data(1,i);
        immax = data(2,i);
        handles.opt.im(:,i)=logsp(immin,immax,NSample);
    end
end

if handles.opt.immode==3
    data = cell2mat(handles.P1_imtable.Data);
    handles.opt.im=data;
end

guidata(hObject,handles)

% ------------------- P2: Logic Tree -------------------------------------

function P2_add1_ButtonDownFcn(hObject, eventdata, handles)
handles.P2_table1.Data(end+1,:)=handles.P2_table1.Data(end,:);
handles.P2_table1.Data{end,1}='newGeom';

handles=sh_updateLogicTreeTables(handles);
plotPSHALogicTree(handles)
handles.sys.source{1,end+1}=handles.sys.source{end}(1);
handles.sys.labelG{1,end+1}=handles.sys.labelG{end}(1);
handles.sys.numG{1,end+1}  =handles.sys.numG{end}(1,:);
Ngeom = numel(handles.sys.source);
handles.po_region.String{end+1} = 'newGeom';

handles.sys=sh_plot_geometry_PSHA(handles.P3_ax1,handles.sys,handles.opt,Ngeom,1);
guidata(hObject,handles)

function P2_delete1_ButtonDownFcn(hObject, eventdata, handles)
if isempty(handles.P2_index1)
    return
end
ind = handles.P2_index1(:,1);
indcomplete=1:size(handles.P2_table1.Data,1);
indcomplete(ind)=[];
handles.P2_table1.Data(ind,:)=[];
handles=sh_updateLogicTreeTables(handles);

Ns = numel(handles.sys.source{ind});
for i=1:Ns
    sourcetype=handles.sys.source{ind}{i}.sourcetype;
    if sourcetype>1
        delete(handles.sys.source{ind}{i}.handle_depth)
    end
    if sourcetype>2
        delete(handles.sys.source{ind}{i}.handle_mesh)
    end
    delete(handles.sys.source{ind}{i}.handle_edge)
    delete(handles.sys.source{ind}{i}.handle_txt)
end

handles.sys.source(ind)=[];
handles.sys.labelG(ind)=[];
handles.sys.numG(ind)  =[];
handles.po_region.Value=1;
handles.po_region.String(ind)=[];  

for i=1:numel(indcomplete)
    if i~=indcomplete(i)
        tag1=sprintf('dept%g',i);
        tag2=sprintf('dept%g',indcomplete(i));
        ch=findall(handles.P3_ax1,'tag',tag2);  set(ch,'Tag',tag1)
        
        tag1=sprintf('edge%g',i);
        tag2=sprintf('edge%g',indcomplete(i));
        ch=findall(handles.P3_ax1,'tag',tag2);  set(ch,'Tag',tag1)
        
        tag1=sprintf('mesh%g',i);
        tag2=sprintf('mesh%g',indcomplete(i));
        ch=findall(handles.P3_ax1,'tag',tag2);  set(ch,'Tag',tag1)
        
        tag1=sprintf('sourcelabel%g',i);
        tag2=sprintf('sourcelabel%g',indcomplete(i));
        ch=findall(handles.P3_ax1,'tag',tag2);  set(ch,'Tag',tag1)        
    end
end

plotPSHALogicTree(handles)
guidata(hObject,handles)

function P2_add2_ButtonDownFcn(hObject, eventdata, handles)
handles.P2_table2.Data(end+1,:)= handles.P2_table2.Data(end,:);
handles.sys.gmmptr(end+1,:)    = handles.sys.gmmptr(end,:);
handles.P4_table.Data(end+1,:) = handles.P4_table.Data(end,:);

handles.P2_table2.Data{end,1}  = 'newGroup';
handles.P4_table.Data{end,1}   = 'newGroup';
handles=sh_updateLogicTreeTables(handles);
plotPSHALogicTree(handles)
guidata(hObject,handles)

function P2_delete2_ButtonDownFcn(hObject, eventdata, handles)
if isempty(handles.P2_index2)
    return
end
ind = handles.P2_index2(:,1);
handles.P2_table2.Data(ind,:) = [];
handles.sys.gmmptr(ind,:)     = [];
handles.P4_table.Data(ind,:)  = [];
handles=sh_updateLogicTreeTables(handles);

plotPSHALogicTree(handles)
guidata(hObject,handles)

function P2_add3_ButtonDownFcn(hObject, eventdata, handles)
handles.P2_table3.Data(end+1,:)= handles.P2_table3.Data(end,:);
handles=sh_updateLogicTreeTables(handles);
guidata(hObject,handles)

function P2_delete3_ButtonDownFcn(hObject, eventdata, handles)
ind = handles.P2_index3(:,1);
if isempty(ind)
    return
end
handles.sys.mscl(ind)        = [];
handles.P2_table3.Data(ind,:)= [];
handles=sh_updateLogicTreeTables(handles);
plotPSHALogicTree(handles)
guidata(hObject,handles)

% ------------------- P3: Sources -------------------------------------
function po_region_Callback(hObject, eventdata, handles)
geom =hObject.Value;
index=1;
handles.P3_table.Data=sh_fillP3Table(handles,geom);

sh_viewSource(handles.sys,handles.P3_vertices,handles.P3_str,handles.P3_edi,geom,index);
for i=1:numel(handles.sys.source)
    tag=sprintf('dept%g',i); ch =findall(handles.figure1,'tag',tag); set(ch,'Visible','off');
    tag=sprintf('mesh%g',i); ch =findall(handles.figure1,'tag',tag); set(ch,'Visible','off');
    tag=sprintf('edge%g',i); ch =findall(handles.figure1,'tag',tag); set(ch,'Visible','off');
    tag=sprintf('sourcelabel%g',i);  ch =findall(handles.figure1,'tag',tag); set(ch,'Visible','off');
end

tag=sprintf('edge%g',hObject.Value);
ch=findall(handles.figure1,'tag',tag);
set(ch,'Visible',handles.po_sources.Checked);

tag=sprintf('mesh%g',hObject.Value);
ch=findall(handles.figure1,'tag',tag);
switch strcmp(handles.po_sourcemesh.Checked,'on')
    case 0, set(ch,'edgecolor','none'     ,'visible','off');
    case 1, set(ch,'edgecolor',[0.6 0.6 1],'visible','on');
end

dept=sprintf('dept%g',hObject.Value);
ch=findall(handles.figure1,'tag',dept);
switch strcmp(handles.po_depth.Checked,'on')
    case 0, set(ch,'facecolor','none'  ,'visible','off'); handles.cb1.Visible='off';handles.cb2.Visible='off';
    case 1, set(ch,'facecolor','interp','visible','on');  handles.cb1.Visible='on'; handles.cb2.Visible='on';
end

handles.cb1.Title.String='Depth(km)';
handles.cb2.Title.String='Depth(km)';
ch=findall(handles.P3_ax1,'tag',dept);
if ~isempty(ch)
    FVD = vertcat(ch.FaceVertexCData);
    fixlims=[min(FVD),max(FVD)];
    if diff(fixlims)<1e-5
        fixlims=mean(fixlims)+[-0.5 0.5];
    end
    handles.cb1.Limits =fixlims;
    handles.cb2.Limits =fixlims;
    handles.cb1limits1 =fixlims;
    
end

if strcmp(handles.SourceLabels.Checked,'on')
    tag=sprintf('sourcelabel%g',hObject.Value);
    ch =findall(handles.figure1,'tag',tag);
    set(ch,'Visible','on');
end
sh_updatecolorbar

function P3_e1_Callback(hObject, eventdata, handles)

function P3_e2_Callback(hObject, eventdata, handles)

function P3_e3_Callback(hObject, eventdata, handles)

function P3_e4_Callback(hObject, eventdata, handles)

function P3_e5_Callback(hObject, eventdata, handles)

function P3_e6_Callback(hObject, eventdata, handles)

function P3_e7_Callback(hObject, eventdata, handles)

function P3_table_CellSelectionCallback(hObject, eventdata, handles)

set(handles.P3_str  ,'Visible','off');
set(handles.P3_edi,'Visible','off');
geomptr = handles.po_region.Value;
if isempty(eventdata.Indices)
    index = 1;
else
    index = eventdata.Indices(1);
end
handles.P3_tableindex=index;
sh_viewSource(handles.sys,handles.P3_vertices,handles.P3_str,handles.P3_edi,geomptr,index)
guidata(hObject,handles)

function P3_deletesource_Callback(hObject, eventdata, handles)
if ~isfield(handles,'P3_tableindex') || isempty(handles.P3_tableindex)
    return
end
handles.sys = sh_deletesource(handles.sys,handles.po_region.Value,handles.P3_tableindex);
handles.P3_tableindex=1;
handles.P3_table.Data=sh_fillP3Table(handles,1);
sh_updatecolorbar
guidata(hObject,handles)

function P3_addsource_Callback(hObject, eventdata, handles)
handles.sys = sh_addsource(handles);

geom =handles.po_region.Value;
handles.P3_table.Data=sh_fillP3Table(handles,geom);
handles.P3_tableindex=size(handles.P3_table.Data,1);
index   = handles.P3_tableindex;
sh_updatecolorbar
sh_viewSource(handles.sys,handles.P3_vertices,handles.P3_str,handles.P3_edi,geom,index);
guidata(hObject,handles)

function P3_updatesource_Callback(hObject, eventdata, handles)
handles.sys = sh_updatesource(handles);
geomptr = handles.po_region.Value;
index   = handles.P3_tableindex;
% handles.P3_table.Data=fillP3Table(handles,geomptr);
sh_updatecolorbar
sh_viewSource(handles.sys,handles.P3_vertices,handles.P3_str,handles.P3_edi,geomptr,index);
guidata(hObject,handles)

function P3_vertices_CellSelectionCallback(hObject, eventdata, handles)

if isempty(eventdata.Indices)
    handles.P3_vertexindex=1;
else
handles.P3_vertexindex=eventdata.Indices(1);
end
guidata(hObject,handles)

function P3_deletevertex_Callback(hObject, eventdata, handles)

data=handles.P3_vertices.Data;
data(handles.P3_vertexindex,:)=[];
handles.P3_vertices.Data=data;

guidata(hObject,handles)

function P3_addvertex_Callback(hObject, eventdata, handles)

data    = cell2mat(handles.P3_vertices.Data);
index   = handles.P3_vertexindex;
Nvert   = size(data,1);
if index==1
    newdata =[data(1,:);1/2*(data(1,:)+data(2,:));data(2:end,:)];
elseif index==Nvert
    newdata =[data;1/2*(data(1,:)+data(Nvert,:))];
else
    newdata=[data(1:index,:);1/2*(data(index,:)+data(index+1,:));data(index+1:end,:)];
end
handles.P3_vertices.Data=num2cell(newdata);
guidata(hObject,handles)

% ------------------- P4: GMM Library -------------------------------------
function P4_list_Callback(hObject, eventdata, handles)  %#ok<*INUSL>
set(handles.P4_str  ,'Visible','off');
set(handles.P4_edi,'Visible','off');

val = hObject.Value;
gmm=handles.sys.gmmlib(val);
sh_viewGMM(handles.sys.gmmlib,gmm,handles.P4_str,handles.P4_edi)

function P4_e0_Callback(hObject, eventdata, handles) %#ok<*INUSD>

function P4_e1_Callback(hObject, eventdata, handles)

% update GMM handle PENDIENTEEEEEEEEEEEEEEEEE
%gmm=sh_defaultGMM(handles,hObject.Value);
% sh_viewGMM(gmm,handles.P4_str,handles.P4_edi)

function P4_e2_Callback(hObject, eventdata, handles)

function P4_e3_Callback(hObject, eventdata, handles)

function P4_e4_Callback(hObject, eventdata, handles)

function P4_e5_Callback(hObject, eventdata, handles)

function P4_e6_Callback(hObject, eventdata, handles)

function P4_e7_Callback(hObject, eventdata, handles)

function P4_e8_Callback(hObject, eventdata, handles)

function P4_e9_Callback(hObject, eventdata, handles)

function P4_e10_Callback(hObject, eventdata, handles)

function P4_delete_Callback(hObject, eventdata, handles)

function P5_e5_Callback(hObject, eventdata, handles)

function P5_e6_Callback(hObject, eventdata, handles)

if numel(handles.P4_list.String)==1
    f=warndlg('cannot empty GMM list');
    waitfor(f);
    return
end

val = handles.P4_list.Value;
handles.P4_list.Value=1;
strdel=handles.P4_list.String(val);
handles.P4_list.String(val)=[];
handles.sys.gmmlib(val)=[];
Ncols = size(handles.P4_table.Data,2);
for i=2:Ncols
    handles.P4_table.ColumnFormat{i}=handles.P4_list.String(:)';
end

grep=strcmp(handles.P4_table.Data(:,2:end),strdel);
for i=1:size(grep,1)
    for j=1:size(grep,2)
        if grep(i,j)
            handles.P4_table.Data{i,j+1}=handles.P4_list.String{1};
        end
    end
end

guidata(hObject,handles)

function P4_add_Callback(hObject, eventdata, handles)

val = handles.P4_list.Value;
gmm = handles.sys.gmmlib(val);
gmm.label=[gmm.label,'-copy'];
gmm.txt{2}=gmm.label;
handles.sys.gmmlib(end+1)=gmm;
handles.P4_list.String = {handles.sys.gmmlib.label};
Ncols = size(handles.P4_table.Data,2);
for i=2:Ncols
    handles.P4_table.ColumnFormat{i}=handles.P4_list.String(:)';
end
guidata(hObject,handles)

function P4_update_Callback(hObject, eventdata, handles)

val    = handles.P4_list.Value;
gmmOLD = handles.sys.gmmlib(val);

gmm = sh_updategmm(handles,gmmOLD);

handles.sys.gmmlib(val)=gmm;
handles.P4_list.String = {handles.sys.gmmlib.label};

Ncols = size(handles.P4_table.Data,2);
for i=2:Ncols
    handles.P4_table.ColumnFormat{i}=handles.P4_list.String(:)';
end

grep=strcmp(handles.P4_table.Data(:,2:end),gmmOLD.label);
for i=1:size(grep,1)
    for j=1:size(grep,2)
        if grep(i,j)
            handles.P4_table.Data{i,j+1}=gmm.label;
        end
    end
end


guidata(hObject,handles)

% ------------- Magnitude Scaling Relations ------------------------------
function P5_formulation_Callback(hObject, eventdata, handles)
sh_defaultMscl(handles,hObject.Value)

function P5_pop1_Callback(hObject, eventdata, handles)
sh_viewMscl(handles,hObject.Value);

function P5_e1_Callback(hObject, eventdata, handles)

switch hObject.Value
    case 1, handles.P5_t2.String = 'Rate (events/yr)';
    case 2, handles.P5_t2.String = 'Rate (mm/yr)';
end

function P5_e2_Callback(hObject, eventdata, handles)

function P5_e3_Callback(hObject, eventdata, handles)

function P5_e4_Callback(hObject, eventdata, handles)

function P5_list_Callback(hObject, eventdata, handles)
sh_viewMscl(handles,hObject.Value);

function P5_updatebutton_Callback(hObject, eventdata, handles)
val=handles.P5_list.Value;
if isempty(val)
    return
end
mscl_ptr=handles.P5_pop1.Value;
handles.sys.mscl{mscl_ptr}{val}=sh_updateMscl(handles);
if handles.P5_datasource.Value==2
    handles.sys.mscl{mscl_ptr}{val}.num(2:end)=NaN;
end
guidata(hObject,handles)

function P5_datasource_Callback(hObject, eventdata, handles)
sh_viewMscl(handles,handles.P5_list.Value,true)

% --------- LAYERS --------------------------------------------------------
function P6_poplayers_Callback(hObject, eventdata, handles)

fld = hObject.String{hObject.Value};
handles.P6_layerlist.String=handles.sys.layer.(fld);

function P6_layerlist_Callback(hObject, eventdata, handles)
fld = handles.P6_poplayers.String{handles.P6_poplayers.Value};
handles.sys.layer.(fld)=handles.P6_layerlist.String;
s2num = str2double(handles.sys.layer.(fld));
for i=1:numel(s2num)
   if ~isnan(s2num(i)) 
       handles.sys.layer.(fld){i}=s2num(i);
   end
end
guidata(hObject,handles)

function P6_SiteSelectionTool_Callback(hObject, eventdata, handles)

handin.h            = handles.h;
handin.ax           = handles.P3_ax1;
handin.opt          = handles.opt;
handin.layer        = handles.sys.layer;
[handles.h,handles.layer] = SelectLocations(handin);

Ndisp = min(numel(handles.h.id),20);
handles.P6_table.Data=[handles.h.id(1:Ndisp),num2cell(handles.h.p(1:Ndisp,:)),num2cell(handles.h.value(1:Ndisp,:))];
guidata(hObject,handles)

% ----------- VALIDATION --------------------------------------------------
function P8_Delete_Callback(hObject, eventdata, handles)

handles.sys.validation=[];
handles.sys.validation_legend=[];
handles.P8_table.Data=[];
handles.P8_table.RowName='numbered';

function P8_Upload_Callback(hObject, eventdata, handles)

[filename, pathname, filterindex] = uigetfile('*.txt', 'Pick a Validation File');

if filterindex==0
    return
end
fid=fopen(fullfile(pathname,filename));
data = textscan(fid,'%s','delimiter','\n');
data = data{1};
fclose(fid);
data=strrep(data,'	',' ');
data=strtrim(regexprep(data,' +',' '));
data    = regexp(data,'\ ','split');
Nrow    = numel(data);
Ncol    = numel(data{1}); 
D = cell(Nrow,Ncol);
for i=1:Nrow
    D{i,1}=data{i}{1};
    D(i,2:end)=num2cell(str2double(data{i}(2:end)));
end
handles.P8_table.Data=D;
guidata(hObject,handles);

% -------------- PSDA MODELS ----------------------------------------------
function P10_Enable_Callback(hObject, eventdata, handles)

ch=handles.P10.Children;
switch hObject.Value
    case 0,set(ch,'Enable','off');
    case 1,set(ch,'Enable','on');
end
handles.P10_Enable.Enable='on';

function P10_Dmin_Callback(hObject, eventdata, handles)

function P10_Dmax_Callback(hObject, eventdata, handles)

function P10_Nsta_Callback(hObject, eventdata, handles)

function P10_ky_Callback(hObject, eventdata, handles)

function P10_Ts_Callback(hObject, eventdata, handles)

function P10_realSa_Callback(hObject, eventdata, handles)

function P10_realD_Callback(hObject, eventdata, handles)

function P10_list_Callback(hObject, eventdata, handles)
sh_fillPSDA(handles,hObject.Value)

function P10_e2_Callback(hObject, eventdata, handles)
sh_adddefaultPSDA(handles,hObject.Value)

function P10_e1_Callback(hObject, eventdata, handles)

function P10_e3_Callback(hObject, eventdata, handles)

function P10_e4_Callback(hObject, eventdata, handles)

function P10_e5_Callback(hObject, eventdata, handles)

function P10_e6_Callback(hObject, eventdata, handles)

function P10_e7_Callback(hObject, eventdata, handles)

function P10_add_Callback(hObject, eventdata, handles)
handles.smlib=sh_addnewPSDA(handles,'add');
guidata(hObject,handles)

function P10_update_Callback(hObject, eventdata, handles)
handles.smlib=sh_addnewPSDA(handles,'update');
guidata(hObject,handles)

function P10_delete_Callback(hObject, eventdata, handles)
val = handles.P10_list.Value;
if isempty(handles.P10_list.String)
    return
end
handles.smlib(val)=[];
handles.P10_list.Value=1;
handles.P10_list.String(val)=[];
if ~isempty(handles.P10_list.String)
    sh_fillPSDA(handles,1)
end
guidata(hObject,handles)

% --------------------- LIBS ----------------------------------------------
function P11_Enable_Callback(hObject, eventdata, handles)
ch=handles.P11.Children;
switch hObject.Value
    case 0,set(ch,'Enable','off');
    case 1,set(ch,'Enable','on');
end
handles.P11_Enable.Enable='on';

function P11_Smin_Callback(hObject, eventdata, handles)

function P11_Smax_Callback(hObject, eventdata, handles)

function P11_Nsta_Callback(hObject, eventdata, handles)

function P11_Qsamples_CreateFcn(hObject, eventdata, handles)

function P11_list_Callback(hObject, eventdata, handles)
sh_fillLIBS(handles,hObject.Value)

function P11_e1_Callback(hObject, eventdata, handles)

function P11_e2_Callback(hObject, eventdata, handles)

function P11_add_Callback(hObject, eventdata, handles)
handles.setlib=sh_addnewLIBS(handles,'add');
guidata(hObject,handles)

function P11_update_Callback(hObject, eventdata, handles)
handles.setlib=sh_addnewLIBS(handles,'update');
guidata(hObject,handles)

function P11_delete_Callback(hObject, eventdata, handles)

% ------------------- sh_editor functions ---------------------------------
function DisplayOptions_Callback(hObject, eventdata, handles)

function po_grid_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'on' , hObject.Checked='off';
    case 'off', hObject.Checked='on';
end
grid(handles.P3_ax1,hObject.Checked)

function Boundary_check_Callback(hObject, eventdata, handles)

switch hObject.Checked
    case 'off', hObject.Checked='on';  
    case 'on' , hObject.Checked='off';
end
ch = findall(handles.figure1,'tag','shape1');
set(ch,'visible',hObject.Checked);

function SourceLabels_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'on' , hObject.Checked='off';
    case 'off', hObject.Checked='on'; 
end

tag = sprintf('sourcelabel%g',handles.po_region.Value);
ch  = findall(handles.figure1,'tag',tag);
set(ch,'visible',hObject.Checked)

function po_sources_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'off', hObject.Checked='on'; 
    case 'on',  hObject.Checked='off';
end
tag_edge = sprintf('edge%g',handles.po_region.Value);
ch       = findall(handles.figure1,'tag',tag_edge);
set(ch,'visible',hObject.Checked);

function po_sourcemesh_Callback(hObject, eventdata, handles)
switch handles.po_sourcemesh.Checked
    case 'off', hObject.Checked='on'; 
    case 'on', hObject.Checked='off';
end
tag_mesh = sprintf('mesh%g',handles.po_region.Value);
ch       = findall(handles.figure1,'tag',tag_mesh);
set(ch,'visible',hObject.Checked);

function po_depth_Callback(hObject, eventdata, handles)
switch handles.po_depth.Checked
    case 'on' , handles.po_depth.Checked='off';
    case 'off', handles.po_depth.Checked='on';
end
sh_updatecolorbar
guidata(hObject,handles);

function po_sites_Callback(hObject, eventdata, handles)

function po_googleearth_Callback(hObject, eventdata, handles)

ch=findall(handles.P3_ax1,'tag','gmap');
if isempty(ch)
    return
end

switch hObject.Checked
    case 'on', hObject.Checked='off'; set(ch,'Visible','off');
    case 'off',hObject.Checked='on';  set(ch,'Visible','on');
end

function P3_zoom_Callback(hObject, eventdata, handles)

if ~isfield(handles,'zoom')
    handles.zoom = zoom(handles.figure1);
    guidata(hObject,handles);
end

switch handles.zoom.Enable
    case 'off', handles.zoom.Enable='on';
    case 'on' , handles.zoom.Enable='off';
end

function P1_image_ButtonDownFcn(hObject, eventdata, handles)

D = what('platform_earth');
[filename,pathname]=uigetfile([D.path,'\*.mat'], 'Select file');
if isnumeric(filename)
    return
end
handles.P1_image.String=fullfile(filename);
handles.opt.Image=fullfile(pathname,filename);
default_maps(handles.figure1,handles.opt,handles.P3_ax1)
guidata(hObject,handles)

function P1_boundary_ButtonDownFcn(hObject, eventdata, handles)

D = what('platform_shapefiles');
[filename,pathname]=uigetfile([D.path,'\*.shp'], 'Select file');
if isnumeric(filename)
    return
end
handles.P1_boundary.String=filename;
handles.opt.Boundary=fullfile(pathname,filename);
default_maps(handles.figure1,handles.opt,handles.P3_ax1)
guidata(hObject,handles)

function File_Callback(hObject, eventdata, handles)

function RefreshModel_Callback(hObject, eventdata, handles)
handles=importmodel(handles,handles.sys.filename);
guidata(hObject,handles)

function P3_drawpolyline_Callback(hObject, eventdata, handles)

% p5_e1      = gridNC(handles.P3_ax1,'polyline',handles.figure1);
% LONLAT = [p5_e1.XData',p5_e1.YData'];

function P2_table1_CellSelectionCallback(hObject, eventdata, handles)
handles.P2_index1=eventdata.Indices;
guidata(hObject,handles)

function P2_table2_CellSelectionCallback(hObject, eventdata, handles)
handles.P2_index2=eventdata.Indices;
guidata(hObject,handles)

function P2_table3_CellSelectionCallback(hObject, eventdata, handles)
handles.P2_index3=eventdata.Indices;
guidata(hObject,handles)

function P2_table2_CellEditCallback(hObject, eventdata, handles)
handles.P4_table.Data(:,1)=handles.P2_table2.Data(:,1);
