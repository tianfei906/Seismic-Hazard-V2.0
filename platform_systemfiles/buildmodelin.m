function[source]=buildmodelin(sys,branch,opt,optdspec)

geomptr   = branch(1);
gmpeptr   = branch(2);
msclptr   = branch(3);

point1   = sys.point1(geomptr);
line1    = sys.line1(geomptr);
area1    = sys.area1(geomptr);
area2    = sys.area2(geomptr);
volume1  = sys.volume1(geomptr);
gmmptr   = sys.gmmptr(gmpeptr,:);
gmmlib   = sys.gmmlib(gmmptr);

mrr1     = sys.mrr1(msclptr);
mrr2     = sys.mrr2(msclptr);
mrr3     = sys.mrr3(msclptr);
mrr4     = sys.mrr4(msclptr);
mrr5     = sys.mrr5(msclptr);
mrr6     = sys.mrr6(msclptr);
numG     = sys.numG{geomptr};
numM     = sys.numM{msclptr};
cgm      = sys.cgm{geomptr,msclptr};
Nsrc     = size(cgm,1);

% assembly of area sources
source(1:Nsrc,1)=struct('pfun',[],'vert',[],'numgeom',[],'nummag',[],'hypm',[],'aream',[],'normal',[],'p',[],'dsv',[],'mscl',[],'gmm',[],'meanMo',[],'NMmin',[],'media',[],'rclust',[]);
for j=1:Nsrc
    spt =numG(j,2);
    switch numG(j,1)
        case 1 % point1
            source(j).pfun    = @RAcirc_leak;
            source(j).numgeom = point1.num(spt,:);
            source(j).hypm    = gps2xyz(point1.vert(spt,:),opt.ellipsoid); % might need to convert
            source(j).aream   = 1;
            source(j).normal  = point1.normal(spt,:);
            source(j).gmm     = gmmlib(point1.num(spt,5));
            
        case 2 % line1
            mptr = line1.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            source(j).pfun    = @RAcirc_leak;
            source(j).numgeom = line1.num(spt,:);
            source(j).hypm    = line1.hypm(ind,:);
            source(j).aream   = line1.aream(ind);
            source(j).normal  = line1.normal(ind,:);
            source(j).gmm     = gmmlib(line1.num(spt,5));
            
        case 3 % area1
            mptr = area1.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            switch area1.num(spt,11)
                case 0
                    source(j).pfun    = @RAcirc_leak;
                    source(j).numgeom = area1.num(spt,:);
                    source(j).hypm    = area1.hypm(ind,:);
                    source(j).aream   = area1.aream(ind);
                    source(j).normal  = area1.normal(ind,:);
                    source(j).gmm     = gmmlib(area1.num(spt,5));
                case 1
                    source(j).pfun    = @RAcirc_rigid;
                    source(j).numgeom = area1.num(spt,:);
                    source(j).hypm    = area1.hypm(ind,:);
                    source(j).gmm     = gmmlib(area1.num(spt,5));
                    source(j).rclust  = area1.rclust(j);
            end
            
        case 4 % area2
            mptr = area2.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            source(j).pfun    = @RArect_rigid;
            source(j).numgeom = area2.num(spt,:);
            source(j).hypm    = area2.hypm(ind,:);
            source(j).aream   = area2.aream(ind);
            source(j).p       = area2.p(:,:,ind);
            source(j).normal  = area2.dsv(:,:,ind);
            source(j).gmm     = gmmlib(area2.num(spt,5));
            
        case 5 % volume1
            mptr = volume1.mptr(spt,:);
            ind  = mptr(1):mptr(2);
            source(j).pfun    = @RAcirc_leak;
            source(j).numgeom = volume1.num(spt,:);
            source(j).hypm    = volume1.hypm(ind,:);
            source(j).aream   = volume1.aream(ind);
            source(j).normal  = volume1.normal;
            source(j).gmm     = gmmlib(volume1.num(spt,5));
    end
    
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
    
    % magnitude recurrence relation for standard psha analysis
    if nargin==3
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
                source(j).nummag = mrr5.num{mptr};
                ind = mrr5.mptr(mptr,1):mrr5.mptr(mptr,2);
                source(j).mscl   = mrr5.mdata(ind,:);
                source(j).meanMo = mrr5.meanMo(mptr,:);
            case 6
                source(j).nummag = mrr6.num(mptr,:);
                ind = mrr6.mptr(mptr,1):mrr6.mptr(mptr,2);
                source(j).mscl   = mrr6.mdata(ind,:);
                source(j).meanMo = mrr6.meanMo(mptr,:);
        end
    end
    
    % magnitude recurrence relation for dbspec analysis
    if nargin==4
        mp    = cgm(j);
        mtype = numM(mp,1);
        mptr  = numM(mp,2);
        if optdspec.GRMmax==1
            switch mtype
                case 1
                    source(j).nummag = mrr1.num(mptr,:);
                    source(j).mscl   = [mrr1.num(mptr,3),1];
                case 2
                    source(j).nummag = mrr2.num(mptr,:);
                    source(j).mscl   = [mrr2.num(mptr,5) 1];
                case 3
                    source(j).nummag = mrr3.num(mptr,:);
                    source(j).mscl   = [mrr3.num(mptr,5),1];
                case 4
                    source(j).nummag = mrr4.num(mptr,:);
                    source(j).mscl   = [mrr4.num(mptr,5),1];
                case 5
                    source(j).nummag = mrr5.num{mptr};
                    source(j).mscl   = [];
                    keyboard % not yet implemented
                case 6
                    source(j).nummag = mrr6.num(mptr,:);
                    source(j).mscl   =[];
                    keyboard % not yet implemented
            end
        else
            userMmax = optdspec.userMmax{j,3};
            source(j).mscl   =[userMmax,1];
        end
    end
    
end

if nargin==3
    for j=1:Nsrc
        if source(j).nummag(1)==1
            source(j).NMmin=source(j).nummag(2);
        elseif source(j).nummag(1)==2
            A          = sum(source(j).aream)* 1e10;  % cm2
            S          = source(j).nummag(2)*0.100;   % cm/year
            meanMo     = source(j).meanMo;
            source(j).NMmin = opt.ShearModulus*A*S/meanMo;
        end
    end
end