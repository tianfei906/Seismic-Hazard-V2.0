function[area1]=process_area1(area1,ellipsoid)

%% process area1 sourcess
np    = size(area1.txt,1);
mptr  = zeros(np,2);
xyzm  = zeros(0,3);
conn  = zeros(0,4);
aream = zeros(0,1);
hypm  = zeros(0,3);
center = zeros(np,3);

num   = area1.num;
vert  = area1.vert;
vptr  = area1.vptr;

atype = sum(isnan(num),2);

for j=1:np
    connshift = size(xyzm,1);
    ptrshift  = size(conn,1);
    if atype(j)==3 % 3D poly
        lmax = num(j,9);
        nref = num(j,10);
        ind  = vptr(j,1):vptr(j,2);
        pv   = gps2xyz(vert(ind,:),ellipsoid);
        center(j,:) =  mean(vert(ind,:),1);
        s3        = std(vert(ind,3));
        [xyzmj,connj,areamj,hypmj]=mesh_area1(pv,s3,lmax,nref,ellipsoid);
    end
    
    if atype(j)==0  % trace + USD + LSD
        lmax = num(j,9);
        nref = num(j,10);
        ind  = vptr(j,1):vptr(j,2);
        pv   = gps2xyz(vert(ind,:),ellipsoid);
        center(j,:) =  mean(vert(ind,:),1);
        s3 = std(vert(ind,3));
        [xyzmj,connj,areamj,hypmj]=mesh_area1(pv,s3,lmax,nref,ellipsoid);
    end
    
    if atype(j)==5 % matfile
        load(area1.adp{j},'geom')
        center(j,:) = mean(geom.vertices,1);
        xyzmj  = geom.xyzm;
        areamj = geom.aream;
        hypmj  = geom.hypm;
        connj  = geom.conn; 
        if size(connj,2)==3
            connj = connj(:,[1 2 3 3]);
        end
    end
    
    %cptr(j,:) = [1,size(xyzmj,1)]+size(xyzm,1);
    xyzm  = [xyzm;xyzmj]; %#ok<*AGROW>
    conn  = [conn;connj+connshift];
    aream = [aream;areamj];
    hypm  = [hypm;hypmj];
    mptr(j,:)=[1,size(connj,1)]+ptrshift;
end

area1.mptr  = mptr;
area1.xyzm  = xyzm;
area1.conn  = conn;
area1.aream = aream;
area1.hypm  = hypm;

% compute normal to each subarea (segments)
Nseg   = size(hypm,1);
strike = zeros(Nseg,3);
normal = zeros(Nseg,3);
dip    = nan(Nseg,1);
for j=1:Nseg
    xyzj  = xyzm(conn(j,:),:);
    [strike(j,:),normal(j,:),dip(j,:)]=dsv_area1(xyzj,ellipsoid);
end
area1.strike = strike;
area1.normal = normal;
area1.dip    = dip;
area1.center = center;
