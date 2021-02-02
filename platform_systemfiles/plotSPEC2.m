function plotSPEC2(SPEC,MRZ,optdspec,dslib,ax)
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
specmode    = ax.YLabel.String;

%% RETRIEVES RESPONSE SPECTRA FROM A SINGLE SOURCE
T           = optdspec.periods;
source_ptr  = display_pop.Value;
site_ptr    = site_pop.Value;


SPEC       = permute(SPEC(site_ptr,:,source_ptr,:),[4 2 1 3]);
MRZ        = permute(MRZ(site_ptr,:,source_ptr,:),[4 2 1 3]);


AVG1 = prod(bsxfun(@power,SPEC,optdspec.weights),1);
AVG2 = prctile(SPEC,50,1);


switch specmode
    case 'Sa(g)'
        if check1.Value
            plot(ax,T,SPEC,'-','tag','speclines')
        end
        ax.ColorOrderIndex=1;
        plot(ax,T,AVG1,'-','linewidth',1.5,'tag','speclines')
        plot(ax,T,AVG2,'-','linewidth',1.5,'tag','speclines')
        
    case 'Sd(cm)'
        om2 = (2*pi./T).^2;
        if check1.Value
            plot(ax,T,SPEC*981./om2,'-','tag','speclines')
        end
        ax.ColorOrderIndex=1;
        plot(ax,T,AVG1*981./om2,'-','linewidth',1.5,'tag','speclines')
        plot(ax,T,AVG2*981./om2,'-','linewidth',1.5,'tag','speclines')
end

Nbranches  = size(SPEC,1);
zone = display_pop.String(source_ptr);
col1 = repmat(zone,Nbranches,1);
col2 = compose('Branch %g',(1:Nbranches)');

nanMRZ = isnan(MRZ(:,1:4));
col3 = num2cell(MRZ(:,1:4));
for i=1:numel(col3)
    if nanMRZ(i)
        col3{i}='';
    end
end

scen.Data  = [col1,col2,col3];
if check1.Value
    L=legend(ax,[col2;'Mean';'Percentile 50']);
else
    L=legend(ax,{'Mean';'Percentile 50'});
end
L.Box='off';
L.Title.String=zone;
ax.Layer='top';

%% PLOTS design spectra
if check2.Value && ~isempty(dslib)
    Nds = length(dslib);
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
if ~all(isnan(SPEC(:)))
    data1 = [['T(s)';col2;'Mean';'Percentile 50'],num2cell([T;SPEC;AVG1;AVG2])]';
    data2 = [{'Model','M','Rrup','Rhyp','Zhyp','Lat','Lon','Elev'};[col2,num2cell(MRZ)]];
    
    c2 = uicontextmenu;
    uimenu(c2,'Label','Get Response Spectra','Callback'  ,{@data2clipboard_uimenu,data1});
    uimenu(c2,'Label','Get Scenarios','Callback'         ,{@data2clipboard_uimenu,data2});
    set(ax,'uicontextmenu',c2);
else
    c2 = uicontextmenu;
    set(ax,'uicontextmenu',c2);
end
