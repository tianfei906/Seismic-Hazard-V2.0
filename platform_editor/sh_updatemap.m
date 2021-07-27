
delete(findall(handles.P3_ax1,'tag' ,'gmap'));
ae = handles.opt.ae;

handles.sys=sh_plot_geometry_PSHA(handles.P3_ax1,handles.sys,handles.opt);

if isempty(ae)
    xlabel(handles.P3_ax1,'X (km)','fontsize',8,'fontname','arial','tag','xlabel')
    ylabel(handles.P3_ax1,'Y (km)','fontsize',8,'fontname','arial','tag','ylabel')
else
    xlabel(handles.P3_ax1,'Lon','fontsize',8,'fontname','arial','tag','xlabel')
    ylabel(handles.P3_ax1,'Lat','fontsize',8,'fontname','arial','tag','ylabel')
end

% source Labels
tag = sprintf('sourcelabel%g',handles.po_region.Value);
ch  = findall(handles.figure1,'tag',tag);
set(ch,'visible',handles.SourceLabels.Checked);


% source edges
tag = sprintf('edge%g',handles.po_region.Value);
ch  = findall(handles.figure1,'tag',tag);
set(ch,'visible',handles.po_sources.Checked);

% source mesh
tag = sprintf('mesh%g',handles.po_region.Value);
ch  = findall(handles.figure1,'tag',tag);
set(ch,'visible',handles.po_sourcemesh.Checked);


default_maps(handles.figure1,handles.opt,handles.P3_ax1);

if isempty(handles.opt.Image)
    rat = diff(handles.P3_ax1.YLim)/diff(handles.P3_ax1.XLim);
    axis(handles.P3_ax1,'equal');
    axis(handles.P3_ax1,'auto');
    XL = handles.P3_ax1.XLim;
    YC = mean(handles.P3_ax1.YLim);
    handles.P3_ax1.YLim=YC+rat*diff(XL)*[-1 1];
end
