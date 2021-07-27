function[handles]= populate_sheditor(handles)

set(handles.P1 ,'Visible','on')
set(handles.P2 ,'Visible','on')
set(handles.P3 ,'Visible','on')
set(handles.P4 ,'Visible','on')
set(handles.P5 ,'Visible','on')
set(handles.P6 ,'Visible','on')
set(handles.P8 ,'Visible','on')
set(handles.P9 ,'Visible','on')
set(handles.P10,'Visible','on')
set(handles.P11,'Visible','on')
handles.tab0 .ForegroundColor=[0 0 1];
handles.tab1 .ForegroundColor=[0 0 1];
handles.tab2 .ForegroundColor=[0 0 1];
handles.tab3 .ForegroundColor=[0 0 1];
handles.tab4 .ForegroundColor=[0 0 1];
handles.tab5 .ForegroundColor=[0 0 1];
handles.tab6 .ForegroundColor=[0 0 1];
handles.tab8 .ForegroundColor=[0 0 1];
handles.tab9 .ForegroundColor=[0 0 1];
handles.tab10.ForegroundColor=[0 0 1];
handles.tab11.ForegroundColor=[0 0 1];

sys = handles.sys;
opt = handles.opt;
h   = handles.h;

handles.P10_table.Data  = cell(0,6);
handles.P10_table2.Data = cell(0,6);
handles.P1_IS2.Enable='off';
handles.P1_GP2.Enable='off';
handles.P1_UNI2.Enable='off';
handles.P1_sigmaOW2.Enable='off';
handles.P1_sigmaTR2.Enable='off';

%% Fills Real-Values
[~,handles.P1_projection.Value]=intersect({'ecef','wgs84','sphere'},lower(opt.Projection));
handles.P1_image.String=opt.Image;
handles.P1_boundary.String=opt.Boundary;
handles.P1_shermodulus.String=opt.ShearModulus;
handles.P1_maxdist.String=opt.maxdist;
handles.P1_SourceDeagg.Value=opt.SourceDeagg;
handles.P1_clusters1.Value   =opt.Clusters(1);
handles.P1_clusters2.String  =opt.Clusters(2);

switch handles.P1_clusters1.Value
    case 0,handles.P1_clusters2.Enable='off';
    case 1,handles.P1_clusters2.Enable='on';
end

switch opt.msample(1)
    case 1, handles.P1_IS1.Value  = true; handles.P1_IS2.Value   = opt.msample(2); handles.P1_IS2.Enable='on';
    case 2, handles.P1_GP1.Value  = true; handles.P1_GP2.Value   = opt.msample(2); handles.P1_GP2.Enable='on';
    case 3, handles.P1_UNI1.Value = true; handles.P1_UNI2.String = opt.msample(2); handles.P1_UNI2.Enable='on';
end

switch opt.strunc(1)
    case 0, handles.P1_sigma1.Value=true;
    case 1, handles.P1_sigmaOW1.Value=true; handles.P1_sigmaOW2.String=opt.strunc(3);           handles.P1_sigmaOW2.Enable='on';
    case 2, handles.P1_sigmaTR1.Value=true; handles.P1_sigmaTR2.String=-norminv(opt.strunc(4)); handles.P1_sigmaTR2.Enable='on';
end

handles.P1_rad1.Value=strcmp(opt.PCE{2},'PC');
handles.P1_rad2.Value=strcmp(opt.PCE{2},'MC');
handles.P1_PCErealizations.String=opt.PCE{3};
handles.P1_dsha1.String=IM2str(opt.IM1);
handles.P1_dsha2.String=IM2str(opt.IM2);
fun = func2str(opt.Spatial);
if contains(fun,'none_spatial')
    handles.P1_dsha3.Value=1;
else
    me  = pshatoolbox_methods(3);
    str = {me.str}';
    [~,handles.P1_dsha3.Value]=intersect(str,fun);
end

fun = func2str(opt.Spectral);
if contains(fun,'corr_none')
    handles.P1_dsha4.Value=1;
else
    me  = pshatoolbox_methods(4);
    str = {me.str}';
    [~,handles.P1_dsha4.Value]=intersect(str,fun);
end

