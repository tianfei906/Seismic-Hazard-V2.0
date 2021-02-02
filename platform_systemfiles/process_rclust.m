function[rclust]=process_rclust(sys,area1,i,overwrite)

%#ok<*AGROW>
%% process area6 sourcess
np             = numel(area1.txt);
rclust(1:np,1) = struct('idx',[],'C',[],'m',[],'RA',[],'rateR',[],'radio',[],'normal',[]);

% Process leaky/rigid boundaries
for j=1:np
    %% source clustering
    ind   = area1.mptr(j,1):area1.mptr(j,2); %#ok<*PFBNS>
    aream = area1.aream(ind);
    hypm  = area1.hypm(ind,:);
    
    Nc      = min([200,numel(aream)]);
    rng default
    [idx,C] = kmeans(hypm,Nc);
    
    areac   = zeros(Nc,1);
    normalc = zeros(Nc,3);
    for jj=1:Nc
        [~,jind] =min(sum((hypm-C(jj,:)).^2,2));
        C(jj,:)  =hypm(jind,:);
        areac(jj)=sum(aream(idx==jj));
        normalc(jj,:)=area1.normal(jind,:);
    end
    rateR = areac/sum(areac);
    rclust(j).idx   = idx;
    rclust(j).C     = C;
    rclust(j).rateR = rateR;
    rclust(j).normal= normalc;
    
    
    %% computes magnitudes
    mlist = [];
    RA    = [];
    RAmodel=area1.num(j,3);
    if nargin==3
        for ii=1:numel(sys.numM)
            numM   = sys.numM{ii};
            cgm    = sys.cgm{i,ii};
            mp     = cgm(j);
            mtype  = numM(mp,1);
            mptri  = numM(mp,2);
            fld    = sprintf('mrr%g',mtype);
            mrr    = sys.(fld)(ii);
            ind    = mrr.mptr(mptri,1):mrr.mptr(mptri,2);
            mi     = mrr.mdata(ind,1);
            RAii   = rupRelation(mi,0,RAmodel);
            mlist  = [mlist;mi];
            RA     = [RA;RAii];
        end
    elseif nargin==4 % magnitude overwrite
        mlist  = overwrite(j);
        RA     = rupRelation(mlist,0,RAmodel);
    end
    
    aux  = sortrows([RA,mlist],[1,2]);
    aux  = unique(aux,'rows');
    II   = find(diff(aux(:,1))==0,1);
    if ~isempty(II)
        aux(II+1,:)=[];
    end
    RA    = aux(:,1);
    mlist = aux(:,2);
    nRA   = length(RA);
    rclust(j).m     = mlist';
    rclust(j).RA    = RA';
    
    if area1.num(j,11)==1
        rclust(j).radio = zeros(Nc,nRA);
        for ii=1:nRA
            rclust(j).radio(:,ii) = buildRRA(hypm,aream,C,RA(ii));
        end
    else
        rclust(j).radio = sqrt(RA'/pi);
    end
    
end

rng shuffle
