function[source]=buildDSHAmodel2(sys,opt,h,bptr,sptr)

if nargin==3
    % by default gets assembles 'source' for the first logic tree branch
    branch = sys.branch(1,:);
else
    branch = sys.branch(bptr,:);
end

geomptr   = branch(1);
gmpeptr   = branch(2);
msclptr   = branch(3);

point1    = sys.point1(geomptr);
line1     = sys.line1(geomptr);
area1     = sys.area1(geomptr);
area2     = sys.area2(geomptr);
volume1   = sys.volume1(geomptr);
gmmptr    = sys.gmmptr(gmpeptr,:);
gmmlib    = sys.gmmlib(gmmptr);

mrr1     = sys.mrr1(msclptr);
mrr2     = sys.mrr2(msclptr);
mrr3     = sys.mrr3(msclptr);
mrr4     = sys.mrr4(msclptr);
mrr5     = sys.mrr5(msclptr);

numG  = sys.numG{geomptr};
numM  = sys.numM{msclptr};
cgm   = sys.cgm{geomptr,msclptr};
Nsrc   = size(cgm,1);


if nargin==3
    sptr = 1:size(numG,1);
else
    sptr = sptr(:)';
end

% assembly of area sources
source(1:Nsrc,1)=createObj('sourceDSHA');
for j=sptr
    source(j,1).branch=branch;
    spt =numG(j,2);
    switch numG(j,1)
        case 1
            source(j).pfun    = @RAcirc_leak;
            source(j).numgeom = point1.num(spt,:);
            source(j).hypm    = gps2xyz(point1.vert(spt,:),opt.ellipsoid); % might need to convert
            source(j).aream   = 1;
            source(j).normal  = point1.normal(spt,:);
            source(j).gmm     = gmmlib(point1.num(spt,5));
            
        case 2
            mptr = line1.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            source(j).pfun    = @RAcirc_leak;
            source(j).numgeom = line1.num(spt,:);
            source(j).hypm    = line1.hypm(ind,:);
            source(j).aream   = line1.aream(ind);
            source(j).normal  = line1.normal(ind,:);
            source(j).gmm     = gmmlib(line1.num(spt,5));
            
        case 3
            vptr = area1.vptr(spt,:); jnd  = vptr(1):vptr(2);
            mptr = area1.mptr(spt,:); ind  = mptr(1):mptr(2);
            
            switch area1.num(spt,11)
                case 0, source(j).pfun    = @RAcirc_leak2;
                case 1, source(j).pfun    = @RAcirc_rigid;
            end
            source(j).numgeom = area1.num(spt,:);
            if numel(jnd)==4 % computes spte (surface projection of top edge)
                source(j).spte = gps2xyz(area1.vert(jnd,:),opt.ellipsoid);
            end            
            source(j).conn    = area1.conn(ind,:);
            source(j).aream   = area1.aream(ind);
            source(j).normal  = area1.normal(ind,:);
            source(j).hypm    = area1.hypm(ind,:);
            source(j).gmm     = gmmlib(area1.num(spt,5));
            source(j).rclust  = area1.rclust(spt);
            source(j).vert    = area1.vert(jnd,:);
            
        case 4
            mptr = area2.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            source(j).pfun    = @RArect_rigid;
            source(j).numgeom = area2.num(spt,:);
            source(j).hypm    = area2.hypm(ind,:);
            source(j).aream   = area2.aream(ind);
            source(j).p       = area2.p(:,:,ind);
            source(j).normal  = area2.dsv(:,:,ind);
            source(j).gmm     = gmmlib(area2.num(spt,5));
            
        case 5
            mptr = volume1.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            source(j).pfun    = @RAcirc_leak;
            source(j).numgeom = volume1.num(spt,:);
            source(j).hypm    = volume1.hypm(ind,:);
            source(j).aream   = volume1.aream(ind);
            source(j).normal  = repmat(volume1.normal,length(ind),1);
            source(j).gmm     = gmmlib(volume1.num(spt,5));
            
    end
    
    % required and very time consuming
    source(j).ghypm   = xyz2gps(source(j).hypm,opt.ellipsoid);
    
    % updats usp if mechanism is read from source definition
    switch source(j).gmm.type
        case {'regular','pce'}
            [A,B]=ismember(source(j).gmm.txt,{'auto'});
            if any(A)
                rake = source(j).numgeom(2);
                vv   = find(B)-3;
                source(j).gmm.usp{vv} = rake2sof(rake);
            end
        case 'cond'
            [A,B]=ismember(source(j).gmm.txt,{'auto'});
            if any(A)
                rake = source(j).numgeom(2);
                vv   = find(B)-6;
                source(j).gmm.usp{vv} = rake2sof(rake);
            end
        case 'frn'
            for uu=1:length(source(j).gmm.usp)
                [A,B]=ismember(source(j).gmm.usp{uu}.txt,{'auto'});
                if any(A)
                    rake = source(j).numgeom(2);
                    vv   = find(B)-3;
                    source(j).gmm.usp{uu}.usp{vv} = rake2sof(rake);
                end
            end
    end
    
    % magnitude recurrence relation
    mp    = cgm(j);
    mtype = numM(mp,1);
    mptr  = numM(mp,2);
    switch mtype
        case 1
            source(j).nummag = mrr1.num(mptr,:);
            source(j).mscl   = mrr1.mdata(mptr,:);
            source(j).meanMo = mrr1.meanMo(mptr,:);
        case 2
            source(j).nummag = mrr2.num(mptr,:);
            ind = mrr2.mptr(mptr,1):mrr2.mptr(mptr,2);
            source(j).mscl   = mrr2.mdata(ind,:);
            source(j).meanMo = mrr2.meanMo(mptr,:);
        case 3
            source(j).nummag = mrr3.num(mptr,:);
            ind = mrr3.mptr(mptr,1):mrr3.mptr(mptr,2);
            source(j).mscl   = mrr3.mdata(ind,:);
            source(j).meanMo = mrr3.meanMo(mptr,:);
        case 4
            source(j).nummag = mrr4.num(mptr,:);
            ind = mrr4.mptr(mptr,1):mrr4.mptr(mptr,2);
            source(j).mscl   = mrr4.mdata(ind,:);
            source(j).meanMo = mrr4.meanMo(mptr,:);
        case 5
            source(j).nummag = mrr5.num(mptr,:);
            ind = mrr5.mptr(mptr,1):mrr5.mptr(mptr,2);
            source(j).mscl   = mrr5.mdata(ind,:);
            source(j).meanMo = mrr5.meanMo(mptr,:);
    end
end

for j=sptr
    if source(j).nummag(1)==1
        source(j).NMmin=source(j).nummag(2);
    elseif source(j).nummag(1)==2
        A          = sum(source(j).aream)* 1e10;  % cm2
        S          = source(j).nummag(2)*0.100;   % cm/year
        meanMo     = source(j).meanMo;
        source(j).NMmin = opt.ShearModulus*A*S/meanMo;
    end
end

source = source(sptr);
if isempty(h)
    return
end
xyz = gps2xyz(h.p,opt.ellipsoid);
Nsite  = size(xyz,1);
ind    = zeros(Nsite,length(source));
for i=1:Nsite
    ind(i,:)=selectsource(opt.MaxDistance,xyz(i,:),source);
end

if ~isempty(source(sum(ind,1)>0))
    source=source(sum(ind,1)>0);
end


