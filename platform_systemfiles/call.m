function[]=call(obj)

stx{1}='not found';
switch obj
    case 'point1'
        stx{1}='point1 label mech style RA sRA gmmptr strike dip vertices';
    case 'line1'
        stx{1}='line1 label  mechanism style RA sRA gmmptr dip lmax nref vertices';
    case 'area1'
        stx{1}='area1 label mechanism style RA sRA gmmptr lmax nref bc vertices';
        stx{2}='area1 label mechanism style RA sRA gmmptr dip usd lsd lmax nref bc vertices';
        stx{3}='area1 label mechanism style RA sRA gmmptr mat bc reduction';
    case 'area2'
        stx{1}='Area2 label mechanism style RA sRA gmmptr strike dip length width aratio dx vertices';
    case 'volume1'
        stx{1}='Volume1 label mechanism style RA sRA gmmptr lmax nref thick slices vertices';
    case 'txt2source'
        stx{1}='txt2soure filename gmmptr lmax nref radius center';
end

switch obj
    case 'delta'     , stx{1}='delta label stype svalue Mchar';
    case 'truncexp'  , stx{1}='truncexp label stype svalue bvalue MMin MMax sigmab sigmaMMax';
    case 'truncnorm' , stx{1}='truncnorm label stype svalue MMin MMax Mchar sigmaMChar';
    case 'yc1985'    , stx{1}='yc1985 label stype svalue bvalue MMin Mchar';
    case 'magtable'  , stx{1}='magtable label Mmin binwidth occurrates';
    case 'catalog'   , stx{1}='catalog label filename FDsup FDinf';
end

