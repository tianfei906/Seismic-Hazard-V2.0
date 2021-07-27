function[sys]=sh_updatesource(handles)

sys = handles.sys;
opt = handles.opt;
geom   = handles.po_region.Value;
index  = handles.P3_tableindex;
source = handles.sys.source{geom}{index};
sys.labelG{geom}{index}=handles.P3_table.Data{index,2};

% label
source.txt=handles.P3_table.Data{index,2};

% mechanism
switch handles.P3_table.Data{index,3}
    case 'Interface'  , source.num(1)=1;
    case 'Intraslab'  , source.num(1)=2;
    case 'Crustal'    , source.num(1)=3;
    case 'Background' , source.num(1)=8;
end

% rake angle
source.num(2)=handles.P3_table.Data{index,4};

% rupture area model
switch handles.P3_table.Data{index,5}
    case 'null'                    , source.num(3)=1;
    case 'wc1994'                  , source.num(3)=2;
    case 'ellsworth'               , source.num(3)=3;
    case 'hanksbakun2001'          , source.num(3)=4;
    case 'somerville1999'          , source.num(3)=5;
    case 'wellscoppersmithr1994'   , source.num(3)=6;
    case 'wellscoppersmithss1994'  , source.num(3)=7;
    case 'strasser2010'            , source.num(3)=8;
end

% RA standard deviation
source.num(4)=handles.P3_table.Data{index,6};

% GMM type
source.num(5)=handles.P3_table.Data{index,7};

switch source.sourcetype
    case 1
        source.num(6)=str2double(handles.P3_e1.String);%strike
        source.num(7)=str2double(handles.P3_e2.String);%dip
        source.vert  =cell2mat(handles.P3_vertices.Data);
        delete(sys.source{geom}{index}.handle_edge)
        delete(sys.source{geom}{index}.handle_txt)
    case 2
        data =cell2mat(handles.P3_vertices.Data);
        Nnodes=size(data,1);
        source.vptr = 1:Nnodes;
        source.vert = [data;nan(1,3)];
        lmax = source.num(7);
        nref = source.num(8);
        pv   = gps2xyz(data,opt.ae);
        [xyzmj,connj,areamj,hypmj]=mesh_line1(pv,lmax,nref);
        source.xyzm = xyzmj;
        source.center=mean(data,1);
        source.conn = connj;
        source.aream=areamj;
        source.hypm=hypmj;
        delete(sys.source{geom}{index}.handle_edge)
        delete(sys.source{geom}{index}.handle_mesh)
        delete(sys.source{geom}{index}.handle_txt)
        
        source.num(6)=str2double(handles.P3_e1.String);
        source.num(7)=str2double(handles.P3_e2.String);
        source.num(8)=str2double(handles.P3_e3.String);
         
    case 3.1
        data =cell2mat(handles.P3_vertices.Data);
        Nnodes=size(data,1);
        source.vptr = 1:Nnodes;
        source.vert = [data;data(1,:);nan(1,3)];
        lmax = str2double(handles.P3_e2.String);
        nref = str2double(handles.P3_e3.String);
        pv   = gps2xyz(data,opt.ae);
        s3   = std(data(:,3));
        [xyzmj,connj,areamj,hypmj]=mesh_area1(pv,s3,lmax,nref,opt.ae);
        source.xyzm = xyzmj;
        source.center=mean(data,1);
        source.conn = connj;
        source.aream=areamj;
        source.hypm=hypmj;
        delete(sys.source{geom}{index}.handle_depth)
        delete(sys.source{geom}{index}.handle_edge)
        delete(sys.source{geom}{index}.handle_mesh)
        delete(sys.source{geom}{index}.handle_txt)
        
        source.num(6)=str2double(handles.P3_e1.String);  % Length
        source.num(9)=str2double(handles.P3_e2.String);  % Lmax
        source.num(10)=str2double(handles.P3_e3.String); % Nref
        
        
    case 4
    case 5
end

sys.source{geom}{index}=source;
sys = sh_plot_geometry_PSHA(handles.P3_ax1,handles.P6_ax1,sys,opt,geom,index);

sys.source{geom}{index}.handle_depth.Visible = handles.po_depth.Checked;
sys.source{geom}{index}.handle_mesh.Visible  = handles.po_sourcemesh.Checked;
sys.source{geom}{index}.handle_edge.Visible  = handles.po_sources.Checked;
sys.source{geom}{index}.handle_txt.Visible   = handles.SourceLabels.Checked;


 