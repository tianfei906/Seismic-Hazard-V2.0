function [CMSout]=run_funcCMS(Rbin,Mbin,sources,deagg2,param)

Nsource = numel(sources);
deagg   = vertcat(deagg2{1,1,1,:});
lambda2 = nansum(deagg(:,3));
param   = permute(param,[4 1 2 3]);
Mbar    = nansum(deagg(:,1).*deagg(:,3))/lambda2;
Rbar    = nansum(deagg(:,2).*deagg(:,3))/lambda2;

indsource = zeros(0,2);
for i=1:Nsource
    if ~isempty(param{i})
        if isa(param{i}{1},'function_handle')
            nscen = numel(param{i}{5}{1});
        else
            nscen = numel(param{i}{1});
        end
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
DG     = DG(1,:);
% finds the scenario closest to the Mbar,Rbar
Mdiff     = abs((DG(:,1)-Mbar)); iM=Mdiff==min(Mdiff); DG=DG(iM,:);
Rdiff     = abs((DG(:,2)-Rbar)); iR=Rdiff==min(Rdiff); DG=DG(iR,:);
pkd       = DG(3);
sptr      = DG(4);
eptr      = DG(5);
param     = param{sptr};

if isa(param{1},'function_handle')
    Ndepend  = length(param)/3;
    ind3     = (1:Ndepend)+Ndepend;
    iptrs    = getIMptrs(0.01,param(ind3));
    ind4     = iptrs+2*Ndepend;
    
    for ind5=2*Ndepend+1:3*Ndepend
        Np        = numel(param{ind5});
        Ns        = numel(param{ind5}{1});
        for i=1:Np
            if numel(param{ind5}{i})==Ns
                param{ind5}{i}=param{ind5}{i}(eptr);
            end
        end
    end
    
    
    Mavg      = param{ind4}{1};
    Ravg      = param{ind4}{2};
    
else
    Np        = numel(param);
    Ns        = numel(param{1});
    for i=1:Np
        if numel(param{i})==Ns
            param{i}=param{i}(eptr);
        end
    end
    Mavg  = param{1};
    Ravg  = param{2};
end

CMSout.dchart = dchart;
CMSout.param  = param;
CMSout.gmmfun = sources(sptr).gmm.handle;
CMSout.pkd    = pkd;
CMSout.M      = Mavg;
CMSout.R      = Ravg;

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


