function varargout = LIBS_DeaggMR(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @LIBS_DeaggMR_OpeningFcn, ...
    'gui_OutputFcn',  @LIBS_DeaggMR_OutputFcn, ...
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

function LIBS_DeaggMR_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
load icons_DispDeaggMR.mat c
handles.Exit_button.CData  = c{1};

handles.sys    = varargin{1};
handles.opt    = varargin{2};
handles.h      = varargin{3};
handles.T1     = varargin{4};
handles.T2     = varargin{5};
handles.T3     = varargin{6};
handles.optlib = varargin{7};
handles.setLIB = varargin{8};
handles.param = varargin{9};

[handles.branches,handles.IJK]=main_settle(handles.T1,handles.T2,handles.T3);

handles.Rbin  = createObj(15,handles);
handles.Mbin  = createObj(16,handles.sys);

handles.popreturn.String   = num2cell(createObj(18));
handles.popreturn.Value    = 1;

Nbranches = size(handles.IJK,1);
handles.menu_branch.String = compose('Branch %g',1:Nbranches);
handles.menu_branch.Value  = 1;
handles.menu_site.String   = handles.h.id;
handles.menu_site.Value    = 1;

handles = drawbars(handles);
xlabel(handles.ax,'LIBS(mm)');
ylabel(handles.ax,'MRE');
handles.bartitle.String='';
handles.bartitle2.String='';
akZoom(handles.ax)
rotate3d(handles.ax1)

plot(handles.ax,nan*[1 1],handles.ax.YLim,'-','tag','haz1');
plot(handles.ax,nan*[1 1],handles.ax.YLim,'.' ,'tag','haz2');
plot(handles.ax,nan*[1 1],handles.ax.YLim,'k:','tag','line');

guidata(hObject, handles);

function varargout = LIBS_DeaggMR_OutputFcn(hObject, eventdata, handles)
varargout{1} = [];

% -------- FILE MENU ------------------------------------------------------

function File_Callback(hObject, eventdata, handles)

function SaveChart_Callback(hObject, eventdata, handles)

if ~isfield(handles,'deagg2')
    return
end

[FileName,PathName] =  uiputfile('*.out','Save Hazard Deaggregation Analysis');
if isnumeric(FileName)
    return
end

fid      = fopen([PathName,FileName],'w');
fprintf(fid,'Hazard Deagregation\n');
fprintf(fid,'-------------------\n');

% lambda  = handles.lambda1;
% Sa      = handles.im1;
dchart  = handles.dchart;

Nperiods = size(dchart,3);
Mcenter  = mean(handles.Mbin,2);
Rcenter  = mean(handles.Rbin,2);
for i=1:Nperiods
    fprintf(fid,'return period %g\n',handles.returnperiod(i));
    fprintf(fid,'\n');
    data = [nan,     Mcenter';
        Rcenter,dchart(:,:,i)];
    strfmt1 = ['R(km) | Mw',repmat('%10.2g',1,size(data,2)-1),'\n'];
    strfmt2 = [repmat('%10.2g',1,size(data,2)),'\n'];
    fprintf(fid,strfmt1,data(1,2:end)');
    fprintf(fid,strfmt2,data(2:end,:)');
    fprintf(fid,'\n');
    
end
fclose(fid);
open([PathName,FileName])

function Exit_Callback(hObject, eventdata, handles)
close(handles.figure1)

function Exit_button_Callback(hObject, eventdata, handles)
close(handles.figure1)

% -------- EDIT MENU ------------------------------------------------------

function Edit_Callback(hObject, eventdata, handles)

% -------- PANNEL OPTIONS -------------------------------------------------

function popreturn_Callback(hObject, eventdata, handles)

function menu_branch_Callback(hObject, eventdata, handles)

function menu_site_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>

function handles = drawbars(handles,varargin)

switch nargin
    case 1
        Mwin      = 5.1:0.2:8.9;        NM = length(Mwin);
        Rwin      = linspace(0,600,10); NR = length(Rwin); dr = Rwin(2)-Rwin(1);
        handles.b=bar3(handles.ax1,Rwin,nan(NR,NM));
        set(handles.ax1,...
            'xtick',1:1:length(Mwin),...
            'xticklabel',Mwin,...
            'projection','perspective',...
            'fontsize',8,...
            'ylim',[0-dr/2,600+dr/2],...
            'zlim',[0 1])
    otherwise
end

function run_Callback(hObject, eventdata, handles)
home
deaggD  = runDeaggAnalysis(handles);
if isempty(deaggD)
    return
end
dchart  = DchartPSDA(deaggD,handles.Mbin,handles.Rbin);
Mcenter = mean(handles.Mbin,2);
Rcenter = mean(handles.Rbin,2);
rmin    = handles.Rbin(1);
rmax    = handles.Rbin(end);
handles.b=bar3(handles.ax1,Rcenter,dchart);

xlabel(handles.ax1,'Magnitude');
ylabel(handles.ax1,'R (km)');
zlabel(handles.ax1,'Settlement - Deagg')
set(handles.ax1,...
    'xtick',1:1:length(Mcenter),...
    'xticklabel',Mcenter,...
    'projection','perspective',...
    'fontsize',8,...
    'ylim',[rmin,rmax])
guidata(hObject,handles)

function deaggD = runDeaggAnalysis(handles)
% preparacion de calculos
d             = handles.optlib.sett(:);
Tr            = str2double(handles.popreturn.String{handles.popreturn.Value});
branch_ptr    = handles.menu_branch.Value;
site_ptr      = handles.menu_site.Value;
IND           = handles.IJK(branch_ptr,:);
handles.T1    = handles.T1(IND(1),:);
handles.T2    = handles.T2(IND(2),:);
handles.T3    = handles.T3(IND(3),:);
handles.IJK   = [1 1 1];
handles.h.p   = handles.h.p(site_ptr,:);
handles.param = handles.param(site_ptr);

% Run Seismic Hazard and Displacement Hazard
handles.haz = haz_LIBS(handles);
nQ = handles.optlib.nQ;
Q  = trlognpdf_psda([handles.param.Q nQ]);
Q  = Q(IND(2));
handles.param.Q(1)=Q;
handles.optlib.nQ=1;

handles     = runLIBS_regular2(handles);

lambdaD   = permute(handles.lambdaD,[2 3 1]);
geomptr   = handles.sys.branch(IND(1),1);
mechs     = handles.sys.mech{geomptr};
m1        = mechs==1;
m2        = mechs==2;
m3        = mechs==3;

lambdaD   = [sum(lambdaD,2,'omitnan'),sum(lambdaD(:,m1),2,'omitnan') sum(lambdaD(:,m2),2,'omitnan') sum(lambdaD(:,m3),2,'omitnan')];
NOTNAN    = (sum(lambdaD,1)>0);
lambdaD   = lambdaD(:,NOTNAN);
mechs     = {'total','interface','intraslab','crustal'};
str       = mechs(NOTNAN);

delete(findall(handles.ax,'type','line'))
handles.ax.XLimMode='auto';
handles.ax.YLimMode='auto';
handles.ax.ColorOrderIndex=1;
plot(handles.ax,d,lambdaD,'.-')
L=legend(handles.ax,str);L.Box='off';L.Location='SouthWest';
deaggD         = [];
lambdaD        = lambdaD(:,1);
if and(min(lambdaD)<=1/Tr,1/Tr<max(lambdaD))
    dtr        = robustinterp(lambdaD,d,1/Tr,'loglog');
    handles.d  = dtr;
    deaggD     = DeaggLIBS_regular(handles);
    
    meanM = deaggD(:,1)'*deaggD(:,3)/sum(deaggD(:,3));
    meanR = deaggD(:,2)'*deaggD(:,3)/sum(deaggD(:,3));
    
    handles.bartitle.String={sprintf('Mean M: %3.3g',meanM),sprintf('Mean R: %3.3g',meanR),sprintf('LIBS(%g yr)=%g mm',Tr,dtr)};
    
    XL = handles.ax.XLim; plot(handles.ax,XL,1/Tr*[1 1],'k--','handlevisibility','off')
    YL = handles.ax.YLim; plot(handles.ax,dtr*[1 1],YL,'k--','handlevisibility','off')
    plot(handles.ax,dtr,1/Tr,'b.','markersize',10,'handlevisibility','off')
    handles.ax.XLim=XL;
    handles.ax.YLim=YL;
else
    warndlg('Displacement Hazard Out of Bounds')
end

function Undockdeagg_Callback(hObject, eventdata, handles)

figure2clipboard_uimenu([],[],handles.ax1)

function lessM_Callback(hObject, eventdata, handles)
Xo = compose('%g',mean(handles.Mbin,2));
nX = size(handles.Mbin,1);
IND= find(~ismember(handles.ax1.XTickLabel,''));
Xn = repmat({''},nX,1);
n  = max(diff(IND))+1;
if ~isempty(n)
    for i=1:n:nX
        Xn{i}=Xo{i};
    end
    handles.ax1.XTickLabel=Xn;
end

function moreM_Callback(hObject, eventdata, handles)
Xo = compose('%g',mean(handles.Mbin,2));
nX = size(handles.Mbin,1);
IND= find(~ismember(handles.ax1.XTickLabel,''));
Xn = repmat({''},nX,1);
n  = max(max(diff(IND))-1,1);
for i=1:n:nX
    Xn{i}=Xo{i};
end
handles.ax1.XTickLabel=Xn;

function lessR_Callback(hObject, eventdata, handles)
Yo = compose('%g',mean(handles.Rbin,2));
nY = size(handles.Rbin,1);
IND= find(~ismember(handles.ax1.YTickLabel,''));
Yn = repmat({''},nY,1);
n  = max(diff(IND))+1;
if ~isempty(n)
    for i=1:n:nY
        Yn{i}=Yo{i};
    end
    handles.ax1.YTickLabel=Yn;
end

function moreR_Callback(hObject, eventdata, handles)
Yo = compose('%g',mean(handles.Rbin,2));
nY = size(handles.Rbin,1);
IND= find(~ismember(handles.ax1.YTickLabel,''));
Yn = repmat({''},nY,1);
n  = max(max(diff(IND))-1,1);
for i=1:n:nY
    Yn{i}=Yo{i};
end
handles.ax1.YTickLabel=Yn;
