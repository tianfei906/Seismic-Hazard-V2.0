function varargout = UHS(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UHS_OpeningFcn, ...
    'gui_OutputFcn',  @UHS_OutputFcn, ...
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

function UHS_OpeningFcn(hObject, eventdata, handles, varargin)
load icons_UHS.mat c jp
handles.clear_analysis.CData = c{1};
handles.Engine.CData         = c{2};
handles.Exit_button.CData    = c{3};
handles.ax1Limits.CData      = c{4};
handles.compute_uhs.CData    = c{5};
handles.undock.CData         = c{6};


handles.sys       = varargin{1};
handles.opt       = varargin{2};
handles.h         = varargin{3};
handles.opt.SourceDeagg='off';

% ------------ REMOVES PCE MODELS (AT LEAST FOR NOW) ----------------------
isREG = handles.sys.isREG;
[~,B]=setdiff(handles.sys.branch(:,2),isREG);
if ~isempty(B)
    handles.sys.branch(B,:)=[];
    handles.sys.weight(B,:)=[];
    handles.sys.weight(:,5)=handles.sys.weight(:,5)/sum(handles.sys.weight(:,5));
    warndlg('PCE Models removed from logic tree. Logic Tree weights were normalized')
    uiwait
end
% -------------------------------------------------------------------------

set(handles.select_site,'string',handles.h.id);
handles.figure1.Name=[handles.sys.filename, ' - Uniform Hazard Spectrum'];

Tmax = [];
gptr = unique(unique(handles.sys.gmmptr(:)))';
for i=gptr
    Tmax = [Tmax;max(handles.sys.gmmlib(i).T)]; %#ok<AGROW>
end
Tmax  = min(Tmax);
handles.Tmax = Tmax;
tlist = unique([0.01:0.01:0.1,0.1:0.1:1,1:1:10,Tmax]);
tlist(tlist>Tmax)=[];
handles.defaultperiods = tlist;
handles.Tlist.String = num2cell(tlist);

Nbranch = size(handles.sys.branch,1);
handles.param=[1 0 0 50 1 Nbranch 1 1];
guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = UHS_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
varargout{1} = [];

% delete(handles.figure1)

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% if isequal(get(hObject,'waitstatus'),'waiting')
%     uiresume(hObject);
% else
%     delete(hObject);
% end
delete(hObject);

function select_site_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
if isfield(handles,'UHS') 
    handles=rmfield(handles,{'UHS','lambda'});
    delete(findall(handles.ax1,'type','line'))
end
guidata(hObject, handles);

function select_site_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function compute_uhs_Callback(hObject, eventdata, handles)

handles.opt.IM  = sort(str2double(handles.Tlist.String));
val     = handles.select_site.Value;
if ~isfield(handles,'lambda')
    [handles.im,handles.lambda]  = runUHS(handles.sys,handles.opt,handles.h,val);
end
hazlevel  = 1./str2double(handles.ReturnPeriod.String);
[~,~,NIM,Nbranches] = size(handles.lambda);
handles.UHS = zeros(NIM,Nbranches);
set(handles.figure1,'Pointer','watch');
for j=1:Nbranches
    lij = permute(handles.lambda(1,:,:,j),[2,3,1]);
    uhs = uhspectrum(handles.im,lij,hazlevel);
    handles.UHS(:,j) = uhs;
end

set(handles.figure1,'Pointer','arrow');
plot_UHS_spec(handles)
guidata(hObject, handles);

function plot_UHS_spec(handles)
if ~isfield(handles,'UHS')
    return
end
param    = handles.param;
uhs      = handles.UHS;
% delete(findall(handles.ax1,'tag','uhs'))
mod1     = param(8);

if mod1
    switch param(5)
        case 1
            Ny = size(uhs,2);
            c1 = [0.7660    0.6740    0.1880];
            c2 = [0.3010    0.7450    0.9330];
            handles.ax1.ColorOrder= [linspace(c1(1),c2(1),Ny)',linspace(c1(2),c2(2),Ny)',linspace(c1(3),c2(3),Ny)'];
            plot(handles.ax1,handles.opt.IM,uhs,'-','tag','uhs');
        case 0
    end
    
    % mean UHS
    if param(1)==1
        weight = handles.sys.weight(:,5)';
        uhsm   = prod(bsxfun(@power,uhs,weight),2);
        legstr = 'Default Weights';
    elseif param(2)==1
        weight = rand(size(handles.sys.branch(:,1)'));
        weight = weight/sum(weight);
        uhsm   = prod(bsxfun(@power,uhs,weight),2);
        legstr = 'Random Weights';
    elseif param(3)==1
        per = param(4);
        uhsm  = prctile(uhs,per,2);
        legstr = sprintf('Percentile %g',per);
    end
    plot(handles.ax1,handles.opt.IM,uhsm,'-','color',[0 0.447 0.741],'linewidth',2,'tag','uhs');
    xlabel('Period (s)')
    ylabel('Sa (g)')
    
    switch param(5)
        case 1
            Nbranch = size(handles.sys.branch,1);
            LL=legend([compose('Branch%i',1:Nbranch),legstr]); LL.Box='off';
        case 0
            LL=legend(legstr); LL.Box='off';
    end
end

if ~mod1
    val = param(7);
    plot(handles.ax1,handles.opt.IM,uhs(:,val),'-','color',[0 0.447 0.741],'linewidth',2,'tag','uhs');
    LL=legend(sprintf('Branch %g',val)); LL.Box='off';
end
% uicontext
cF=get(0,'format');
format long g
if mod1
    num = [handles.opt.IM(:),[uhs,uhsm]];
else
    num = [handles.opt.IM(:),uhs(:,val)];
end
data = num2cell(num);
c = uicontextmenu;
uimenu(c,'Label','Copy data','Callback'          ,{@data2clipboard_uimenu,data});
set(handles.ax1,'uicontextmenu',c);
format(cF);

function edit_hazard_level_CellEditCallback(hObject, eventdata, handles)

data=get(hObject,'data');
for i=1:numel(data)
    if isempty(data{i}) || isnan(data{i})
        data{i}=[];
    end
end
f = size(data,1);
for i=1:f
    if data{i,1}<=0 , data{i,1}=[];end
    if data{i,1}>100, data{i,1}=[];end
    if data{i,2}<=0 , data{i,2}=[];end
    data{i,3}=[];
    
end

data0=data;
for i=1:numel(data0)
    if isempty(data0{i}) || isnan(data0{i})
        data0{i}=0;
    end
end
data0 = cell2mat(data0);

% number of entered rows
ind = find(prod(data0(:,1:2),2));

if isempty(ind)
    set(hObject,'data',data);
    set(handles.compute_uhs,'enable','off')
    return
end


for i=1:length(ind)
    prob = data0(ind(i),1)/100;
    twin = data0(ind(i),2);
    data{ind(i),3}= -twin/log(1-prob);
end

set(hObject,'data',data);
Nsite = size(handles.h.p,1);
if Nsite>0 && isfield(handles,'model') && ~isempty(cell2mat(data(:,3)))
    set(handles.compute_uhs,'enable','on');
end

guidata(hObject, handles);

function File_Callback(hObject, eventdata, handles)

function Options_Callback(hObject, eventdata, handles)

function SetDefault_Callback(hObject, eventdata, handles)

handles.edit_hazard_level.Data= {10,50,-50/log(1-10/100)};
data = handles.edit_hazard_level.Data;
Nsite = size(handles.h.p,1);
if Nsite>0 && isfield(handles,'model') && ~isempty(cell2mat(data(:,3)))
    handles.compute_uhs.Enable='on';
end

guidata(hObject, handles);

function handles = axscale_uimenu(source,callbackdata,handles)

str = get(source,'Label');
switch str
    case 'linear'   , set(gca,'xscale','linear' ,'yscale','linear'),
    case 'loglog'   , set(gca,'xscale','log'    ,'yscale','log')
    case 'semilogx' , set(gca,'xscale','log'    ,'yscale','linear'),
    case 'semilogy' , set(gca,'xscale','linear' ,'yscale','log'),
end

function Exit_Callback(hObject, eventdata, handles)

close(handles.figure1)

function Exit_button_Callback(hObject, eventdata, handles)
close(handles.figure1)

function Tlist_Callback(hObject, eventdata, handles)

Tlist = strtrim(handles.Tlist.String);

if length(Tlist)==1
    Tlist = eval(Tlist{1});
    Tlist = Tlist(:);
else
    Tlist = unique(str2double(Tlist));
end
Tlist(Tlist>handles.Tmax)=[];
handles.Tlist.String=num2cell(Tlist);
if isfield(handles,'lambda')
    handles=rmfield(handles,'lambda');
end
guidata(hObject,handles)

function Tlist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ReturnPeriod_Callback(hObject, eventdata, handles)

function ReturnPeriod_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clear_analysis_Callback(hObject, eventdata, handles)

delete(findall(handles.ax1,'tag','uhs'))
if isfield(handles,'UHS')
    handles=rmfield(handles,{'UHS'});
end
guidata(hObject,handles);

% --- Executes on button press in ax1Limits.
function ax1Limits_Callback(hObject, eventdata, handles)
handles.ax1=ax2Control(handles.ax1);

function restoredefaultperiods_Callback(hObject, eventdata, handles)

handles.Tlist.String=num2cell(handles.defaultperiods);
guidata(hObject,handles)

function Engine_Callback(hObject, eventdata, handles)

handles.param = UHSOptions(handles.param);
plot_UHS_spec(handles);
guidata(hObject,handles)

function undock_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax1)
