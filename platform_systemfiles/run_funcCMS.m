function [CMSout]=run_funcCMS(Rbin,Mbin,sources,deagg2,param)

Nsource = numel(sources);
deagg   = vertcat(deagg2{1,1,1,:});
lambda2 = sum(deagg(:,3));
param   = permute(param,[4 1 2 3]);
Mbar    = sum(deagg(:,1).*deagg(:,3))/lambda2;
Rbar    = sum(deagg(:,2).*deagg(:,3))/lambda2;

indsource = zeros(0,2);
for i=1:Nsource
    if ~isempty(param{i})
        nscen = numel(param{i}{1});
        newind   = [i*ones(nscen,1),(1:nscen)'];
        indsource=[indsource;newind]; %#ok<AGROW>
    end
end

% build deaggregation chart 'dchart'
Rcenter   = mean(Rbin,2);
Mcenter   = mean(Mbin,2);
dchart    = deagghazard({deagg},lambda2,Mcenter,Rcenter);

ind1 = and(Mbin(:,1)<Mbar,Mbin(:,2)>Mbar);
ind2 = and(Rbin(:,1)<Rbar,Rbin(:,2)>Rbar);

MBIN = Mbin(ind1,:);
RBIN = Rbin(ind2,:);
ind  = (deagg(:,1)>=MBIN(1)).*(deagg(:,1)<=MBIN(2)).*...
       (deagg(:,2)>=RBIN(1)).*(deagg(:,2)<=RBIN(2))==1;
DG     = [deagg(ind,:),indsource(ind,:)];

% finds the scenario closest to the Mbar,Rbar
Mdiff     = abs((DG(:,1)-Mbar)); iM=Mdiff==min(Mdiff); DG=DG(iM,:);
Rdiff     = abs((DG(:,2)-Rbar)); iR=Rdiff==min(Rdiff); DG=DG(iR,:);
pkd       = DG(3);
sptr      = DG(4);
eptr      = DG(5);
param     = param{sptr};
Np        = numel(param);
Ns        = numel(param{1});
for i=1:Np
    if numel(param{i})==Ns
        param{i}=param{i}(eptr);
    end
end

CMSout.dchart = dchart;
CMSout.param  = param;
CMSout.gmmfun = sources(sptr).gmm.handle;
CMSout.pkd    = pkd;
CMSout.M      = param{1};
CMSout.R      = param{2};
switch sources(sptr).numgeom(1)
    case 1,CMSout.mech='interface';
    case 2,CMSout.mech='intraslab';
    case 3,CMSout.mech='crustal';
end

sof =sources(sptr).numgeom(2);
if isnumeric(sof)
    CMSout.sof = rake2sof(sof);
else
    CMSout.sof = sof;
end


