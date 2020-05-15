function handles=mGMPEdefault(handles,txt,edi)

set(edi,'BackgroundColor',[1 1 1],'Enable','on');
handles.rad1.Enable='on';
handles.rad2.Enable='on';

[~,val]=intersect({handles.methods.label},handles.GMPEselect.String{handles.GMPEselect.Value});
str    = handles.methods(val).str;
handles.fun = handles.methods(val).func;
handles.IM  = mGMPE_info(str);


old_str = handles.targetIM.String{handles.targetIM.Value};
new_str = IM2str(handles.IM);
handles.targetIM.String=new_str;
if ismember(old_str,new_str)
   [~,handles.targetIM.Value]=intersect(new_str,old_str);
else
    handles.targetIM.Value=1;
end

SUB = handles.SUB;
SC  = handles.SC;

switch str
    case 'Youngs1997'
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Media';
        handles.t5.String='Mechanism';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Zhyp;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'rock','soil'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'interface','intraslab'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'AtkinsonBoore2003'
        set(txt(1:6),'Visible','on');
        set(edi(1:6),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Media';
        handles.t5.String='Mechanism';
        handles.t6.String='Region';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Zhyp;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'nehrpb','nehrpc','nehrpd','nehrpe'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'interface','intraslab'};
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'general','cascadia','japan'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'Zhao2006' % subduction
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Vs30 (m/s)';
        handles.t5.String='Mechanism';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Zhyp;
        handles.e4.String=SUB.Vs30;
        handles.e5.Style='popupmenu'; handles.e5.Value=2; handles.e5.String={'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'Mcverry2006' % subduction
        set(txt(1:6),'Visible','on');
        set(edi(1:6),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp(km)';
        handles.t4.String='Media';
        handles.t5.String='Mechanism';
        handles.t6.String='Rvol (km)';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String='50';
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'A','B','C','D','E'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e6.String='0';
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'ContrerasBoroschek2012' % subduction
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Media';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Zhyp;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'rock','soil'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'BCHydro2012'
        set(txt(1:8),'Visible','on');
        set(edi(1:8),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rhyp (km)';
        handles.t4.String='Zhyp (km)';
        handles.t5.String='Vs30 (m/s)';
        handles.t6.String='Mechanism';
        handles.t7.String='Arc';
        handles.t8.String='DeltaC1';
        
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Rhyp;
        handles.e4.String=SUB.Zhyp;
        handles.e5.String=SUB.Vs30;
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'interface','intraslab'};
        handles.e7.Style='popupmenu'; handles.e7.Value=1; handles.e7.String={'forearc','backarc','unknown'};
        handles.e8.Style='popupmenu'; handles.e8.Value=2; handles.e8.String={'lower','central','upper','none'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'BCHydro2018'
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Ztor (km)';
        handles.t4.String='Vs30 (m/s)';
        handles.t5.String='Mechanism';
        
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Ztor;
        handles.e4.String=SUB.Vs30;
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'interface','intraslab'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Arteta2018' % subduction
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rhyp (km)';
        handles.t3.String='Media';
        handles.t4.String='Arc';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rhyp;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'rock','soil'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'forearc','backarc'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Idini2016' % subduction
        set(txt(1:7),'Visible','on');
        set(edi(1:7),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rhyp (km)';
        handles.t4.String='Zhyp (km)';
        handles.t5.String='Vs30 (m/s)';
        handles.t6.String='Mechanism';
        handles.t7.String='Spectrum';
        
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Rhyp;
        handles.e4.String=SUB.Zhyp;
        handles.e5.String=SUB.Vs30;
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'interface','intraslab'};
        handles.e7.Style='popupmenu'; handles.e7.Value=1; handles.e7.String={'si','sii','siii','siv','sv','svi'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case {'MontalvaBastias2017','MontalvaBastias2017HQ'}
        set(txt(1:7),'Visible','on');
        set(edi(1:7),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rhyp (km)';
        handles.t4.String='Zhyp (km)';
        handles.t5.String='Vs30 (m/s)';
        handles.t6.String='Mechanism';
        handles.t7.String='Arc';
        
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Rhyp;
        handles.e4.String=SUB.Zhyp;
        handles.e5.String=SUB.Vs30;
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'interface','intraslab'};
        handles.e7.Style='popupmenu'; handles.e7.Value=1; handles.e7.String={'forearc','backarc','unknown'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'SiberRisk2019' % subduction
        set(txt(1:6),'Visible','on');
        set(edi(1:6),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rhyp (km)';
        handles.t4.String='Zhyp (km)';
        handles.t5.String='Vs30 (m/s)';
        handles.t6.String='Mechanism';
        
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Rhyp;
        handles.e4.String=SUB.Zhyp;
        handles.e5.String=SUB.Vs30;
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'interface','intraslab'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'Garcia2005'
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rhyp (km)';
        handles.t4.String='Zhyp (km)';
        handles.t5.String='Direction';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Rhyp;
        handles.e4.String=SUB.Zhyp;
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'horizontal','vertical'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        
    case 'Jaimes2006'
        set(txt(1:2),'Visible','on');
        set(edi(1:2),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.e1.String=SUB.Mag;
        handles.e2.String='400';
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Jaimes2015'
        set(txt(1:3),'Visible','on');
        set(edi(1:3),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Station';
        handles.e1.String=SUB.Mag;
        handles.e2.String='200';
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'CU','SCT','CDAO'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'Jaimes2016'
        set(txt(1:2),'Visible','on');
        set(edi(1:2),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.e1.String='3.0';
        handles.e2.String='10';
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'GarciaJaimes2017'
        set(txt(1:3),'Visible','on');
        set(edi(1:3),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Component';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.Style='popupmenu'; handles.e3.Value=2; handles.e3.String={'vertical','horizontal'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        
    case 'GarciaJaimes2017HV'
        set(txt(1:2),'Visible','on');
        set(edi(1:2),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Bernal2014'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Mechanism';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Zhyp;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'interface','intraslab'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        
    case 'Sadigh1997'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Media';
        handles.t4.String='SOF';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'deepsoil','rock'};
        handles.e4.Style='popupmenu'; handles.e4.Value=2; handles.e4.String={'strike-slip','reverse','reverse-oblique'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'I2008'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Vs30 (m/s)';
        handles.t4.String='Mechanism';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Vs30;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'CY2008'
        set(txt(1:11),'Visible','on');
        set(edi(1:11),'Visible','on');
        handles.t1.String  ='M';
        handles.t2.String  ='Rrup (km)';
        handles.t3.String  ='Rjb (km)';
        handles.t4.String  ='Rx (km)';
        handles.t5.String  ='Ztor (km)';
        handles.t6.String  ='dip (°)';
        handles.t7.String  ='Vs30 (m/s)';
        handles.t8.String  ='Z1.0 (m)';
        handles.t9.String  ='SOF';
        handles.t10.String ='Event';
        handles.t11.String ='VS30 type';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rjb;
        handles.e4.String=SC.Rx;
        handles.e5.String=SC.Ztor;
        handles.e6.String=SC.dip;
        handles.e7.String=SC.Vs30;
        handles.e8.String=SC.Z10;
        handles.e9.Style ='popupmenu'; handles.e9.Value=1;  handles.e9.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e10.Style='popupmenu'; handles.e10.Value=1; handles.e10.String={'mainshock','aftershock'};
        handles.e11.Style='popupmenu'; handles.e11.Value=1; handles.e11.String={'measured','inferred'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        handles.e6.BackgroundColor=[1 1 0.7];
        
    case 'BA2008'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rjb (km)';
        handles.t3.String='Vs30 (m/s)';
        handles.t4.String='SOF';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rjb;
        handles.e3.String=SC.Vs30;
        handles.e4.Style='popupmenu'; handles.e4.Value=2; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'CB2008'
        %M,Rrup,Rjb,Ztor,dip,Vs30,Z25,SOF,sigmatype
        set(txt(1:9),'Visible','on');
        set(edi(1:9),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rjb (km)';
        handles.t4.String='Ztor (km)';
        handles.t5.String='Dip (°)';
        handles.t6.String='Vs30 (m/s)';
        handles.t7.String='Z2.5 (km)';
        handles.t8.String='SOF';
        handles.t9.String='Sigma Type';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rjb;
        handles.e4.String=SC.Ztor;
        handles.e5.String=SC.dip;
        handles.e6.String=SC.Vs30;
        handles.e7.String=SC.Z25;
        handles.e8.Style='popupmenu'; handles.e8.Value=1; handles.e8.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e9.Style='popupmenu'; handles.e9.Value=1; handles.e9.String={'arbitrary','average'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        
    case 'AS2008'
        set(txt(1:12),'Visible','on');
        set(edi(1:12),'Visible','on');
        handles.t1.String  = 'M';
        handles.t2.String  = 'Rrup (km)';
        handles.t3.String  = 'Rjb (km)';
        handles.t4.String  = 'Rx (km)';
        handles.t5.String  = 'Ztor (km)';
        handles.t6.String  = 'Dip (°)';
        handles.t7.String  = 'W (km)';
        handles.t8.String  = 'Vs30 (m/s)';
        handles.t9.String  = 'Z1.0 (m)';
        handles.t10.String = 'SOF';
        handles.t11.String = 'Event';
        handles.t12.String = 'VS30 type';
        handles.e1.String  = SC.Mag;
        handles.e2.String  = SC.Rrup;
        handles.e3.String  = SC.Rjb;
        handles.e4.String  = SC.Rx;
        handles.e5.String  = SC.Ztor;
        handles.e6.String  = SC.dip;
        handles.e7.String  = SC.W;
        handles.e8.String  = SC.Vs30;
        handles.e9.String  = SC.Z10;
        handles.e10.Style='popupmenu'; handles.e10.Value=1; handles.e10.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e11.Style='popupmenu'; handles.e11.Value=2; handles.e11.String={'aftershock','mainshock','foreshock','swarms'};
        handles.e12.Style='popupmenu'; handles.e12.Value=1; handles.e12.String={'measured','inferred'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        handles.e6.BackgroundColor=[1 1 0.7];
        handles.e7.BackgroundColor=[1 1 0.7];
        
    case 'AS1997h'
        set(txt(1:6),'Visible','on');
        set(edi(1:6),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Media';
        handles.t4.String='SOF';
        handles.t5.String='Location';
        handles.t6.String='Sigma Type';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'rock','deepsoil'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'hangingwall','footwall','other'};
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'arbitrary','average'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'I2014'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Vs30 (m/s)';
        handles.t4.String='SOF';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Vs30;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'CY2014'
        set(txt(1:11),'Visible','on');
        set(edi(1:11),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rjb (km)';
        handles.t4.String='Rx (km)';
        handles.t5.String='Ztor (km)';
        handles.t6.String='dip (°)';
        handles.t7.String='Vs30 (m/s)';
        handles.t8.String='Z1.0 (km)';
        handles.t9.String='SOF';
        handles.t10.String='VS30 Type';
        handles.t11.String='Region';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rjb;
        handles.e4.String=SC.Rx;
        handles.e5.String=SC.Ztor;
        handles.e6.String=SC.dip;
        handles.e7.String=SC.Vs30;
        handles.e8.String=SC.Z10;
        handles.e9.Style='popupmenu';  handles.e9.Value=1;  handles.e9.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e10.Style='popupmenu'; handles.e10.Value=1; handles.e10.String={'measured','inferred'};
        handles.e11.Style='popupmenu'; handles.e11.Value=1; handles.e11.String={'global','california','japan','china','italy','turkey'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        handles.e6.BackgroundColor=[1 1 0.7];
        
    case 'CB2014'
        set(txt(1:14),'Visible','on');
        set(edi(1:14),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rjb (km)';
        handles.t4.String='Rx (km)';
        handles.t5.String='Zhyp (km)';
        handles.t6.String='Ztor (km)';
        handles.t7.String='Zbot (km)';
        handles.t8.String='dip (°)';
        handles.t9.String='width (km)';
        handles.t10.String='Vs30 (m/s)';
        handles.t11.String='Z2.5 (km)';
        handles.t12.String='SOF';
        handles.t13.String='HW Effect';
        handles.t14.String='Region';
        
        handles.e1.String  = SC.Mag;
        handles.e2.String  = SC.Rrup;
        handles.e3.String  = SC.Rjb;
        handles.e4.String  = SC.Rx;
        handles.e5.String  = SC.Zhyp;
        handles.e6.String  = SC.Ztor;
        handles.e7.String  = SC.Zbot;
        handles.e8.String  = SC.dip;
        handles.e9.String  = SC.W;
        handles.e10.String = SC.Vs30;
        handles.e11.String = SC.Z25;
        handles.e12.Style  ='popupmenu'; handles.e12.Value=1; handles.e12.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e13.Style  ='popupmenu'; handles.e13.Value=1; handles.e13.String={'include','exclude'};
        handles.e14.Style  ='popupmenu'; handles.e14.Value=1; handles.e14.String={'global','california','japan','china','italy','turkey'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        handles.e6.BackgroundColor=[1 1 0.7];
        handles.e7.BackgroundColor=[1 1 0.7];
        handles.e8.BackgroundColor=[1 1 0.7];
        
    case 'BSSA2014'
        set(txt(1:6),'Visible','on');
        set(edi(1:6),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rjb (km)';
        handles.t3.String='Vs30 (m/s)';
        handles.t4.String='Basin Depth';
        handles.t5.String='SOF';
        handles.t6.String='Region';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Vs30;
        handles.e4.String='unk';
        handles.e5.Style='popupmenu'; handles.e5.Value=2; handles.e5.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'global','california','japan','china','italy','turkey'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'ASK2014'
        set(txt(1:14),'Visible','on');
        set(edi(1:14),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rjb (km)';
        handles.t4.String='Rx (km)';
        handles.t5.String='Ry0(km)';
        handles.t6.String='Ztor (km)';
        handles.t7.String='dip (°)';
        handles.t8.String='width (km)';
        handles.t9.String='Vs30 (m/s)';
        handles.t10.String='Z1.0 (km)';
        handles.t11.String='SOF';
        handles.t12.String='Event';
        handles.t13.String='VS30 type';
        handles.t14.String='Region';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rjb;
        handles.e4.String=SC.Rx;
        handles.e5.String=SC.Ry0;
        handles.e6.String=SC.Ztor;
        handles.e7.String=SC.dip;
        handles.e8.String=SC.W;
        handles.e9.String=SC.Vs30;
        handles.e10.String=SC.Z10;
        handles.e11.Style='popupmenu'; handles.e11.Value=1; handles.e11.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e12.Style='popupmenu'; handles.e12.Value=1; handles.e12.String={'mainshock','aftershock'};
        handles.e13.Style='popupmenu'; handles.e13.Value=1; handles.e13.String={'measured','inferred'};
        handles.e14.Style='popupmenu'; handles.e14.Value=1; handles.e14.String={'global','california','japan','china','italy','turkey'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        handles.e6.BackgroundColor=[1 1 0.7];
        handles.e7.BackgroundColor=[1 1 0.7];
        handles.e8.BackgroundColor=[1 1 0.7];
        
    case 'AkkarBoomer2007'
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rjb (km)';
        handles.t3.String='Media';
        handles.t4.String='SOF';
        handles.t5.String='Damping';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rjb;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'stiff','soil','other'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'2','5','10','20','30'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'AkkarBoomer2010'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rjb (km)';
        handles.t3.String='Media';
        handles.t4.String='SOF';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rjb;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'rock','stiff','soft'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Arroyo2010'
        set(txt(1:2),'Visible','on');
        set(edi(1:2),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup(km)';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Bindi2011'
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rjb(km)';
        handles.t3.String='Media';
        handles.t4.String='SOF';
        handles.t5.String='Component';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'AEC8','BEC8','CEC8','DEC8','EEC8'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'GeoH','Z'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Kanno2006'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup(km)';
        handles.t3.String='Zhyp(km)';
        handles.t4.String='Vs30 (m/s)';
        handles.e1.String=SUB.Mag;
        handles.e2.String=SUB.Rrup;
        handles.e3.String=SUB.Zhyp;
        handles.e4.String=SUB.Vs30;
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'Cauzzi2015'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rhyp (km)';
        handles.t4.String='Vs30 (m/s)';
        handles.t5.String='SOF';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rhyp;
        handles.e4.String=SC.Vs30;
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
    case 'DW12'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Media';
        handles.t4.String='SOF';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'sgs-b','sgs-c','sgs-d'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'FG15'
        set(txt(1:7),'Visible','on');
        set(edi(1:7),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Vs30';
        handles.t5.String='SOF';
        handles.t6.String='arc';
        handles.t7.String='Regtype';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Zhyp;
        handles.e4.String=SC.Vs30;
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e6.Style='popupmenu'; handles.e6.Value=1; handles.e6.String={'forearc','backarc'};
        handles.e7.Style='popupmenu'; handles.e7.Value=1; handles.e7.String={'linear','nonlinear'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'TBA03'
        set(txt(1:4),'Visible','on');
        set(edi(1:4),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t4.String='Media';
        handles.t3.String='SOF';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.Style='popupmenu'; handles.e3.Value=1; handles.e3.String={'sgs-b','sgs-c','sgs-d'};
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'BU17'
        set(txt(1:5),'Visible','on');
        set(edi(1:5),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Zhyp (km)';
        handles.t4.String='Mechanism';
        handles.t5.String='imtype';
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Zhyp;
        handles.e4.Style='popupmenu'; handles.e4.Value=1; handles.e4.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e5.Style='popupmenu'; handles.e5.Value=1; handles.e5.String={'CAV','CAV5','CAVSTD'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'CB10'
        set(txt(1:8),'Visible','on');
        set(edi(1:8),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rjb (km)';
        handles.t4.String='Ztor (km)';
        handles.t5.String='dip(°)';
        handles.t6.String='Vs30(m/s)';
        handles.t7.String='Z2.5 (km)';
        handles.t8.String='SOF';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rjb;
        handles.e4.String=SC.Ztor;
        handles.e5.String=SC.dip;
        handles.e6.String=SC.Vs30;
        handles.e7.String=SC.Z25;
        handles.e8.Style='popupmenu'; handles.e8.Value=1; handles.e8.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'CB11'
        set(txt(1:9),'Visible','on');
        set(edi(1:9),'Visible','on');
        handles.t1.String='M';
        handles.t2.String='Rrup (km)';
        handles.t3.String='Rjb (km)';
        handles.t4.String='Ztor (km)';
        handles.t5.String='dip(°)';
        handles.t6.String='Vs30(m/s)';
        handles.t7.String='Z2.5 (km)';
        handles.t8.String='SOF';
        handles.t9.String='Database';
        
        handles.e1.String=SC.Mag;
        handles.e2.String=SC.Rrup;
        handles.e3.String=SC.Rjb;
        handles.e4.String=SC.Ztor;
        handles.e5.String=SC.dip;
        handles.e6.String=SC.Vs30;
        handles.e7.String=SC.Z25;
        handles.e8.Style='popupmenu'; handles.e8.Value=1; handles.e8.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e9.Style='popupmenu'; handles.e9.Value=1; handles.e9.String={'CB08-NGA-PSV','CB08-NGA-NoPSV','PEER-NGA-PSV','PEER-NGA-NoPSV'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'CB19'
        set(txt(1:13),'Visible','on');
        set(edi(1:13),'Visible','on');
        handles.t1.String  = 'M';
        handles.t2.String  = 'Rrup (km)';
        handles.t3.String  = 'Rjb (km)';
        handles.t4.String  = 'Rx (km)';
        handles.t5.String  = 'Zhyp (km)';
        handles.t6.String  = 'Ztor (km)';
        handles.t7.String  = 'Zbot (km)';
        handles.t8.String  = 'dip (°)';
        handles.t9.String  = 'width (km)';
        handles.t10.String = 'Vs30 (m/s)';
        handles.t11.String = 'Z2.5 (km)';
        handles.t12.String = 'SOF';
        handles.t13.String = 'Region';
        
        handles.e1.String  = SC.Mag;
        handles.e2.String  = SC.Rrup;
        handles.e3.String  = SC.Rjb;
        handles.e4.String  = SC.Rx;
        handles.e5.String  = SC.Zhyp;
        handles.e6.String  = SC.Ztor;
        handles.e7.String  = SC.Zbot;
        handles.e8.String  = SC.dip;
        handles.e9.String  = SC.W;
        handles.e10.String = SC.Vs30;
        handles.e11.String = SC.Z25;
        handles.e12.Style  = 'popupmenu'; handles.e12.Value=1; handles.e12.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        handles.e13.Style  = 'popupmenu'; handles.e13.Value=1; handles.e13.String={'global','california','japan','china','italy','turkey'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        handles.e3.BackgroundColor=[1 1 0.7];
        handles.e4.BackgroundColor=[1 1 0.7];
        handles.e5.BackgroundColor=[1 1 0.7];
        handles.e6.BackgroundColor=[1 1 0.7];
        handles.e7.BackgroundColor=[1 1 0.7];
        handles.e8.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
    case 'KM06'
        set(txt(1:3),'Visible','on');
        set(edi(1:3),'Visible','on');
        handles.t1.String='M';
        handles.t2.String = 'Rrup (km)';
        handles.t3.String = 'SOF';
        handles.e1.String = SC.Mag;
        handles.e2.String = SC.Rrup;
        handles.e3.Style  = 'popupmenu'; handles.e3.Value=1; handles.e3.String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        handles.e1.BackgroundColor=[1 1 0.7];
        handles.e2.BackgroundColor=[1 1 0.7];
        
        handles.rad1.Enable='inactive';
        handles.rad1.Value=0;
        handles.rad2.Value=1;
        
end

