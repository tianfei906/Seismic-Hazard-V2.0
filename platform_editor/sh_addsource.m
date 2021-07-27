function[sys]=sh_addsource(handles)

sys = handles.sys;
opt = handles.opt;
n   = handles.po_region.Value;

[s,v] = listdlg('PromptString','Select source type:',...
    'SelectionMode','single',...
    'ListString',{'Point source','Line Source','Area 1 (3D-point cloud)','Area1 (Surface Trace)','Area1 (mat file)','Area2','Volume1'});
if v==0
    return
end

XLIM=handles.P3_ax1.XLim;
YLIM=handles.P3_ax1.YLim;
newsource = createObj(9.1);
switch s
    case 1
        newsource.sourcetype=1;
        newsource.txt  =  'NewPoint';
        newsource.num  = [1   -90     2     0     1     0    90];
        newsource.vptr = [1 1];
        newsource.vert = [mean(XLIM),mean(YLIM),0];
    case 2
        newsource.sourcetype=2;
        newsource.txt  =  'NewLine';        
        newsource.num  = [1 -90 2 0 1 90 5 0];
        newsource.vptr = [1 2];
        DY=diff(YLIM)/20;
        lmax = 5;
        nref = 0;
        pv = [mean(XLIM),mean(YLIM)-DY,0;mean(XLIM),mean(YLIM)+DY,0];
        newsource.vert=[pv;nan(1,3)];
        pv = gps2xyz(pv,handles.opt.ae);
        [xyzmj,connj,areamj,hypmj]=mesh_line1(pv,lmax,nref);
        newsource.xyzm = xyzmj;
        newsource.center=[mean(XLIM) mean(YLIM) 0];
        newsource.conn = connj;
        newsource.aream=areamj;
        newsource.hypm=hypmj;
    case 3
        newsource.sourcetype=3.1;
        newsource.txt= 'NewArea';
        newsource.num=[1  -90  2 0 1 55 NaN   NaN 5 0 0 1];
        newsource.vptr=[1 4];
        DX=diff(XLIM)/20;
        DY=diff(YLIM)/20;
        lmax = 5;
        nref = 0;
        pv = [
            mean(XLIM)-DX,mean(YLIM)-DY, 0;
            mean(XLIM)+DX,mean(YLIM)-DY, 0;
            mean(XLIM)+DX,mean(YLIM)+DY, 0;
            mean(XLIM)-DX,mean(YLIM)+DY, 0];
        newsource.vert = [pv;pv(1,:);nan(1,3)];
        pv = gps2xyz(pv,handles.opt.ae);
        [xyzmj,connj,areamj,hypmj]=mesh_area1(pv,0,lmax,nref);
        newsource.xyzm  = xyzmj;
        newsource.center= [mean(XLIM) mean(YLIM) 0];
        newsource.conn  = connj;
        newsource.aream = areamj;
        newsource.hypm  = hypmj;

    case 4
        newsource.sourcetype=3.2;
        newsource.txt= 'NewArea';
        newsource.num=[1 -90 2 0 1 45 1 20 2 0 0 0];
        DIP  = 45;
        USD  = 0;
        LSD  = 20;
        lmax = 5;
        nref = 0;
        DY   = diff(YLIM)/10;
        lv   = [mean(XLIM) mean(YLIM)-DY;
                mean(XLIM) mean(YLIM)+DY];
        newsource.vptr=[1 2];
        newsource.vert=[lv;flipud(lv);lv(1,:);nan(1,2)];
        pv   = area2convert(lv,DIP,USD,LSD,opt.ae);
        pv = gps2xyz(pv,handles.opt.ae);
        [xyzmj,connj,areamj,hypmj]=mesh_area1(pv,0,lmax,nref);
        newsource.xyzm   = xyzmj;
        newsource.center = [mean(XLIM) mean(YLIM) 0];
        newsource.conn   = connj;
        newsource.aream  = areamj;
        newsource.hypm   = hypmj;

    case 5
        [filename, pathname] = uigetfile({'*.mat'},'Pick source file');
        newsource.sourcetype=3.3;
        newsource.txt= strrep(filename,'.mat','');
        load(fullfile(pathname,filename),'geom')
        newsource.adp    = {filename};
        newsource.num    = [1 -90 2 0 1 NaN NaN NaN NaN NaN 30 1];
        newsource.vptr   = [1,size(geom.vertices,1)];
        newsource.vert   = [geom.vertices;geom.vertices(1,:);nan(1,3)];
        newsource.xyzm   = geom.xyzm; %#ok<*AGROW>
        newsource.center = mean(geom.vertices,1);
        newsource.conn   = geom.conn;
        newsource.aream  = geom.aream;
        newsource.hypm   = geom.hypm;
        
    case 6
        newsource.sourcetype=4;
        newsource.txt= 'NewArea';
        newsource.num=[1 -90 2 0 1 0 90 25 10 2 1];
        newsource.vptr=[1 4];
        DY=diff(YLIM)/20;
        pv = [
            mean(XLIM),mean(YLIM)-DY, 0;
            mean(XLIM),mean(YLIM)-DY, -10;
            mean(XLIM),mean(YLIM)+DY, -10;
            mean(XLIM),mean(YLIM)+DY, 0];
        
        newsource.vert = [pv;pv(1,:);nan(1,3)];
        pv = gps2xyz(pv,handles.opt.ae);
        [xyzmj,connj,areamj,hypmj]=mesh_area1(pv,0,inf,0);
        newsource.xyzm   = xyzmj;
        newsource.center = hypmj;
        newsource.conn   = connj;
        newsource.aream  = areamj;
        newsource.hypm   = hypmj;
    case 7
        newsource.sourcetype=5;
        newsource.txt= 'NewVolume';
        newsource.num=[1 -90 1 0 1 2 0 10 3];
        newsource.vptr=[1 4];
        DX=diff(XLIM)/20;
        DY=diff(YLIM)/20;
        lmax = 5;
        nref = 0;
        pv = [
            mean(XLIM)-DX,mean(YLIM)-DY, -5;
            mean(XLIM)+DX,mean(YLIM)-DY, -5;
            mean(XLIM)+DX,mean(YLIM)+DY, -5;
            mean(XLIM)-DX,mean(YLIM)+DY, -5];
        newsource.vert = [pv;pv(1,:);nan(1,3)];
        pv = gps2xyz(pv,handles.opt.ae);
        [xyzmj,connj,areamj,hypmj]=mesh_area5(pv,0,lmax,nref,10,3,opt.ae);
        newsource.xyzm  = xyzmj;
        newsource.center= [mean(XLIM) mean(YLIM) 0];
        newsource.conn  = connj;
        newsource.aream = areamj;
        newsource.hypm  = hypmj;
end

% stores newsource
sys.labelG{n}{end+1}=newsource.txt;
sys.numG{n}(end+1)  =newsource.sourcetype;
sys.source{n}{end+1}=newsource;
index = numel(sys.labelG{n});
sys = sh_plot_geometry_PSHA(handles.P3_ax1,handles.P6_ax1,sys,opt,n,index);

sys.source{n}{index}.handle_depth.Visible = handles.po_depth.Checked;
sys.source{n}{index}.handle_mesh.Visible  = handles.po_sourcemesh.Checked;
sys.source{n}{index}.handle_edge.Visible  = handles.po_sources.Checked;
sys.source{n}{index}.handle_txt.Visible   = handles.SourceLabels.Checked;