switch obj
    case 'Youngs1997'            , ME=pshatoolbox_methods(1,  1); stx{1}='% Syntax : Youngs1997 mechanism';
    case 'AtkinsonBoore2003'     , ME=pshatoolbox_methods(1,  2); stx{1}='% Syntax : AtkinsonBoore2003 mechanism region';
    case 'Zhao2006'              , ME=pshatoolbox_methods(1,  3); stx{1}='% Syntax : Zhao2006 mechanism';
    case 'Mcverry2006'           , ME=pshatoolbox_methods(1,  4); stx{1}='% Syntax : Mcverry2006 mechanism rvol';
    case 'ContrerasBoroschek2012', ME=pshatoolbox_methods(1,  5); stx{1}='% Syntax : ContrerasBoroschek2012';
    case 'BCHydro2012'           , ME=pshatoolbox_methods(1,  6); stx{1}='% Syntax : BCHydro2012 mechanism arc DeltaC1';
    case 'BCHydro2018'           , ME=pshatoolbox_methods(1,  7); stx{1}='% Syntax : BCHydro2018 mechanism';
    case 'Kuehn2020'             , ME=pshatoolbox_methods(1,  8); stx{1}='% Syntax : Kuehn2020 mechanism region AlfaBackArc AlphaNankai Z10 Z25 Nepist';
    case 'Parker2020'            , ME=pshatoolbox_methods(1,  9); stx{1}='% Syntax : Parker2020 Z25 mechanism region';
    case 'Arteta2018'            , ME=pshatoolbox_methods(1, 10); stx{1}='% Syntax : Arteta2018 arc';
    case 'Idini2016'             , ME=pshatoolbox_methods(1, 11); stx{1}='% Syntax : Idini2016 mechanism spectype';
    case 'MontalvaBastias2017'   , ME=pshatoolbox_methods(1, 12); stx{1}='% Syntax : MontalvaBastias2017 mechanism arc';
    case 'MontalvaBastias2017HQ' , ME=pshatoolbox_methods(1, 13); stx{1}='% Syntax : MontalvaBastias2017HQ mechanism arc';
    case 'Montalva2018'          , ME=pshatoolbox_methods(1, 14); stx{1}='% Syntax : Montalva2018 mechanism';
    case 'SiberRisk2019'         , ME=pshatoolbox_methods(1, 15); stx{1}='% Syntax : SiberRisk2019 mechanism';
    case 'Garcia2005'            , ME=pshatoolbox_methods(1, 16); stx{1}='% Syntax : Garcia2005 component';
    case 'Jaimes2006'            , ME=pshatoolbox_methods(1, 17); stx{1}='% Syntax : Jaimes2006';
    case 'Jaimes2015'            , ME=pshatoolbox_methods(1, 18); stx{1}='% Syntax : Jaimes2015 station';
    case 'Jaimes2016'            , ME=pshatoolbox_methods(1, 19); stx{1}='% Syntax : Jaimes2016';
    case 'GarciaJaimes2017'      , ME=pshatoolbox_methods(1, 20); stx{1}='% Syntax : GarciaJaimes2017 component';
    case 'GarciaJaimes2017VH'    , ME=pshatoolbox_methods(1, 21); stx{1}='% Syntax : GarciaJaimes2017HV';
    case 'GA2011'                , ME=pshatoolbox_methods(1, 22); stx{1}='% Syntax : GA11 SOF';
    case 'SBSA2016'              , ME=pshatoolbox_methods(1, 23); stx{1}='% Syntax : SBSA2016 SOF region';
    case 'GKAS2017'              , ME=pshatoolbox_methods(1, 24); stx{1}='% Syntax : GKAS2017 SOF region';
    case 'Bernal2014'            , ME=pshatoolbox_methods(1, 25); stx{1}='% Syntax : Bernal2014 mechanism';
    case 'Sadigh1997'            , ME=pshatoolbox_methods(1, 26); stx{1}='% Syntax : Sadigh1997 SOF';
    case 'I2008'                 , ME=pshatoolbox_methods(1, 27); stx{1}='% Syntax : I2008 SOF';
    case 'CY2008'                , ME=pshatoolbox_methods(1, 28); stx{1}='% Syntax : CY2008 Z10 SOF event VS30type';
    case 'BA2008'                , ME=pshatoolbox_methods(1, 29); stx{1}='% Syntax : BA2008 SOF';
    case 'CB2008'                , ME=pshatoolbox_methods(1, 30); stx{1}='% Syntax : CB2008 Z25 SOF sigmatype';
    case 'AS2008'                , ME=pshatoolbox_methods(1, 31); stx{1}='% Syntax : AS2008 Z10 SOF event Vs30type';
    case 'AS1997h'               , ME=pshatoolbox_methods(1, 32); stx{1}='% Syntax : AS1997h SOF location sigmatype';
    case 'I2014'                 , ME=pshatoolbox_methods(1, 33); stx{1}='% Syntax : I2014 SOF';
    case 'CY2014'                , ME=pshatoolbox_methods(1, 34); stx{1}='% Syntax : CY2014 Z10 SOF Vs30type region';
    case 'CB2014'                , ME=pshatoolbox_methods(1, 35); stx{1}='% Syntax : CB2014 Z25 SOF HWeffect region';
    case 'BSSA2014'              , ME=pshatoolbox_methods(1, 36); stx{1}='% Syntax : BSSA2014 Z10 SOF region';
    case 'ASK2014'               , ME=pshatoolbox_methods(1, 37); stx{1}='% Syntax : ASK2014 Z10 SOF event Vs30type region';
    case 'AkkarBoomer2007'       , ME=pshatoolbox_methods(1, 38); stx{1}='% Syntax : AkkarBoomer2007 stiff SOF damping';
    case 'AkkarBoomer2010'       , ME=pshatoolbox_methods(1, 39); stx{1}='% Syntax : AkkarBoomer2010 media SOF';
    case 'Akkar2014'             , ME=pshatoolbox_methods(1, 40); stx{1}='% Syntax : Akkar2014 SOF model';
    case 'Arroyo2010'            , ME=pshatoolbox_methods(1, 41); stx{1}='% Syntax : Arroyo2010';
    case 'Bindi2011'             , ME=pshatoolbox_methods(1, 42); stx{1}='% Syntax : Bindi2011 SOF component';
    case 'Kanno2006'             , ME=pshatoolbox_methods(1, 43); stx{1}='% Syntax : Kanno2006';
    case 'Cauzzi2015'            , ME=pshatoolbox_methods(1, 44); stx{1}='% Syntax : Cauzzi2015 Vs30form SOF';
    case 'DW12'                  , ME=pshatoolbox_methods(1, 45); stx{1}='% Syntax : DW12 SGSCLASS SOF';
    case 'FG15'                  , ME=pshatoolbox_methods(1, 46); stx{1}='% Syntax : FG15 SOF forearc rtype';
    case 'TBA03'                 , ME=pshatoolbox_methods(1, 47); stx{1}='% Syntax : TBA03 SGSCLASS SOF';
    case 'BU17'                  , ME=pshatoolbox_methods(1, 48); stx{1}='% Syntax : BU17 SOF CAV';
    case 'CB10'                  , ME=pshatoolbox_methods(1, 49); stx{1}='% Syntax : CB10 Z25 SOF';
    case 'CB11'                  , ME=pshatoolbox_methods(1, 50); stx{1}='% Syntax : CB11 Z25 SOF Database';
    case 'CB19'                  , ME=pshatoolbox_methods(1, 51); stx{1}='% Syntax : CB19 Z25 SOF region';
    case 'KM06'                  , ME=pshatoolbox_methods(1, 52); stx{1}='% Syntax : KM06 SOF';
    case 'medianPCEbchydro'      , ME=pshatoolbox_methods(1, 53); stx{1}='% Syntax : medianPCEbchydro';
    case 'medianPCEnga'          , ME=pshatoolbox_methods(1, 54); stx{1}='% Syntax : medianPCEnga';
    case 'udm'                   , ME=pshatoolbox_methods(1, 55); stx{1}='% Syntax : udm mfile param1 param2 ...';
    case 'MAB2019'               , ME=pshatoolbox_methods(1, 56); stx{1}='% Syntax : MAB2019 mechanism region handle {param}';
    case 'MAL2020'               , ME=pshatoolbox_methods(1, 57); stx{1}='% Syntax : MAL2020 HWeffect handle {param}';
    case 'MMLA2020'              , ME=pshatoolbox_methods(1, 58); stx{1}='% Syntax : MMLA2020 handle {param}';
    case 'ML2021'                , ME=pshatoolbox_methods(1, 59); stx{1}='% Syntax : ML2021 mechanism handle {param}';
    case 'MCAVdp2021'            , ME=pshatoolbox_methods(1, 60); stx{1}='% Syntax : MCAVdp2021 mechanism handle {param}';    
    case 'PCE_nga'               , ME=pshatoolbox_methods(1, 61); stx{1}='% Syntax : PCE_bchydro';
    case 'PCE_bchydro'           , ME=pshatoolbox_methods(1, 62); stx{1}='% Syntax : PCE_nga';
    case 'franky'                , ME=pshatoolbox_methods(1, 63); stx{1}='% Syntax : franky gmm1 gmm2 gmm3 ...';
end


fid=fopen(sprintf('%s.m',obj),'r');
if fid~=-1
    line = textscan(fid,'%s','delimiter','\n');
    line = line{1};
    fclose(fid);
end

% display results
fprintf('Object: %s\n',obj)

if exist('line','var')
    fprintf('\n')
    disp(line{1})
    fprintf('-------------------------------------------------------------\n')
end

if exist('ME','var')
    disp(ME)
    fprintf('-------------------------------------------------------------\n')
end

fprintf('   Syntax: %s\n',stx{:})
