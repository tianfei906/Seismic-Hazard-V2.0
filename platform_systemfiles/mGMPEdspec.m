function [IND]=mGMPEdspec(gmm,param)

T = true;
F = false;
S = 0.5;

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
        IND2     = cell(1,Ndepend);
end

for jj=1:Ndepend
    if isfrn
        if strcmp(gmm.usp{jj}.type,'regular')
            str_test = func2str(gmm.usp{jj}.handle);
        else
            str_test = func2str(gmm.usp{jj}.cond);
        end
    end
    
    switch str_test
        case 'Youngs1997',                    IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'AtkinsonBoore2003',             IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'Zhao2006',                      IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'Mcverry2006',                   IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'ContrerasBoroschek2012',        IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'BCHydro2012',                   IND = [T,T,T,T,S,F];           % [M,rrup,rhyp,zhyp,VS30,usp];
        case 'BCHydro2018',                   IND = [T,T,T,S,F];             % [M,rrup,ztor,VS30,usp];
        case 'Kuehn2020',                     IND = [T,T,T,S,F];             % [M,rrup,ztor,VS30,usp];
        case 'Parker2020',                    IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'Arteta2018',                    IND = [T,T,S,F];               % [M,rhyp,VS30,usp];
        case 'Idini2016',                     IND = [T,T,T,T,S,F];           % [M,rrup,rhyp,zhyp,VS30,usp];
        case 'MontalvaBastias2017',           IND = [T,T,T,T,S,F];           % [M,rrup,rhyp,zhyp,VS30,usp];
        case 'MontalvaBastias2017HQ',         IND = [T,T,T,T,S,F];           % [M,rrup,rhyp,zhyp,VS30,usp];
        case 'Montalva2018',                  IND = [T,T,T,T,S,S,F];         % [M,rrup,rhyp,zhyp,VS30,f0,usp];
        case 'SiberRisk2019',                 IND = [T,T,T,T,S,F];           % [M,rrup,rhyp,zhyp,VS30,usp];
        case 'Garcia2005',                    IND = [T,T,T,T,F];             % [M,rrup,rhyp,zhyp,usp];
        case 'Jaimes2006',                    IND = [T,T,F];                 % [M,rrup,usp];
        case 'Jaimes2015',                    IND = [T,T,F];                 % [M,rrup,usp];
        case 'Jaimes2016',                    IND = [T,T,F];                 % [M,rrup,usp];
        case 'GarciaJaimes2017',              IND = [T,T,F];                 % [M,rrup,usp];
        case 'GarciaJaimes2017VH',            IND = [T,T,F];                 % [M,rrup,usp];
        case 'GA2011',                        IND = [T,T,S,F];               % [M,Rrup,Vs30,SOF];
        case 'SBSA2016',                      IND = [T,T,S,F];               % [M,Rjb,VS30,usp]
        case 'GKAS2017',                      IND = [T,T,T,T,T,T,T,T,S,F];   % [M,Rrup,Rjb,Rx,Ry0,Ztor,dip,W,VS30,usp]            
        case 'Bernal2014',                    IND = [T,T,T,F];               % [M,rrup,zhyp,usp];
        case 'Sadigh1997',                    IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'I2008',                         IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'CY2008',                        IND = [T,T,T,T,T,F,S,F];       % [M,rrup,UNK,-UNK,ztor,dip,VS30,usp];
        case 'BA2008',                        IND = [T,T,S,F];               % [M,rjb,VS30,usp];
        case 'CB2008',                        IND = [T,T,T,T,F,S,F];         % [M,rrup,rjb,ztor, nan,VS30,usp];
        case 'AS2008',                        IND = [T,T,T,T,T,F,F,S,F];     % [M,rrup,UNK,-UNK,ztor,dip,999,VS30,usp];
        case 'AS1997h',                       IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'I2014',                         IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'CY2014',                        IND = [T,T,T,T,T,F,S,F];       % [M,rrup,UNK,UNK,ztor,dip,VS30,usp];
        case 'CB2014',                        IND = [T,T,T,T,T,T,T,F,F,S,F]; % [M,rrup,UNK,UNK,UNK,ztor,'unk',dip,999,VS30,usp];
        case 'BSSA2014',                      IND = [T,T,S,F];               % [M,rjb,VS30,usp];
        case 'ASK2014',                       IND = [T,T,T,T,T,T,F,F,S,F];   % [M,rrup,UNK,-UNK,UNK,ztor,dip,999,VS30,usp];
        case 'AkkarBoomer2007',               IND = [T,T,F];                 % [M,rjb,usp];
        case 'AkkarBoomer2010',               IND = [T,T,F];                 % [M,rjb,usp];
        case 'Akkar2014',                     IND = [T,T,T,T,S,F];           % [M,Rhyp,Rjb,Repi,Vs30,usp];
        case 'Arroyo2010',                    IND = [T,T,F];                 % [M,rrup,usp];
        case 'Bindi2011',                     IND = [T,T,S,F];               % [M,rjb,VS30,usp];
        case 'Kanno2006',                     IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'Cauzzi2015',                    IND = [T,T,T,S,F];             % [M,rrup,rhyp,VS30,usp];
        case 'DW12',                          IND = [T,T,F];                 % [M,rrup,usp];
        case 'FG15',                          IND = [T,T,T,S,F];             % [M,rrup,zhyp,VS30,usp];
        case 'TBA03',                         IND = [T,T,F];                 % [M,rrup,usp];
        case 'BU17',                          IND = [T,T,T,F];               % [M,rrup,zhyp,usp];
        case 'CB10',                          IND = [T,T,T,T,F,S,F];         % [M,rrup,rjb,ztor,dip,VS30,usp];
        case 'CB11',                          IND = [T,T,T,T,F,S,F];         % [M,rrup,rjb,ztor,dip,VS30,usp];
        case 'CB19',                          IND = [T,T,T,T,T,T,T,F,F,S,F]; % [M,rrup,rjb,UNK,UNK,ztor,zhyp,dip,999,VS30,usp];
        case 'KM06',                          IND = [T,T,F];                 % [M,rrup,usp];
        case 'medianPCEbchydro',              IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'medianPCEnga',                  IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'PCE_nga',                       IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'PCE_bchydro',                   IND = [T,T,S,F];               % [M,rrup,VS30,usp];
        case 'udm'
            Nparam = length(param);
            IND    = false(1,Nparam);
            IND(5) = true;
            for j=6:Nparam
                if numel(param{5})==numel(param{j})
                    IND(j)=true;
                end
            end
    end
    
    switch gmm.type
        case 'frn'
            IND2{jj}=IND;
    end
    
end

switch gmm.type
    case 'frn'
        IND=IND2;
end



