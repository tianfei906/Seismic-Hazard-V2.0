function[area2]=process_area2(area2,ellipsoid)

% num = mechanism gmmptr strike dip style length width rupArea aratio lmax nref
np    = size(area2.txt,1);
mptr  = zeros(np,2);
cptr  = zeros(np,2);
xyzm  = zeros(0,3);
conn  = zeros(0,4);
aream = zeros(0,1);
hypm  = zeros(0,3);
p     = zeros(4,3,np);
dsv   = zeros(3,3,np);
center = zeros(np,3);

vert  = area2.vert;
vptr  = area2.vptr;

for j=1:np
    ind  = vptr(j,1):vptr(j,2);
    pv   = gps2xyz(vert(ind,:),ellipsoid);
    center(j,:) =  mean(vert(ind,:),1);
    connshift = size(xyzm,1);
    ptrshift  = size(conn,1);
    connj     = 1:4;
    if isempty(ellipsoid.Code)
        [p(:,:,j),hypmj,Aj,dsv(:,:,j)] = rot_area3(pv(:,[2 1 3]));
    else
        [p(:,:,j),hypmj,Aj,dsv(:,:,j)] = rot_area3(pv);
    end
    xyzm = [xyzm;pv]; %#ok<*AGROW>
    cptr(j,:) = [1,size(connj,1)]+size(conn,1);
    conn = [conn;connj+connshift];
    
    aream = [aream;Aj];
    hypm = [hypm;hypmj];
    mptr(j,:)=[1,size(connj,1)]+ptrshift;
end

area2.mptr   = mptr;
area2.xyzm   = xyzm;
area2.conn   = conn;
area2.aream  = aream;
area2.hypm   = hypm;
area2.p      = p;
area2.dsv    = dsv;
area2.center = center;


function [p,hypm,area,dsv] = rot_area3(pv)

hypm      = mean(pv);
pv_mov  = bsxfun(@minus,pv,hypm);
covar   = pv_mov'*pv_mov;
[~,~,dsv] = svd(covar);
pv_rot  = pv_mov*dsv;
p       = pv_rot;
if size(p,1)==4
    sigp    = sign(p(:,1:2));
    [~,~,C] = intersect([-1 -1;1 -1;1 1;-1 1],sigp,'rows','stable');
    p       = p(C,:);
end

V1  = pv(1,:);
V2  = pv(2,:);
V4  = pv(4,:);
W   = norm(V2-V1);
L   = norm(V4-V1);
area = W*L;

