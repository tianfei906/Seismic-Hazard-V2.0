function [param,tag]=mGMPEdefault_conditional(handles,str,upd)

MEC ={'interface','intraslab'};
SOF ={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};

SUB  = handles.SUB;
SC   = handles.SC;
mech = SUB.Mech;
sof  = SC.Mech;
sigmatype = 'average';

mechanism = MEC{mech};
SOF       = SOF{sof};


SITE = handles.SITE;
VS30 = SITE.VS30;
f0   = SITE.f0;
Z10  = SITE.Z10;
Z25  = SITE.Z25;
SGS  = SITE.SGS;
Vs30type = 'measured';
region   = 'global';
arc      = 'forearc';

switch str
    case 'Youngs1997'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Zhyp,VS30,mechanism};
        tag   = {'M','Rrup','Zhyp','media','mechanism'};
        
        
    case 'AtkinsonBoore2003'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        media = VS30;
        param = {M,Rrup,Zhyp,media,mechanism,'general'};
        tag   = {'M','Rrup','Zhyp','media','mechanism','region'};
        
    case 'Zhao2006'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Zhyp,VS30,mechanism};
        tag   = {'M','Rrup','Zhyp','Vs30','mechanism'};
        
        
    case 'Mcverry2006'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        rvol  = 0;
        param = {M,Rrup,Zhyp,VS30,mechanism,rvol};
        tag   = {'M','Rrup','Zhyp','media','mechanism','rvol'};
        
        
    case 'ContrerasBoroschek2012'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Zhyp,VS30};
        tag   = {'M','Rrup','Zhyp','media'};
        
        
    case 'BCHydro2012'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Rhyp  = SUB.Rhyp;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,arc,'central'};
        tag   = {'M','Rrup','Rhyp','Zhyp','VS30','mechanism','arc','DeltaC1'};
        
        
    case 'BCHydro2018'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Ztor  = SUB.Ztor;
        param = {M,Rrup,Ztor,VS30,mechanism};
        tag   = {'M','Rrup','Ztor','VS30','mechanism'};
        
    case 'Kuehn2020'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Ztor  = SUB.Ztor;
        param = {M,Rrup,Ztor,VS30,mechanism,region,0,0,Z10,Z25,0};
        tag   = {'M','Rrup','Ztor','VS30','mechanism','region','alfaBackArc','alfaNankai','Z10','Z25','Nepist'};
        
        
    case 'Parker2020'
        %M,Rrup,Zhyp,VS30,Z25,mechanism,region
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Zhyp,VS30,Z25,mechanism,region};
        tag   = {'M','Rrup','Zhyp','VS30','Z25','mechanism','region'};
        
    case 'Arteta2018'
        M     = SUB.Mag;
        Rhyp  = SUB.Rhyp;
        param = {M,Rhyp,VS30,arc};
        tag   = {'M','Rhyp','media','arc'};
        
    case 'Idini2016'
        M        = SUB.Mag;
        Rrup     = SUB.Rrup;
        Rhyp     = SUB.Rhyp;
        Zhyp     = SUB.Zhyp;
        spectrum = {'si','sii','siii','siv','sv','svi'};
        spectrum = spectrum{SITE.Idini};
        param    = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,spectrum};
        tag      = {'M','Rrup','Rhyp','Zhyp','VS30','mechanism','spectrum'};
        
    case {'MontalvaBastias2017','MontalvaBastias2017HQ'}
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Rhyp  = SUB.Rhyp;
        Zhyp  = SUB.Zhyp;        
        param = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,arc};
        tag   = {'M','Rrup','Rhyp','Zhyp','VS30','mechanism','arc'};
        
    case 'Montalva2018'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Rhyp  = SUB.Rhyp;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Rhyp,Zhyp,VS30,f0,mechanism};
        tag   = {'M','Rrup','Rhyp','Zhyp','VS30','f0','mechanism'};
        
    case 'SiberRisk2019'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Rhyp  = SUB.Rhyp;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Rhyp,Zhyp,VS30,mechanism};
        tag   = {'M','Rrup','Rhyp','Zhyp','VS30','mechanism'};
        
    case 'Garcia2005'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Rhyp  = SUB.Rhyp;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Rhyp,Zhyp,'horizontal'};
        tag   = {'M','Rrup','Rhyp','Zhyp','direction'};
        
    case 'Jaimes2006'
        M     = SUB.Mag;
        Rrup  = '400';
        param = {M,Rrup};
        tag   = {'M','Rrup'};
        
    case 'Jaimes2015'
        M     = SUB.Mag;
        Rrup  = '200';
        param = {M,Rrup,'CU'};
        tag   = {'M','Rrup','station'};
        
    case 'Jaimes2016'
        M     = '3.0';
        Rrup  = '10';
        param = {M,Rrup};
        tag   = {'M','Rrup'};
        
    case 'GarciaJaimes2017'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        param = {M,Rrup,'horizontal'};
        tag   = {'M','Rrup','component'};
        
    case 'GarciaJaimes2017VH'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        param = {M,Rrup};
        tag   = {'M','Rrup'};
        
    case 'GA2011'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,VS30,SOF};
        tag   = {'M','Rrup','VS30','SOF'};
        
    case 'SBSA2016'
        %M,Rjb,VS30,SOF,region
        M     = SC.Mag;
        Rjb   = SC.Rjb;
        param = {M,Rjb,VS30,SOF,region};
        tag   = {'M','Rjb','VS30','SOF','region'};
        
    case 'GKAS2017'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Ry0   = SC.Ry0;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        width = SC.W;
        param = {M,Rrup,Rjb,Rx,Ry0,Ztor,dip,width,VS30,SOF,region};
        tag   = {'M','Rrup','Rjb','Rx','Ry0','Ztor','dip','width','VS30','SOF','region'};
        
    case 'Bernal2014'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Zhyp,mechanism};
        tag   = {'M','Rrup','Zhyp','mechanism'};
        
    case 'Sadigh1997'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,VS30,SOF};
        tag   = {'M','Rrup','media','SOF'};
        
    case 'I2008'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,VS30,SOF};
        tag   = {'M','Rrup','VS30','SOF'};
        
    case 'CY2008'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        param = {M,Rrup,Rjb,Rx,Ztor,dip,VS30,Z10,SOF,'mainshock',Vs30type};
        tag   = {'M','Rrup','Rjb','Rx','Ztor','dip','Vs30','Z10','SOF','event','Vs30type'};
        
    case 'BA2008'
        M     = SC.Mag;
        Rjb   = SC.Rjb;
        param = {M,Rjb,VS30,SOF};
        tag   = {'M','Rjb','VS30','SOF'};
        
    case 'CB2008'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        param = {M,Rrup,Rjb,Ztor,dip,VS30,Z25,SOF,sigmatype};
        tag   = {'M','Rrup','Rjb','Ztor','dip','VS30','Z25','SOF','sigmatype'};
        
    case 'AS2008'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        width = SC.W;
        param = {M,Rrup,Rjb,Rx,Ztor,dip,width,VS30,Z10,SOF,'mainshock',Vs30type};
        tag   = {'M','Rrup','Rjb','Rx','Ztor','dip','width','VS30','Z10','SOF','event','Vs30type'};
        
    case 'AS1997h'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,VS30,SOF,'other',sigmatype};
        tag   = {'M','Rrup','media','SOF','location','sigmatype'};
        
    case 'I2014'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,VS30,SOF};
        tag   = {'M','Rrup','VS30','SOF'};
        
    case 'CY2014'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        param = {M,Rrup,Rjb,Rx,Ztor,dip,VS30,Z10,SOF,Vs30type,region};
        tag   = {'M','Rrup','Rjb','Rx','Ztor','dip','VS30','Z10','SOF','Vs30type','region'};
        
    case 'CB2014'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Zhyp  = SC.Zhyp;
        Ztor  = SC.Ztor;
        Zbot  = SC.Zbot;
        dip   = SC.dip;
        width = SC.W;
        param = {M,Rrup,Rjb,Rx,Zhyp,Ztor,Zbot,dip,width,VS30,Z25,SOF,'exclude',region};
        tag   = {'M','Rrup','Rjb','Rx','Zhyp','Ztor','Zbot','dip','width','VS30','Z25','SOF','HWEffect','region'};
        
    case 'BSSA2014'
        M     = SC.Mag;
        Rjb   = SC.Rjb;
        param = {M,Rjb,VS30,Z10,SOF,region};
        tag   = {'M','Rjb','VS30','Z10','SOF','region'};
        
    case 'ASK2014'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Ry0   = SC.Ry0;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        width = SC.W;
        param = {M,Rrup,Rjb,Rx,Ry0,Ztor,dip,width,VS30,Z10,SOF,'mainshock',Vs30type,region};
        tag   = {'M','Rrup','Rjb','Rx','Ry0','Ztor','dip','width','VS30','Z10','SOF','event','Vs30type','region'};
        
    case 'AkkarBoomer2007'
        
        if VS30>=750
            siteQualyAkkarBoomer = 1;
        elseif and(360<=VS30,VS30<750)
            siteQualyAkkarBoomer = 2;
        else
            siteQualyAkkarBoomer = 3;
        end
        M        = SC.Mag;
        Rjb      = SC.Rjb;        
        soiltype = {'stiff','soil','other'};
        soiltype = soiltype{siteQualyAkkarBoomer};
        param    = {M,Rjb,soiltype,SOF,'5'};
        tag      = {'M','Rjb','media','SOF','damping'};
        
    case 'AkkarBoomer2010'

        if VS30>=750
            siteQualyAkkarBoomer = 1;
        elseif and(360<=VS30,VS30<750)
            siteQualyAkkarBoomer = 2;
        else
            siteQualyAkkarBoomer = 3;
        end
        M        = SC.Mag;
        Rjb      = SC.Rjb;    
        soiltype = {'rock','stiff','soft'};
        soiltype = soiltype{siteQualyAkkarBoomer};
        param    = {M,Rjb,soiltype,SOF};
        tag      = {'M','Rjb','media','SOF'};
        
    case 'Akkar2014'
        M     = SC.Mag;
        Rhyp  = SC.Rhyp;
        Rjb   = SC.Rjb;
        Repi  = SC.Rjb;  % ojo aca
        param = {M,Rhyp,Rjb,Repi,VS30,SOF,'rhyp'};
        tag   = {'M','Rhyp','Rjb','Repi','VS30','SOF','model'};
        
    case 'Arroyo2010'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup};tag   = {'M','Rrup'};
        
    case 'Bindi2011'
        M     = SC.Mag;
        Rjb   = SC.Rjb;
        param = {M,Rjb,VS30,SOF,'GeoH'};
        tag   = {'M','Rjb','media','SOF','component'};
        
    case 'Kanno2006'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        Zhyp  = SUB.Zhyp;
        param = {M,Rrup,Zhyp,VS30};
        tag   = {'M','Rrup','Zhyp','VS30'};
        
    case 'Cauzzi2015'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rhyp  = SC.Rhyp;
        param = {M,Rrup,Rhyp,VS30,1,SOF};
        tag   = {'M','Rrup','Rhyp','VS30','Vs30form','SOF'};
        
    case 'DW12'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,SGS,SOF};
        tag   = {'M','Rrup','media','SOF'};
        
    case 'FG15'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Zhyp  = SC.Zhyp;
        param = {M,Rrup,Zhyp,VS30,SOF,arc,'linear'};
        tag   = {'M','Rrup','Zhyp','VS30','SOF','arc','regtype'};
        
    case 'TBA03'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,SGS,SOF};
        tag   = {'M','Rrup','media','SOF'};
        
    case 'BU17'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Zhyp  = SC.Zhyp;
        param = {M,Rrup,Zhyp,SOF,'CAV'};
        tag   = {'M','Rrup','Zhyp','mechanism','imtype'};
        
    case 'CB10'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        param = {M,Rrup,Rjb,Ztor,dip,VS30,Z25,SOF};
        tag   = {'M','Rrup','Rjb','Ztor','dip','VS30','Z25','SOF'};
        
    case 'CB11'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Ztor  = SC.Ztor;
        dip   = SC.dip;
        param = {M,Rrup,Rjb,Ztor,dip,VS30,Z25,SOF,'CB08-NGA-PSV'};
        tag   = {'M','Rrup','Rjb','Ztor','dip','VS30','Z25','SOF','Database'};
        
    case 'CB19'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        Rjb   = SC.Rjb;
        Rx    = SC.Rx;
        Zhyp  = SC.Zhyp;
        Ztor  = SC.Ztor;
        Zbot  = SC.Zbot;
        dip   = SC.dip;
        width = SC.W;
        param = {M,Rrup,Rjb,Rx,Zhyp,Ztor,Zbot,dip,width,VS30,Z25in,SOF,region};
        tag   = {'M','Rrup','Rjb','Rx','Zhyp','Ztor','Zbot','dip','width','VS30','Z25in','SOF','region'};
        
    case 'KM06'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,SOF};
        tag   = {'M','Rrup','SOF'};
        
    case 'medianPCEbchydro'
        M     = SUB.Mag;
        Rrup  = SUB.Rrup;
        param = {M,Rrup,VS30};
        tag   = {'M','Rrup','VS30'};
        
    case 'medianPCEnga'
        M     = SC.Mag;
        Rrup  = SC.Rrup;
        param = {M,Rrup,VS30};
        tag   = {'M','Rrup','VS30'};
end

