function plotSPEC1(SPEC,MRZ,optdspec,dslib,ax,im,lambdauhs)
if isempty(SPEC)
    return
end
delete(findall(ax,'tag','speclines'))
ax.ColorOrderIndex=1;
fig         = ax.Parent;
display_pop = findall(fig,'tag','display_pop');
site_pop    = findall(fig,'tag','site_pop');
scen        = findall(fig,'tag','scen');
check1      = findall(fig,'tag','check1');
check2      = findall(fig,'tag','checkbox4');
sourceData  = optdspec.userMmax(:,1:2);
specmode    = ax.YLabel.String;

%% RETRIEVES RESPONSE SPECTRA FROM A SINGLE LOGIC TREE BRANCH
T           = optdspec.periods;
nIM         = length(T);
Nbranches   = size(optdspec.branch,1);
display_ptr = display_pop.Value;
site_ptr    = site_pop.Value;

if display_ptr<=Nbranches
    branch_ptr = display_ptr;
    SPEC       = permute(SPEC(site_ptr,:,:,branch_ptr),[3 2 1]);
    MRZ        = permute(MRZ(site_ptr,:,:,branch_ptr),[3 2 1]);
    ISNAN      = isnan(MRZ(:,1));
end

%% COMPUTES AVERAGE RESPONSE SPECTRA USING LOGIT TREE WEIGHTS
if display_ptr==Nbranches+1
    SPEC       = SPEC(site_ptr,:,:,:);
    SPEC       = permute(SPEC,[3  2  4 1]);
    MRZ        = permute(MRZ(site_ptr,:,:,1),[3 2 4 1]);
    ISNAN      = isnan(MRZ(:,1));
    weights    = optdspec.weights;
    SPEC       = prod(bsxfun(@power,SPEC,permute(weights(:),[3 2 1])),3);
end

%% COMPUTES PERCENTILE RESPONSE SPECTRA FROM BRANCHES
if display_ptr>Nbranches+1
    SPEC       = SPEC(site_ptr,:,:,:);
    SPEC       = permute(SPEC,[3  2  4 1]);
    MRZ        = permute(MRZ(site_ptr,:,:,1),[3 2 4 1]);
    ISNAN      = isnan(MRZ(:,1));
    per        = regexp(display_pop.String{display_ptr},'\Percentile','split');
    per        = str2double(per{2});
    SPEC       = prctile(SPEC,per,3);
end

sourceData = sourceData(~ISNAN,:);
MRZ    = MRZ(~ISNAN,:);
SPEC   = SPEC(~ISNAN,:);


%% SELECTS CONTROLLING SOURCES MECHANISM
if check1.Value==1
    list1  = nan(1,nIM);
    list2  = nan(1,nIM);
    list3  = nan(1,nIM);
    
    [~,id1] = ismember(sourceData(:,2),'interface'); id1 = find(id1);
    [~,id2] = ismember(sourceData(:,2),'intraslab'); id2 = find(id2);
    [~,id3] = ismember(sourceData(:,2),'crustal');   id3 = find(id3);
    for i=1:nIM
        if ~isempty(id1)&& ~isnan(max(SPEC(id1,i))), [~,list1(i)]=max(SPEC(id1,i)); end
        if ~isempty(id2)&& ~isnan(max(SPEC(id2,i))), [~,list2(i)]=max(SPEC(id2,i)); end
        if ~isempty(id3)&& ~isnan(max(SPEC(id3,i))), [~,list3(i)]=max(SPEC(id3,i)); end
    end
    list1(isnan(list1))=[]; list1=unique(list1);
    list2(isnan(list2))=[]; list2=unique(list2);
    list3(isnan(list3))=[]; list3=unique(list3);
    
    clist = [id1(list1);id2(list2);id3(list3)];
    sourceData = sourceData(clist,:);
    MRZ    = MRZ(clist,:);
    SPEC   = SPEC(clist,:);
end

%% PLOTS DATA
ax.ColorOrderIndex=1;
if display_ptr<=Nbranches
    scen.Data = [sourceData,num2cell(MRZ(:,1:4))];
else
    Nrows = size(sourceData,1);
    scen.Data = cell(Nrows,6);
    scen.Data(:,1:2)=sourceData;
end

switch specmode
    case 'Sa(g)' , plot(ax,T,SPEC,'.-','tag','speclines')
    case 'Sd(cm)', plot(ax,T,SPEC*981./(2*pi./T).^2,'.-','tag','speclines')
end

L=legend(ax,sourceData(:,1));
L.Box='off';
L.Title.String='';
ax.Layer='top';

%% PLOTS design spectra
if check2.Value && ~isempty(dslib)
    Nds = length(dslib);
    ax.ColorOrderIndex=1;
    for j=1:Nds
        label = dslib(j).label;
        fun   = dslib(j).fun;
        param = dslib(j).param;
        
        switch func2str(fun)
            case 'builduhs'
                To    = T;
                ds    = builduhs(To,param{:},optdspec);
                ds    = ds(site_ptr,:);
            otherwise
                To    = 0:0.01:optdspec.Tmax;
                ds    = fun(To,param{:});
        end
        
        switch specmode
            case 'Sa(g)' , plot(ax,To,ds,'linewidth',2,'DisplayName',label,'tag','speclines');
            case 'Sd(cm)', plot(ax,To,ds*981./(2*pi./To).^2,'linewidth',2,'DisplayName',label,'tag','speclines');
        end
    end
end


%% uicontext menu
data = [['T(s)';sourceData(:,1)],num2cell([T;SPEC])]';
c2 = uicontextmenu;
uimenu(c2,'Label','Get Spectra','Callback'  ,{@data2clipboard_uimenu,data});
set(ax,'uicontextmenu',c2);

