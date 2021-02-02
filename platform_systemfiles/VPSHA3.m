function varargout = VPSHA3(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VPSHA3_OpeningFcn, ...
    'gui_OutputFcn',  @VPSHA3_OutputFcn, ...
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

function VPSHA3_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
load icons_VPSHA.mat c
handles.ExitButton.CData = c{1};
handles.gridbutton.CData = c{2};
handles.undock.CData     = c{3};

handles.sys    = varargin{1};
handles.opt    = varargin{2};
handles.h      = varargin{3};

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
Nmodels = size(handles.sys.branch,1);
handles.popbranch.String = compose('Branch %i',1:Nmodels);
handles.popsource.String = [{'all sources'};handles.sys.labelG{1}];
handles.popsite.String   = handles.h.id;

if numel(handles.opt.IM)==2
    answer = inputdlg('Specify 3nd intensity measure','VPSHA',1,{'SA(T=1)'});
    if isempty(answer)
        close(handles.figure1)
        return
    end
    handles.opt.IM(3)=str2IM(answer);
end

handles.popIM1.String  = IM2str(handles.opt.IM); handles.popIM1.Value=1;
handles.popIM2.String  = IM2str(handles.opt.IM); handles.popIM2.Value=2;
handles.popIM3.String  = IM2str(handles.opt.IM); handles.popIM3.Value=3;

xlabel(handles.ax1,addIMunits(handles.opt.IM(1)),'fontsize',10)
ylabel(handles.ax1,addIMunits(handles.opt.IM(end)),'fontsize',10)
caxis([0 1])
C=colorbar('peer',handles.ax1,'location','eastoutside','tag','cbar');
set(get(C,'Title'),'String','MRE')

IM  = handles.opt.IM([handles.popIM1.Value,handles.popIM2.Value,handles.popIM3.Value]);
rho = eye(3,3);
defaultrho = eye(3);
for i=1:3
    for j=1:3
        r = corr_BCHhydro2016(IM(i),IM(j));
        if isnan(r)
            rho(i,j)=defaultrho(i,j);
        else
            rho(i,j)=corr_BCHhydro2016(IM(i),IM(j));
        end
    end
end
handles.methods = pshatoolbox_methods(4);
handles.popcorrelation.String = {'Manual',handles.methods(2:end).label};
handles.uitable1.Data=rho;
vals = num2cell(handles.opt.im(:,handles.popIM3.Value));
handles.im3level.String=vals;

akZoomTitle(handles.ax1)
guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = VPSHA3_OutputFcn(hObject, eventdata, handles)
varargout{1} = [];

function popIM1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
poprhoVPSHA3
guidata(hObject,handles);

function popIM2_Callback(hObject, eventdata, handles)
poprhoVPSHA3
guidata(hObject,handles);

function popIM3_Callback(hObject, eventdata, handles)
poprhoVPSHA3
vals = num2cell(handles.opt.im(:,handles.popIM3.Value));
handles.im3level.String=vals;
guidata(hObject,handles);

function runVPSHA3_Callback(hObject, eventdata, handles)

if rank(handles.uitable1.Data)<3
    errordlg('Correlation Matrix is singular to working precision. ')
    return
end

model_ptr  = handles.popbranch.Value;
source_ptr = handles.popsource.Value;
site_ptr   = handles.popsite.Value;
IM_ptr     = [handles.popIM1.Value;handles.popIM2.Value;handles.popIM3.Value];
branch     = handles.sys.branch;

if source_ptr ==1
    Nsource    = sum(handles.sys.Nsrc(:,branch(model_ptr,1)));
    source_ptr = 1:Nsource;
else
    source_ptr = source_ptr-1;
end

ncol    = size(handles.opt.im,2);
if ncol==1
    im      = repmat(handles.opt.im,1,3);
else
    im      = handles.opt.im(:,IM_ptr);
end

IM      = handles.opt.IM(IM_ptr);
h.id    = handles.h.id(site_ptr,:);
h.p     = handles.h.p(site_ptr,:);
h.param = handles.h.param;
h.value = handles.h.value(site_ptr,:);

opt        = handles.opt;
opt.method = handles.pop_method.Value;
sources    = buildmodelin(handles.sys,branch(model_ptr,:),handles.opt);
sources    = sources(source_ptr);
Nsource    = length(source_ptr);
rho        = handles.uitable1.Data;
tic
[handles.lambda,handles.MRE,handles.MRD] = runhazardV3(im,IM,h,opt,sources,Nsource,rho);
toc
handles.im3level.String=num2cell(im(:,3));
handles.im = im;
handles.IM = IM;
plotVPSHA(handles)
guidata(hObject,handles)

function popsite_Callback(hObject, eventdata, handles) %#ok<*INUSD>

function popbranch_Callback(hObject, eventdata, handles)

function popsource_Callback(hObject, eventdata, handles)

function rho_Callback(hObject, eventdata, handles)

function popcorrelation_Callback(hObject, eventdata, handles)
poprhoVPSHA3
guidata(hObject,handles);

function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
plotVPSHA(handles)

function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);

