function[handles]=importLIBS(handles,pathname,filename)

[handles.sys,handles.opt,handles.h]=loadPSHA(fullfile(pathname,filename));
txtLIBS = handles.sys.txtLIBS;
ptrs    = handles.sys.ptrs(21:24,:);
ptrs    = ptrs-ptrs(1)+1;

%% Option 20: reads analysis options
str = txtLIBS(ptrs(1,1):ptrs(1,2));
str = regexp(str,'\:','split');
str = vertcat(str{:});
handles.optlib.analysis = strtrim(str{1,2});
handles.optlib.sett = eval(str{2,2});
handles.optlib.tilt = eval(str{3,2});
handles.optlib.nQ   = str2double(str{4,2});
handles.optlib.nPGA = str2double(str{5,2});
handles.optlib.wHL  = eval(['[',str{6,2},']']);
handles.optlib.rhoCABSA1= str2double(str{7,2});

%% Option 21: reads site/building properties assignments
str = regexp(txtLIBS(ptrs(2,1):ptrs(2,2)),'\ ','split');
str = vertcat(str{:});
[~,B]=intersect(str,handles.h.id(:));
str = str(B,:);
Nsites = size(str,1);
handles.param(1:Nsites,1)=createObj('LIBSsite');
for i=1:Nsites
    handles.param(i)= loadsiteLIBS(str{i,2});
end

%% Option 22: Settlement model library
str = regexp(txtLIBS(ptrs(3,1):ptrs(3,2)),'\ ','split');
str = vertcat(str{:});
ME  = pshatoolbox_methods(6);
[~,~,B]=intersect({ME.str},str(:,3));
handles.setLIB=ME(B);
for i=1:length(B)
    handles.setLIB(i).label=str{i,1};
end
%% Option 23: Settlement Branches and T3
str        = regexp(txtLIBS(ptrs(4,1):ptrs(4,2)),'\ ','split');
weights    = str2double(str{1}(2:end))';
str        = vertcat(str{2:end});
handles.T3 = [str(:,[1,3,5,7]),num2cell(weights)];

%% T1 and T2
Nhaz       = size(handles.sys.branch,1);
id         = compose('Haz%i',1:Nhaz)';
weight     = num2cell(handles.sys.weight(:,5));
handles.T1 =[id,weight];
T2val      = T2settle(handles.optlib.nQ,handles.optlib.nPGA,handles.optlib.wHL);
handles.T2 = [compose('SP%i',(1:size(T2val,1))'),num2cell(T2val)];
[handles.tableREG.Data,handles.IJK]=main_settle(handles.T1,handles.T2,handles.T3);

%% Site pop
handles.pop_site.String=handles.h.id;
handles.pop_site.Enable='on';
handles.pop_site.Value=1;


function T2= T2settle(nQ,nPGA,wHL)

wHL=wHL(:);
wHL(wHL==0)=[];

[~,~,wQ]   = trlognpdf_psda([1 0.2 nQ]);
[~,~,wLBS] = trlognpdf_psda([1 0.2 nPGA]);
[II,JJ,KK]=meshgrid(1:nQ,1:nPGA,1:length(wHL)); II=II(:); JJ=JJ(:);KK=KK(:);
T2=[wQ(II),wLBS(JJ),wHL(KK),wQ(II).*wLBS(JJ).*wHL(KK)];






