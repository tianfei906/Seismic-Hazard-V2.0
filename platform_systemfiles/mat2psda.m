function[handles]=mat2psda(handles,varargin)
%#ok<*NODEF>

%% loads sys, opt, h, model
if nargin==3
    pathname=varargin{1};
    filename=varargin{2};
    if contains(filename,'.mat')
        load([pathname,filename],'sys','opt','h')
        handles.sys    = sys; clear sys
        handles.opt    = opt; clear opt
        handles.h      = h;   clear h
    elseif contains(filename,'.txt')
        [handles.sys,handles.opt,handles.h]=loadPSHA(fullfile(pathname,filename));
    end
elseif nargin==5
    handles.sys    = varargin{1};
    handles.opt    = varargin{3};
    handles.h      = varargin{4};
end

opt.MagDiscrete  = {'uniform',0.1};
n=max(handles.sys.branch(:,3));
for i=1:n
    handles.sys.mrr2(i) = process_truncexp  (handles.sys.mrr2(i) , {'uniform' 0.1});
    handles.sys.mrr3(i) = process_truncnorm (handles.sys.mrr3(i) , {'uniform' 0.1});
    handles.sys.mrr4(i) = process_yc1985    (handles.sys.mrr4(i) , {'uniform' 0.1});
end

%% updates weights
isREG = handles.sys.isREG;
handles.sys.branch         = handles.sys.branch(isREG,:);
handles.sys.branch(:,4)    = handles.sys.branch(:,4)/sum(handles.sys.branch(:,4));

%% loads default models
ME     = handles.ME;
func   = {ME.str};
ptrs   = handles.sys.ptrs(9:14,:);
ptrs   = ptrs-ptrs(1)+1;
[d_default,Sadef,Ddef,SMLIB_default,default_reg]=loadPSDADefaultParam(ME);
txtPSDA = handles.sys.txtPSDA;
% d values
if ~isnan(ptrs(1,1))
    str = txtPSDA(ptrs(1,1):ptrs(1,2),:);
    str = regexp(str,'\ : ','split');
    handles.paramPSDA.d         = eval(str{1}{2});
    handles.paramPSDA.realSa    = str2double(str{2}{2});
    handles.paramPSDA.realD     = str2double(str{3}{2});
    handles.paramPSDA.imhazard  = str{4}{2};
    handles.paramPSDA.rng       = str{5}{2};
    handles.paramPSDA.method    = str{6}{2};
    handles.paramPSDA.optimize  = str{7}{2};
else
    handles.paramPSDA.d         = d_default;
    handles.paramPSDA.realSa    = Sadef;
    handles.paramPSDA.realD     = Ddef;
    handles.paramPSDA.imhazard  = 'full';
    handles.paramPSDA.rng       = 'shuffle';
    handles.paramPSDA.method    = 'MC';
    handles.paramPSDA.optimize  = 'on';
    
end

% ky and Ts
if ~isnan(ptrs(2,1))
    str = txtPSDA(ptrs(2,1):ptrs(2,2),:);
    str = regexp(str,'\ : ','split');
    
    % param 1
    fld = [str{1}{1},'_param'];
    val = lower(regexp(str{1}{2},'\ ','split'));
    val = struct(val{:});
    handles.(fld) = [str2double(val.mean),str2double(val.cov),str2double(val.samples)];
    
    %param2
    fld = [str{2}{1},'_param'];
    val = lower(regexp(str{2}{2},'\ ','split'));
    val = struct(val{:});
    handles.(fld) = [str2double(val.mean),str2double(val.cov),str2double(val.samples)];
else
    handles.Ts_param = default_reg.Ts_param;
    handles.ky_param = default_reg.ky_param;
end

% displacement model library
if ~isnan(ptrs(3,1))
    
    str = txtPSDA(ptrs(3,1):ptrs(3,2),:);
    str = regexp(str,'\ handle ','split');
    
    Nmodels = length(str);
    SMLIB(1:Nmodels,1) = struct('id',[],'label',[],'str',[],'func',[],'isregular',[],'integrator',[],'primaryIM',[],'Safactor',[]);
    for i=1:Nmodels
        stri = regexp(str{i}{2},'\ ','split');
        [~,C]=intersect(func,stri{1});
        SMLIB(i).id = str{i}{1};
        SMLIB(i).str        = ME(C).str;
        SMLIB(i).func       = ME(C).func;
        SMLIB(i).isregular  = ME(C).isregular;
        SMLIB(i).integrator = ME(C).integrator;
        SMLIB(i).primaryIM  = ME(C).primaryIM;
        SMLIB(i).Safactor   = ME(C).Safactor;
        SMLIB(i).param      = [];
        if length(stri)>2
            fixparam = struct(stri{2:end});
            flds     = fields(fixparam);
            for j=1:length(flds)
                fixparam.(flds{j})=str2double(fixparam.(flds{j}));
            end
            SMLIB(i).param   = fixparam;
        end
    end
    handles.sys.SMLIB=SMLIB;
else
    handles.sys.SMLIB = SMLIB_default;
end

