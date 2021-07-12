function plot_LIBS_regular(handles)

if ~isfield(handles,'sys'), return;end
if ~isfield(handles,'lambdaD'),return;end

delete(findall(handles.ax1,'type','line'));
handles.ax1.NextPlot='add';
handles.ax1.ColorOrderIndex=1;
site_ptr = handles.pop_site.Value;

haz  = handles.REG_Display;
d    = handles.optlib.sett;
flatcolor=0;%handles.ColorSecondaryLines.Value;
% gris = [0.76 0.76 0.76];

if haz.L0
    lambdaD = sum(handles.lambdaD(site_ptr,:,:,:),3,'omitnan');
    lambdaD = permute(lambdaD,[4 2 3 1]);
    
    handles.ax1.ColorOrderIndex=1;
    
    if haz.L1 % default weights
        weights = cell2mat(handles.tableREG.Data(:,end));
        lam2    = nanprod(bsxfun(@power,lambdaD,weights),1);
        plot(handles.ax1,d',lam2','.-','DisplayName','Default Weights');
    end
    
    if haz.L2 % random weights
        weights = handles.REG_Display.rnd;
        lam2 = nanprod(bsxfun(@power,lambdaD,weights),1);
        plot(handles.ax1,d',lam2','.-','DisplayName','Random Weights');
    end
    
    if haz.L3 % mean
        lambdaD(lambdaD<0)=nan;
        lam2 = exp(mean(log(lambdaD),1,'omitnan'));
        plot(handles.ax1,d',lam2','.-','DisplayName','Mean');
    end
    
    if haz.L4 % percentiles
        percentile = haz.L5;
        str  = compose('Percentile %g',percentile);
        Nt   = length(str);
        handles.table.Data(:,4)=cell(Nt,1);
        lambdaD(lambdaD<0)=nan;
        lam2 = exp(prctile(log(lambdaD),percentile,1));
        for jj=1:Nt
            plot(handles.ax1,d',lam2(jj,:)','-','DisplayName',str{jj});
        end
    end
    
    if haz.L6 % CDM branches
        lam1 = lambdaD;
        lam1(lam1==0)=nan;
        Nbranch = size(lambdaD,1);
        str = compose('Branch %i',1:Nbranch);
        ind = find(any(lambdaD,2))';
        for jj=ind
            if flatcolor
                plot(handles.ax1,d',lam1(jj,:)','color',gris,'DisplayName',str{jj})
            else
                plot(handles.ax1,d',lam1(jj,:)','DisplayName',str{jj})
            end
        end
    end
    
    Leg=legend(handles.ax1);
    Leg.FontSize=8;
    Leg.Box='off';
    Leg.Location='SouthWest';
    Leg.Tag='hazardlegend';
    
    switch handles.toggle1.Value
        case 0,Leg.Visible='off';
        case 1,Leg.Visible='on';
    end
end

if haz.R0
    branch_ptr = haz.R1;
    lambdaD    = handles.lambdaD(site_ptr,:,:,branch_ptr);
    lambdaD    = permute(lambdaD,[2 3 1]);
    lam2       = sum(lambdaD,2,'omitnan')';
    handles.ax1.ColorOrderIndex=1;
    plot(handles.ax1,d',lam2','.-','DisplayName','Total');
    
    if haz.R2 % displays source contribution
        haz_ptr      = handles.IJK(branch_ptr,1);
        geomptr      = handles.sys.branch(haz_ptr,1);
        NOTZERO      = sum(lambdaD,1,'omitnan')>0;
        source_label = handles.sys.labelG{geomptr};
        str          = source_label(NOTZERO);
        lam1         = lambdaD(:,NOTZERO)';
        
        for jj=1:size(lam1,1)
            if flatcolor
                plot(handles.ax1,d,lam1(jj,:),'color',gris,'DisplayName',str{jj})
            else
                plot(handles.ax1,d,lam1(jj,:),'DisplayName',str{jj})
            end
        end
        
    end
    
    if haz.R3 % displays mechanism contribution
        haz_ptr    = handles.IJK(branch_ptr,1);
        geomptr    = handles.sys.branch(haz_ptr,1);
        mechs      = handles.sys.mech{geomptr};
        m1         = (mechs==1); % interface
        m2         = (mechs==2); % intraslab
        m3         = (mechs==3); % crustal
        
        lambdaD    = [sum(lambdaD(:,m1),2,'omitnan') sum(lambdaD(:,m2),2,'omitnan') sum(lambdaD(:,m3),2,'omitnan')];
        NOTNAN     = (sum(lambdaD,1,'omitnan')>0);
        lam1       = lambdaD(:,NOTNAN)';
        mechs = {'interface','intraslab','crustal'};
        str = mechs(NOTNAN);
        
        for jj=1:length(str)
            if flatcolor
                handles.ax1.ColorOrderIndex=1;
                plot(handles.ax1,d,lam1(jj,:),'color',gris,'DisplayName',str{jj});
            else
                plot(handles.ax1,d,lam1(jj,:),'DisplayName',str{jj});
            end
        end
    end
    Leg=legend(handles.ax1);
    
    Leg.FontSize=8;
    Leg.EdgeColor=[1 1 1];
    Leg.Location='SouthWest';
    Leg.Tag='hazardlegend';
    switch handles.toggle1.Value
        case 0,Leg.Visible='off';
        case 1,Leg.Visible='on';
    end
end

axis(handles.ax1,'auto')
cF   = get(0,'format');
format long g
if exist('lam1','var')
    data = num2cell([d;lam2;lam1]); % branches
else
    data = num2cell([d;lam2]); % average
end
c    = uicontextmenu;
uimenu(c,'Label','Copy data','Callback',        {@data2clipboard_uimenu,data'});
uimenu(c,'Label','Undock','Callback',           {@figure2clipboard_uimenu,handles.ax1});
uimenu(c,'Label','Undock & compare','Callback', {@figurecompare_uimenu,handles.ax1});
set(handles.ax1,'uicontextmenu',c);
format(cF);

% ylim(handles.ax1,[1e-6 1e2])

