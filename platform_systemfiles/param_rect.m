function [param,rate]=param_rect(r0,source,ellipsoid)

if isempty(ellipsoid.Code)
    r0=r0([2 1 3]);
end

Area    = source.aream;
MM      = source.mscl(:,1);
rateM   = source.mscl(:,2);
gmm     = source.gmm;
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
Rmetric = gmm.Rmetric;
media   = source.media;

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
if Rmetric(1),  Rrup  = cell(1,nM);end
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
    
    if Rmetric(1),  Rrup{i}  = dist_rrup4  (r0,rf,RW,RL,geom);end
    if Rmetric(2),  Rhyp{i}  = dist_rhyp4  (r0,rf,RW,RL,geom);end
    if Rmetric(3),  Rjb{i}   = dist_rjb4   (r0,rf,RW,RL,geom,ellipsoid);end
    if Rmetric(6),  Rx{i}    = dist_rx4    (r0,rf,RW,RL,geom,ellipsoid);end
    if Rmetric(7),  Ry0{i}   = dist_ry04   (r0,rf,RW,RL,geom);end
    if Rmetric(8),  Zhyp{i}  = dist_zhyp4  (r0,rf,RW,RL,geom,ellipsoid);end
    if Rmetric(9),  Ztor{i}  = dist_ztor4  (r0,rf,RW,RL,geom,ellipsoid);end
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
rate  = vertcat(rate{:});
if Rmetric(1),  Rrup  = vertcat(Rrup {:});end
if Rmetric(2),  Rhyp  = vertcat(Rhyp {:});end
if Rmetric(3),  Rjb   = vertcat(Rjb  {:});end
if Rmetric(6),  Rx    = vertcat(Rx   {:});end
if Rmetric(7),  Ry0   = vertcat(Ry0  {:});end
if Rmetric(8),  Zhyp  = vertcat(Zhyp {:});end
if Rmetric(9),  Ztor  = vertcat(Ztor {:});end

%% GMM PARAMETERS
Ndepend  = 1;
isfrn    = false;

switch gmm.type
    case 'regular', str_test = func2str(gmm.handle);
    case 'cond',    str_test = func2str(gmm.cond);
    case 'udm' ,    str_test = 'udm';
    case 'pce' ,    str_test = func2str(gmm.handle);
    case 'frn'
        isfrn   = true;
        Ndepend = length(gmm.usp);
        funcs   = cell(1,Ndepend);
        IMlist  = cell(1,Ndepend);
        PARAM   = cell(1,Ndepend);
end


