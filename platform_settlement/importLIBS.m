function[handles]=importLIBS(handles,pathname,filename)

overwrite.msample = [3,0.1];
[handles.sys,handles.opt,handles.h]=loadPSHA(fullfile(pathname,filename),overwrite);

txtLIBS = handles.sys.txtLIBS;
ptrs    = handles.sys.ptrs(16:19,:);
ptrs    = ptrs-ptrs(1)+1;

%% Option 20: reads analysis options
str = txtLIBS(ptrs(1,1):ptrs(1,2)-1);
str = regexp(str,'\:','split');
str = vertcat(str{:});
handles.optlib.analysis = strtrim(str{1,2});
handles.optlib.sett = eval(str{2,2});
handles.optlib.tilt = eval(str{3,2});
handles.optlib.nQ   = str2double(str{4,2});
handles.optlib.nPGA = size(handles.sys.branch,1);
handles.optlib.corr = str2func(strtrim(str{5,2}));
pypath = txtLIBS(ptrs(1,2));
str    = regexp(pypath,' : ','split');
handles.optlib.pypath    = str{1}{2};


%% Option 21: reads site/building properties assignments
str = regexp(txtLIBS(ptrs(2,1):ptrs(2,2)),'\ ','split');
str = vertcat(str{:});
[~,B]=intersect(str,handles.h.id(:));
str = str(B,:);
Nsites = size(str,1);
handles.param(1:Nsites,1)=createObj(19);
for i=1:Nsites
    handles.param(i)= loadsiteLIBS(str{i,2},handles.optlib.pypath);
end

%% Option 22: Settlement model library
str = regexp(txtLIBS(ptrs(3,1):ptrs(3,2)),'\ ','split');
str = vertcat(str{:});
ME  = pshatoolbox_methods(6);
[~,~,B]=intersect(str(:,3),{ME.str}','stable');

handles.setLIB=ME(B);
for i=1:length(B)
    handles.setLIB(i).label=str{i,2};
end
%% Option 23: Settlement Branches and T3
str        = regexp(txtLIBS(ptrs(4,1):ptrs(4,2)),'\ ','split');
str        = vertcat(str{:});
w          = str2double(str(:,6));
w          = w/sum(w);
str(:,6)   = num2cell(w);
handles.T3 = str;

%% T1 and T2
Nhaz       = size(handles.sys.branch,1);
id         = compose('Haz%i',1:Nhaz)';
weight     = num2cell(handles.sys.weight(:,5));
handles.T1 = [id,weight];
T2val      = T2settle(handles.optlib.nQ);
handles.T2 = [compose('SP%i',(1:size(T2val,1))'),num2cell(T2val)];
[handles.tableREG.Data,handles.IJK]=main_settle(handles.T1,handles.T2,handles.T3);

%% Site pop
handles.pop_site.String=handles.h.id;
handles.pop_site.Enable='on';
handles.pop_site.Value=1;


function T2= T2settle(nQ)
[~,wQ] = trlognpdf_psda([1 0.2 nQ]);
T2     = wQ;






