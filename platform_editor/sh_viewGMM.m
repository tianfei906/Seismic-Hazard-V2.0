function[]=sh_viewGMM(gmmlib,gmm,str,edi)

edi(1).String=gmm.txt{2};
str(2).String={'Handle'};
set(edi(3:end),'string','','value',1);

[~,edi(2).Value]=intersect(edi(2).String,gmm.str);
disc = gmm.id;
usp  = gmm.usp;

% checks if adjustment function is used
W          = what('gmm_adjust');
adj_models = ['none';strrep(W.m,'.m','')];
adj_ptr    = [];
if ~isempty(usp) && ischar(usp{end}) && gmm.type==1
    ind = ismember(adj_models,usp{end});
    if any(ind)
        adj_ptr= find(ind);
    end
end

switch disc
    case 1  %Youngs et al. 1997
        nvis=3;
        str(3).String='Mechanism';
        
        edi(3).Style='popupmenu';edi(3).String={'interface','intraslab'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 2  %Atkinson & Boore, 2003
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='Region';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='popupmenu'; edi(4).String={'general','cascadia','japan'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 3  %Zhao et al. 2006
        nvis=3;
        str(3).String='Mechanism';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 4  %McVerry et al. 2006
        nvis=4;
        str(3).String='SOF';
        str(4).String='Rvol';
        
        edi(3).Style='popupmenu';edi(3).String={'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='edit';
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        edi(4).String=usp{2};
        
    case 5  %Boroschek et al. 2012
        nvis=2;
        
    case 6  %Abrahamson et al. 2016
        nvis=5;
        str(3).String='Mechanism';
        str(4).String='Arc';
        str(5).String='DeltaC1';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='popupmenu'; edi(4).String={'forearc','backarc','unknown'};
        edi(5).Style='popupmenu'; edi(5).String={'lower','central','upper','none'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});        
        
    case 7  %Abrahamson et al. 2018
        nvis=3;
        str(3).String='Mechanism';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 8  %Kuehn et al. 2020
        nvis=9;
        str(3).String='Mechanism';
        str(4).String='Region';
        str(5).String='aBackarc';
        str(6).String='aNankai';
        str(7).String='Z1.0';
        str(8).String='Z2.5';
        str(9).String='Nsample';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='popupmenu'; edi(4).String={'global','aleutian','alaska','cascadia','central_america_s','central_america_n','japan_pac','japan_phi','new_zealand_n','new_zealand_s','south_america_n','south_america_s','taiwan_w','taiwan_e'};
        edi(5).Style='edit';
        edi(6).Style='edit';
        edi(7).Style='edit';
        edi(8).Style='edit';
        edi(9).Style='edit';
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        edi(5).String=usp{3};
        edi(6).String=usp{4};
        edi(7).String=usp{5};
        edi(8).String=usp{6};
        edi(9).String=usp{7};
        
    case 9  %Parker et al. 2020
        nvis=5;
        str(3).String='Z2.5';
        str(4).String='Mechanism';
        str(5).String='Region';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'interface','intraslab'};
        edi(5).Style='popupmenu'; edi(5).String={'global','alaska','aleutian','cascadia','central_america_n','central_america_s','japan_pac','japan_phi','south_america_n','south_america_s','taiwan'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        
    case 10 %Arteta et al. 2018
        nvis=3;
        str(3).String='Arc';
        
        edi(3).Style='popupmenu'; edi(3).String={'forearc','backarc'};
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 11 %Idini et al. 2016
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='Spectrum';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='popupmenu'; edi(4).String={'sI','sII','sIII','sIV','sV','sVI'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 12 %Montalva et al. 2017
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='Arc';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='popupmenu'; edi(4).String={'forearc','backarc','unknown'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 13 %Montalva et al. 2017 (HQ)
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='Arc';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='popupmenu'; edi(4).String={'forearc','backarc','unknown'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 14 %Montalva et al. 2018
        nvis=3;
        str(3).String='Mechanism';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 15 %SIBER-RISK 2019
        nvis=3;
        str(3).String='Mechanism';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 16 %Garcia et al. 2005
        nvis=3;
        str(3).String='Direction';
        
        edi(4).Style='popupmenu'; edi(3).String={'horizontal','vertical'};
        
        [~,edi(4).Value]=intersect(edi(4).String,usp{1});
        
    case 17 %Jaimes et al. 2006
        nvis=2;
        
    case 18 %Jaimes et al. 2015
        nvis=3;
        str(3).String='Station';
        
        edi(3).Style='popupmenu'; edi(3).String={'cu','sct','cdao'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 19 %Jaimes et al. 2016
        nvis=2;
        
    case 20 %Garcia-Soto Jaimes 2017
        nvis=3;
        str(3).String='Component';
        
        edi(3).Style='popupmenu'; edi(3).String={'horizontal','vertical'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 21 %Garcia-Soto Jaimes 2017 (VH)
        nvis=2;
        
    case 22 %Gulerce, Abrahamson 2011
        nvis=3;
        str(3).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 23 %Stewart et al. 2016
        nvis=4;
        str(3).String='SOF';
        str(4).String='Region';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='popupmenu'; edi(4).String={'global','california','japan','china','italy','turkey'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 24 %Gulerce et al. 2017
        nvis=4;
        str(3).String='SOF';
        str(4).String='Region';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='popupmenu'; edi(4).String={'global','japan','china','italy','middle-east','taiwan'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 25 %Bernal et al. 2014
        nvis=3;
        str(3).String='Mechanism';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 26 %Sadigh et al. 1997
        nvis=3;
        str(3).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 27 %Idriss 2008 - NGA
        nvis=3;
        str(3).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 28 %Chiou Youngs 2008 - NGA
        nvis=6;
        str(3).String='Z1.0';
        str(4).String='SOF';
        str(5).String='Event';
        str(6).String='VS30 type';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'mainshock','aftershock'};
        edi(6).Style='popupmenu'; edi(6).String={'measured','inferred'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        [~,edi(6).Value]=intersect(edi(6).String,usp{4});
        
    case 29 %Boore Atkinson 2008 - NGA
        nvis=3;
        str(3).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 30 %Campbell Bozorgnia 2008 - NGA
        nvis=5;
        str(3).String='Z2.5';
        str(4).String='SOF';
        str(5).String='Sigma type';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'arbitrary','average'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        
    case 31 %Abrahamson Silva 2008 - NGA
        nvis=6;
        str(3).String='Z1.0';
        str(4).String='SOF';
        str(5).String='Event';
        str(6).String='VS30 type';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'mainshock','foreshock','swarms'};
        edi(6).Style='popupmenu'; edi(6).String={'measured','inferred'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        [~,edi(6).Value]=intersect(edi(6).String,usp{4});
        
    case 32 %Abrahamson Silva 1997 (Horz)
        nvis=5;
        str(3).String='SOF';
        str(4).String='Location';
        str(5).String='Sigma type';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='popupmenu'; edi(4).String={'hangingwall','footwall','other'};
        edi(5).Style='popupmenu'; edi(5).String={'arbitrary','average'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});        
        
    case 33 %Idriss 2014 - NGAW2
        nvis=3;
        str(3).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 34 %CY 2014 - NGAW2
        nvis=6;
        str(3).String='Z1.0';
        str(4).String='SOF';
        str(5).String='VS30 type';
        str(6).String='Region';
        
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'measured','inferred'};
        edi(6).Style='popupmenu'; edi(6).String={'global','california','japan','china','italy','turkey'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        [~,edi(6).Value]=intersect(edi(6).String,usp{4});
        
    case 35 %CB 2014 - NGAW2
        nvis=6;
        str(3).String='Z2.5';
        str(4).String='SOF';
        str(5).String='HW Effect';
        str(6).String='Region';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'include','exclude'};
        edi(6).Style='popupmenu'; edi(6).String={'global','california','japan','china','italy','turkey'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        [~,edi(6).Value]=intersect(edi(6).String,usp{4});
        
    case 36 %BSSA 2014 - NGAW2
        nvis=5;
        str(3).String='Z1.0';
        str(4).String='SOF';
        str(5).String='Region';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'global','california','japan','china','italy','turkey'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        
    case 37 %ASK 2014 - NGAW2
        nvis=7;
        str(3).String='Z1.0';
        str(4).String='SOF';
        str(5).String='Event';
        str(6).String='VS30 type';
        str(7).String='Region';
        
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'mainshock','aftershock'};
        edi(6).Style='popupmenu'; edi(6).String={'measured','inferred'};
        edi(7).Style='popupmenu'; edi(7).String={'global','california','japan','china','italy','turkey'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        [~,edi(6).Value]=intersect(edi(6).String,usp{4});
        [~,edi(7).Value]=intersect(edi(7).String,usp{5});
        
    case 38 %Akkar & Boomer 2007
        nvis=5;
        str(3).String='Media';
        str(4).String='SOF';
        str(5).String='Damping';
        
        edi(3).Style='popupmenu'; edi(3).String={'stiff','soil','other'};
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={2,5,10,20,30};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,num2str(usp{3}));
        
    case 39 %Akkar & Boomer 2010
        nvis=4;
        str(3).String='Media';
        str(4).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'rock','stiff','soft'};
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 40 %Akkar et al. 2014
        nvis=4;
        str(3).String='SOF';
        str(4).String='Model';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='popupmenu'; edi(4).String={'rhyp','rjb','repi'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 41 %Arroyo et al. 2010
        nvis=2;
        
    case 42 %Bindi et al. 2011
        nvis=4;
        str(3).String='SOF';
        str(4).String='Component';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='popupmenu'; edi(4).String={'geoh','z'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 43 %Kanno et al. 2006
        nvis=2;
        
    case 44 %Cauzzi et al., 2015
        nvis=4;
        str(3).String='VS30 form';
        str(4).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'1','2','3'};
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(edi(3).String,num2str(usp{1}));
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 45 %Du & Wang, 2012
        nvis=4;
        str(3).String='SGS Class';
        str(4).String='SOF';
        
        edi(3).Style='popupmenu';  edi(3).String={'B','C','D'};
        edi(4).Style='popupmenu';  edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(lower(edi(3).String),lower(usp{1}));
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 46 %Foulser-Piggott, Goda 2015
        nvis=5;
        str(3).String='Mechanism';
        str(4).String='Arc';
        str(5).String='Regtype';
        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab','strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(4).Style='popupmenu'; edi(4).String={'forearc','backarc'};
        edi(5).Style='popupmenu'; edi(5).String={'linear','nonlinear'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        
    case 47 %Travasarou, Bray, Abra  2003
        nvis=4;
        str(3).String='SGS Class';
        str(4).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'B','C','D'};
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        [~,edi(3).Value]=intersect(lower(edi(3).String),lower(usp{1}));
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});        
        
    case 48 %Bullock et al, 2017
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='imtype';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','reverse','intraplate','normal-oblique','reverse-oblique','unspecified','subduction-interface','subduction-intraslab','subduction-unknown'};
        edi(4).Style='popupmenu'; edi(4).String={'CAV','CAV5','CAVSTD'};
        
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        [~,edi(4).Value]=intersect(lower(edi(4).String),lower(usp{2}));        
        
    case 49 %Campbell,Bozorgnia 2010
        nvis=4;
        str(3).String='Z2.5';
        str(4).String='SOF';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        
    case 50 %Campbell,Bozorgnia 2011
        nvis=5;
        str(3).String='Z2.5';
        str(4).String='SOF';
        str(5).String='Database';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'CB08-NGA-PSV','CB08-NGA-NoPSV','PEER-NGA-PSV','PEER-NGA-NoPSV'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(lower(edi(5).String),lower(usp{3}));
        
    case 51 %Campbell,Bozorgnia 2019
        nvis=5;
        str(3).String='Z2.5';
        str(4).String='SOF';
        str(5).String='Region';
        
        edi(3).Style='edit';
        edi(4).Style='popupmenu'; edi(4).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        edi(5).Style='popupmenu'; edi(5).String={'global','california','japan','china','italy','turkey'};
        
        edi(3).String=usp{1};
        [~,edi(4).Value]=intersect(edi(4).String,usp{2});
        [~,edi(5).Value]=intersect(edi(5).String,usp{3});
        
    case 52 %Kramer & Mitchell, 2006
        nvis=3;
        str(3).String='SOF';
        
        edi(3).Style='popupmenu'; edi(3).String={'strike-slip','normal','normal-oblique','reverse','reverse-oblique','unspecified'};
        [~,edi(3).Value]=intersect(edi(3).String,usp{1});
        
    case 53 %PCE BCHydro (median)
        nvis=2;
        
    case 54 %PCE NGA (median)
        nvis=2;
        
    case 55 %PCE BCHydro
        nvis=2;
        
    case 56 %PCE NGA
        nvis=2;        

    case 57 %MAB2019
        nvis=5;
        str(3).String='Mechanism';
        str(4).String='Region';
        str(5).String='Condition';        
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'}; 
        edi(4).Style='popupmenu'; edi(4).String={'global','japan','taiwan','south-america','new-zeeland'};
        edi(5).Style='edit';      edi(5).String=gmmlib(str2double(gmm.txt{end})).label;
        [~,edi(3).Value]=intersect(edi(3).String,gmm.txt{4});
        [~,edi(4).Value]=intersect(edi(4).String,gmm.txt{5});
        
    case 58 %MAL2020
        nvis=4;
        str(3).String='HW effect';
        str(4).String='Condition';        
        edi(3).Style='popupmenu'; edi(3).String={'include','exclude'};
        edi(4).Style='edit';      edi(4).String=gmmlib(str2double(gmm.txt{end})).label;  
        [~,edi(3).Value]=intersect(edi(3).String,gmm.txt{4});
        
    case 59 %MMLA2020
        nvis=3;
        str(3).String='Condition';
        edi(3).Style='edit';      edi(3).String=gmmlib(str2double(gmm.txt{end})).label;          
        
    case 60 %ML2021
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='Condition';
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='edit';      edi(4).String=gmmlib(str2double(gmm.txt{end})).label;
        [~,edi(3).Value]=intersect(edi(3).String,gmm.txt{4});
        
    case 61 %MCAVdp2021
        nvis=4;
        str(3).String='Mechanism';
        str(4).String='Condition';
        edi(3).Style='popupmenu'; edi(3).String={'interface','intraslab'};
        edi(4).Style='edit';      edi(4).String=gmmlib(str2double(gmm.txt{end})).label;        
        [~,edi(3).Value]=intersect(edi(3).String,gmm.txt{4});
        
    case 62 % Franky
        nvis=3;
        str(3).String='GMMs';
        edi(3).Style='edit';
        edi(3).String=strjoin(gmm.txt(4:end),',');
        
    case 63 %Jaimes et al. 2018
        nvis=2;        
end

for i=1:nvis
    str(i).Visible='on';
    edi(i).Visible='on';
end

if gmm.type==1
    N = nvis+1;
    str(N).Visible='on';
    str(N).String='IM Modifier';
    edi(N).Style='popupmenu';
    edi(N).Visible='on';
    edi(N).String=adj_models;
    if ~isempty(adj_ptr)
        edi(N).Value=adj_ptr;
    else
        edi(N).Value=1;
    end
end