for jj=1:Ndepend
    if isfrn
        str_test = func2str(gmm.usp{jj}.handle);
        usp      = gmm.usp{jj}.usp;
    else
        usp     = gmm.usp;
    end
    
    
    switch str_test
        case 'Youngs1997',              param = [M,Rrup,Zhyp,media,usp];
        case 'AtkinsonBoore2003',       param = [M,Rrup,Zhyp,media,usp];
        case 'Zhao2006',                param = [M,Rrup,Zhyp,media,usp];
        case 'Mcverry2006',             param = [M,Rrup,Zhyp,media,usp];
        case 'ContrerasBoroschek2012',  param = [M,Rrup,Zhyp,media,usp];
        case 'BCHydro2012',             param = [M,Rrup,Rhyp,Zhyp,media,usp];
        case 'BCHydro2018',             param = [M,rrup,ztor,media,usp];
        case 'Arteta2018',              param = [M,Rhyp,media,usp];
        case 'Idini2016',               param = [M,Rrup,Rhyp,Zhyp,media,usp];
        case 'MontalvaBastias2017',     param = [M,Rrup,Rhyp,Zhyp,media,usp];
        case 'MontalvaBastias2017HQ',   param = [M,Rrup,Rhyp,Zhyp,media,usp];
        case 'SiberRisk2019',           param = [M,Rrup,Rhyp,Zhyp,media,usp];
        case 'Garcia2005',              param = [M,Rrup,Rhyp,Zhyp,usp];
        case 'Jaimes2006',              param = [M,Rrup,usp];
        case 'Jaimes2015',              param = [M,Rrup,usp];
        case 'Jaimes2016',              param = [M,Rrup,usp];
        case 'GarciaJaimes2017',        param = [M,Rrup,usp];
        case 'GarciaJaimes2017HV',      param = [M,Rrup,usp];
        case 'Bernal2014',              param = [M,Rrup,Zhyp,usp];
        case 'Sadigh1997',              param = [M,Rrup,media,usp];
        case 'I2008',                   param = [M,Rrup,media,usp];
        case 'CY2008',                  param = [M,Rrup,Rjb,Rx,Ztor,dip,media,usp];
        case 'BA2008',                  param = [M,Rjb,media,usp];
        case 'CB2008',                  param = [M,Rrup,Rjb,Ztor,dip,media,usp];
        case 'AS2008',                  param = [M,Rrup,Rjb,Rx,Ztor,dip,width,media,usp];
        case 'AS1997h',                 param = [M,Rrup,usp];
        case 'I2014',                   param = [M,Rrup,media,usp];
        case 'CY2014',                  param = [M,Rrup,Rjb,Rx,Ztor,dip,media,usp];
        case 'CB2014',                  param = [M,Rrup,Rjb,Rx,Zhyp,Ztor,'unk',dip,width,media,usp];
        case 'BSSA2014',                param = [M,Rjb,media,usp];
        case 'ASK2014',                 param = [M,Rrup,Rjb,Rx,Ry0,Ztor,dip,width,media,usp];
        case 'AkkarBoomer2007',         param = [M,Rjb,usp];
        case 'AkkarBoomer2010',         param = [M,Rjb,usp];
        case 'Arroyo2010',              param = [M,Rrup,usp];
        case 'Bindi2011',               param = [M,Rjb,media,usp];
        case 'Kanno2006',               param = [M,Rrup,Zhyp,media,usp];
        case 'Cauzzi2015',              param = [M,Rrup,Rhyp,media,usp];
        case 'DW12',                    param = [M,Rrup,usp];
        case 'FG15',                    param = [M,Rrup,Zhyp,media,usp];
        case 'TBA03',                   param = [M,Rrup,usp];
        case 'BU17',                    param = [M,Rrup,Zhyp,usp];
        case 'CB10',                    param = [M,Rrup,Rjb,Ztor,dip,media,usp];
        case 'CB11',                    param = [M,Rrup,Rjb,Ztor,dip,media,usp];
        case 'CB19',                    param = [M,Rrup,Rjb,Rx,Zhyp,Ztor,'unk',dip,width,media,usp];
        case 'KM06',                    param = [M,Rrup,usp];
        
        case 'PCE_nga',                 param = [M,Rrup,media,usp];
        case 'PCE_bchydro',             param = [M,Rrup,media,usp];
        case 'udm'
            var      = gmm.var;
            txt      = regexp(var.syntax,'\(','split');
            args     = regexp(txt{2}(1:end-1),'\,','split');
            args     = strtrim(args);
            args(1)  = [];
            param    = cell(1,4+length(args));
            param{1} = str2func(strtrim(txt{1}));
            param{2} = var.vector;
            param{3} = var.residuals;
            uspcont  = 2;
            for cont=1:length(args)
                f = var.(args{cont});
                if strcmpi(f.tag,'magnitude')
                    param{4+cont}=M;
                end
                
                if strcmpi(f.tag,'distance')
                    fval = find(f.value);
                    switch fval
                        case 1 , param{4+cont}=rrup;
                        case 2 , param{4+cont}=rhyp;
                        case 3 , param{4+cont}=rjb;
                        case 4 , param{4+cont}=repi;
                        case 6 , param{4+cont}=rx;
                        case 7 , param{4+cont}=ry0;
                        case 8 , param{4+cont}=zhyp;
                        case 9 , param{4+cont}=rztor;
                        case 10, param{4+cont}=rzbor;
                        case 11, param{4+cont}=rzbot;
                    end
                end
                
                if strcmpi(f.tag,'Vs30')
                    param{4+cont} = source.media;
                    uspcont=uspcont+1;
                end
                
                if strcmpi(f.tag,'param')
                    switch f.type
                        case 'string'
                            param{4+cont}=usp{uspcont};
                        case 'double'
                            param{4+cont}=str2double(usp{uspcont});
                            
                    end
                    uspcont=uspcont+1;
                end
                
            end
            
    end
    
    switch gmm.type
        case 'cond'
            switch func2str(gmm.handle)
                case 'Macedo2019', param = {M,rrup,gmm.txt{4},gmm.txt{5},source.media,gmm.cond,param{:}}; %#ok<CCAT>
                case 'Macedo2020', param = {M,rrup,source.media         ,gmm.cond,param{:}}; %#ok<CCAT>
            end
        case 'frn'
            funcs {jj}=gmm.usp{jj}.handle;
            IMlist{jj}=gmm.usp{jj}.T;
            PARAM {jj}=param;
    end
end

if isfrn
    param=[funcs,IMlist,PARAM];
end
