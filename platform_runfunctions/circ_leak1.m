function [M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,rate]=circ_leak1(xyz,source,Rmetric,maxdist,ae)

RA      = source.numgeom(3:4);
M       = source.mscl(:,1);
nM      = size(M,1);
rf      = source.hypm;
nR      = size(rf,1);
[iR,iM] = meshgrid(1:nR,1:nM);
M       = M(iM(:));
rf      = rf(iR(:),:);
dip     = source.dip;
Rhyp    = -999;
Rjb     = -999;
Rx      = -999;
Ry0     = -999;
Zhyp    = -999;
Ztor    = -999;

%% EVALUATES RUPTURE AREA AND SOURCE NORMAL VECTOR
rupArea   = rupRelation(M,0,RA(1));
if size(source.normal,1)==1
    n = zeros(length(iR(:)),3);
    n(:,1)=source.normal(1);
    n(:,2)=source.normal(2);
    n(:,3)=source.normal(3);
else
    n         = source.normal(iR(:),:);
end
rateM     = source.mscl(iM(:),2);
rateR     = source.aream(iR(:))/sum(source.aream);
rate      = (rateM.*rateR/(rateM'*rateR))';

Rrup  = dist_rrup(xyz,rf,rupArea,n);
if Rmetric(2)
    Rhyp = dist_rhyp(xyz,rf);
    Rhyp(Rrup>maxdist)=[];
end
if Rmetric(3)
    Rjb = dist_rjb(xyz,rf,rupArea,n,dip,ae);
    Rjb(Rrup>maxdist)=[];
end
if Rmetric(8)
    Zhyp = dist_zhyp(xyz,rf,ae);
    Zhyp(Rrup>maxdist)=[];
end
if Rmetric(9)
    Ztor = dist_ztor(xyz,rf,rupArea,n,dip,ae);
    Ztor(Rrup>maxdist)=[];
end

rate(Rrup>maxdist)=[];
M(Rrup>maxdist)   =[];

% if nargout==10
%     C = repmat(C,nM,1);
%     C(Rrup>maxdist,:)  = [];
% else
%     C=[];
% end

Rrup(Rrup>maxdist)=[];

