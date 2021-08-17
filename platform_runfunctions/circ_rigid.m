function [M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate,C]=circ_rigid(xyz,source,Rmetric,maxdist,ae)

hypm    = source.hypm; % source centroids
mag     = source.mscl(:,1);
rateM   = source.mscl(:,2);
nM      = size(mag,1);
mlist   = source.rclust.m(:);
C       = source.rclust.C;
radii2  = source.rclust.radio.^2;
dip     = source.dip;
strike  = source.strike;
cptr    = zeros(nM,1);
Rhyp    = -999;
Rx      = -999;
Ry0     = -999;
Zhyp    = -999;
Ztor    = -999;

for i=1:nM
    [~,cptr(i)]=min(abs(mlist-mag(i)));
end
nC   = size(source.rclust.C,1);
rrup = zeros(nC,nM);

% Magnitude
M = repmat(mag',nC,1);
M = M(:);

% Hypocentral Distance, rhyp
if Rmetric(2)
    Rhyp = sum((xyz-C).^2,2).^0.5;
    Rhyp = repmat(Rhyp,nM,1);
end

% Joyner Boore Distance, rjb
if Rmetric(3)
    rg  = source.ghypm(:,1:2);
    rjb = zeros(nC,nM);
end

% Computes strike vector of
if dip>0
    [~,imax]=max(source.ghypm(:,3));
    [~,imin]=min(source.ghypm(:,3));
    vB  = hypm(imax,:);
    vA  = hypm(imin,:);
else
    [~,imax]=max(source.ghypm(:,1));
    [~,imin]=min(source.ghypm(:,1));
    vB  = hypm(imax,:);
    vA  = hypm(imin,:);
end

if Rmetric(6) && dip<90
    rx = zeros(nC,nM);
end

% Focal Depth, zhyp
if Rmetric(8)
    Zhyp = dist_zhyp(xyz,source.rclust.C,ae);
    Zhyp = repmat(Zhyp,nM,1);
end

% Depth to top of rupture, ztor
if Rmetric(9)
    TOR  = abs(source.ghypm(:,3));
    ztor = zeros(nC,nM);
end

% rate of scenarios
rate = source.rclust.rateR*rateM';
rate = rate(:)';
on   = [1;1;1];
% Rrup & Rjb & Ztor
for i=1:nM
    Rrup  = nan(nC,1);
    Rjb   = nan(nC,1);
    Ztor  = nan(nC,1);
    Rx    = nan(nC,1);
    
    for j=1:nC
        Cj      = C(j,:);
        IND     = (hypm-Cj).^2*on<radii2(j,cptr(i));
        hypmj   = hypm(IND,:);
        % Rrup
        
        Rrup(j) = min(((xyz-hypmj).^2*on)).^0.5;
        
        % Rjb
        if Rmetric(3) && sum(IND)>2 && dip<90
            P      = rg(IND,:);
            kk     = convhull(P);
            if fastpolyarea(P(kk,1),P(kk,2))>0
                gxyz0  = xyz2gps(xyz,ae);
                [d,x,y]= p_poly_dist(gxyz0(1),gxyz0(2),P(kk,1),P(kk,2));
                if d>0
                    rgp    = gps2xyz([x y 0],ae);
                    Rjb(j) = norm(xyz-rgp);
                else
                    Rjb(j) = 0;
                end
            else
                xyzsup = gps2xyz([rg(IND,:) rg(IND,1)*0],ae);
                d      = sum((xyzsup-xyz).^2,2).^0.5;
                Rjb(j) = min(d);
            end
            
        elseif Rmetric(3) && or(sum(IND)<2,dip==90)
            xyzsup = gps2xyz([rg(IND,:) rg(IND,1)*0],ae);
            d      = sum((xyzsup-xyz).^2,2).^0.5;
            Rjb(j) = min(d);
        end
        
        % Rx
        if Rmetric(6) && dip<90 && dip>0
            rgx  = source.ghypm(IND,:);
            [~,mrg] = max(rgx(:,3));
            B  = rgx(mrg,:).*[1 1 0];
            cp = norm(cross(xyz-B,strike));
            pp   =sign(dot(xyz-B,vA-vB));
            Rx(j)= pp*cp(end);
        end
        
        % Ztor
        if Rmetric(9)
            Ztor(j) = min(TOR(IND));
        end
    end
    rrup(:,i) = Rrup;
    
    if Rmetric(3),  rjb(:,i)   = Rjb; end
    if Rmetric(6),  rx(:,i)    = Rx; end
    if Rmetric(9),  ztor(:,i)  = Ztor; end
end

Rrup=rrup(:);

if Rmetric(2)
   Rhyp(Rrup>maxdist)=[]; 
end

if Rmetric(3)
    Rjb  = rjb(:);
    Rjb(Rrup>maxdist)=[];
else
    Rjb = -999;
end

if Rmetric(6) && dip<90 && dip>0
    Rx   = rx(:);
    Rx(Rrup>maxdist)=[];
elseif Rmetric(6) && or(dip==90,dip==0)
    Rx   = rjb(:);
    Rx(Rrup>maxdist)=[];
elseif ~Rmetric(6)
    Rx = -999;
end

if Rmetric(8)
    Zhyp(Rrup>maxdist)=[];
end

if Rmetric(9)
    Ztor = ztor(:);
    Ztor(Rrup>maxdist)=[];
end

rate(Rrup>maxdist)=[];
M(Rrup>maxdist)   =[];

if nargout==10
    C = repmat(C,nM,1);
    C(Rrup>maxdist,:)  = [];
else
    C=[];
end

Rrup(Rrup>maxdist)=[];

