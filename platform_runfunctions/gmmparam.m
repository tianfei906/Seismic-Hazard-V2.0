function [param]=gmmparam(M,Rrup,Rhyp,Rjb,Rx,Ry0,Zhyp,Ztor,media,dip,W,gmm)


%% GMM Parameters
VS30     = media(1);
Ndepend  = 1;
isfrn    = false;
switch gmm.type
    case 1, str_test = gmm.id;
    case 2, str_test = gmm.id;
    case 3, str_test = gmm.cond{2};
    case 4
        isfrn   = true;
        Ndepend = length(gmm.usp);
        funcs   = cell(1,Ndepend);
        IMlist  = cell(1,Ndepend);
        PARAM   = cell(1,Ndepend);
end

for jj=1:Ndepend
    if isfrn
        if gmm.usp{jj}.type==1 %'regular'
            str_test = gmm.usp{jj}.id;
        else
            str_test = gmm.usp{jj}.cond{2};
        end
        usp      = gmm.usp{jj}.usp;
    else
        usp     = gmm.usp;
    end
    
    switch str_test
        case 1 , param = [M,Rrup,Zhyp,VS30,usp];                          %'Youngs1997',
        case 2 , param = [M,Rrup,Zhyp,VS30,usp];                          %'AtkinsonBoore2003',
        case 3 , param = [M,Rrup,Zhyp,VS30,usp];                          %'Zhao2006',
        case 4 , param = [M,Rrup,Zhyp,VS30,usp];                          %'Mcverry2006',
        case 5 , param = [M,Rrup,Zhyp,VS30,usp];                          %'ContrerasBoroschek2012',
        case 6 , param = [M,Rrup,Rhyp,Zhyp,VS30,usp];                     %'BCHydro2012',
        case 7 , param = [M,Rrup,Ztor,VS30,usp];                          %'BCHydro2018',
        case 8 , param = [M,Rrup,Ztor,VS30,usp];                          %'Kuehn2020',
        case 9 , param = [M,Rrup,Zhyp,VS30,usp];                          %'Parker2020',
        case 10, param = [M,Rhyp,VS30,usp];                               %'Arteta2018',
        case 11, param = [M,Rrup,Rhyp,Zhyp,VS30,usp];                     %'Idini2016',
        case 12, param = [M,Rrup,Rhyp,Zhyp,VS30,usp];                     %'MontalvaBastias2017',
        case 13, param = [M,Rrup,Rhyp,Zhyp,VS30,usp];                     %'MontalvaBastias2017HQ',
        case 14, param = [M,Rrup,Rhyp,Zhyp,media(1),media(2),usp];        %'Montalva2018',
        case 15, param = [M,Rrup,Rhyp,Zhyp,VS30,usp];                     %'SiberRisk2019',
        case 16, param = [M,Rrup,Rhyp,Zhyp,usp];                          %'Garcia2005',
        case 17, param = [M,Rrup,usp];                                    %'Jaimes2006',
        case 18, param = [M,Rrup,usp];                                    %'Jaimes2015',
        case 19, param = [M,Rrup,usp];                                    %'Jaimes2016',
        case 20, param = [M,Rrup,usp];                                    %'GarciaJaimes2017',
        case 21, param = [M,Rrup,usp];                                    %'GarciaJaimes2017VH',
        case 22, param = [M,Rrup,VS30,usp];                               %'GA2011',
        case 23, param = [M,Rjb,VS30,usp];                                %'SBSA2016',
        case 24, param = [M,Rrup,Rjb,Rx,Ry0,Ztor,dip,W,VS30,usp];         %'GKAS2017',
        case 25, param = [M,Rrup,Zhyp,usp];                               %'Bernal2014',
        case 26, param = [M,Rrup,VS30,usp];                               %'Sadigh1997',
        case 27, param = [M,Rrup,VS30,usp];                               %'I2008',
        case 28, param = [M,Rrup,Rjb,Rx,Ztor,dip,VS30,usp];               %'CY2008',
        case 29, param = [M,Rjb,VS30,usp];                                %'BA2008',
        case 30, param = [M,Rrup,Rjb,Ztor, dip,VS30,usp];                 %'CB2008',
        case 31, param = [M,Rrup,Rjb,Rx,Ztor,dip,W,VS30,usp];             %'AS2008',
        case 32, param = [M,Rrup,VS30,usp];                               %'AS1997h',
        case 33, param = [M,Rrup,VS30,usp];                               %'I2014',
        case 34, param = [M,Rrup,Rjb,Rx,Ztor,dip,VS30,usp];               %'CY2014',
        case 35, param = [M,Rrup,Rjb,Rx,Zhyp,Ztor,-999,dip,W,VS30,usp];   %'CB2014',
        case 36, param = [M,Rjb,VS30,usp];                                %'BSSA2014',
        case 37, param = [M,Rrup,Rjb,Rx,Ry0,Ztor,dip,W,VS30,usp];         %'ASK2014',
        case 38, param = [M,Rjb,usp];                                     %'AkkarBoomer2007',
        case 39, param = [M,Rjb,usp];                                     %'AkkarBoomer2010',
        case 40, param = [M,Rhyp,Rjb,Rjb,VS30,usp];                       %'Akkar2014',
        case 41, param = [M,Rrup,usp];                                    %'Arroyo2010',
        case 42, param = [M,Rjb,VS30,usp];                                %'Bindi2011',
        case 43, param = [M,Rrup,Zhyp,VS30,usp];                          %'Kanno2006',
        case 44, param = [M,Rrup,Rhyp,VS30,usp];                          %'Cauzzi2015',
        case 45, param = [M,Rrup,usp];                                    %'DW12',
        case 46, param = [M,Rrup,Zhyp,VS30,usp];                          %'FG15',
        case 47, param = [M,Rrup,usp];                                    %'TBA03',
        case 48, param = [M,Rrup,Zhyp,usp];                               %'BU17',
        case 49, param = [M,Rrup,Rjb,Ztor,dip,VS30,usp];                  %'CB10',
        case 50, param = [M,Rrup,Rjb,Ztor,dip,VS30,usp];                  %'CB11',
        case 51, param = [M,Rrup,Rjb,Rx,Zhyp,Ztor,-999,dip,W,VS30,usp];   %'CB19',
        case 52, param = [M,Rrup,usp];                                    %'KM06',
        case 53, param = [M,Rrup,VS30,usp];                               %'medianPCEbchydro',
        case 54, param = [M,Rrup,VS30,usp];                               %'medianPCEnga',
        case 55, param = [M,Rrup,VS30,usp];                               %'PCE_nga',
        case 56, param = [M,Rrup,VS30,usp];                               %'PCE_bchydro',
            
        case 63, param = [M,Rrup,usp];                                    %'Jaimes2018', 
            
    end
    
    switch gmm.type
        case 3 % cond
            gmmcond = gmm.cond{1};
            switch gmm.id %func2str(gmm.handle)
                case 57, param = {M,Rrup,gmm.txt{4},gmm.txt{5},VS30,gmmcond,param{:}}; %#ok<CCAT> %MAB2019
                case 58, param = {M,Rrup,Rjb,gmm.txt{4},dip,VS30 ,gmmcond,param{:}}; %#ok<CCAT>   %MAL2020
                case 59, param = {M,Rrup,VS30 ,gmmcond,param{:}}; %#ok<CCAT>                      %MMLA2020
                case 60, param = {M,Rrup,gmm.txt{4},VS30 ,gmmcond,param{:}}; %#ok<CCAT>           %ML2021
                case 61, param = {M,Rrup,gmm.txt{4},VS30 ,gmmcond,param{:}}; %#ok<CCAT>           %MCAVdp2021
            end
        case 4 %'frn'
            funcs {jj}=gmm.usp{jj}.handle;
            IMlist{jj}=gmm.usp{jj}.T;
            
            switch gmm.usp{jj}.type
                case 1 %'regular'
                    PARAM {jj}=param;
                case 3 %'cond'
                    gmmcond=gmm.usp{jj}.cond{1};
                    switch gmm.usp{jj}.id
                        case 57, PARAM{jj} = {M,Rrup,gmm.usp{jj}.txt{4},gmm.usp{jj}.txt{5},VS30,gmmcond,param{:}}; %#ok<CCAT>  %MAB2019
                        case 58, PARAM{jj} = {M,Rrup,Rjb,gmm.usp{jj}.txt{4},dip,VS30 ,gmmcond,param{:}}; %#ok<CCAT>            %MAL2020
                        case 59, PARAM{jj} = {M,Rrup,VS30 ,gmmcond,param{:}}; %#ok<CCAT>                                       %MMLA2020
                        case 60, PARAM{jj} = {M,Rrup,gmm.usp{jj}.txt{4},VS30 ,gmmcond,param{:}}; %#ok<CCAT>                    %ML2021
                        case 61, PARAM{jj} = {M,Rrup,gmm.usp{jj}.txt{4},VS30 ,gmmcond,param{:}}; %#ok<CCAT>                    %MCAVdp2021
                    end
            end
    end
end

if isfrn
    param=[funcs,IMlist,PARAM];
end

