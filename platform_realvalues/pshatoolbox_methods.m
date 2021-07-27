function ME = pshatoolbox_methods(group,varargin)

% regular = typical GMPEs
% cond    = conditional GMPE
% pce     = polynomial chaos expansion GMPE

% ground motion models (gmpe)
if group ==1
    ME(1:63,1)=struct('id',[],'label',[],'func',[],'str',[],'type',[],'mech',[],'ref',[]);
    % --------------------REGULAR MODELS --------------------------------------------------------------------------
    i=1;  ME(i).id=i; ME(i).label = 'Youngs et al. 1997';           ME(i).func = @Youngs1997;              ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/gssrl.68.1.58';
    i=2;  ME(i).id=i; ME(i).label = 'Atkinson & Boore, 2003';       ME(i).func = @AtkinsonBoore2003;       ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120020156';
    i=3;  ME(i).id=i; ME(i).label = 'Zhao et al. 2006';             ME(i).func = @Zhao2006;                ME(i).mech=[1 1 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120050122';
    i=4;  ME(i).id=i; ME(i).label = 'McVerry et al. 2006';          ME(i).func = @Mcverry2006;             ME(i).mech=[1 1 1]; ME(i).type=1;  ME(i).ref='http://www.nzsee.org.nz/db/Bulletin/Archive/39(1)0001.pdf';
    i=5;  ME(i).id=i; ME(i).label = 'Boroschek et al. 2012';        ME(i).func = @ContrerasBoroschek2012;  ME(i).mech=[1 0 0]; ME(i).type=1;  ME(i).ref='https://nisee.berkeley.edu/elibrary/files/documents/elib/www/documents/201204/PISELL/boroschek-maule-eq.pdf';
    i=6;  ME(i).id=i; ME(i).label = 'Abrahamson et al. 2016';       ME(i).func = @BCHydro2012;             ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/051712EQS188MR';
    i=7;  ME(i).id=i; ME(i).label = 'Abrahamson et al. 2018';       ME(i).func = @BCHydro2018;             ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://peer.berkeley.edu/sites/default/files/2018_02_abrahamson_9.10.18.pdf';
    i=8;  ME(i).id=i; ME(i).label = 'Kuehn et al. 2020';            ME(i).func = @Kuehn2020;               ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://peer.berkeley.edu/sites/default/files/2020_02_final_3.17.2020.pdf';
    i=9;  ME(i).id=i; ME(i).label = 'Parker et al. 2020';           ME(i).func = @Parker2020;              ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://peer.berkeley.edu/sites/default/files/2020_02_final_3.17.2020.pdf';
    i=10; ME(i).id=i; ME(i).label = 'Arteta et al. 2018';           ME(i).func = @Arteta2018;              ME(i).mech=[0 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/102116EQS176M';
    i=11; ME(i).id=i; ME(i).label = 'Idini et al. 2016';            ME(i).func = @Idini2016;               ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1007/s10518-016-0050-1';
    i=12; ME(i).id=i; ME(i).label = 'Montalva et al. 2017';         ME(i).func = @MontalvaBastias2017;     ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120160221';
    i=13; ME(i).id=i; ME(i).label = 'Montalva et al. 2017 (HQ) ';   ME(i).func = @MontalvaBastias2017HQ;   ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120160221';
    i=14; ME(i).id=i; ME(i).label = 'Montalva et al. 2018';         ME(i).func = @Montalva2018;            ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='';
    i=15; ME(i).id=i; ME(i).label = 'SIBER-RISK 2019';              ME(i).func = @SiberRisk2019;           ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1177/8755293019891723';
    i=16; ME(i).id=i; ME(i).label = 'Garcia et al. 2005';           ME(i).func = @Garcia2005;              ME(i).mech=[0 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120050072';
    i=17; ME(i).id=i; ME(i).label = 'Jaimes et al. 2006';           ME(i).func = @Jaimes2006;              ME(i).mech=[1 0 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1080/13632460609350622';
    i=18; ME(i).id=i; ME(i).label = 'Jaimes et al. 2015';           ME(i).func = @Jaimes2015;              ME(i).mech=[0 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1080/13632469.2015.1025926';
    i=19; ME(i).id=i; ME(i).label = 'Jaimes et al. 2016';           ME(i).func = @Jaimes2016;              ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120150283';
    i=20; ME(i).id=i; ME(i).label = 'Garcia-Soto Jaimes 2017';      ME(i).func = @GarciaJaimes2017;        ME(i).mech=[1 0 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120160273';
    i=21; ME(i).id=i; ME(i).label = 'Garcia-Soto Jaimes 2017 (V/H)';ME(i).func = @GarciaJaimes2017VH;      ME(i).mech=[1 0 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120160273';
    i=22; ME(i).id=i; ME(i).label = 'Gulerce, Abrahamson 2011';     ME(i).func = @GA2011;                  ME(i).mech=[1 1 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.3651317';
    i=23; ME(i).id=i; ME(i).label = 'Stewart et al. 2016';          ME(i).func = @SBSA2016;                ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/072114eqs116m';
    i=24; ME(i).id=i; ME(i).label = 'Gulerce et al. 2017';          ME(i).func = @GKAS2017;                ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='http://dx.doi.org/10.1193/121814EQS213M';
    i=25; ME(i).id=i; ME(i).label = 'Bernal et al. 2014';           ME(i).func = @Bernal2014;              ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.13140/2.1.2693.6641';
    i=26; ME(i).id=i; ME(i).label = 'Sadigh et al. 1997';           ME(i).func = @Sadigh1997;              ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/gssrl.68.1.180';
    i=27; ME(i).id=i; ME(i).label = 'Idriss 2008';                  ME(i).func = @I2008;                   ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.2924362';
    i=28; ME(i).id=i; ME(i).label = 'Chiou Youngs 2008';            ME(i).func = @CY2008;                  ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.2894832';
    i=29; ME(i).id=i; ME(i).label = 'Boore Atkinson 2008';          ME(i).func = @BA2008;                  ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.2830434';
    i=30; ME(i).id=i; ME(i).label = 'Campbell Bozorgnia 2008';      ME(i).func = @CB2008;                  ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.2857546';
    i=31; ME(i).id=i; ME(i).label = 'Abrahamson Silva 2008';        ME(i).func = @AS2008;                  ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.2924360';
    i=32; ME(i).id=i; ME(i).label = 'Abrahamson Silva 1997 (Horz)'; ME(i).func = @AS1997h;                 ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/gssrl.68.1.94';
    i=33; ME(i).id=i; ME(i).label = 'Idriss 2014';                  ME(i).func = @I2014;                   ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref ='https://doi.org/10.1193/070613EQS195M';
    i=34; ME(i).id=i; ME(i).label = 'CY 2014';                      ME(i).func = @CY2014;                  ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/072813eqs219m';
    i=35; ME(i).id=i; ME(i).label = 'CB 2014';                      ME(i).func = @CB2014;                  ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/062913eqs175m';
    i=36; ME(i).id=i; ME(i).label = 'BSSA 2014';                    ME(i).func = @BSSA2014;                ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/070113eqs184m';
    i=37; ME(i).id=i; ME(i).label = 'ASK 2014';                     ME(i).func = @ASK2014;                 ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/070913eqs198m';
    i=38; ME(i).id=i; ME(i).label = 'Akkar & Boomer 2007';          ME(i).func = @AkkarBoomer2007;         ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1002/eqe.679';
    i=39; ME(i).id=i; ME(i).label = 'Akkar & Boomer 2010';          ME(i).func = @AkkarBoomer2010;         ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/gssrl.81.2.195';
    i=40; ME(i).id=i; ME(i).label = 'Akkar et al. 2014';            ME(i).func = @Akkar2014;               ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1007/s10518-013-9461-4';
    i=41; ME(i).id=i; ME(i).label = 'Arroyo et al. 2010';           ME(i).func = @Arroyo2010;              ME(i).mech=[1 0 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1007/s10950-010-9200-0';
    i=42; ME(i).id=i; ME(i).label = 'Bindi et al. 2011';            ME(i).func = @Bindi2011;               ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1007/s10518-011-9313-z';
    i=43; ME(i).id=i; ME(i).label = 'Kanno et al. 2006';            ME(i).func = @Kanno2006;               ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='http://dx.doi.org/10.1785/0120050138';
    i=44; ME(i).id=i; ME(i).label = 'Cauzzi et al. 2015';           ME(i).func = @Cauzzi2015;              ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1007/s10518-014-9685-y';
    i=45; ME(i).id=i; ME(i).label = 'Du & Wang, 2012';              ME(i).func = @DW12;                    ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1002/eqe.2266';
    i=46; ME(i).id=i; ME(i).label = 'Foulser-Piggott, Goda 2015';   ME(i).func = @FG15;                    ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120140316';
    i=47; ME(i).id=i; ME(i).label = 'Travasarou et al. 2003';       ME(i).func = @TBA03;                   ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1002/eqe.270';
    i=48; ME(i).id=i; ME(i).label = 'Bullock et al, 2017';          ME(i).func = @BU17;                    ME(i).mech=[1 1 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1785/0120160388';
    i=49; ME(i).id=i; ME(i).label = 'Campbell,Bozorgnia 2010';      ME(i).func = @CB10;                    ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.3457158';
    i=50; ME(i).id=i; ME(i).label = 'Campbell,Bozorgnia 2011';      ME(i).func = @CB11;                    ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1016/j.nucengdes.2011.04.020';
    i=51; ME(i).id=i; ME(i).label = 'Campbell,Bozorgnia 2019';      ME(i).func = @CB19;                    ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/090818EQS212M';
    i=52; ME(i).id=i; ME(i).label = 'Kramer & Mitchell, 2006';      ME(i).func = @KM06;                    ME(i).mech=[0 0 1]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1193/1.2194970';
    i=53; ME(i).id=i; ME(i).label = 'PCE BCHydro (median)';         ME(i).func = @medianPCEbchydro;        ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1016/j.enggeo.2020.105786';
    i=54; ME(i).id=i; ME(i).label = 'PCE NGA (median)';             ME(i).func = @medianPCEnga;            ME(i).mech=[1 1 0]; ME(i).type=1;  ME(i).ref='https://doi.org/10.1016/j.enggeo.2020.105786';
    
    % --------------------PCE MODELS -----------------------------------------------------------------------
    i=55; ME(i).id=i; ME(i).label = 'PCE NGA';                      ME(i).func = @PCE_nga;                 ME(i).mech=[0 0 1]; ME(i).type=2;      ME(i).ref='https://doi.org/10.1016/j.enggeo.2020.105786';
    i=56; ME(i).id=i; ME(i).label = 'PCE BCHydro';                  ME(i).func = @PCE_bchydro;             ME(i).mech=[1 1 0]; ME(i).type=2;      ME(i).ref='https://doi.org/10.1016/j.enggeo.2020.105786';
    
    % --------------------CONDITIONAL MODELS -----------------------------------------------------------------------
    % AI SUB
    i=57; ME(i).id=i; ME(i).label = 'Macedo, Abrahamson, Bray 2019';ME(i).func = @MAB2019;                 ME(i).mech=[1 1 0]; ME(i).type=3;     ME(i).ref='https://doi.org/10.1785/0120180297';
    
    % CAV shallow crustal
    i=58; ME(i).id=i; ME(i).label = 'Macedo, Abrahamson, Liu  2020';ME(i).func = @MAL2020;                 ME(i).mech=[0 0 1]; ME(i).type=3;     ME(i).ref='https://doi.org/10.1785/0120190321';
    i=59; ME(i).id=i; ME(i).label = 'Macedo, Mao, Liu, Abrah. 2020';ME(i).func = @MMLA2020;                ME(i).mech=[0 0 1]; ME(i).type=3;     ME(i).ref='not published, but a good model';
    
    % CAV SUB
    i=60; ME(i).id=i; ME(i).label = 'Macedo, Liu, 2021';            ME(i).func = @ML2021;                  ME(i).mech=[1 1 0]; ME(i).type=3;     ME(i).ref='under review';
    
    % CAVdp SUB
    i=61; ME(i).id=i; ME(i).label = 'Macedo et al., 2021';          ME(i).func = @MCAVdp2021;              ME(i).mech=[1 1 0]; ME(i).type=3;     ME(i).ref='under review';
    
    % --------------------SPECIAL MODELS  -----------------------------------------------------------------------
    i=62; ME(i).id=i; ME(i).label = 'Franky';                       ME(i).func = @franky;                  ME(i).mech=[0 0 0]; ME(i).type=4;      ME(i).ref='www.google.com';
    
    %-------------------------------------------------------------------------------------
    i=63; ME(i).id=i; ME(i).label = 'Jaimes et al. 2018';           ME(i).func = @Jaimes2018;              ME(i).mech=[0 1 0]; ME(i).type=1;  ME(i).ref='www.google.com';
    
end

% magnitude scaling models
if group == 2
    ME(1:4,1)=struct('id',[],'label',[],'func',[],'str',[],'ref',[]);
    i=1;ME(i).id=i; ME(i).label = 'Delta';                   ME(i).func = @delta;
    i=2;ME(i).id=i; ME(i).label = 'Truncated Exponential';   ME(i).func = @truncexp;
    i=3;ME(i).id=i; ME(i).label = 'Truncated Normal';        ME(i).func = @truncnorm;
    i=4;ME(i).id=i; ME(i).label = 'Characteristic';          ME(i).func = @yc1985;
end

% spatial correlation models
if group ==3
    ME(1:4,1)=struct('id',[],'label',[],'func',[],'str',[],'ref',[]);
    i=1;ME(i).id=i; ME(i).label = 'none';                              ME(i).func= @none_spatial;     ME(i).ref='www.google.com';
    i=2;ME(i).id=i; ME(i).label = 'Jayaram N. and Baker J.W. (2009)';  ME(i).func= @JB_spatial_2009;  ME(i).ref='https://doi.org/10.1002/eqe.922';
    i=3;ME(i).id=i; ME(i).label = 'Loth, C., and Baker, J. W. (2013)'; ME(i).func= @LB_spatial_2013;  ME(i).ref='https://doi.org/10.1002/eqe.2212';
    i=4;ME(i).id=i; ME(i).label = 'Candia et al. (2019)';              ME(i).func= @SR_spatial_2019;  ME(i).ref='www.google.com';
end

% interperiod correlation models
if group == 4
    ME(1:14,1)=struct('id',[],'label',[],'func',[],'str',[],'dependency',[],'ref',[]);                      % mechanism - magnitude - direction
    i=1; ME(i).id=i; ME(i).label = 'none';                     ME(i).func = @corr_none;                 ME(i).dependency = [0 0 0];    ME(i).ref='www.google.com';
    i=2; ME(i).id=i; ME(i).label = 'Baker & Cornell 2006';     ME(i).func = @corr_BakerCornell2006;     ME(i).dependency = [0 0 1];    ME(i).ref='https://doi.org/10.1785/0120050060';
    i=3; ME(i).id=i; ME(i).label = 'Baker & Jayaram 2008';     ME(i).func = @corr_BakerJayaram2008;     ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1193/1.2857544';
    i=4; ME(i).id=i; ME(i).label = 'Jayaram et al. 2011';      ME(i).func = @corr_JayaramBaker2011;     ME(i).dependency = [1 0 0];    ME(i).ref='https://doi.org/10.12989/eas.2011.2.4.357';
    i=5; ME(i).id=i; ME(i).label = 'Cimellaro 2013';           ME(i).func = @corr_Cimellaro2013;        ME(i).dependency = [0 0 1];    ME(i).ref='https://doi.org/10.1002/eqe.2248';
    i=6; ME(i).id=i; ME(i).label = 'ASK2014 - NGA West2';      ME(i).func = @corr_Abrahamson2014;       ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1193/070913eqs198m';
    i=7; ME(i).id=i; ME(i).label = 'Abrahamanson et al. 2016'; ME(i).func = @corr_BCHhydro2016;         ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1193/051712EQS188MR';
    i=8; ME(i).id=i; ME(i).label = 'Baker & Bradley 2017';     ME(i).func = @corr_BakerBradley2017;     ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1193/060716EQS095M';
    i=9; ME(i).id=i; ME(i).label = 'Jaimes & Candia 2019';     ME(i).func = @corr_JaimesCandia2019;     ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1193/080918EQS200M';
    i=10;ME(i).id=i; ME(i).label = 'Candia et al. 2019';       ME(i).func = @corr_Candia2019;           ME(i).dependency = [1 0 0];    ME(i).ref='https://doi.org/10.1177/8755293019891723';
    i=11;ME(i).id=i; ME(i).label = 'Goda & Atkinson 2009';     ME(i).func = @corr_GodaAtkinson2009;     ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1785/0120090007';
    i=12;ME(i).id=i; ME(i).label = 'Akkar & Sandikkaya 2014';  ME(i).func = @corr_Akkar2014;            ME(i).dependency = [0 0 0];    ME(i).ref='https://doi.org/10.1007/s10518-013-9537-1';
    i=13;ME(i).id=i; ME(i).label = 'Ji et al. 2017';           ME(i).func = @corr_Ji2017;               ME(i).dependency = [0 1 0];    ME(i).ref='https://doi.org/10.1785/0120160291';
    i=14;ME(i).id=i; ME(i).label = 'Campbell & Bozorgnia 2019';ME(i).func = @corr_CambpelBozorgnia2019; ME(i).dependency = [0 1 0];    ME(i).ref='https://doi.org/10.1193/090818EQS212M';
end

% psda
if group == 5
    ME(1:13,1)=struct('id',[],'label',[],'isregular',[],'func',[],'str',[],'integrator',[],'primaryIM',[],'Safactor',[],'ref',[]);
    % subduction
    i=1; ME(i).id=i;ME(i).label = 'BMT 2017 Sa(M)';      ME(i).func = @BMT2017M;     ME(i).mechanism = 'subduction'; ME(i).integrator=1;  ME(i).primaryIM='SA(T=1.5Ts)';     ME(i).isregular=true;  ME(i).ref = 'https://doi.org/10.1061/(ASCE)GT.1943-5606.0001833';
    i=2; ME(i).id=i;ME(i).label = 'BMT 2017 (PCE-M)';    ME(i).func = @BMT2017_cdmM; ME(i).mechanism = 'subduction'; ME(i).integrator=6;  ME(i).primaryIM='SA(T=1.5Ts)';     ME(i).isregular=false; ME(i).ref = 'https://doi.org/10.1061/(ASCE)GT.1943-5606.0001833';
    
    % shallow crustal (bray et al)
    i=3; ME(i).id=i;ME(i).label = 'BT 2007 Sa';          ME(i).func = @BT2007;       ME(i).mechanism = 'crustal'; ME(i).integrator=2;  ME(i).primaryIM='SA(T=1.5Ts)';     ME(i).isregular=true;  ME(i).ref = 'https://doi.org/10.1061/(ASCE)1090-0241(2007)133:4(381)';
    i=4; ME(i).id=i;ME(i).label = 'BT 2007 Sa(M)';       ME(i).func = @BT2007M;      ME(i).mechanism = 'crustal'; ME(i).integrator=1;  ME(i).primaryIM='SA(T=1.5Ts)';     ME(i).isregular=true;  ME(i).ref = 'https://doi.org/10.1061/(ASCE)1090-0241(2007)133:4(381)';
    i=5; ME(i).id=i;ME(i).label = 'BT 2007 (PCE)';       ME(i).func = @BT2007_cdm;   ME(i).mechanism = 'crustal'; ME(i).integrator=5;  ME(i).primaryIM='SA(T=1.5Ts)';     ME(i).isregular=false; ME(i).ref = 'https://doi.org/10.1061/(ASCE)1090-0241(2007)133:4(381)';
    i=6; ME(i).id=i;ME(i).label = 'BT 2007 (PCE-M)';     ME(i).func = @BT2007_cdmM;  ME(i).mechanism = 'crustal'; ME(i).integrator=6;  ME(i).primaryIM='SA(T=1.5Ts)';     ME(i).isregular=false; ME(i).ref = 'https://doi.org/10.1061/(ASCE)1090-0241(2007)133:4(381)';
    i=7; ME(i).id=i;ME(i).label = 'BM 2019 NonNF (M)';   ME(i).func = @BM2019M;      ME(i).mechanism = 'crustal'; ME(i).integrator=1;  ME(i).primaryIM='SA(T=1.3Ts)';     ME(i).isregular=true;  ME(i).ref = 'https://www.ce.berkeley.edu/people/faculty/bray/research';
    
    % shallow crustal (other)
    i=8; ME(i).id=i;ME(i).label = 'Jibson  2007 (M)';    ME(i).func = @J07M;         ME(i).mechanism = 'crustal'; ME(i).integrator=1;  ME(i).primaryIM='PGA';           ME(i).isregular=true;  ME(i).ref = 'https://www.sciencedirect.com/science/article/pii/S0013795207000300?via%3Dihub';
    i=9; ME(i).id=i;ME(i).label = 'Jibson  2007 Ia';     ME(i).func = @J07Ia;        ME(i).mechanism = 'crustal'; ME(i).integrator=2;  ME(i).primaryIM='AI';            ME(i).isregular=true;  ME(i).ref = 'https://www.sciencedirect.com/science/article/pii/S0013795207000300?via%3Dihub';
    i=10;ME(i).id=i;ME(i).label = 'RA 2011';             ME(i).func = @RA2011;       ME(i).mechanism = 'crustal'; ME(i).integrator=4;  ME(i).primaryIM='PGV-PGA';       ME(i).isregular=true;  ME(i).ref = 'https://www.sciencedirect.com/science/article/pii/S0013795210002553';
    i=11;ME(i).id=i;ME(i).label = 'RS 2009 (Scalar-M)';  ME(i).func = @RS09M;        ME(i).mechanism = 'crustal'; ME(i).integrator=1;  ME(i).primaryIM='PGA';           ME(i).isregular=true;  ME(i).ref = 'http://www.nzsee.org.nz/db/Bulletin/Archive/42(1)0018.pdf';
    i=12;ME(i).id=i;ME(i).label = 'RS 2009 (Vector)';    ME(i).func = @RS09V;        ME(i).mechanism = 'crustal'; ME(i).integrator=3;  ME(i).primaryIM='PGV-PGA';       ME(i).isregular=true;  ME(i).ref = 'http://www.nzsee.org.nz/db/Bulletin/Archive/42(1)0018.pdf';
    i=13;ME(i).id=i;ME(i).label = 'AM 1988';             ME(i).func = @AM1988;       ME(i).mechanism = 'crustal'; ME(i).integrator=2;  ME(i).primaryIM='PGA';           ME(i).isregular=true;  ME(i).ref = 'https://doi.org/10.1002/eqe.4290160704';
    
    for j=1:length(ME)
        ME(j).Safactor=str2IM(regexp(ME(j).primaryIM,'\-','split'));
        ME(j).Safactor=ME(j).Safactor(:)';
    end
    
end

% settlement and tilt models
if group == 6
    ME(1:10,1)=struct('id',[],'label',[],'func',[],'str',[],'IM',[],'integrator',[],'ref',[]);
    
    % Bray & Macedo 2017 LIBS
    i=1;ME(i).id=i;ME(i).label = 'Bray & Macedo 2017 (Ds)';              ME(i).func = @BrayMacedo2017Ds;     ME(i).IM='PGA-SA(T=1)-CAV'; ME(i).integrator=3; ME(i).ref = 'https://doi.org/10.1016/j.soildyn.2017.08.026';
    i=2;ME(i).id=i;ME(i).label = 'Juang et al. 2013  (Dv)';              ME(i).func = @Juang2013Dv;          ME(i).IM='PGA';             ME(i).integrator=0; ME(i).ref = 'https://doi.org/10.1016/j.soildyn.2017.08.026';
    i=3;ME(i).id=i;ME(i).label = 'Bray & Macedo 2017 (LIBS)';            ME(i).func = @BrayMacedo2017;       ME(i).IM='PGA-SA(T=1)-CAV'; ME(i).integrator=3; ME(i).ref = '';
    i=4;ME(i).id=i;ME(i).label = 'Hutabarat 2020 (De)';                  ME(i).func = @Hutabarat2020De;      ME(i).IM='PGA';             ME(i).integrator=0; ME(i).ref = '';
    
    % Bullock 2018 LIBS
    i=5;ME(i).id=i;ME(i).label = 'Bullock 2018 (Ds)';                    ME(i).func = @Bullock2018Ds;        ME(i).IM='CAV';             ME(i).integrator=1; ME(i).ref = 'https://doi.org/10.1680/jgeot.17.P.174';
    i=6;ME(i).id=i;ME(i).label = 'Bullock 2018 (Dv)';                    ME(i).func = @Bullock2018Dv;        ME(i).IM='CAV';             ME(i).integrator=1; ME(i).ref = 'https://doi.org/10.1680/jgeot.17.P.174';
    i=7;ME(i).id=i;ME(i).label = 'Bullock 2018 (LIBS)';                  ME(i).func = @Bullock2018;          ME(i).IM='CAV';             ME(i).integrator=1; ME(i).ref = 'https://doi.org/10.1680/jgeot.17.P.174';
    
    % Bullock 2018 Tilting
    i=8;ME(i).id=i;ME(i).label = 'Bullock, 2018 (Tilt Empirical)';       ME(i).func = @Bullock2018e_tilt;         ME(i).IM='CAV';             ME(i).integrator=1; ME(i).ref = 'https://doi.org/10.1680/jgeot.17.P.174';
    i=9;ME(i).id=i;ME(i).label = 'Bullock, 2018 (Tilt Semi Empirical)';  ME(i).func = @Bullock2018s_tilt;         ME(i).IM='CAV-VGI';         ME(i).integrator=1; ME(i).ref = 'https://doi.org/10.1680/jgeot.17.P.174';
    
    % Null Model
    i=10;ME(i).id=i;ME(i).label = 'Null';                                 ME(i).func = @libs_null;                 ME(i).IM='PGA';             ME(i).integrator=1; ME(i).ref = '';
end

for i=1:numel(ME)
    ME(i).str=func2str(ME(i).func);
end

%% selective method
if nargin==2
    val = varargin{1};
    ME = ME(val);
end