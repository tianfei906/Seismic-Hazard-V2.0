function[]=SMDplot(handles,dummy)

delete(findall(handles.ax1,'tag','spec'))
delete(findall(handles.ax1,'tag','spec2'))
if isempty(handles.list1.String)
    return
end
handles.ax1.ColorOrderIndex=1;
fname = handles.pop2.String{handles.pop2.Value};
ptrs  = cell2mat(handles.t.Data(:,1))+1;
T     = handles.T;
if ~isempty(handles.dslib)
    dslib = handles.dslib;
    DS    = dslib.fun(T,dslib.param{:});
else
    DS = [];
end


if ~strcmp(fname,'residuals')
    IM    = SMDreadspec(T,fname,ptrs);
    if ~handles.opt.none
        IM  = IM.*handles.m.amp(ptrs);
    end
    
    switch handles.dispmode
        case 'Sa',    plot(handles.ax1,T',IM','-','color',[1 1 1]*0.76,'tag','spec')
        case 'Sd',    plot(handles.ax1,T',IM'*981./(2*pi./T').^2,'color',[1 1 1]*0.76,'tag','spec')
        case 'ratio', plot(handles.ax1,T',IM','-','color',[1 1 1]*0.76,'tag','spec')
        
    end
    
    if ~isempty(handles.evdata)
        ev = handles.evdata(:,1);
        handles.ax1.ColorOrderIndex=1;
        switch handles.dispmode
            case 'Sa',    plot(handles.ax1,T',IM(ev,:)','-','tag','spec','linewidth',1)
            case 'Sd',    plot(handles.ax1,T',IM(ev,:)'*981./(2*pi./T').^2,'linewidth',1,'tag','spec')
            case 'ratio', plot(handles.ax1,T',IM(ev,:)','-','tag','spec','linewidth',1)
        end
    end
    
else
    % gmm predictions
    fun  = handles.fun{handles.gmpepop.Value};
    ms   = handles.m(ptrs,:);
    e    = SMDpredict(T,fun,ms);
    
    plot(handles.ax1,T',e,'.','color',[1 1 1]*0.76,'tag','spec')
    plot(handles.ax1,T',T'*0,'k-','tag','spec')
    plot(handles.ax1,T',nanmean(e,1)','rs-','tag','spec')
end

%% plots design spectra
if strcmp(handles.display_DS.Checked,'on') && ~isempty(DS) && ~strcmp(fname,'residual')
    Nds = length(dslib);
    handles.ax1.ColorOrderIndex=1;
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
                Tmax  = T(end);
                To    = 0:0.01:Tmax;
                ds    = fun(To,param{:});
        end
        
        switch handles.dispmode
            case 'Sa' , plot(handles.ax1,To,ds,'linewidth',2,'DisplayName',label,'tag','spec');
            case 'Sd' , plot(handles.ax1,To,ds*981./(2*pi./To).^2,'linewidth',2,'DisplayName',label,'tag','spec');
        end
    end
end

%% plots CMS
if strcmp(handles.display_CMS.Checked,'on') && isfield(handles,'CMS') && ~isempty(handles.CMS)
    handles.ax1.ColorOrderIndex=1;
    plot(handles.ax1,[T,NaN,T],[handles.CMS(1,:),NaN,handles.CMS(2,:)],'linewidth',2,'tag','spec');
end

handles.ax1.Layer='top';