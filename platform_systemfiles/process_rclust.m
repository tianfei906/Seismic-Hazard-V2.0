function[rclust]=process_rclust(sys,area1,i)
%#ok<*AGROW>
%% process area6 sourcess
np             = numel(area1.txt);
isrigid        = find(area1.num(:,11)'==1);
rclust(1:np,1) = struct('idx',[],'C',[],'m',[],'RA',[],'rateR',[],'radio',[]);

for j=isrigid
    %% source clustering
    ind   = area1.mptr(j,1):area1.mptr(j,2);
    aream = area1.aream(ind);
    hypm  = area1.hypm(ind,:);
    atot  = sum(aream);
    
    Nc      = min([200,ceil(atot/(pi*15^2)),numel(aream)]);
    [idx,C] = kmeans(hypm,Nc);
    
    areac = zeros(Nc,1);
    for jj=1:Nc
        [~,jind] =min(sum((hypm-C(jj,:)).^2,2));
        C(jj,:)  =hypm(jind,:);
        areac(jj)=sum(aream(idx==jj));
    end
    rateR = areac/sum(areac);
    rclust(j).idx   = idx;
    rclust(j).C     = C;
    rclust(j).rateR = rateR;
    
    
    %% computes magnitudes
    mlist = [];
    RA    = [];
    RAmodel=area1.num(j,3);
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
        RAii   = max(RAii,0.1);
        mlist  = [mlist;mi]; 
        RA     = [RA;RAii];
    end
    
    % prepara RA and mlist vector
    aux  = sortrows([RA,mlist],[1,2]);
    aux  = unique(aux,'rows');
    II   = find(diff(aux(:,1))==0,1);
    if ~isempty(II)
        aux(II+1,:)=[];
    end
    RA    = aux(:,1);
    mlist = aux(:,2);
    
    if RAmodel==1 % null model
        nRA         =1;
        RA          =0.1;
        m           =Inf;
    else
        IND         = find(RA<min(aream));
        if numel(RA)>1
            mlist(IND)  = interp1(RA,mlist,min(aream));
            RA(IND)     = min(aream);
            m           = unique(mlist);
            RA          = unique(RA);
            nRA         = length(RA);
        else
            m           = mlist;
            nRA         = 1;
        end
        
    end
    
    rclust(j).m     = m';
    rclust(j).RA    = RA';
    rclust(j).radio = zeros(Nc,nRA);
    for ii=1:nRA
        rclust(j).radio(:,ii) = buildRRA(hypm,aream,C,RA(ii));
    end
end 
