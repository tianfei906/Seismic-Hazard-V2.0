function [M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate,C]=circ_leak2(xyz,source,Rmetric,maxdist,ae)

mag    = source.mscl(:,1);
rateM  = source.mscl(:,2);
nM     = size(mag,1);
mlist  = source.rclust.m(:);
C      = source.rclust.C;
n      = source.rclust.normal;
dip    = source.dip;
Rhyp    = -999;
Rjb     = -999;
Rx      = -999;
Ry0     = -999;
Zhyp    = -999;
Ztor    = -999;

cptr    = zeros(nM,1);
for i=1:nM
    [~,cptr(i)]=min(abs(mlist-mag(i)));
end
nC   = size(source.rclust.C,1);

% Magnitude
M = repmat(mag',nC,1);
M = M(:);

% Distance to rupture plane, Rrup
% rupArea = source.rclust.RA;
Rrup    = zeros(nC,nM);
on      = ones(nC,1);
for i=1:nM
    [~,IND]   = min(abs(source.rclust.m-mag(i)));
    ra        = source.rclust.RA(IND);
    Rrup(:,i) = dist_rrup(xyz,C,ra*on,n);
end
Rrup=Rrup(:);

% Hypocentral Distance, Rhyp
if Rmetric(2) || nargout==3
	Rhyp = sum((xyz-C).^2,2).^0.5;
    Rhyp = repmat(Rhyp,nM,1);
    Rhyp(Rrup>maxdist)=[];
end

% Joyner Boore Distance, Rjb
if Rmetric(3)
    Rjb = zeros(nC,nM);
    for i=1:nM
        [~,IND]  = min(abs(source.rclust.m-mag(i)));
        ra       = source.rclust.RA(IND);
        Rjb(:,i) = dist_rjb(xyz,C,ra*on,n,dip,ae);
    end
    Rjb=Rjb(:);
    Rjb(Rrup>maxdist)=[];
end

% Focal Depth, zhyp
if Rmetric(8) || nargout==3
    Zhyp = dist_zhyp(xyz,source.rclust.C,ae);
    Zhyp = repmat(Zhyp,nM,1);
    Zhyp(Rrup>maxdist)=[];
end

% Depth to top of rupture, ztor
if Rmetric(9)
    Ztor = zeros(nC,nM);
    for i=1:nM
        [~,IND]   = min(abs(source.rclust.m-mag(i)));
        ra        = source.rclust.RA(IND);
        Ztor(:,i) = dist_ztor(xyz,C,ra*on,n,dip,ae);
    end    
    Ztor=Ztor(:);
    Ztor(Rrup>maxdist)=[];
end

% rate of scenarios
rate = source.rclust.rateR*rateM';
rate = rate(:)';

rate(Rrup>maxdist) = [];
M(Rrup>maxdist)    = [];

if nargout==10
    C = repmat(C,nM,1);
    C(Rrup>maxdist,:)  = [];
else
    C=[];
end

Rrup(Rrup>maxdist) = [];

