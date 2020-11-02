function [param,val] = mGMPEusp(gmm,SUB,SC,SITE) %#ok<*INUSD,*DEFNU>

method = pshatoolbox_methods(1);
val    = zeros(1,18);
fun = func2str(gmm.handle);

[~,B]  = intersect({method.str},fun);
val(end)=B;

usp   = gmm.usp;
VS30  = SITE.VS30;
f0    = SITE.f0;

switch fun
    case 'Youngs1997'
        media      = 'rock';
        [~,val(4)] = intersect({'rock','soil'},media);
        [~,val(5)] = intersect({'interface','intraslab'},usp{1});
    case 'AtkinsonBoore2003'
        media = 'nehrpb';
        [~,val(4)]=intersect({'nehrpb','nehrpc','nehrpd','nehrpe'},media);
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        [~,val(6)]=intersect({'general','cascadia','japan'},usp{2});
    case 'Zhao2006'
        media = VS30;
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(5)]=intersect({'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
    case 'Mcverry2006'
        media = 'B';
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(4)]= intersect({'A','B','C','D','E'},media);
        [~,val(5)]=intersect({'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
    case 'ContrerasBoroschek2012'
        media = 'rock';
        [~,val(4)]= intersect({'rock','soil'},media);
    case 'BCHydro2012'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        [~,val(6)]=intersect({'forearc','backarc','unknown'},usp{2});
        [~,val(7)]=intersect({'lower','central','upper','none'},usp{3});
    case 'BCHydro2018'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        
    case 'Kuehn2020'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        [~,val(6)]=intersect({'global','aleutian','alaska','cascadia','central_america_s','central_america_n','japan_pac','japan_phi','new_zealand_n','new_zealand_s','south_america_n','south_america_s','taiwan_w','taiwan_e'},usp{2});
        
    case 'Parker2020'
        media = VS30;
        [~,val(6)]=intersect({'interface','intraslab'},usp{2});
        [~,val(7)]=intersect({'global','aleutian','alaska','cascadia','central_america_s','central_america_n','japan_pac','japan_phi','south_america_n','south_america_s','taiwan'},usp{3});
        
    case 'Arteta2018'
        media = 'rock';
        [~,val(3)]=intersect({'rock','soil'},media);
        [~,val(4)]=intersect({'forearc','backarc'},usp{1});
    case 'Idini2016'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        [~,val(6)]=intersect({'si','sii','siii','siv','sv','svi'},usp{2});
    case 'MontalvaBastias2017'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        [~,val(6)]=intersect({'forearc','backarc','unknown'} ,usp{2});
    case 'MontalvaBastias2017HQ'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
        [~,val(6)]=intersect({'forearc','backarc','unknown'} ,usp{2});
    case 'Montalva2018'
        [~,val(6)]=intersect({'interface','intraslab'},usp{1});
    case 'SiberRisk2019'
        media = VS30;
        [~,val(5)]=intersect({'interface','intraslab'},usp{1});
    case 'Garcia2005'
        [~,val(4)]=intersect({'horizontal','vertical'},usp{1});
    case 'Jaimes2006'
    case 'Jaimes2015'
        [~,val(3)]=intersect({'cu','sct','cdao'},usp{1});
    case 'Jaimes2016'
    case 'GarciaJaimes2017'
        [~,val(3)]=intersect({'vertical','horizontal'},usp{1});
    case 'GarciaJaimes2017VH'
        
    case 'GA2011'
        media = VS30;
        [~,val(4)]= intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        
    case 'SBSA2016'
        media = VS30;
        [~,val(4)]= intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        [~,val(5)]= intersect({'global','california','japan','china','italy','turkey'},usp{2});
        
    case 'GKAS2017'
        media = VS30;
        [~,val(10)]= intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        [~,val(11)]= intersect({'global','japan','china','italy','middle-east','taiwan'},usp{2});        
        
    case 'Bernal2014'
        [~,val(4)]=intersect({'interface','intraslab'},usp{1});
    case 'Sadigh1997'
        media = 'rock';
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(3)]= intersect({'deepsoil','rock'},media);
        [~,val(4)]= intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
    case 'I2008'
        media = VS30;
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(4)]= intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
    case 'CY2008'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(9)]  = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(10)] = intersect({'mainshock','aftershock'},usp{3});
        [~,val(11)] = intersect({'measured','inferred'},usp{4});
    case 'BA2008'
        media = VS30;
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(4)] =intersect({'unspecified','strike-slip','normal','reverse'},usp{1});
    case 'CB2008'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(8)] =intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(9)] =intersect({'arbitrary','average'},usp{3});
    case 'AS2008'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(10)] =intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(11)] =intersect({'aftershock','mainshock','foreshock','swarms'},usp{3});
        [~,val(12)] =intersect({'measured','inferred'},usp{4});
    case 'AS1997h'
        media = 'rock';
        usp{1}= strrep(usp{1},'auto','strike-slip');
        val(3)=1;
        [~,val(4)] =intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        [~,val(5)] =intersect({'hangingwall','footwall','other'},usp{2});
        [~,val(6)] =intersect({'arbitrary','average'},usp{3});
    case 'I2014'
        media = VS30;
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(4)]= intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
    case 'CY2014'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(9)] =intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(10)]=intersect({'measured','inferred'},usp{3});
        [~,val(11)]=intersect({'global','california','japan','china','italy','turkey'},usp{4});
    case 'CB2014'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(12)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(13)] = intersect({'include','exclude'},usp{3});
        [~,val(14)] = intersect({'global','california','japan','china','italy','turkey'},usp{4});
    case 'BSSA2014'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(5)] =intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(6)] =intersect({'global','california','japan','china','italy','turkey'},usp{3});
    case 'ASK2014'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(11)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(12)] = intersect({'mainshock','aftershock'},usp{3});
        [~,val(13)] = intersect({'measured','inferred'},usp{4});
        [~,val(14)] = intersect({'global','california','japan','china','italy','turkey'},usp{5});
    case 'AkkarBoomer2007'
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(3)]  = intersect({'stiff','soft','other'},usp{1});
        [~,val(4)]  = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(5)]  = intersect({'2','5','10','20','30'},sprintf('%g',usp{3}));
    case 'AkkarBoomer2010'
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(3) ] = intersect({'rock','stiff','soft'},usp{1});
        [~,val(4)]  = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        
    case 'Akkar2014'
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(6)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        [~,val(7)] = intersect({'rhyp','rjb','repi'},usp{2});
        
    case 'Arroyo2010'
        
    case 'Bindi2011'
        media = 'A';
        usp{1}= strrep(usp{1},'auto','strike-slip');
        val(3)=1;
        [~,val(4)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        [~,val(5)] = intersect({'geoh','z'},usp{2});
    case 'Kanno2006'
        
    case 'Cauzzi2015'
        %Cauzzi2015(To,M,Rrup,Rhyp,Vs30,Vs30form,SOF)
        [~,val(5)]  = intersect({'1','2','3'},num2str(usp{1}));
        [~,val(6)]  = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        
    case 'DW12'
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(3)]  = intersect({'b','c','d'},lower(usp{1}));
        [~,val(4) ] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
    case 'FG15'
        media = VS30;
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(5) ] = intersect({'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
        [~,val(6) ] = intersect({'forearc','backarc'},usp{2});
        [~,val(7) ] = intersect({'linear','nonlinear'},usp{3});
    case 'TBA03'
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(3)] = intersect({'b','c','d'},lower(usp{1}));
        [~,val(4)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
    case 'BU17'
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(4)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified','intraplate','subduction-interface','subduction-intraslab','subduction-unknown'},usp{1});
        [~,val(5)] = intersect({'cav','cav5','cavstd'},usp{2});
    case 'CB10'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(8)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        
    case 'CB11'
        %M,Rrup,Rjb,Ztor,dip,Vs30,Z25,SOF,Database
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(8)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(9)] = intersect({'cb08-nga-psv','cb08-nga-nopsv','peer-nga-psv','peer-nga-nopsv'},usp{3});
    case 'CB19'
        media = VS30;
        usp{2}= strrep(usp{2},'auto','strike-slip');
        [~,val(12)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{2});
        [~,val(13)] = intersect({'global','california','japan','china','italy','turkey'},usp{3});
    case 'KM06'
        usp{1}= strrep(usp{1},'auto','strike-slip');
        [~,val(3)] = intersect({'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'},usp{1});
    case 'medianPCEbchydro'
        
    case 'medianPCEnga'
        
        
        
        
end


M     = SC.Mag;
dip   = SC.dip;
width = SC.W;
Zhyp  = SC.Zhyp;
Ztor  = SC.Ztor;
Zbot  = SC.Zbot;
Rrup  = SC.Rrup;
Rhyp  = SC.Rhyp;
Rx    = SC.Rx;
Rjb   = SC.Rjb;
Ry0   = SC.Ry0;
Repi  = SC.Repi;

switch fun
    case 'Youngs1997',              param = [M,Rrup,Zhyp,media,usp];
    case 'AtkinsonBoore2003',       param = [M,Rrup,Zhyp,media,usp];
    case 'Zhao2006',                param = [M,Rrup,Zhyp,media,usp];
    case 'Mcverry2006',             param = [M,Rrup,Zhyp,media,usp];
    case 'ContrerasBoroschek2012',  param = [M,Rrup,Zhyp,media,usp];
    case 'BCHydro2012',             param = [M,Rrup,Zhyp,media,usp];        % SOLO aca, Rhyp Eliminado
    case 'BCHydro2018',             param = [M,Rrup,usp];
    case 'Kuehn2020',               param = [M,Rrup,Ztor,media,usp];
    case 'Parker2020',              param = [M,Rrup,Zhyp,media,usp];
    case 'Arteta2018',              param = [M,Rhyp,media,usp];
    case 'Idini2016',               param = [M,Rrup,Zhyp,media,usp];        % SOLO aca, Rhyp Eliminado
    case 'MontalvaBastias2017',     param = [M,Rrup,Zhyp,media,usp];        % SOLO aca, Rhyp Eliminado
    case 'MontalvaBastias2017HQ',   param = [M,Rrup,Zhyp,media,usp];        % SOLO aca, Rhyp Eliminado
    case 'Montalva2018',            param = [M,Rrup,Zhyp,VS30,f0,usp];
    case 'SiberRisk2019',           param = [M,Rrup,Zhyp,media,usp];
    case 'Garcia2005',              param = [M,Rrup,Zhyp,usp];
    case 'Jaimes2006',              param = [M,Rrup,usp];
    case 'Jaimes2015',              param = [M,Rrup,usp];
    case 'Jaimes2016',              param = [M,Rrup,usp];
    case 'GarciaJaimes2017',        param = [M,Rrup,usp];
    case 'GarciaJaimes2017VH',      param = [M,Rrup,usp];
    case 'GA2011',                  param = [M,Rrup,media,usp];
    case 'SBSA2016',                param = [M,Rjb,media,usp];
    case 'GKAS2017',                param = [M,Rrup,Rjb,Rx,Ry0,Ztor,dip,width,media,usp];
    case 'Bernal2014',              param = [M,Rrup,Zhyp,usp];
    case 'Sadigh1997',              param = [M,Rrup,media,usp];
    case 'I2008',                   param = [M,Rrup,media,usp];
    case 'CY2008',                  param = [M,Rrup,Rjb,Rx,Ztor,dip,media,usp];
    case 'BA2008',                  param = [M,Rjb,media,usp];
    case 'CB2008',                  param = [M,Rrup,Rjb,Ztor,dip,media,usp];
    case 'AS2008',                  param = [M,Rrup,Rjb,Rx,Ztor,dip,width,media,usp];
    case 'AS1997h',                 param = [M,Rrup,media,usp];
    case 'I2014',                   param = [M,Rrup,media,usp];
    case 'CY2014',                  param = [M,Rrup,Rjb,Rx,Ztor,dip,media,usp];
    case 'CB2014',                  param = [M,Rrup,Rjb,Rx,Zhyp,Ztor,'unk',dip,width,media,usp];
    case 'BSSA2014',                param = [M,Rjb,media,usp];
    case 'ASK2014',                 param = [M,Rrup,Rjb,Rx,Ry0,Ztor,dip,width,media,usp];
    case 'AkkarBoomer2007',         param = [M,Rjb,usp];
    case 'AkkarBoomer2010',         param = [M,Rjb,usp];
    case 'Akkar2014',               param = [M,Rhyp,Rjb,Repi,usp];
    case 'Arroyo2010',              param = [M,Rrup,usp];
    case 'Bindi2011',               param = [M,Rjb,media,usp];
    case 'Kanno2006',               param = {M,Rrup,Zhyp,VS30};
    case 'Cauzzi2015',              param = [M,Rrup,VS30,usp];
        
    case 'DW12',                    param = [M,Rrup,usp];
    case 'FG15',                    param = [M,Rrup,Zhyp,media,usp];
    case 'TBA03',                   param = [M,Rrup,usp];
    case 'BU17',                    param = [M,Rrup,Zhyp,usp];
    case 'CB10',                    param = [M,Rrup,Rjb,Ztor,dip,VS30,usp];
    case 'CB11',                    param = [M,Rrup,Rjb,Ztor,dip,VS30,usp];
    case 'CB19',                    param = [M,Rrup,Rjb,Rx,Zhyp,Ztor,Zbot,dip,width,VS30,usp];
    case 'KM06',                    param = [M,Rrup,usp];
        
    case 'medianPCEbchydro',       param = [M,Rrup,VS30];
    case 'medianPCEnga',           param = [M,Rrup,VS30];
        
end