handles.P1_IM.String=IM2str(opt.IM);
handles.P1_imtable.ColumnName=handles.P1_IM.String;
handles.P1_NSamples.String=size(opt.im,1);
NIM = numel(opt.IM);
switch opt.immode
    case 1
        handles.radiobutton11.Value=1;
        handles.P1_imtable.ColumnEditable=false(1,NIM);
        handles.P1_imtable.Data=num2cell(opt.im);
        handles.P1_imtable.BackgroundColor=[1 1 1;0.94 0.94 0.94];
        handles.P1_imtable.RowName='numbered';
    case 2
        handles.radiobutton12.Value=1;
        handles.P1_imtable.ColumnEditable=true(1,NIM);
        handles.P1_imtable.Data=num2cell(opt.im([1,end],:));
        handles.P1_imtable.BackgroundColor=[1 1 0.7];
        handles.P1_imtable.RowName={'Min','Max'};
    case 3
        handles.radiobutton13.Value=1;
        handles.P1_imtable.ColumnEditable=true(1,NIM);
        handles.P1_imtable.Data=num2cell(opt.im);
        handles.P1_imtable.BackgroundColor=[1 1 0.7];
        handles.P1_imtable.RowName='numbered';
end

%% Logic Tree
[W1,ind1]=unique([sys.branch(:,1),sys.weight(:,1)],'rows','stable');
[W2,ind2]=unique([sys.branch(:,2),sys.weight(:,2)],'rows','stable');
[W3,ind3]=unique([sys.branch(:,3),sys.weight(:,3)],'rows','stable');
handles.P2_table1.Data=[sys.brnames(ind1,1),num2cell(W1(:,2))];
handles.P2_table2.Data=[sys.brnames(ind2,2),num2cell(W2(:,2))];
handles.P2_table3.Data=[sys.brnames(ind3,3),num2cell(W3(:,2))];
Nbranch = size(sys.branch,1);
handles.P2_table4.Data=[compose('Branch %g',1:Nbranch)',num2cell(sys.branch(:,1:3)),num2cell(sys.weight(:,5))];
plotPSHALogicTree(handles)

%% Sources
handles.po_region.Value =1;
handles.po_region.String=handles.P2_table1.Data(:,1);
handles.P3_table.Data=sh_fillP3Table(handles,1);
sh_updatemap
sh_updatecolorbar
handles.P3_tableindex=1;

sh_viewSource(handles.sys,handles.P3_vertices,handles.P3_str,handles.P3_edi,1,1)

%% GMM Library
handles.P4_list.Value = 1;
handles.P4_list.String={sys.gmmlib.label};
str = {sys.gmmlib.label};
str = str(:);
if size(sys.gmmptr,2)>1
    str = str(:)';
end
handles.P4_table.Data=[handles.P2_table2.Data(:,1),str(sys.gmmptr)];
Ngroups=size(sys.gmmptr,2);
handles.P4_table.ColumnFormat{1}='char';
for i=1:Ngroups
    handles.P4_table.ColumnFormat{i+1}=str(:)';
end

handles.P4_table.ColumnName=['Group ID',compose('Type %g',1:Ngroups)];
handles.P4_table.ColumnEditable=[false,true(1,Ngroups)];
sh_viewGMM(handles.sys.gmmlib,handles.sys.gmmlib(1),handles.P4_str,handles.P4_edi)

%% M-R relations
handles.P5_pop1.Value=1;
handles.P5_pop1.String=handles.P2_table3.Data(:,1);
handles.P5_list.String = vertcat(handles.sys.labelG{:});
handles.P5_table.Data  = handles.sys.catlib;
sh_viewMscl(handles,1)

%% SITES
handles.P6_table.Data=[h.id,num2cell([h.p,h.value])];
handles.P6_table.ColumnName=['ID','Lon','Lat','Depth',h.param];
fld = fields(handles.sys.layer);
handles.P6_poplayers.String=fld;
handles.P6_layerlist.String=handles.sys.layer.(fld{1});

%% Validation Examples
if ~isempty(handles.sys.validation)
    handles.P8_table.Data=handles.sys.validation;
    handles.P8_table.RowName=handles.sys.validation_legend;
else
    handles.P8_table.Data=[];
    handles.P8_table.RowName='numbered';
end

%% Events
handles.P9_table.Data=handles.sys.event;

%% PSDA
ME=pshatoolbox_methods(5);
[d,Sadef,Ddef,smlib,T3_def]=loadPSDADefaultParam(ME,'editor');
if ~isempty(handles.sys.txtPSDA)
    ptrs   = handles.sys.ptrs(11:15,:);
    ptrs   = ptrs-ptrs(1)+1;
    % options
    txt =handles.sys.txtPSDA(ptrs(1,1):ptrs(1,2));
    txt = regexp(txt,'\: ','split');
    txt = vertcat(txt{:});
    
    T = eval(txt{1,2});
    handles.P10_Dmin.String=T(1);
    handles.P10_Dmax.String=T(end);
    handles.P10_Nsta.String=numel(T);
    handles.P10_ky.String=txt{6,2};
    handles.P10_Ts.String=txt{7,2};
    handles.P10_realSa.String=txt{2,2};
    handles.P10_realD.String =txt{3,2};
    
    % smlib
    txt =handles.sys.txtPSDA(ptrs(2,1):ptrs(2,2));
    txt = regexp(txt,'\ ','split');
    clear smlib
    smlib(1:numel(txt),1) = struct('label',[],'formulation',[],'param',[]);
    for j=1:numel(txt)
        smlib(j).label=txt{j}{2};
        smlib(j).formulation=txt{j}{3};
        if numel(txt{j})>3
            smlib(j).param=txt{j}(4:end);
        end
    end
    handles.P10_list.Value=1;
    handles.P10_list.String={smlib.label};
    handles.smlib=smlib;
    sh_fillPSDA(handles,1)
    ch=handles.P10.Children;
    set(ch,'Enable','on');
    handles.P10_Enable.Enable='on';
    handles.P10_Enable.Value =1;
    
    % uncertainty through logic tree 
    if ~isnan(ptrs(3,1))
        T3 =handles.sys.txtPSDA(ptrs(3,1):ptrs(3,2));
        T3 = regexp(T3,'\ ','split');
        T3 = vertcat(T3{:});
        w   = str2double(T3(:,6));
        T3(:,6)=num2cell(w/sum(w));
        handles.P10_table.Data=T3;
    end
    handles.P10_table.ColumnFormat{:,2}={smlib.label};
    handles.P10_table.ColumnFormat{:,3}={smlib.label};
    handles.P10_table.ColumnFormat{:,4}={smlib.label};
    handles.P10_table.ColumnFormat{:,5}={smlib.label};
    
    % uncertanty through polynomial chaos
    if ~isnan(ptrs(4,1))
        T3 =handles.sys.txtPSDA(ptrs(4,1):ptrs(4,2));
        T3 = regexp(T3,'\ ','split');
        T3 = vertcat(T3{:});
        T3(:,2)=[];
        T3red = T3(:,[1 2 5:8]);
        for i=1:size(T3,1)
            T3red{i,2}=strjoin(T3(i,2:4),',');
        end
        handles.P10_table2.Data=T3red;
    end
    handles.P10_table2.ColumnFormat{:,2}={smlib.label};
    handles.P10_table2.ColumnFormat{:,3}={smlib.label};
    handles.P10_table2.ColumnFormat{:,4}={smlib.label};
    handles.P10_table2.ColumnFormat{:,5}={smlib.label};    
    
    
else
       
    handles.P10_Dmin.String   = d(1);
    handles.P10_Dmax.String   = d(end);
    handles.P10_Nsta.String   = numel(d);
    handles.P10_ky.String     = 1;
    handles.P10_Ts.String     = 1;
    handles.P10_realSa.String = Sadef;
    handles.P10_realD.String  = Ddef;
    handles.P10_list.Value    = 1;
    handles.P10_list.String   = {smlib.label};
    handles.smlib             = smlib;
    handles.P10_e1.String = smlib(1).label;
    handles.P10_e2.Value  = 1;
    
    handles.P10_t3.Visible = 'off';
    handles.P10_t4.Visible = 'off';
    handles.P10_t5.Visible = 'off';
    handles.P10_t6.Visible = 'off';
    handles.P10_t7.Visible = 'off';
    handles.P10_e3.Visible = 'off';
    handles.P10_e4.Visible = 'off';
    handles.P10_e5.Visible = 'off';
    handles.P10_e6.Visible = 'off';
    handles.P10_e7.Visible = 'off';    
    
    handles.P10_table.Data=T3_def;
    handles.P10_table.ColumnFormat{:,2}={smlib.label};
    handles.P10_table.ColumnFormat{:,3}={smlib.label};
    handles.P10_table.ColumnFormat{:,4}={smlib.label};
    handles.P10_table.ColumnFormat{:,5}={smlib.label};    
    
    
    
    ch=handles.P10.Children;
    set(ch,'Enable','off');
    handles.P10_Enable.Enable='on';
    handles.P10_Enable.Value =0;
    
end

%% LIBS

if ~isempty(handles.sys.txtLIBS)
    ptrs   = handles.sys.ptrs(16:19,:);
    ptrs   = ptrs-ptrs(1)+1;
    % options
    txt =handles.sys.txtLIBS(ptrs(1,1):ptrs(1,2));
    txt = regexp(txt,'\: ','split');
    txt = vertcat(txt{:});
    
    T = eval(txt{2,2});
    handles.P11_Smin.String=T(1);
    handles.P11_Smax.String=T(end);
    handles.P11_Nsta.String=numel(T);
    handles.P11_Qsamples.String=txt{4,2};
    [~,handles.P11_corrmodel.Value]=intersect(handles.P11_corrmodel.String,txt{5,2});
    
    % cpt logs
    txt = handles.sys.txtLIBS(ptrs(2,1):ptrs(2,2));
    txt = regexp(txt,'\ ','split');
    D   = cell(numel(txt),2);
    for i=1:numel(txt)
        D{i,1}=txt{i}{1};
        D{i,2}=txt{i}{2};
    end
    handles.P11_CPT.Data = D;
    
    % setlib
    txt =handles.sys.txtLIBS(ptrs(3,1):ptrs(3,2));
    txt = regexp(txt,'\ ','split');
    clear setlib
    setlib(1:numel(txt),1) = struct('label',[],'formulation',[]);
    for j=1:numel(txt)
        setlib(j).label=txt{j}{2};
        setlib(j).formulation=txt{j}{3};
    end
    handles.P11_list.Value=1;
    handles.P11_list.String={setlib.label};
    handles.setlib=setlib;
    sh_fillLIBS(handles,1)
    ch=handles.P11.Children;
    set(ch,'Enable','on');
    handles.P11_Enable.Enable='on';
    handles.P11_Enable.Value =1;
    
    % uncertainty through logic tree
    T3 =handles.sys.txtLIBS(ptrs(4,1):ptrs(4,2));
    T3 = regexp(T3,'\ ','split');
    T3 = vertcat(T3{:});
    w   = str2double(T3(:,6));
    T3(:,6)=num2cell(w/sum(w));
    handles.P11_table.Data=T3;
    
    handles.P11_table.ColumnFormat{:,2}={setlib.label};
    handles.P11_table.ColumnFormat{:,3}={setlib.label};
    handles.P11_table.ColumnFormat{:,4}={setlib.label};
    handles.P11_table.ColumnFormat{:,5}={setlib.label};
else
    
    handles.P11_Smin.String=1;
    handles.P11_Smax.String=1000;
    handles.P11_Nsta.String=20;
    handles.P11_Qsamples.String=1;
    [~,handles.P11_corrmodel.Value]=intersect(handles.P11_corrmodel.String,'corr_CambpelBozorgnia2019');
    setlib(1)=struct('label','S1','formulation','Bullock2018');
    setlib(2)=struct('label','null','formulation','libs_null');
    handles.P11_list.Value    = 1;
    handles.P11_list.String   = {setlib.label};
    handles.setlib            = setlib;
    handles.P11_e1.String     = setlib(1).label;
    ME                        = pshatoolbox_methods(6);
    [~,handles.P11_e2.Value]  = intersect({ME.str},'Bullock2018');
    
    handles.P11_table.Data={'SETTLE1','S1','S1','null','nul',1};
    handles.P11_table.ColumnFormat{:,2}={smlib.label};
    handles.P11_table.ColumnFormat{:,3}={smlib.label};
    handles.P11_table.ColumnFormat{:,4}={smlib.label};
    handles.P11_table.ColumnFormat{:,5}={smlib.label};
    
    Nsites = size(handles.P6_table.Data,1);
    handles.P11_CPT.Data=[handles.P6_table.Data(:,1),repmat({'Default_CPT.txt'},Nsites,1)];
    
    ch=handles.P11.Children;
    set(ch,'Enable','off');
    handles.P11_Enable.Enable='on';
    handles.P11_Enable.Value =0;
    
end
