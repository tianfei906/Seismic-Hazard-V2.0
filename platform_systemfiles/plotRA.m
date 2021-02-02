function[]=plotRA(ax,source,scen,xyzm,ellip)

pfun    = func2str(source.pfun);
pinkrgb = [255,192,203]/255;
switch pfun
    case 'RAcirc_rigid'
        M      = scen(2);
        C0     = scen(3:5);
        [~,ii] = min(sum((source.rclust.C-C0).^2,2));
        [~,jj] = min(abs(source.rclust.m-M));
        radio  = source.rclust.radio(ii,jj);
        
        ind = sum((source.hypm-C0).^2,2)<=radio^2;
        vert=xyz2gps(xyzm,ellip);
        patch(ax,...
            'faces',source.conn(ind,:),...
            'vertices',vert(:,1:2),...
            'facecolor',pinkrgb,...
            'edgecolor','none',...
            'facealpha',0.5,...
            'tag','ra')
        focus = xyz2gps(C0,ellip);
        plot(ax,focus(1),focus(2),'r.','tag','ra');
        
    case 'RAcirc_leak2'
        M      = scen(2);
        C0     = scen(3:5);
        normal = scen(6:8);
        [~,jj] = min(abs(source.rclust.m-M));
        radio  = source.rclust.radio(jj);
        if radio>0
            aux    = normal+rand(1,3);
            v1     = cross(normal,aux); v1 = v1/norm(v1);
            v2     = cross(normal,v1);  v2 = v2/norm(v2);
            Ntheta = 50;
            theta  = linspace(0,2*pi,Ntheta);
            vert = zeros(Ntheta,3);
            for i=1:Ntheta
                th = theta(i);
                vert(i,:) =C0+radio*(v1*cos(th)+v2*sin(th));
            end
            vert = xyz2gps(vert,ellip);
            patch(ax,...
                'faces',1:Ntheta,...
                'vertices',vert(:,1:2),...
                'facecolor',pinkrgb,...
                'edgecolor','none',...
                'facealpha',0.5,...
                'tag','ra')
        end
        focus = xyz2gps(C0,ellip);
        plot(ax,focus(1),focus(2),'r.','tag','ra');        
        
    case 'RArect_rigid'
end