function File_Callback(hObject, eventdata, handles)

function Exit_Callback(hObject, eventdata, handles)
close(handles.figure1)

function Advanced_Callback(hObject, eventdata, handles)

function ptype1_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'off'
        hObject.Checked='on';
        handles.ptype2.Checked='off';
        handles.ptype3.Checked='off';
        plotVPSHA(handles)
end

function ptype2_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'off'
        hObject.Checked='on';
        handles.ptype1.Checked='off';
        handles.ptype3.Checked='off';
        plotVPSHA(handles)
end

function ptype3_Callback(hObject, eventdata, handles)
switch hObject.Checked
    case 'off'
        hObject.Checked='on';
        handles.ptype1.Checked='off';
        handles.ptype2.Checked='off';
        plotVPSHA(handles)
end

function ExitButton_Callback(hObject, eventdata, handles)
close(handles.figure1);

function gridbutton_Callback(hObject, eventdata, handles)

ax = handles.ax1;
switch [ax.XGrid,ax.XMinorGrid]
    case 'onon'  , ax.XGrid='on';  ax.YGrid='on';  ax.ZGrid='on';  ax.XMinorGrid='off'; ax.YMinorGrid='off'; ax.ZMinorGrid='off';
    case 'onoff' , ax.XGrid='off'; ax.YGrid='off'; ax.ZGrid='off'; ax.XMinorGrid='on';  ax.YMinorGrid='on';  ax.ZMinorGrid='on';
    case 'offon' , ax.XGrid='off'; ax.YGrid='off'; ax.ZGrid='off'; ax.XMinorGrid='off'; ax.YMinorGrid='off'; ax.ZMinorGrid='off';
    case 'offoff', ax.XGrid='on';  ax.YGrid='on';  ax.ZGrid='on';  ax.XMinorGrid='on';  ax.YMinorGrid='on';  ax.ZMinorGrid='on';
end

function undock_Callback(hObject, eventdata, handles)
figure2clipboard_uimenu(hObject, eventdata,handles.ax1)

function scalarhazard_Callback(hObject, eventdata, handles)

ch = findall(handles.ax1,'tag','pat2');
switch hObject.Checked
    case 'on' , hObject.Checked='off'; if ~isempty(ch),set(ch,'Visible','off'); end
    case 'off', hObject.Checked='on';  if ~isempty(ch),set(ch,'Visible','on');  end
end
guidata(hObject,handles)

function pop_method_Callback(hObject, eventdata, handles)

function im3level_Callback(hObject, eventdata, handles)
plotVPSHA(handles)

function pushbutton8_Callback(hObject, eventdata, handles)

 delete(findall(handles.ax1,'tag','pat'))