% Displacement Models for regular PSDA Analysis
if ~isnan(ptrs(4,1))
    str = txtPSDA(ptrs(4,1):ptrs(4,2),:);
    Nmodels = size(str,1)-1;
    T3    = cell(Nmodels,5);
    newline = regexp(str{1},'\ ','split');
    slopeweights = str2double(newline(3:end)');
    slopeweights = slopeweights / sum(slopeweights);
    T3(:,5) = num2cell(slopeweights);
    
    str(1,:)=[];
    
    for j=1:Nmodels
        strj = regexp(str{j},'\ ','split');
        T3{j,1}=strj{1};
        modelassig = struct(strj{2:end});
        T3{j,2} = modelassig.interface;
        T3{j,3} = modelassig.intraslab;
        T3{j,4} = modelassig.crustal;
    end
    handles.T3=T3;
else
    handles.T3=default_reg.T3;
end

%% Displacement Models for PCE PSDA Analysis
if ~isnan(ptrs(5,1))
    str = txtPSDA(ptrs(5,1):ptrs(5,2),:);
    str = regexp(str,'\ ','split');
    Nmodels  = size(str,1);
    DataCDM  = cell(Nmodels,7);
    for j=1:Nmodels
        modelassig   = struct(str{j}{12:end});
        DataCDM{j,1} = str{j}{1};
        DataCDM{j,2} = sprintf('%s,%s,%s',str{j}{3},str{j}{4},str{j}{5});
        DataCDM{j,3} = sprintf('%s,%s',str{j}{10},str{j}{11});
        DataCDM{j,4} = sprintf('%s,%s',str{j}{7} ,str{j}{8});
        DataCDM{j,5} = modelassig.interface;
        DataCDM{j,6} = modelassig.intraslab;
        DataCDM{j,7} = modelassig.crustal;
    end
    
    isCDMGMM = ~horzcat(SMLIB.isregular);
    handles.tableCDM.ColumnFormat{4}={SMLIB(isCDMGMM).id};
    handles.tableCDM.ColumnFormat{5}={SMLIB(isCDMGMM).id};
    handles.tableCDM.ColumnFormat{6}={SMLIB(isCDMGMM).id};
    handles.tableCDM.Data = DataCDM;
end

%% setup GUI for regular models
if any(isREG)
    handles.pop_site.String=handles.h.id;
    handles.pop_site.Enable='on';
    handles.pop_site.Value=1;
    
    % Tables T1,T2
    w1          = handles.sys.branch(:,4);
    id          = compose('Branch %i',isREG');
    handles.T1  = [id,num2cell(w1)];
    [Ts,~,dPTs] = trlognpdf_psda(handles.Ts_param);
    [ky,~,dPky] = trlognpdf_psda(handles.ky_param);
    Ts          = round(Ts*1e10)/1e10;
    [ind1,ind2] = meshgrid(1:length(Ts),1:length(ky));
    ind1        = ind1(:);
    ind2        = ind2(:);
    Nparam      = length(ind1);
    handles.T2  = [compose('set%i',1:Nparam)',num2cell([Ts(ind1),ky(ind2),dPTs(ind1).*dPky(ind2)])];
    [handles.tableREG.Data,handles.IJK]=main_psda(handles.T1,handles.T2,handles.T3);
    handles.EditLogicTree.Enable='on';
end

%% ACTIVATE / DEACTIVA REG AND CDM MODES
if ~isempty(handles.tableCDM.Data)
    handles.mode2.Value               = 1;
    handles.mode2.Enable              = 'on';
    handles.tableCDM.Enable           = 'on';
    handles.runCDM.Enable             = 'on';
    handles.CDM_DisplayOptions.Enable = 'on';
else
    handles.mode2.Value               = 0;
    handles.mode2.Enable              = 'off';
    handles.tableCDM.Enable           = 'off';
    handles.runCDM.Enable             = 'inactive';
    handles.CDM_DisplayOptions.Enable = 'inactive';
end

if ~isempty(isREG)
    handles.mode1.Value               = 1;
    handles.mode1.Enable              = 'on';
    handles.tableREG.Enable           = 'on';
    handles.runREG.Enable             = 'on';
    handles.treebutton.Enable         = 'on';
    handles.REG_DisplayOptions.Enable = 'on';
else
    handles.mode1.Value               = 0;
    handles.mode1.Enable              = 'off';
    handles.tableREG.Enable           = 'off';
    handles.runREG.Enable             = 'inactive';
    handles.treebutton.Enable         = 'inactive';
    handles.REG_DisplayOptions.Enable = 'inactive';   
end

%% validation data
ind1 =ptrs(6,1);
ind2 =ptrs(6,2);
if ~isnan(ind1)
    line          = regexp(txtPSDA{ind1},'\ ','split');
    handles.sys.D = str2double(line(1,2:end));
    ND            = length(handles.sys.D);
    line          = txtPSDA(ind1+1:ind2,:);
    Nrows         = size(line,1);
    handles.sys.Dlabels     = cell(Nrows,1);
    handles.sys.lambdaDTest = zeros(Nrows,ND);
    
    for i=1:size(line,1)
        line_i = regexp(line{i},'\ ','split');
        lab_i  = strjoin(line_i(1:end-ND),' ');
        line_i = line_i(end-ND+1:end);
        handles.sys.Dlabel{i}=lab_i;
        handles.sys.lambdaDTest(i,:)=str2double(line_i);
    end
end

