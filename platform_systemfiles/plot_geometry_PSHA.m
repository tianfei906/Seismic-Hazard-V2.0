function plot_geometry_PSHA(ax,sys,opt)

vis='off';
if isempty(opt.ellipsoid.Code)
    xlabel(ax,'X (km)','fontsize',8,'fontname','arial','tag','xlabel')
    ylabel(ax,'Y (km)','fontsize',8,'fontname','arial','tag','ylabel')
else
    xlabel(ax,'Lon','fontsize',8,'fontname','arial','tag','xlabel')
    ylabel(ax,'Lat','fontsize',8,'fontname','arial','tag','ylabel')
end

meshcolor  = [0.6 0.6 1];
edgecolor   = [1 0.6 0.6];

Ngeom = size(sys.Nsrc,2);
for i=1:Ngeom
	n1 = length(sys.point1(i).txt);
    vert2=xyz2gps(sys.line1(i).xyzm   , opt.ellipsoid); n2=size(vert2,1);
    vert3=xyz2gps(sys.area1(i).xyzm   , opt.ellipsoid); n3=size(vert3,1);
    vert4=xyz2gps(sys.area2(i).xyzm   , opt.ellipsoid); n4=size(vert4,1);
    vert5=xyz2gps(sys.volume1(i).xyzm , opt.ellipsoid); n5=size(vert5,1);
    
    t2=[];
    if n5>0
        t  = sys.volume1(i).conn;
        t2 = [t(:,[1 2 3]);t(:,[1 4 3]);t(:,[2 3 4]);t(:,[1 2 4])];
        t2 = unique(sort(t2,2),'rows');
    end
    
    % plot sourcemesh
    tag = sprintf('mesh%g',i); delete(findall(ax,'tag',tag));
    if n3>0,patch('parent',ax,'vertices',vert3(:,1:2),'faces',sys.area1(i).conn,'facecolor','none','edgecolor',meshcolor,'tag',tag,'visible',vis);end
    if n4>0,patch('parent',ax,'vertices',vert4(:,1:2),'faces',sys.area2(i).conn,'facecolor','none','edgecolor',meshcolor,'tag',tag,'visible',vis);end
    if n5>0,patch('parent',ax,'vertices',vert5(:,1:2),'faces',t2,'facecolor','none','edgecolor',meshcolor,'tag',tag,'visible',vis);end
    
    % plot sources
    tag = sprintf('edge%g',i); delete(findall(ax,'tag',tag));
    if n1>0,plot(ax,sys.point1(i).vert(:,1) ,sys.point1(i).vert(:,2) ,'ks','markersize',4,'markerfacecolor',edgecolor,'tag',tag,'visible',vis);end
    if n2>0,plot(ax,sys.line1(i).vert(:,1)  ,sys.line1(i).vert(:,2)  ,'color',edgecolor,'tag',tag,'linewidth',1,'visible',vis);end
    if n3>0,plot(ax,sys.area1(i).vert(:,1)  ,sys.area1(i).vert(:,2)  ,'color',edgecolor,'tag',tag,'visible',vis);end
    if n4>0,plot(ax,sys.area2(i).vert(:,1)  ,sys.area2(i).vert(:,2)  ,'color',edgecolor,'tag',tag,'visible',vis);end
    if n5>0,plot(ax,sys.volume1(i).vert(:,1),sys.volume1(i).vert(:,2),'color',edgecolor,'tag',tag,'visible',vis);end
    
    tag = sprintf('mesh%g',i);
    if n2>0, plot(ax,vert2(:,1),vert2(:,2),'k.','tag',tag,'visible',vis); end
    
    % source tag
    tag=sprintf('sourcetag%g',i);
    txt = [
        sys.line1(i).txt;
        sys.area1(i).txt;
        sys.area2(i).txt;
        sys.volume1(i).txt];
    cm  = [
        sys.line1(i).center;
        sys.area1(i).center;
        sys.area2(i).center;
        sys.volume1(i).center];
    
    text(ax,cm(:,1),cm(:,2),strrep(txt,'_','-'),'fontsize',8,'fontweight','bold','visible',vis,'tag',tag,'horizontalalignment','center','verticalalignment','bottom');
end

