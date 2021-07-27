function[gmm]=sh_updategmm(handles,gmm)

gmm.label  = handles.P4_e0.String;
gmm.txt{2} = gmm.label;
switch gmm.id
    case 1  %Youngs et al. 1997
        gmm.txt{4} = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
    case 2  %Atkinson & Boore, 2003
        gmm.txt{4} = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5} = handles.P4_e3.String{handles.P4_e3.Value};
        
        gmm.usp=gmm.txt(4:end);
        
    case 3  %Zhao et al. 2006
        gmm.txt{4} = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 4  %McVerry et al. 2006
        gmm.txt{4} = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5} = handles.P4_e3.String;
        gmm.usp    = [gmm.txt(4),str2double(gmm.txt{5})];
        
    case 5  %Boroschek et al. 2012
        
    case 6  %Abrahamson et al. 2016
        gmm.txt{4} = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5} = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6} = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 7  %Abrahamson et al. 2018
        gmm.txt{4} = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 8  %Kuehn et al. 2020
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String;
        gmm.txt{7}  = handles.P4_e5.String;
        gmm.txt{8}  = handles.P4_e6.String;
        gmm.txt{9}  = handles.P4_e7.String;
        gmm.txt{10} = handles.P4_e8.String;
        gmm.usp     = [gmm.txt(4:5),handles.P4_e4.String,handles.P4_e5.String,handles.P4_e6.String,handles.P4_e7.String,handles.P4_e8.String];
        
    case 9  %Parker et al. 2020
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp     = [handles.P4_e2.String,gmm.txt(5:6)];
        
    case 10 %Arteta et al. 2018
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 11 %Idini et al. 2016
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 12 %Montalva et al. 2017
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 13 %Montalva et al. 2017 (HQ)
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 14 %Montalva et al. 2018
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 15 %SIBER-RISK 2019
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 16 %Garcia et al. 2005
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 17 %Jaimes et al. 2006
        
    case 18 %Jaimes et al. 2015
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 19 %Jaimes et al. 2016
        
    case 20 %Garcia-Soto Jaimes 2017
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 21 %Garcia-Soto Jaimes 2017 (VH)
        
    case 22 %Gulerce, Abrahamson 2011
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 23 %Stewart et al. 2016
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 24 %Gulerce et al. 2017
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 25 %Bernal et al. 2014
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 26 %Sadigh et al. 1997
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 27 %Idriss 2008 - NGA
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 28 %Chiou Youngs 2008 - NGA
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.txt{7}  = handles.P4_e5.String{handles.P4_e5.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 29 %Boore Atkinson 2008 - NGA
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 30 %Campbell Bozorgnia 2008 - NGA
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp     = [str2double(handles.P4_e2.String),gmm.txt(5:end)];
        
    case 31 %Abrahamson Silva 2008 - NGA
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.txt{7}  = handles.P4_e5.String{handles.P4_e5.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 32 %Abrahamson Silva 1997 (Horz)
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 33 %Idriss 2014 - NGAW2
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 34 %CY 2014 - NGAW2
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.txt{7}  = handles.P4_e5.String{handles.P4_e5.Value};
        gmm.usp     = gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
        
    case 35 %CB 2014 - NGAW2
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.txt{7}  = handles.P4_e5.String{handles.P4_e5.Value};
        gmm.usp=gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
        
    case 36 %BSSA 2014 - NGAW2
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
        
    case 37 %ASK 2014 - NGAW2
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.txt{7}  = handles.P4_e5.String{handles.P4_e5.Value};
        gmm.txt{8}  = handles.P4_e6.String{handles.P4_e6.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 38 %Akkar & Boomer 2007
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 39 %Akkar & Boomer 2010
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 40 %Akkar et al. 2014
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 41 %Arroyo et al. 2010
        
    case 42 %Bindi et al. 2011
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 43 %Kanno et al. 2006
        
    case 44 %Cauzzi et al., 2015
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
        
    case 45 %Du & Wang, 2012
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 46 %Foulser-Piggott, Goda 2015
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 47 %Travasarou, Bray, Abra  2003
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 48 %Bullock et al, 2017
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 49 %Campbell,Bozorgnia 2010
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.usp=gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
        
    case 50 %Campbell,Bozorgnia 2011
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
        
    case 51 %Campbell,Bozorgnia 2019
        gmm.txt{4}  = handles.P4_e2.String;
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        gmm.txt{6}  = handles.P4_e4.String{handles.P4_e4.Value};
        gmm.usp=gmm.txt(4:end);
        gmm.usp{1}  = str2double(gmm.usp{1});
    case 52 %Kramer & Mitchell, 2006
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.usp=gmm.txt(4:end);
        
    case 53 %PCE BCHydro (median)
        
    case 54 %PCE NGA (median)
        
    case 55 %PCE BCHydro
        
    case 56 %PCE NGA
        
    case 57
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        gmm.txt{5}  = handles.P4_e3.String{handles.P4_e3.Value};
        [~,b]=intersect({handles.sys.gmmlib.label},handles.P4_e4.String);
        gmm.txt{6}=sprintf('%g',b);
        
    case 58
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        [~,b]=intersect({handles.sys.gmmlib.label},handles.P4_e3.String);
        gmm.txt{5}=sprintf('%g',b);
        
    case 59
        [~,b]=intersect({handles.sys.gmmlib.label},handles.P4_e2.String);
        gmm.txt{4}=sprintf('%g',b);
        
    case 60
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        [~,b]=intersect({handles.sys.gmmlib.label},handles.P4_e3.String);
        gmm.txt{5}=sprintf('%g',b);
        
    case 61
        gmm.txt{4}  = handles.P4_e2.String{handles.P4_e2.Value};
        [~,b]=intersect({handles.sys.gmmlib.label},handles.P4_e3.String);
        gmm.txt{5}=sprintf('%g',b);
        
    case 62
        gmm.txt(4:end)  = regexp(handles.P4_e2.String,',','split');
        
    case 63 %Jaimes et al. 2018
end

% ads modified
if gmm.type==1
    W          = what('gmm_adjust');
    adj_models = ['none';strrep(W.m,'.m','')];
    if any(ismember(adj_models,gmm.txt{end}))
        fld = sprintf('P4_e%g',numel(gmm.txt)-2);
        fun = handles.(fld).String{handles.(fld).Value};
        if ~strcmp(fun,'none')
            gmm.txt{end} = fun;
            gmm.usp{end} = fun;
        end
    else
        fld = sprintf('P4_e%g',numel(gmm.txt)-1);
        fun = handles.(fld).String{handles.(fld).Value};
        if ~strcmp(fun,'none')
            gmm.txt{end+1} = fun;
            gmm.usp{end+1} = fun;
        end
    end
end


