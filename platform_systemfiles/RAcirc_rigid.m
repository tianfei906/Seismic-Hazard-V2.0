function [param,rate,MRZ]=RAcirc_rigid(xyz0,source,ellipsoid,hparam)

hypm    = source.hypm;              % source centroids
gmm     = source.gmm;
mag     = source.mscl(:,1);
rateM   = source.mscl(:,2);
nM      = size(mag,1);
mlist   = source.rclust.m(:);
C       = source.rclust.C;
radii   = source.rclust.radio;
Rmetric = gmm.Rmetric;

cptr    = zeros(nM,1);
for i=1:nM
    [~,cptr(i)]=min(abs(mlist-mag(i)));
end
nC   = size(source.rclust.C,1);
rrup = zeros(nC,nM);

% Magnitude
M = repmat(mag',nC,1);
M = M(:);

% Hypocentral Distance, rhyp
if Rmetric(2) || nargout==3
	rhyp = sum((xyz0-C).^2,2).^0.5;
    rhyp = repmat(rhyp,nM,1);
end

% Joyner Boore Distance, rjb
if Rmetric(3)
    rg  = source.ghypm(:,1:2);
    rjb = zeros(nC,nM);
end

% Rx
if Rmetric(6) % only available for rectangular sources
    x1 = source.spte(1,:);
    x2 = source.spte(4,:);
    rx = norm(cross(xyz0-x1,xyz0-x2))/norm(x1-x2)*ones(nC*nM,1);
end

% Focal Depth, zhyp
if Rmetric(8) || nargout==3
    zhyp = dist_zhyp(xyz0,source.rclust.C,ellipsoid);
    zhyp = repmat(zhyp,nM,1);
end

% Depth to top of rupture, ztor
if Rmetric(9)
    TOR  = abs(source.ghypm(:,3));
    ztor = zeros(nC,nM);
end

% rate of scenarios
rate = source.rclust.rateR*rateM';
rate = rate(:);

% Rrup & Rjb & Ztor
for i=1:nM
    Rrup  = nan(nC,1);
    Rjb   = nan(nC,1);
    Ztor  = nan(nC,1);
    
    for j=1:nC
        Cj    = C(j,:);
%         IND   = sum((hypm-Cj).^2,2)<radii(j)^2;
        IND   = sum((hypm-Cj).^2,2)<radii(j,cptr(i))^2;
        hypmj = hypm(IND,:);
        
        % Rrup
        dist    = sum((xyz0-hypmj).^2,2).^0.5;
        Rrup(j) = min(dist);
        
        % Rjb
        if Rmetric(3) && sum(IND)>2
            P      = rg(IND,:);
            if polyarea(P(:,1),P(:,2))>0
                kk     = convhull(P);
                gxyz0  = xyz2gps(xyz0,ellipsoid);
                [d,x,y]= p_poly_dist(gxyz0(1),gxyz0(2),P(kk,1),P(kk,2));
                if d>0
                    rgp    = gps2xyz([x y 0],ellipsoid);
                    Rjb(j) = norm(xyz0-rgp);
                end
            else
                xyzsup = gps2xyz([rg(IND,:) rg(IND,1)*0],ellipsoid);
                d      = sum((xyzsup-xyz0).^2,2).^0.5;
                Rjb(j) = min(d);
            end
        elseif Rmetric(3) && sum(IND)<2
            xyzsup = gps2xyz([rg(IND,:) rg(IND,1)*0],ellipsoid);
            d      = sum((xyzsup-xyz0).^2,2).^0.5;
            Rjb(j) = min(d);
        end
        
        % Ztor
        if Rmetric(9)
            Ztor(j) = min(TOR(IND));
        end
    end
    rrup(:,i) = Rrup;
    
    if Rmetric(3),  rjb(:,i)   = Rjb; end
    if Rmetric(9),  ztor(:,i) = Ztor; end
    
end

UNK =999*ones(size(M));
rrup=rrup(:);
if Rmetric(3), rjb=rjb(:);end
if Rmetric(9), ztor=ztor(:);end

%% calculo de dip y width, pendiente
if isempty(source.spte)
    W    = nan;
else
    W = norm(source.spte(1,:)-source.spte(2,:));
end
dip = mean(source.dip);

%% GMM Parameters
media    = source.media;
VS30     = media(strcmp(hparam,'VS30'));
Ndepend  = 1;
isfrn    = false;
isadj    = false;
switch gmm.type
    case 'regular', str_test = func2str(gmm.handle);
    case 'cond',    str_test = func2str(gmm.cond);
    case 'udm' ,    str_test = 'udm';
    case 'adj' ,    str_test = gmm.usp{2}; isadj    = true;
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
        if strcmp(gmm.usp{jj}.type,'regular')
            str_test = func2str(gmm.usp{jj}.handle);
        else
            str_test = func2str(gmm.usp{jj}.cond);
        end
        usp      = gmm.usp{jj}.usp;
    elseif isadj
        usp     = gmm.usp([3:end,1:2]);
    else
        usp     = gmm.usp;
    end
    
    switch str_test
        case 'Youngs1997',                    param = [M,rrup,zhyp,VS30,usp];
        case 'AtkinsonBoore2003',             param = [M,rrup,zhyp,VS30,usp];
        case 'Zhao2006',                      param = [M,rrup,zhyp,VS30,usp];
        case 'Mcverry2006',                   param = [M,rrup,zhyp,VS30,usp];
        case 'ContrerasBoroschek2012',        param = [M,rrup,zhyp,VS30,usp];
        case 'BCHydro2012',                   param = [M,rrup,rhyp,zhyp,VS30,usp];
        case 'BCHydro2018',                   param = [M,rrup,ztor,VS30,usp];
        case 'Kuehn2020',                     param = [M,rrup,ztor,VS30,usp];
        case 'Parker2020',                    param = [M,rrup,zhyp,VS30,usp];
        case 'Arteta2018',                    param = [M,rhyp,VS30,usp];
        case 'Idini2016',                     param = [M,rrup,rhyp,zhyp,VS30,usp];
        case 'MontalvaBastias2017',           param = [M,rrup,rhyp,zhyp,VS30,usp];
        case 'MontalvaBastias2017HQ',         param = [M,rrup,rhyp,zhyp,VS30,usp];
        case 'Montalva2018'
            [~,indf0] = intersect(hparam,'f0');    f0    = media(indf0);
            param = [M,rrup,rhyp,zhyp,VS30,f0,usp];
        case 'SiberRisk2019',                 param = [M,rrup,rhyp,zhyp,VS30,usp];
        case 'Garcia2005',                    param = [M,rrup,rhyp,zhyp,usp];
        case 'Jaimes2006',                    param = [M,rrup,usp];
        case 'Jaimes2015',                    param = [M,rrup,usp];
        case 'Jaimes2016',                    param = [M,rrup,usp];
        case 'GarciaJaimes2017',              param = [M,rrup,usp];
        case 'GarciaJaimes2017VH',            param = [M,rrup,usp];
        case 'GA2011',                        param = [M,rrup,VS30,usp];
        case 'SBSA2016',                      param = [M,rjb,VS30,usp];
        case 'GKAS2017',                      param = [M,rrup,rjb,UNK,UNK,ztor,dip,W,VS30,usp];
        case 'Bernal2014',                    param = [M,rrup,zhyp,usp];
        case 'Sadigh1997',                    param = [M,rrup,VS30,usp];
        case 'I2008',                         param = [M,rrup,VS30,usp];
        case 'CY2008',                        param = [M,rrup,rjb,rx,ztor,dip,VS30,usp];
        case 'BA2008',                        param = [M,rjb,VS30,usp];
        case 'CB2008',                        param = [M,rrup,rjb,ztor, dip,VS30,usp];
        case 'AS2008',                        param = [M,rrup,rjb,rx,ztor,dip,W,VS30,usp];
        case 'AS1997h',                       param = [M,rrup,VS30,usp];
        case 'I2014',                         param = [M,rrup,VS30,usp];
        case 'CY2014',                        param = [M,rrup,rjb,rx,ztor,dip,VS30,usp];
        case 'CB2014',                        param = [M,rrup,rjb,rx,zhyp,ztor,'unk',dip,W,VS30,usp];
        case 'BSSA2014',                      param = [M,rjb,VS30,usp];
        case 'ASK2014',                       param = [M,rrup,rbj,rx,UNK,ztor,dip,W,VS30,usp];
        case 'AkkarBoomer2007',               param = [M,rjb,usp];
        case 'AkkarBoomer2010',               param = [M,rjb,usp];
        case 'Akkar2014',                     param = [M,rhyp,rjb,UNK,VS30,usp];
        case 'Arroyo2010',                    param = [M,rrup,usp];
        case 'Bindi2011',                     param = [M,rjb,VS30,usp];
        case 'Kanno2006',                     param = [M,rrup,zhyp,VS30,usp];
        case 'Cauzzi2015',                    param = [M,rrup,rhyp,VS30,usp];
        case 'DW12',                          param = [M,rrup,usp];
        case 'FG15',                          param = [M,rrup,zhyp,VS30,usp];
        case 'TBA03',                         param = [M,rrup,usp];
        case 'BU17',                          param = [M,rrup,zhyp,usp];
        case 'CB10',                          param = [M,rrup,rjb,ztor,dip,VS30,usp];
        case 'CB11',                          param = [M,rrup,rjb,ztor,dip,VS30,usp];
        case 'CB19',                          param = [M,rrup,rjb,rx,zhyp,ztor,UNK,dip,W,VS30,usp];
        case 'KM06',                          param = [M,rrup,usp];
        case 'medianPCEbchydro',              param = [M,rrup,VS30,usp];
        case 'medianPCEnga',                  param = [M,rrup,VS30,usp];
        case 'PCE_nga',                       param = [M,rrup,VS30,usp];
        case 'PCE_bchydro',                   param = [M,rrup,VS30,usp];
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
                case 'MAB2019'    , param = {M,rrup,gmm.txt{4},gmm.txt{5},VS30,gmm.cond,param{:}}; %#ok<CCAT>
                case 'MAL2020'    , param = {M,rrup,rjb,gmm.txt{4},dip,VS30 ,gmm.cond,param{:}}; %#ok<CCAT>
                case 'MMLA2020'   , param = {M,rrup,VS30 ,gmm.cond,param{:}}; %#ok<CCAT>
                case 'ML2021'     , param = {M,rrup,gmm.txt{4},VS30 ,gmm.cond,param{:}}; %#ok<CCAT>
                case 'MCAVdp2021' , param = {M,rrup,gmm.txt{4},VS30 ,gmm.cond,param{:}}; %#ok<CCAT>
            end
        case 'frn'
            funcs {jj}=gmm.usp{jj}.handle;
            IMlist{jj}=gmm.usp{jj}.T;
            
            switch gmm.usp{jj}.type
                case 'regular'
                    PARAM {jj}=param;
                case 'cond'
                    switch func2str(gmm.usp{jj}.handle)
                        case 'MAB2019'     , PARAM{jj} = {M,rrup,gmm.usp{jj}.txt{4},gmm.usp{jj}.txt{5},VS30,gmm.usp{jj}.cond,param{:}}; %#ok<CCAT>
                        case 'MAL2020'     , PARAM{jj} = {M,rrup,rjb,gmm.usp{jj}.txt{4},dip,VS30 ,gmm.usp{jj}.cond,param{:}}; %#ok<CCAT>
                        case 'MMLA2020'    , PARAM{jj} = {M,rrup,VS30 ,gmm.usp{jj}.cond,param{:}}; %#ok<CCAT>
                        case 'ML2021'      , PARAM{jj} = {M,rrup,gmm.usp{jj}.txt{4},VS30 ,gmm.usp{jj}.cond,param{:}}; %#ok<CCAT>
                        case 'MCAVdp2021'  , PARAM{jj} = {M,rrup,gmm.usp{jj}.txt{4},VS30 ,gmm.usp{jj}.cond,param{:}}; %#ok<CCAT>
                    end
            end
    end
end

if isfrn
    param=[funcs,IMlist,PARAM];
end

if nargout==3
    MRZ = [M,rrup,rhyp,zhyp,C];
end

