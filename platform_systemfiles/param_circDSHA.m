function [param]=param_circDSHA(r0,rf,M,n,RA,gmm,media,ellipsoid)

%% EVALUATES RUPTURE AREA AND SOURCE NORMAL VECTOR
rupArea = rupRelation(M,0,RA(1));
rrup    = dist_rrup(r0,rf,rupArea,n);
UNK     = ones(size(rrup))*999;
if gmm.Rmetric(2), rhyp  = dist_rhyp(r0,rf);           end
if gmm.Rmetric(3), rjb   = dist_rjb(r0,rf,rupArea,n,ellipsoid);  end
if gmm.Rmetric(8), zhyp  = dist_zhyp(r0,rf,ellipsoid); end
if gmm.Rmetric(9), ztor  = dist_ztor(r0,rf,rupArea,n,ellipsoid);end

%% GMM Parameters
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
    
    dip = 90;
    switch str_test
        case 'Youngs1997',                    param = [M,rrup,zhyp,media,usp];
        case 'AtkinsonBoore2003',             param = [M,rrup,zhyp,media,usp];
        case 'Zhao2006',                      param = [M,rrup,zhyp,media,usp];
        case 'Mcverry2006',                   param = [M,rrup,zhyp,media,usp];
        case 'ContrerasBoroschek2012',        param = [M,rrup,zhyp,media,usp];
        case 'BCHydro2012',                   param = [M,rrup,rhyp,zhyp,media,usp];
        case 'BCHydro2018',                   param = [M,rrup,ztor,media,usp];
        case 'Kuehn2020',                     param = [M,rrup,ztor,media,usp];
        case 'Parker2020',                    param = [M,rrup,zhyp,media,usp];            
        case 'Arteta2018',                    param = [M,rhyp,media,usp];
        case 'Idini2016',                     param = [M,rrup,rhyp,zhyp,media,usp];
        case 'MontalvaBastias2017',           param = [M,rrup,rhyp,zhyp,media,usp];
        case 'MontalvaBastias2017HQ',         param = [M,rrup,rhyp,zhyp,media,usp];
        case 'SiberRisk2019',                 param = [M,rrup,rhyp,zhyp,media,usp];
        case 'Garcia2005',                    param = [M,rrup,rhyp,zhyp,usp];
        case 'Jaimes2006',                    param = [M,rrup,usp];
        case 'Jaimes2015',                    param = [M,rrup,usp];
        case 'Jaimes2016',                    param = [M,rrup,usp];
        case 'GarciaJaimes2017',              param = [M,rrup,usp];
        case 'GarciaJaimes2017HV',            param = [M,rrup,usp];
        case 'Bernal2014',                    param = [M,rrup,zhyp,usp];
        case 'Sadigh1997',                    param = [M,rrup,media,usp];
        case 'I2008',                         param = [M,rrup,media,usp];
        case 'CY2008',                        param = [M,rrup,UNK,-UNK,ztor,dip,media,usp];
        case 'BA2008',                        param = [M,rjb,media,usp];
        case 'CB2008',                        param = [M,rrup,rjb,ztor, nan,media,usp];
        case 'AS2008',                        param = [M,rrup,UNK,-UNK,ztor,dip,999,media,usp];
        case 'AS1997h',                       param = [M,rrup,usp];
        case 'I2014',                         param = [M,rrup,media,usp];
        case 'CY2014',                        param = [M,rrup,UNK,UNK,ztor,dip,media,usp];
        case 'CB2014',                        param = [M,rrup,UNK,UNK,UNK,ztor,'unk',dip,999,media,usp];
        case 'BSSA2014',                      param = [M,rjb,media,usp];
        case 'ASK2014',                       param = [M,rrup,UNK,-UNK,UNK,ztor,dip,999,media,usp];
        case 'AkkarBoomer2007',               param = [M,rjb,usp];
        case 'AkkarBoomer2010',               param = [M,rjb,usp];
        case 'Arroyo2010',                    param = [M,rrup,usp];
        case 'Bindi2011',                     param = [M,rjb,media,usp];
        case 'Kanno2006',                     param = [M,Rrup,Zhyp,media,usp];
        case 'Cauzzi2015',                    param = [M,Rrup,Rhyp,media,usp];
        case 'DW12',                          param = [M,rrup,usp];
        case 'FG15',                          param = [M,rrup,zhyp,media,usp];
        case 'TBA03',                         param = [M,rrup,usp];
        case 'BU17',                          param = [M,rrup,zhyp,usp];
        case 'CB10',                          param = [M,rrup,rjb,ztor,dip,media,usp];
        case 'CB11',                          param = [M,rrup,rjb,ztor,dip,media,usp];
        case 'CB19',                          param = [M,rrup,rjb,UNK,UNK,ztor,zhyp,dip,999,media,usp];
        case 'KM06',                          param = [M,rrup,usp];
        case 'PCE_nga',                       param = [M,rrup,media,usp];
        case 'PCE_bchydro',                   param = [M,rrup,media,usp];
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

