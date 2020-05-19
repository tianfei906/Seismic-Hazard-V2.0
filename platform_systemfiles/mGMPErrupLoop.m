function[Rrup,param]=mGMPErrupLoop(fun,param,SUB,SC)

str  = func2str(fun);
Rrup = SUB.Rrup;
ON   = ones(size(Rrup));
switch str
    
    case 'Youngs1997'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'AtkinsonBoore2003'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'Zhao2006'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'Mcverry2006'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'ContrerasBoroschek2012'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'BCHydro2012'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        param{4}=ON*param{4};
        
    case 'BCHydro2018'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'Kuehn2020'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'Parker2020'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};        
        
    case 'Arteta2018'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'Idini2016'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=Rhyp;
        param{4}=ON*param{4};
        
    case {'MontalvaBastias2017','MontalvaBastias2017HQ'}
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=Rhyp;
        param{4}=ON*param{4};
        
    case 'SiberRisk2019'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=Rhyp;
        param{4}=ON*param{4};
        
    case 'Garcia2005'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=Rhyp;
        param{4}=ON*param{4};
        
    case 'Jaimes2006'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'Jaimes2015'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'Jaimes2016'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case {'GarciaJaimes2017','GarciaJaimes2017HV'}
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'Bernal2014'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'Sadigh1997'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'I2008'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'CY2008'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Rx
        param{5}=ON*param{5}; %Ztor
        
    case 'BA2008'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'CB2008'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Ztor
        
    case 'AS2008'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Rx
        param{5}=ON*param{5}; %Ztor
        
    case 'AS1997h'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'I2014'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'CY2014'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Rx
        param{5}=ON*param{5}; %Ztor
        
    case 'CB2014'
        param{1}  = ON*param{1};
        param{2}  = Rrup;        %Rrup
        param{3}  = ON*param{3}; %Rjb
        param{4}  = ON*param{4}; %Rx
        param{5}  = ON*param{5}; %Zhyp
        param{6}  = ON*param{6}; %Ztor
        param{7} = ON*param{7}; %Zbot
        
    case 'BSSA2014'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'ASK2014'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Rx
        param{5}=ON*param{5}; %Ry0
        param{6}=ON*param{6}; %Ztor
        
    case 'AkkarBoomer2007'
        param{1}=ON*param{1};
        param{2}=Rjb;
        
    case 'AkkarBoomer2010'
        param{1}=ON*param{1};
        param{2}=Rjb;
        
    case 'Arroyo2010'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'Bindi2011'
        param{1}=ON*param{1};
        param{2}=Rjb;
        
    case 'Kanno2006'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'Cauzzi2015'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'DW12'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'FG15'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'TBA03'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
    case 'BU17'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3};
        
    case 'CB10'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Ztor
        
    case 'CB11'
        param{1}=ON*param{1};
        param{2}=Rrup;
        param{3}=ON*param{3}; %Rjb
        param{4}=ON*param{4}; %Ztor        
        
    case 'CB19'
        param{1}  = ON*param{1};
        param{2}  = Rrup;        %Rrup
        param{3}  = ON*param{3}; %Rjb
        param{4}  = ON*param{4}; %Rx
        param{5}  = ON*param{5}; %Zhyp
        param{6}  = ON*param{6}; %Ztor
        param{7}  = ON*param{7}; %Zbot
        
    case 'KM06'
        param{1}=ON*param{1};
        param{2}=Rrup;
        
end