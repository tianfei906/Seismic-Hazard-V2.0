function [param,val,p2,t2] = mGMPEgetparam(handles) %#ok<*INUSD,*DEFNU>

ch=get(handles.panel2,'children');
ch2=ch(handles.edit);
val=vertcat(ch2.Value);
str=cell(length(ch2),1);
for i=1:length(ch2)
    str{i}=ch2(i).String;
    if val(i)~=0 && size(str{i},1)>1
        str{i}=str{i}{val(i)};
    end
end
val = [val;handles.GMPEselect.Value];
me  = handles.me;
[~,val2]=intersect({me.label},handles.GMPEselect.String{handles.GMPEselect.Value});
set(ch2,'Enable','on')

p2=[];
t2=[];

switch me(val2).str
    case 'Youngs1997'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        media     = str{4};
        mechanism = str{5};
        param     = {M,Rrup,Zhyp,media,mechanism};
        
    case 'AtkinsonBoore2003'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        media     = str{4};
        mechanism = str{5};
        region    = str{6};
        param     = {M,Rrup,Zhyp,media,mechanism,region};
        
    case 'Zhao2006'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        mechanism = str{5};
        param     = {M,Rrup,Zhyp,VS30,mechanism};
        
    case 'Mcverry2006'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        media     = str{4};
        mechanism = str{5};
        rvol      = str2double(str{6});
        param     = {M,Rrup,Zhyp,media,mechanism,rvol};
        
    case 'ContrerasBoroschek2012'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        media     = str{4};
        param     = {M,Rrup,Zhyp,media};
        
    case 'BCHydro2012'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        mechanism = str{5};
        arc       = str{6};
        DeltaC1   = str{7};
        param     = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,arc,DeltaC1};
        
    case 'Kuehn2020'
        M            = str2double(str{1});
        Rrup         = str2double(str{2});
        Ztor         = str2double(str{3});
        VS30         = str2double(str{4});
        mechanism    = str{5};
        region       = str{6};
        alfaBackArc  = str2double(str{7});
        alfaNankai   = str2double(str{8});
        Z10          = str2double(str{9});
        Z25          = str2double(str{10});
        Nepist       = str2double(str{11});
        param        = {M,Rrup,Ztor,VS30,mechanism,region,alfaBackArc,alfaNankai,Z10,Z25,Nepist};
        
    case 'Parker2020'
        M            = str2double(str{1});
        Rrup         = str2double(str{2});
        Zhyp         = str2double(str{3});
        VS30         = str2double(str{4});
        Z25          = str2double(str{5});
        mechanism    = str{6};
        region       = str{7};
        param        = {M,Rrup,Zhyp,VS30,Z25,mechanism,region};
        
    case 'BCHydro2018'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Ztor      = str2double(str{3});
        VS30      = str2double(str{4});
        mechanism = str{5};
        param     = {M,Rrup,Ztor,VS30,mechanism};
        
    case 'Arteta2018'
        M         = str2double(str{1});
        Rhyp      = str2double(str{2});
        media     = str{3};
        arc       = str{4};
        param     = {M,Rhyp,media,arc};
        
    case 'Idini2016'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        VS30      = str2double(str(4));
        mechanism = str{5};
        spectrum  = str{6};
        param     = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,spectrum};
        
    case 'MontalvaBastias2017'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        mechanism = str{5};
        arc       = str{6};
        param     = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,arc};
        
    case 'MontalvaBastias2017HQ'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        mechanism = str{5};
        arc       = str{6};
        param     = {M,Rrup,Rhyp,Zhyp,VS30,mechanism,arc};
        
    case 'Montalva2018'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        f0        = str2double(str{5});
        mechanism = str{6};
        param     = {M,Rrup,Rhyp,Zhyp,VS30,f0,mechanism};
        
    case 'SiberRisk2019'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        mechanism = str{5};
        param     = {M,Rrup,Rhyp,Zhyp,VS30,mechanism};
        
    case 'Garcia2005'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rhyp      = Rrup;
        Zhyp      = str2double(str{3});
        direction = str{4};
        param     = {M,Rrup,Rhyp,Zhyp,direction};
        
    case 'Jaimes2006'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        param     = {M,Rrup};
        
    case 'Jaimes2015'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        station   = str{3};
        param     = {M,Rrup,station};
        
    case 'Jaimes2016'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        param     = {M,Rrup};
        
    case 'GarciaJaimes2017'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        component = str{3};
        param     = {M,Rrup,component};
        
    case 'GarciaJaimes2017VH'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        param     = {M,Rrup};
        
    case 'GA2011'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        VS30      = str2double(str{3});
        SOF       = str{4};
        param     = {M,Rrup,VS30,SOF};
        
    case 'SBSA2016'
        M         = str2double(str{1});
        Rjb       = str2double(str{2});
        VS30      = str2double(str{3});
        SOF       = str{4};
        region    = str{5};
        param     = {M,Rjb,VS30,SOF,region};
        
    case 'GKAS2017'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rjb       = str2double(str{3});
        Rx        = str2double(str{4});
        Ry0       = str2double(str{5});
        Ztor      = str2double(str{6});
        dip       = str2double(str{7});
        W         = str2double(str{8});
        VS30      = str2double(str{9});
        SOF       = str{10};
        region    = str{11};
        param     = {M,Rrup,Rjb,Rx,Ry0,Ztor,dip,W,VS30,SOF,region};
        
    case 'Bernal2014'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        mechanism = str{4};
        param     = {M,Rrup,Zhyp,mechanism};
        
    case 'Sadigh1997'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        media     = str{3};
        SOF       = str{4};
        param     = {M,Rrup,media,SOF};
        
    case 'I2008'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        VS30      = str2double(str{3});
        SOF       = str{4};
        param     = {M,Rrup,VS30,SOF};
        
    case 'CY2008'
        M        = str2double(str{1});
        Rrup     = str2double(str{2});
        Rjb      = str2double(str{3});
        Rx       = str2double(str{4});
        Ztor     = str2double(str{5});
        dip      = str2double(str{6});
        VS30     = str2double(str{7});
        Z10      = str{8}; if ~strcmp(Z10,'unk'), Z10 = str2double(Z10); end
        SOF      = str{9};
        event    = str{10};
        Vs30type = str{11};
        param    = {M,Rrup,Rjb,Rx,Ztor,dip,VS30,Z10,SOF,event,Vs30type};
        
    case 'BA2008'
        M      = str2double(str{1});
        Rjb    = str2double(str{2});
        VS30   = str2double(str{3});
        SOF    = str{4};
        param  = {M,Rjb,VS30,SOF};
        
    case 'CB2008'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rjb       = str2double(str{3});
        Ztor      = str2double(str{4});
        dip       = str2double(str{5});
        VS30      = str2double(str{6});
        Z25       = str2double(str{7});
        SOF       = str{8};
        sigmatype = str{9};
        param     = {M,Rrup,Rjb,Ztor,dip,VS30,Z25,SOF,sigmatype};
        
    case 'AS2008'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rjb       = str2double(str{3});
        Rx        = str2double(str{4});
        Ztor      = str2double(str{5});
        dip       = str2double(str{6});
        width     = str2double(str{7});
        VS30      = str2double(str{8});
        Z10       = str{9}; if ~strcmp(Z10,'unk'), Z10 = str2double(Z10); end
        SOF       = str{10};
        event     = str{11};
        Vs30type  = str{12};
        param     = {M,Rrup,Rjb,Rx,Ztor,dip,width,VS30,Z10,SOF,event,Vs30type};
        
    case 'AS1997h'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        media     = str{3};
        SOF       = str{4};
        location  = str{5};
        sigmatype = str{6};
        param     = {M,Rrup,media,SOF,location,sigmatype};
        
    case 'I2014'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        VS30      = str2double(str{3});
        SOF       = str{4};
        param     = {M,Rrup,VS30,SOF};
        
    case 'CY2014'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rjb       = str2double(str{3});
        Rx        = str2double(str{4});
        Ztor      = str2double(str{5});
        dip       = str2double(str{6});
        VS30      = str2double(str{7});
        Z10       = str{8}; if ~strcmp(Z10,'unk'), Z10 = str2double(Z10); end
        SOF       = str{9};
        Vs30type  = str{10};
        region    = str{11};
        param     = {M,Rrup,Rjb,Rx,Ztor,dip,VS30,Z10,SOF,Vs30type,region};
        
    case 'CB2014'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rjb       = str2double(str{3});
        Rx        = str2double(str{4});
        Zhyp      = str2double(str{5});
        Ztor      = str2double(str{6});
        Zbot      = str2double(str{7});
        dip       = str2double(str{8});
        width     = str2double(str{9});
        VS30      = str2double(str{10});
        Z25       = str2double(str{11});
        SOF       = str{12};
        HWEffect  = str{13};
        region    = str{14};
        param     = {M,Rrup,Rjb,Rx,Zhyp,Ztor,Zbot,dip,width,VS30,Z25,SOF,HWEffect,region};
        
    case 'BSSA2014'
        M          = str2double(str{1});
        Rjb        = str2double(str{2});
        VS30       = str2double(str{3});
        BasinDepth = str{4}; if ~strcmp(BasinDepth,'unk'), BasinDepth = str2double(BasinDepth); end
        SOF        = str{5};
        region     = str{6};
        param      = {M,Rjb,VS30,BasinDepth,SOF,region};
        
    case 'ASK2014'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Rjb       = str2double(str{3});
        Rx        = str2double(str{4});
        Ry0       = str2double(str{5});
        Ztor      = str2double(str{6});
        dip       = str2double(str{7});
        width     = str2double(str{8});
        VS30      = str2double(str{9});
        Z10       = str{10}; if ~strcmp(Z10,'unk'), Z10 = str2double(Z10); end
        SOF       = str{11};
        event     = str{12};
        Vs30type  = str{13};
        region    = str{14};
        param     = {M,Rrup,Rjb,Rx,Ry0,Ztor,dip,width,VS30,Z10,SOF,event,Vs30type,region};
        
    case 'AkkarBoomer2007'
        M       = str2double(str{1});
        Rjb     = str2double(str{2});
        media   = str{3};
        SOF     = str{4};
        damping = str2double(str{5});
        param   = {M,Rjb,media,SOF,damping};
        
    case 'AkkarBoomer2010'
        M       = str2double(str{1});
        Rjb     = str2double(str{2});
        media   = str{3};
        SOF     = str{4};
        param   = {M,Rjb,media,SOF};
        
    case 'Akkar2014'
        M       = str2double(str{1});
        Rhyp    = str2double(str{2});
        Rjb     = str2double(str{3});
        Repi    = str2double(str{4});
        VS30    = str2double(str{5});
        SOF     = str{6};
        model   = str{7};
        param   = {M,Rhyp,Rjb,Repi,VS30,SOF,model};
        
    case 'Arroyo2010'
        M       = str2double(str{1});
        Rrup    = str2double(str{2});
        param   = {M,Rrup};
        
    case 'Bindi2011'
        M         = str2double(str{1});
        Rjb       = str2double(str{2});
        media     = str{3};
        SOF       = str{4};
        component = str{5};
        param     = {M,Rjb,media,SOF,component};
        
    case 'Kanno2006'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        VS30      = str2double(str{4});
        param     = {M,Rrup,Zhyp,VS30};
        
    case 'Cauzzi2015'
        M        = str2double(str{1});
        Rrup     = str2double(str{2});
        Rhyp     = str2double(str{3});
        VS30     = str2double(str{4});
        Vs30form = str2double(str{5});
        SOF      = str{6};
        param    = {M,Rrup,Rhyp,VS30,Vs30form,SOF};
        
    case 'DW12'
        M      = str2double(str{1});
        Rrup   = str2double(str{2});
        media  = str{3};
        SOF    = str{4};
        param  = {M,Rrup,media,SOF};
        
    case 'FG15'
        M       = str2double(str{1});
        Rrup    = str2double(str{2});
        Zhyp    = str2double(str{3});
        VS30    = str2double(str{4});
        SOF     = str{5};
        arc     = str{6};
        regtype = str{7};
        param   = {M,Rrup,Zhyp,VS30,SOF,arc,regtype};
        
    case 'TBA03'
        M      = str2double(str{1});
        Rrup   = str2double(str{2});
        media  = str{3};
        SOF    = str{4};
        param  = {M,Rrup,media,SOF};
        
    case 'BU17'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        Zhyp      = str2double(str{3});
        mechanism = str{4};
        imtype    = str{5};
        param     = {M,Rrup,Zhyp,mechanism,imtype};
        
    case 'CB10'
        M       = str2double(str{1});
        Rrup    = str2double(str{2});
        Rjb     = str2double(str{3});
        Ztor    = str2double(str{4});
        dip     = str2double(str{5});
        VS30    = str2double(str{6});
        Z25     = str2double(str{7});
        SOF     = str{8};
        param   = {M,Rrup,Rjb,Ztor,dip,VS30,Z25,SOF};
        
    case 'CB11'
        M       = str2double(str{1});
        Rrup    = str2double(str{2});
        Rjb     = str2double(str{3});
        Ztor    = str2double(str{4});
        dip     = str2double(str{5});
        VS30    = str2double(str{6});
        Z25     = str2double(str{7});
        SOF     = str{8};
        PSVtype = str{9};
        param   = {M,Rrup,Rjb,Ztor,dip,VS30,Z25,SOF,PSVtype};
        
    case 'CB19'
        M      = str2double(str{1});
        Rrup   = str2double(str{2});
        Rjb    = str2double(str{3});
        Rx     = str2double(str{4});
        Zhyp   = str2double(str{5});
        Ztor   = str2double(str{6});
        Zbot   = str2double(str{7});
        dip    = str2double(str{8});
        width  = str2double(str{9});
        VS30   = str2double(str{10});
        Z25    = str2double(str{11});
        SOF    = str{12};
        region = str{13};
        param  = {M,Rrup,Rjb,Rx,Zhyp,Ztor,Zbot,dip,width,VS30,Z25,SOF,region};
        
    case 'KM06'
        M      = str2double(str{1});
        Rrup   = str2double(str{2});
        SOF    = str{3};
        param  = {M,Rrup,SOF};
        
    case 'medianPCEbchydro'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        VS30      = str2double(str{3});
        param     = {M,Rrup,VS30};
        
    case 'medianPCEnga'
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        VS30      = str2double(str{3});
        param     = {M,Rrup,VS30};
        
    case 'MAB2019'
        %M,Rrup,mechanism,region,Vs30,func,varargin
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        mechanism = str{3};
        region    = str{4};
        VS30      = str2double(str{5});
        func      = str2func(str{6});
        t1        = {'M','Rrup','mechanism','region','VS30'};
        p1        = {M,Rrup,mechanism,region,VS30};
        [p2,t2]   = mGMPEdefault_conditional(handles,str{6});
        pcond     = mGMPEupdateparam_cond(t1,p1,t2,p2);
        param     = [p1,{func},pcond];
        
    case 'MAL2020'
        %M,Rrup,Rjb,HWeffect,dip,Vs30,func,varargin
        M        = str2double(str{1});
        Rrup     = str2double(str{2});
        Rjb      = str2double(str{3});
        HWeffect = str{4};
        dip      = str2double(str{5});
        VS30     = str2double(str{6});
        func     = str2func(str{7});
        t1       = {'M','Rrup','Rjb','HWeffect','dip','Vs30'};
        p1       = {M,Rrup,Rjb,HWeffect,dip,VS30};
        [p2,t2]  = mGMPEdefault_conditional(handles,str{7});
        pcond    = mGMPEupdateparam_cond(t1,p1,t2,p2);
        param    = [p1,{func},pcond];
        
    case 'MMLA2020'
        % M,Rrup,Vs30,func,varargin
        M        = str2double(str{1});
        Rrup     = str2double(str{2});
        VS30     = str2double(str{3});
        func     = str2func(str{4});
        t1       = {'M','Rrup','VS30'};
        p1       = {M,Rrup,VS30};
        [p2,t2]  = mGMPEdefault_conditional(handles,str{4});
        pcond    = mGMPEupdateparam_cond(t1,p1,t2,p2);
        param    = [p1,{func},pcond];
        
    case 'ML2021'
        % M,Rrup,mechanism,Vs30,func,varargin
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        mechanism = str{3};
        VS30      = str2double(str{4});
        func      = str2func(str{5});
        t1        = {'M','Rrup','mechanism','VS30'};
        p1        = {M,Rrup,mechanism,VS30};
        [p2,t2]   = mGMPEdefault_conditional(handles,str{5});
        pcond     = mGMPEupdateparam_cond(t1,p1,t2,p2);
        param     = [p1,{func},pcond];
        
    case 'MCAVdp2021'
        % M,Rrup,mechanism,Vs30,func,varargin
        M         = str2double(str{1});
        Rrup      = str2double(str{2});
        mechanism = str{3};
        VS30      = str2double(str{4});
        func      = str2func(str{5});
        t1        = {'M','Rrup','mechanism','VS30'};
        p1        = {M,Rrup,mechanism,VS30};
        [p2,t2]   = mGMPEdefault_conditional(handles,str{5});
        pcond     = mGMPEupdateparam_cond(t1,p1,t2,p2);
        param     = [p1,{func},pcond];        
end
