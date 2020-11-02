function plotgmpe(handles)

%% housekeeping
marker='-';
if handles.HoldPlot.Value==0
    delete(findall(handles.ax1,'type','line'))
    handles.ax1.ColorOrderIndex=1;
else
    Nlines=length(findall(handles.ax1,'type','line'));
    if     and( 7<=Nlines,Nlines<13), marker='.-';
    elseif and(13<=Nlines,Nlines<19), marker='--';
    elseif Nlines>=19               , marker='.--';
    end
end

%% plot data
switch handles.plotgmpetype.Value
    case 1, plotgmpe1(handles,marker); %IM - T
    case 2, plotgmpe2(handles,marker); %IM/IM1100 - T
    case 3, plotgmpe3(handles,marker); %sigma - T
    case 4, plotgmpe4(handles,marker); %Rrup scaling
    case 5, plotgmpe5(handles,marker); %Mag  scaling
    case 6, plotgmpe6(handles,marker); %VS30 scaling
    case 7, plotgmpe7(handles)
        
end

%% updates legend
ch=findall(handles.figure1,'type','legend');
new_str = handles.GMPEselect.String{handles.GMPEselect.Value};

switch handles.HoldPlot.Value
    case 0
        delete(ch);
        if ~isempty(findall(handles.ax1,'type','line'))
            ch=legend(handles.ax1,new_str);
            ch.Box='off';
        end
    case 1
        ch.String{end}=new_str;
end

if ~isempty(findall(handles.ax1,'type','line'))
    switch handles.disp_legend.Value
        case 0, ch.Visible='off';
        case 1, ch.Visible='on';
    end
end


function click_on_curve(hObject,eventdata)

switch eventdata.Button
    case 3
        ax=hObject.Parent;
        ax.ColorOrderIndex=max(ax.ColorOrderIndex-1,1);
        delete(hObject)
    otherwise
end

function plotgmpe1(handles,marker) % Sa - T
epsilon = handles.epsilon;
Neps    = length(epsilon);
param   = mGMPEgetparam(handles);
IM      = real(handles.IM);
LB      = imag(handles.IM);

IM = [0.01,0.02,0.03,0.04,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,3.55,4,5];
LB = IM*0;

LB      = LB(IM>=0);
IM      = IM(IM>=0);

uLB = unique(LB);
if isempty(LB)
    return
end

if length(uLB)>1
    str0 = {'SA(T)','SV(T)','SD(T)','H/V(T)'};
    str0 = str0(uLB+1);
    [indx,tf] = listdlg('ListString',str0,'SelectionMode','single');
    if tf==0
        uLB=uLB(1);
    else
        uLB=uLB(indx);
    end
end

switch uLB
    case 0, YLABEL = 'SA(g)';    IM = IM(LB==0); LB = LB(LB==0);
    case 1, YLABEL = 'SV(cm/s)'; IM = IM(LB==1); LB = LB(LB==1);
    case 2, YLABEL = 'SD(cm)';   IM = IM(LB==2); LB = LB(LB==2);
    case 3, YLABEL = 'V/H';      IM = IM(LB==3); LB = LB(LB==3);
end

Sa        = nan(Neps,length(IM)+1);
for i=1:length(IM)
    To = IM(i)+LB(i)*1i;
    [lny,sigma] = handles.fun(To,param{:});
    for j=1:Neps
        Sa(j,i) = exp(lny+epsilon(j)*sigma);
    end
end

x  = repmat([IM,nan],1,Neps);
Sa = Sa';
y  = Sa(:)';
plot(handles.ax1,x,y,marker,'tag','curves','ButtonDownFcn',@click_on_curve,'linewidth',1);
handles.xlabel=xlabel(handles.ax1,'T(s)','fontsize',10);
handles.ylabel=ylabel(handles.ax1,YLABEL,'fontsize',10);

function plotgmpe2(handles,marker) % Sa/Sa1100 - T

epsilon = handles.epsilon;
Neps    = length(epsilon);
param   = mGMPEgetparam(handles);

IND  = mGMPEplotVS30(func2str(handles.fun));
IND  = find(IND==0.5);
paramrock = param;
if ~isempty(IND)
    paramrock{IND}=1100;
end

IM      = real(handles.IM);
LB      = imag(handles.IM);
LB      = LB(IM>=0);
IM      = IM(IM>=0);

uLB = unique(LB);
if isempty(LB)
    return
