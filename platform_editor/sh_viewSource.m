function[]=sh_viewSource(sys,vertices,str,edi,geomptr,index)
ch = findall(vertices.Parent,'tag','text59');
ch.String='Source Vertices';
set(str,'visible','off');
set(edi,'string','','value',1,'style','edit','visible','off');

source =sys.source{geomptr}{index};
num  = source.num;
Panel3=vertices.Parent;
addvertex=findall(Panel3,'tag','P3_addvertex');
delvertex=findall(Panel3,'tag','P3_deletevertex');

addvertex.Visible='on';
delvertex.Visible='on';

switch source.sourcetype
    case 1
        str(1).Visible='on';str(1).String='Strike (°)';
        str(2).Visible='on';str(2).String='Dip (°)';
        edi(1).Visible='on';edi(1).String=num(6);
        edi(2).Visible='on';edi(2).String=num(7);
        vertices.Data = num2cell(source.vert);
        
    case 2
        str(1).Visible='on';str(1).String='Dip (°)';
        str(2).Visible='on';str(2).String='Lmax (km)';
        str(3).Visible='on';str(3).String='Nref';
        edi(1).Visible='on';edi(1).String=num(6);
        edi(2).Visible='on';edi(2).String=num(7);
        edi(3).Visible='on';edi(3).String=num(8);
        vertices.Data = num2cell(source.vert(1:end-1,:));
        
    case 3.1
        str(1).Visible='on';str(1).String='Length (km)';
        str(2).Visible='on';str(2).String='Lmax (km)';
        str(3).Visible='on';str(3).String='Nref';
        str(4).Visible='on';str(4).String='Avg. Dist (km)';
        str(5).Visible='on';str(5).String='Boundaries';        
        edi(1).Visible='on';edi(1).String=num(6);
        edi(2).Visible='on';edi(2).String=num(9);
        edi(3).Visible='on';edi(3).String=num(10);
        edi(4).Visible='on';edi(4).String=num(11);        
        edi(5).Visible='on';
        edi(5).Style='popupmenu';
        edi(5).String={'leak','rigid'};
        edi(5).Value=num(12)+1;
        vertices.Data = num2cell(source.vert(1:end-2,:));
        
    case 3.2
        ch.String='Source trace';
        str(1).Visible='on';str(1).String='Dip (°)';
        str(2).Visible='on';str(2).String='USD (km)';
        str(3).Visible='on';str(3).String='LSD (km)';
        str(4).Visible='on';str(4).String='Lmax (km)';
        str(5).Visible='on';str(5).String='Nref';
        str(6).Visible='on';str(6).String='Avg. Dist (km)';
        str(7).Visible='on';str(7).String='Boundaries';        
        edi(1).Visible='on';edi(1).String=num(6);
        edi(2).Visible='on';edi(2).String=num(7);
        edi(3).Visible='on';edi(3).String=num(8);
        edi(4).Visible='on';edi(4).String=num(9);
        edi(5).Visible='on';edi(5).String=num(10);
        edi(6).Visible='on';edi(6).String=num(11);        
        edi(7).Visible='on';
        edi(7).Style='popupmenu';
        edi(7).String={'leak','rigid'};
        edi(7).Value=num(12)+1;
        vert = source.vert(1:end-2,1:2);
        vert = vert(1:end/2,:);
        vertices.Data = vert;
        
        
    case 3.3 % matfile
        str(1).Visible='on';str(1).String='Avg. Dist (km)';
        str(2).Visible='on';str(2).String='Boundaries';
        str(3).Visible='on';str(3).String='Matfile';        
        edi(1).Visible='on';edi(1).String=num(11);        
        edi(2).Visible='on';
        edi(2).Style='popupmenu';
        edi(2).String={'leak','rigid'};
        edi(2).Value=num(12)+1;
        edi(3).Visible='on';
        edi(3).String=source.adp{1};
        vertices.Data = source.vert(1:end-2,:);
        addvertex.Visible='off';
        delvertex.Visible='off';
        
    case 4
        str(1).Visible='on';str(1).String='Strike (°)';
        str(2).Visible='on';str(2).String='Dip (°)';
        str(3).Visible='on';str(3).String='Length (km)';
        str(4).Visible='on';str(4).String='Width (km)';
        str(5).Visible='on';str(5).String='RA aspect ratio ';
        str(6).Visible='on';str(6).String='Avg. Dist (km)';        
        edi(1).Visible='on';edi(1).String=num(6);
        edi(2).Visible='on';edi(2).String=num(7);
        edi(3).Visible='on';edi(3).String=num(8);
        edi(4).Visible='on';edi(4).String=num(9);
        edi(5).Visible='on';edi(5).String=num(10);
        edi(6).Visible='on';edi(6).String=num(11);
        vertices.Data = source.vert(1:end-2,:);
        
    case 5
        str(1).Visible='on';str(1).String='Lmax (km)';
        str(2).Visible='on';str(2).String='Nref';
        str(3).Visible='on';str(3).String='Thick (km)';
        str(4).Visible='on';str(4).String='Slices';        
        edi(1).Visible='on';edi(1).String=num(6);
        edi(2).Visible='on';edi(2).String=num(7);
        edi(3).Visible='on';edi(3).String=num(8);
        edi(4).Visible='on';edi(4).String=num(9);
        vertices.Data = source.vert(1:end-2,:);
end
