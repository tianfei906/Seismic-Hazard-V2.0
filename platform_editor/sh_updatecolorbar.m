
depth = sprintf('dept%g',handles.po_region.Value);
ch       = findall(handles.figure1,'tag',depth);
if isempty(ch)
    return
end

set(ch,'visible',handles.po_depth.Checked);
handles.cb1.Visible=handles.po_depth.Checked;
handles.cb2.Visible=handles.po_depth.Checked;

handles.cb1.Title.String='Depth(km)';
handles.cb2.Title.String='Depth(km)';
ch  = findall(handles.P3_ax1,'tag',depth);
ulims=[min(vertcat(ch.FaceVertexCData)),max(vertcat(ch.FaceVertexCData))];
if diff(ulims)==0
    ulims=ulims+[-0.5 0.5];
end
handles.cb1.Limits =ulims;
handles.cb2.Limits =ulims;
handles.cblimits1 =ulims;
caxis(handles.P3_ax1,handles.cblimits1)