end

if length(uLB)>1
    str0 = {'SA(T)','SV(T)','SD(T)','H/V(T)'};
    str0 = str0(uLB+1);
    [indx,tf] = listdlg('ListString',str0,'SelectionMode','single');
    if tf==0
        uLB=uLB(1);
    else
        uLB=uLB(indx);
    end
end

switch uLB
    case 0, YLABEL = 'SA/SA1100';       IM = IM(LB==0); LB = LB(LB==0);
    case 1, YLABEL = 'SV/SV1100';       IM = IM(LB==1); LB = LB(LB==1);
    case 2, YLABEL = 'SD/SD1100';       IM = IM(LB==2); LB = LB(LB==2);
    case 3, YLABEL = '(V/H)/(V/H)1100'; IM = IM(LB==3); LB = LB(LB==3);
end

sarat  = nan(1,length(IM)+1);
for i=1:length(IM)
    To = IM(i)+LB(i)*1i;
    [lny ,sigma]  = handles.fun(To,param{:});
    [lnyR,sigmaR] = handles.fun(To,paramrock{:});
    
    for j=1:Neps
        sarat(j,i) = exp(lny+epsilon(j)*sigma)/exp(lnyR+epsilon(j)*sigmaR);
    end
end

x     = repmat([IM,nan],1,Neps);
sarat = sarat';
y     = sarat(:)';
plot(handles.ax1,x,y,marker,'tag','curves','ButtonDownFcn',@click_on_curve,'linewidth',1);
handles.xlabel=xlabel(handles.ax1,'T(s)','fontsize',10);
handles.ylabel=ylabel(handles.ax1,YLABEL,'fontsize',10);

function plotgmpe3(handles,marker) % sigma - T

param   = mGMPEgetparam(handles);
IM      = real(handles.IM);
LB      = imag(handles.IM);
LB      = LB(IM>=0);
IM      = IM(IM>=0);
if isempty(LB)
    return
end
uLB = unique(LB);

if length(uLB)>1
    str0 = {'SA(T)','SV(T)','SD(T)','H/V(T)'};
    str0 = str0(uLB+1);
    [indx,tf] = listdlg('ListString',str0,'SelectionMode','single');
    if tf==0
        uLB=uLB(1);
    else
        uLB=uLB(indx);
    end
end

switch uLB
    case 0, YLABEL = '\sigma_{lnSA}';    IM = IM(LB==0); LB = LB(LB==0);
    case 1, YLABEL = '\sigma_{lnSV}';    IM = IM(LB==1); LB = LB(LB==1);
    case 2, YLABEL = '\sigma_{lnSD}';    IM = IM(LB==2); LB = LB(LB==2);
    case 3, YLABEL = '\sigma_{lnV/H}';   IM = IM(LB==3); LB = LB(LB==3);
end

sigma  = nan(1,length(IM)+1);
for i=1:length(IM)
    To = IM(i)+LB(i)*1i;
    [~,sigma(i)] = handles.fun(To,param{:});
end

x = [IM,nan];
plot(handles.ax1,x,sigma,marker,'tag','curves','ButtonDownFcn',@click_on_curve,'linewidth',1);
handles.xlabel=xlabel(handles.ax1,'T(s)','fontsize',10);
handles.ylabel=ylabel(handles.ax1,YLABEL,'fontsize',10);

function plotgmpe4(handles,marker) % Rrup scaling
epsilon = handles.epsilon;
Neps    = length(epsilon);
param   = mGMPEgetparam(handles);
imptr   = handles.targetIM.Value;
[Rrup,param2] = mGMPErrupLoop(handles.fun,param,handles.SUB,handles.SC);
if isempty(param2)
    Sa = nan(length(Rrup)+1,Neps);
else
    IM     = handles.IM(imptr);
    [lny,sigma] = handles.fun(IM,param2{:});
    Sa = nan(length(lny)+1,Neps);
    for i=1:Neps
        Sa(1:end-1,i) = exp(lny+epsilon(i)*sigma);
    end
end

x = repmat([Rrup;nan],Neps,1);
y = Sa(:);
plot(handles.ax1,x,y,marker,'tag','curves','ButtonDownFcn',@click_on_curve,'linewidth',1);
xlabel(handles.ax1,'Rrup(km)','fontsize',10);
ylabel(handles.ax1,addIMunits(IM),'fontsize',10);

function plotgmpe5(handles,marker) % Mag Scaling

