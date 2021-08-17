function [M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate]=rect_rigid(r0,source,Rmetric,maxdist,ae)

if isempty(ae)
    r0=r0([2 1 3]);
end

Area    = source.aream;
MM      = source.mscl(:,1);
rateM   = source.mscl(:,2);
RA      = source.numgeom(3:4);
L       = sum(abs(source.p(:,1)))/2;%source.numgeom(8);
dip     = source.numgeom(7);

if source.numgeom(9)==-999
    width = Area/L;
else
    width   = source.numgeom(9);
end

aratio  = source.numgeom(10);
spacing = source.numgeom(11);

Rhyp   = [];
Rjb    = [];
Rx     = [];
Ry0    = [];
Zhyp   = [];
Ztor   = [];

%% RUPTURE AREA AND SCENARIOS
if RA(2)==0
    rupArea   = rupRelation(MM,0,RA(1));
else
    NA = 25;
    x  = linspace(-2,2,NA)';
    dx = x(2)-x(1);
    rateA = normcdf(x+dx/2,0,1)-normcdf(x-dx/2,0,1);
    rateA = rateA/sum(rateA);
    rupArea = zeros(length(MM),NA);
    for i=1:NA
        rupArea(:,i) = rupRelation(MM,x(i),RA(1));
    end
    rupArea = min(rupArea,Area);
    [iM,iA]=meshgrid(1:length(MM),1:length(x));
    MM     = MM(iM(:));
    rateM = rateM(iM(:)).*rateA(iA(:));
    rupArea = rupArea';
    rupArea = rupArea(iA(:));
end

rupWidth  = min(sqrt(rupArea/aratio),width);  % preserve area at expense of aspect ratio
rupLength = min(rupArea./rupWidth,L);     % preserve area at expense of aspect ratio

nM    = length(MM);
Rrup  = cell(1,nM);
if Rmetric(2),  Rhyp  = cell(1,nM);end
if Rmetric(3),  Rjb   = cell(1,nM);end
if Rmetric(6),  Rx    = cell(1,nM);end
if Rmetric(7),  Ry0   = cell(1,nM);end
if Rmetric(8),  Zhyp  = cell(1,nM);end
if Rmetric(9),  Ztor  = cell(1,nM);end

p     = source.p;
pmean = source.hypm;
rot   = source.normal;

geom.pmean  = pmean;
geom.normal =-rot(:,3)';
geom.rot    = rot;
geom.dip    = dip;

for i=1:nM
    RL    = rupLength(i);
    RW    = rupWidth (i);
    xmin  = p(1,1)+RL/2;
    xmax  = p(2,1)-RL/2;
    ymin  = p(2,2)+RW/2;
    ymax  = p(3,2)-RW/2;
    if xmin>xmax
        xavg = 1/2*(xmin+xmax);
        xmin = xavg;
        xmax = xavg;
    end
    
    if ymin>ymax
        yavg = 1/2*(ymin+ymax);
        ymin = yavg;
        ymax = yavg;
    end
    
    dx    = max(xmax-xmin,0);
    dy    = max(ymax-ymin,0);
    NX    = ceil(dx/spacing)+1;
    NY    = ceil(dy/spacing)+1;
    locx  = linspace(xmin,xmax,NX);
    locy  = linspace(ymin,ymax,NY);
    [locx,locy] = meshgrid(locx,locy);
    nR    = numel(locx);
    locxy = [locx(:),locy(:),zeros(nR,1)]; % Y,X,Z coordinates of
    rf      = bsxfun(@plus,pmean,locxy*rot');
    
    Rrup{i}  = dist_rrup4  (r0,rf,RW,RL,geom);
    if Rmetric(2),  Rhyp{i}  = dist_rhyp4  (r0,rf,RW,RL,geom);end %#ok<*AGROW>
    if Rmetric(3),  Rjb{i}   = dist_rjb4   (r0,rf,RW,RL,geom,ae);end
    if Rmetric(6),  Rx{i}    = dist_rx4    (r0,rf,RW,RL,geom,ae);end
    if Rmetric(7),  Ry0{i}   = dist_ry04   (r0,rf,RW,RL,geom);end
    if Rmetric(8),  Zhyp{i}  = dist_zhyp4  (r0,rf,RW,RL,geom,ae);end
    if Rmetric(9),  Ztor{i}  = dist_ztor4  (r0,rf,RW,RL,geom,ae);end
end

if Rmetric(1)==1
    M    = cell(size(Rrup));
    rate  = cell(size(Rrup));
    for i=1:nM
        nri =size(Rrup{i},1);
        M{i}=MM(i)*ones(nri,1);
        rate{i}=1/nri*ones(nri,1)*rateM(i);
    end
else
    if Rmetric(2)==1
        M    = cell(size(Rhyp));
        rate  = cell(size(Rhyp));
        for i=1:nM
            nri =size(Rhyp{i},1);
            M{i}=MM(i)*ones(nri,1);
            rate{i}=1/nri*ones(nri,1)*rateM(i);
        end
    elseif Rmetric(3)==1
        M    = cell(size(Rjb));
        rate  = cell(size(Rjb));
        for i=1:nM
            nri =size(Rjb{i},1);
            M{i}=MM(i)*ones(nri,1);
            rate{i}=1/nri*ones(nri,1)*rateM(i);
        end
    end
end

M     = vertcat(M{:});
rate  = vertcat(rate{:})';
Rrup  = vertcat(Rrup {:});
if Rmetric(2),  Rhyp  = vertcat(Rhyp {:});end
if Rmetric(3),  Rjb   = vertcat(Rjb  {:});end
if Rmetric(6),  Rx    = vertcat(Rx   {:});end
if Rmetric(7),  Ry0   = vertcat(Ry0  {:});end
if Rmetric(8),  Zhyp  = vertcat(Zhyp {:});end
if Rmetric(9),  Ztor  = vertcat(Ztor {:});end