imptr   = handles.targetIM.Value;
epsilon = handles.epsilon;
Neps    = length(epsilon);
param   = mGMPEgetparam(handles);
IM      = real(handles.IM); IM = IM(imptr);
LB      = imag(handles.IM); LB = LB(imptr);
uLB     = LB;

switch uLB
    case 0, YLABEL = 'SA(g)';    IM = IM(LB==0); LB = LB(LB==0);
    case 1, YLABEL = 'SV(cm/s)'; IM = IM(LB==1); LB = LB(LB==1);
    case 2, YLABEL = 'SD(cm)';   IM = IM(LB==2); LB = LB(LB==2);
    case 3, YLABEL = 'V/H';      IM = IM(LB==3); LB = LB(LB==3);
end

m  = 3:0.05:9;
nM = length(m);
Sa = nan(Neps,nM+1);
To = IM+1j*LB;
for i=1:nM
    param{1}=m(i);
    [lny,sigma] = handles.fun(To,param{:});
    for j=1:Neps
        Sa(j,i) = exp(lny+epsilon(j)*sigma);
    end
end

x  = repmat([m,nan],1,Neps);
Sa = Sa';
y  = Sa(:)';
plot(handles.ax1,x,y,marker,'tag','curves','ButtonDownFcn',@click_on_curve,'linewidth',1);
handles.xlabel=xlabel(handles.ax1,'magntiude','fontsize',10);
handles.ylabel=ylabel(handles.ax1,YLABEL,'fontsize',10);

function plotgmpe6(handles,marker) % Sa/Sa1100 - VS30

imptr   = handles.targetIM.Value;
epsilon = handles.epsilon;
Neps    = length(epsilon);
param   = mGMPEgetparam(handles);
IM      = real(handles.IM); IM = IM(imptr);
LB      = imag(handles.IM); LB = LB(imptr);
uLB     = LB;

switch uLB
    case 0, YLABEL = 'SA/SA1100';        IM = IM(LB==0); LB = LB(LB==0);
    case 1, YLABEL = 'SV/SV1100';        IM = IM(LB==1); LB = LB(LB==1);
    case 2, YLABEL = 'SD/SD1100';        IM = IM(LB==2); LB = LB(LB==2);
    case 3, YLABEL = '(V/H)/(V/H)1100';  IM = IM(LB==3); LB = LB(LB==3);
end

tol  = [-1e-3 0 1e-3];
VS30 = [100:10:1000 180+tol 200+tol 300+tol 360+tol  600+tol 750+tol 760+tol 800+tol 1000+tol 1100];
VS30 = unique(sort(VS30));
nVs  = length(VS30);
Sa   = nan(Neps,nVs+1);
To   = IM+1j*LB;
IND  = mGMPEplotVS30(func2str(handles.fun));
IND  = find(IND==0.5);
for i=1:nVs
    if ~isempty(IND)
        param{IND}=VS30(i);
    end
    [lny,sigma] = handles.fun(To,param{:});
    for j=1:Neps
        Sa(j,i) = exp(lny+epsilon(j)*sigma);
    end
end

x  = repmat([VS30,nan],1,Neps);
Sa = (Sa./Sa(:,end-1))';
y  = Sa(:)';
plot(handles.ax1,x,y,marker,'tag','curves','ButtonDownFcn',@click_on_curve,'linewidth',1);
handles.xlabel=xlabel(handles.ax1,'VS30(m/s)','fontsize',10);
handles.ylabel=ylabel(handles.ax1,YLABEL,'fontsize',10);

function plotgmpe7(handles)
handles.ax1.XTickMode='auto';
handles.ax1.YTickMode='auto';
handles.AutoScale.Value=0;
ptr      = handles.targetIM.Value;
folder   = handles.path2figures(ptr).folder;
filename = handles.path2figures(ptr).name;
I        = imshow(fullfile(folder,filename),'parent',handles.ax2,'XData',[0 10],'YData',[0 10]);
AD       = handles.ImageAlpha;
set(I,'AlphaData',AD,'tag','image');

ch = get(handles.panel2,'children');
set(ch(handles.text),'Visible','off')
set(ch(handles.edit),'Visible','off','Style','edit');
str = regexp(filename,'\_','split');
str = str{1};
fun=str2func(['GMMValidation_',str]);
handles.ax1.ColorOrderIndex=1;
fun(handles,filename);
