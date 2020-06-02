function[sys,opt,h]=loadPSHA(filename)

%% PREPROCES TEXTFILE
sys=[];
opt=[];
h  =[];
fid  = fopen(filename);
if fid==-1
    return
end
sys.filename=filename;
data = textscan(fid,'%s','delimiter','\n');
data = data{1};
fclose(fid);

% removes comments and trailing blank spaces
ind=strfind(data,'#');
for i=1:size(data,1)
    if ~isempty(ind{i})
        II = ind{i}(1);
        data{i}(II:end)=[];
    end
    data{i}=deblank(data{i});
end

% removes empty lines
emptylist= [];
for i=1:size(data,1)
    if isempty(data{i,1})
        emptylist=[emptylist,i]; %#ok<*AGROW>
    end
end
data(emptylist,:)=[];

% removes multiple spaces
data=regexprep(data,' +',' ');

% add source and magnitude scaling relations from textfiles
data=loadTXTdata(data,'txt2source'); % add source from textfile
data=loadTXTdata(data,'txt2mscl');   % add magnitude recurrence mododels from textfile

%% computes option pointers
ptrs = nan(24,2);
for i=1:size(data,1)
    if strfind(data{i,1},'Option 0 '), ptrs(1,1) =i;end % real values
    if strfind(data{i,1},'Option 1 '), ptrs(2,1) =i;end % Logic tree weights
    if strfind(data{i,1},'Option 2 '), ptrs(3,1) =i;end % Source Geometry
    if strfind(data{i,1},'Option 3 '), ptrs(4,1) =i;end % GMM Library
    if strfind(data{i,1},'Option 4 '), ptrs(5,1) =i;end % GMM Groups
    if strfind(data{i,1},'Option 5 '), ptrs(6,1) =i;end % Magnitude Recurrence
    if strfind(data{i,1},'Option 6 '), ptrs(7,1) =i;end % Sites (optional)
    if strfind(data{i,1},'Option 7 '), ptrs(8,1) =i;end % Validation (optional)
    
    % PSDA Options
    if strfind(data{i,1},'Option 8 '), ptrs(9,1) =i;end % PSDA setup
    if strfind(data{i,1},'Option 9 '), ptrs(10,1)=i;end % Slope Parameters
    if strfind(data{i,1},'Option 10 '),ptrs(11,1)=i;end % Library of Slope Displacement Models 
    if strfind(data{i,1},'Option 11 '),ptrs(12,1)=i;end % REG Slope Displacement Models
    if strfind(data{i,1},'Option 12 '),ptrs(13,1)=i;end % PCE Slope Displacement Models
    if strfind(data{i,1},'Option 13 '),ptrs(14,1)=i;end % PSDA validation
    
    % Liquefaction Induced Settlement (LIS) Options
    if strfind(data{i,1},'Option 20 '), ptrs(21,1) =i;end % LIBS options
    if strfind(data{i,1},'Option 21 '), ptrs(22,1) =i;end % Building and Site Specific Parameters
    if strfind(data{i,1},'Option 22 '), ptrs(23,1) =i;end % Settlement model library
    if strfind(data{i,1},'Option 23 '), ptrs(24,1) =i;end % Settlement branches
end
ptrs = FindEndPtrs(ptrs,data);

%% GLOBAL PARAMETERS
str              = data(ptrs(1,1):ptrs(1,2),:);
str              = regexp(str,'\ : ','split');
opt.Projection   = str{1}{2};
switch opt.Projection
    case 'ECEF'
        opt.ellipsoid.Code=[];
    otherwise
        opt.ellipsoid=referenceEllipsoid(opt.Projection,'km');
end

for i=1:length(str)
    if numel(str{i})==1
        str{i}{2}='';
    end
end

opt.Image        = str{2}{2};
opt.Boundary     = str{3}{2};
opt.Layer        = str{4}{2};
opt.ShearModulus = str2double(str{5}{2});
opt.IM           = str2IM(field2str(regexp(str{6}{2},'\s+','split')));
opt.im           = eval(['[',str{7}{2},']'])'; % is stored in columns

if size(opt.im,2) ~= length(opt.IM)
    opt.im = repmat(opt.im(:,1),1,length(opt.IM));
end

opt.MaxDistance  = str2double(str{8}{2});
Mag = regexp(str{9}{2},'\ ','split');
Mag{2}=str2double(Mag{2});
opt.MagDiscrete  = Mag;

sig = regexp(str{10}{2},'\ ','split');
if isempty(sig{1})
    opt.Sigma={};
else
    opt.Sigma        = {sig{1},str2double(sig{2})};
end

cgmm             = regexp(str{11}{2},'\ ','split');
opt.PCE          = {cgmm{1},cgmm{2},str2double(cgmm{3})};
opt.IM1          = str2IM(field2str(regexp(str{12}{2},'\s+','split')));
opt.IM2          = str2IM(field2str(regexp(str{13}{2},'\s+','split')));
opt.Spatial      = str2func(strrep(str{14}{2},'@',''));
opt.Spectral     = str2func(strrep(str{15}{2},'@',''));
opt.SourceDeagg  = str{16}{2};
aux              = regexp(str{17}{2},'\ ','split');  
opt.Clusters     = {aux{1},str2double(aux(2:3))};

opt.IM  = opt.IM(:);
opt.IM1 = opt.IM1(:);
opt.IM2 = opt.IM2(:); opt.IM2(isnan(opt.IM2))=[];

%% ASSEMBLES LOGIC TREE
str = data(ptrs(2,1):ptrs(2,2),:);
str = regexp(str,'\:','split');
geom_weight = eval(['[',str{1}{2},']'])'; Ngeom = length(geom_weight);
gmpe_weight = eval(['[',str{2}{2},']'])'; Ngmpe = length(gmpe_weight);
mscl_weight = eval(['[',str{3}{2},']'])'; Nmscl = length(mscl_weight);

[iZ,iY,iX] = meshgrid(1:Nmscl,1:Ngmpe,1:Ngeom);
branch = [iX(:),iY(:),iZ(:)];
N0     = size(branch,1);
weight = [
    geom_weight(branch(:,1)),...
    gmpe_weight(branch(:,2)),...
    mscl_weight(branch(:,3))];
weight = [weight,ones(N0,1)];
branch = [branch,ones(N0,1)];
weight = [weight,prod(weight,2)];

%% READS SOURCES
source1(1:Ngeom,1) = createObj('source');
source2(1:Ngeom,1) = createObj('source');
source3(1:Ngeom,1) = createObj('source');
source4(1:Ngeom,1) = createObj('source');
source5(1:Ngeom,1) = createObj('source');
source6(1:Ngeom,1) = createObj('source');
source7(1:Ngeom,1) = createObj('source');

str = data(ptrs(3,1):ptrs(3,2),:);
pt  = zeros(Ngeom,2); j=1;
pt(end)=size(str,1);
for i=1:size(str,1)
    if ~isempty(strfind(str{i},'geometry'))
        pt(j,1)=i+1;
        if j>1
            pt(j-1,2)=i-1;
        end
        j=j+1;
    end
end

for i=1:Ngeom
    stri = str(pt(i,1):pt(i,2));
    ind1  = contains(stri,'point1'); source1(i) = read_obj1(stri(ind1));
    ind2  = contains(stri,'line1');  source2(i) = read_obj2(stri(ind2));
    ind3  = contains(stri,'area1');  source3(i) = read_obj3(stri(ind3));
    ind4  = contains(stri,'area2');  source4(i) = read_obj4(stri(ind4),opt.ellipsoid);
    ind5  = contains(stri,'area3');  source5(i) = read_obj5(stri(ind5));
    ind6  = contains(stri,'area4');  source6(i) = read_obj6(stri(ind6));
    ind7  = contains(stri,'area5');  source7(i) = read_obj7(stri(ind7));
end

%% READS GMPE LIBRRY
str = data(ptrs(4,1):ptrs(4,2),:);
Ngmpe = size(str,1);
GMMLIB(1:Ngmpe,1) = createObj('gmmlib');

methods = pshatoolbox_methods(1);
strs    = {methods.str};

for i=1:size(str,1)
    linea = regexp(str{i},'\s+','split');
    GMMLIB(i).txt=linea;
    GMMLIB(i).label=linea{2};
    linea = linea(3:end);
    model  = linea{1};
    [~,cgm]  = intersect(strs,model);
    GMMLIB(i).type  = methods(cgm).type;
    GMMLIB(i).handle=str2func(model);
    [GMMLIB(i).T,GMMLIB(i).Rmetric,GMMLIB(i).Residuals]=mGMPE_info(model);
    
    if strcmpi(linea{1},'udm')
        GMMLIB(i).usp=linea(2:end);
    else
        txt = lower(linea(2:end));
        num = str2double(txt);
        isd = ~isnan(num);
        txt(isd)=num2cell(num(isd));
        GMMLIB(i).usp=txt;
    end
end

meth  = pshatoolbox_methods(1);
str   = {meth.str};
typ   = {meth.type};

% PRE-PROCESS USER DEFINED MODELS
Rm = zeros(0,11);
for i=1:length(GMMLIB)
    hnd = func2str(GMMLIB(i).handle);
    [~,b]=intersect(str,hnd);
    if strcmp(typ{b},'udm')
        var = feval(GMMLIB(i).usp{1});
        GMMLIB(i).T  = var.IM.value;
        GMMLIB(i).Residuals=var.residuals;
        flds = fields(var);
        for jj=1:length(flds)
            if isfield(var.(flds{jj}),'tag')
                f = var.(flds{jj});
                if strcmp(f.tag,'Distance')
                    Rm=[Rm;f.value];
                end
            end
        end
        GMMLIB(i).Rmetric = sum(Rm,1)>0;
        GMMLIB(i).var     = var;
    end
end

% PRE-PROCESS CONDITIONAL MODELS
for i=1:length(GMMLIB)
    hnd = func2str(GMMLIB(i).handle);
    [~,b]=intersect(str,hnd);
    if strcmp(typ{b},'cond')
        usp = GMMLIB(i).usp;
        [~,Rmetric1]       = mGMPE_info(hnd);
        [~,b,c]            = intersect(lower(str),usp);
        GMMLIB(i).usp      = usp(c+1:end);
        GMMLIB(i).cond     = meth(b).func;
        [~,Rmetric2]       = mGMPE_info(meth(b).str);
        GMMLIB(i).Rmetric  = or(Rmetric1,Rmetric2);
    end
end

% PRE-PROCESS FRANKY MODELS
for i=1:length(GMMLIB)
    hnd = func2str(GMMLIB(i).handle);
    [~,b]=intersect(str,hnd);
    if strcmp(typ{b},'frn')
        usp     = cell2mat(GMMLIB(i).usp);
        Ndepend = length(usp);
        GMMLIB(i).Residuals = 'lognormal';
        for j=1:Ndepend
            val  = usp(j);
            GMMLIB(i).usp{j}  = GMMLIB(val);
            GMMLIB(i).T       = [GMMLIB(i).T,GMMLIB(val).T];
            GMMLIB(i).Rmetric = [GMMLIB(i).Rmetric;GMMLIB(val).Rmetric];
        end
        GMMLIB(i).T           = unique(GMMLIB(i).T);
        GMMLIB(i).Rmetric     = any(GMMLIB(i).Rmetric,1);
    end
end

%% READS GMM
str = data(ptrs(5,1):ptrs(5,2),:);
Ng = size(str,1);
id = cell(Ng,1);
ptr = [];
for i=1:Ng
    linea = regexp(str{i},'\ ','split');
    id{i} =linea{2};
    ptr = [ptr;str2double(linea(3:end))];
end
GMM.id  = id;
GMM.ptr = ptr;
GMM.type = ~strcmp({GMMLIB(ptr(:,1)).type}','pce');

%% READ MAGNITUDE SCALING RELATIONS
str = data(ptrs(6,1):ptrs(6,2),:);
pt  = zeros(Nmscl,2); j=1;
pt(end)=size(str,1);
ms = createObj('mscl');
mscl1 (1:Nmscl,1)= ms;
mscl2 (1:Nmscl,1)= ms;
mscl3 (1:Nmscl,1)= ms;
mscl4 (1:Nmscl,1)= ms;
mscl5 (1:Nmscl,1)= ms;
mscl6 (1:Nmscl,1)= ms;
mscl7 (1:Nmscl,1)= ms;

for i=1:size(str,1)
    if ~isempty(strfind(str{i},'seismicity'))
        pt(j,1)=i+1;
        if j>1
            pt(j-1,2)=i-1;
        end
        j=j+1;
    end
end

for i=1:Nmscl
    stri = str(pt(i,1):pt(i,2));                                                           
    ind1  = contains(stri,'delta');       mscl1(i) = read_mscl1(stri(ind1),'delta');    
    ind2  = contains(stri,'truncexp');    mscl2(i) = read_mscl1(stri(ind2),'truncexp'); 
    ind3  = contains(stri,'truncnorm');   mscl3(i) = read_mscl1(stri(ind3),'truncnorm');
    ind4  = contains(stri,'yc1985');      mscl4(i) = read_mscl1(stri(ind4),'yc1985');   
    ind5  = contains(stri,'magtable');    mscl5(i) = read_mscl2(stri(ind5)); 
    ind6  = contains(stri,'catalog');     mscl6(i) = read_mscl3(stri(ind6)); 
    ind7  = contains(stri,'trexpub');     mscl7(i) = read_mscl1(stri(ind7),'trexpub'); 
end

%% READS SITES
h = createObj('site');
if ~isnan(ptrs(7,1))
    str = data(ptrs(7,1):ptrs(7,2),:);
    
    newline = regexp(str{1},'\ ','split');
    newline(1)=[];
    Nline   = length(newline);
    VS30.baseline = str2double(newline{Nline});
    if Nline>1
        VS30.source   = strrep(newline(1:Nline-1),'''','');
    else
        VS30.source  = {' '};
    end
    str(1)=[];
    
    if contains(str,'.txt')
        str=regexp(str{1},'\ ','split');
        h = ss_readtxtPSHA(str{1},VS30);
    else
        
        for i=1:size(str,1)
            if contains(lower(str{i}),'vs30')
                linea = regexp(str{i},'\s+','split');
                id          = strjoin(linea(1:end-5),' ');
                Lat         = str2double(linea{end-4});
                Lon         = str2double(linea{end-3});
                Elev        = str2double(linea{end-2})/1000;
                VS30_i      = str2double(linea{end});
                h.id{i}  = id;
                h.p(i,:)    = [Lat,Lon,Elev];
                h.VS30(i,1) = VS30_i;
            end
        end
        
        for i=1:size(str,1)
            if ~contains(str{i},'VS30')
                linea = regexp(str{i},'\s+','split');
                id       = strjoin(linea(1:end-3),' ');
                Lat      = str2double(linea{end-2});
                Lon      = str2double(linea{end-1});
                Elev     = str2double(linea{end})/1000;
                h.id{i}  = id;
                h.p(i,:) = [Lat,Lon,Elev];
                h.VS30(i,1) = nan;
            end
        end
    end
    IND = find(isnan(h.VS30));
    if ~isempty(IND)
        h.VS30(IND)=getVs30(h.p(IND,1:2),VS30);
    end
else
    VS30.baseline=760;
    VS30.source  ={' '};
end

%% READS VALIDATION HAZARD CURVES (optional)
do_validation=0;
if ~isnan(ptrs(8,1))
    do_validation=1;
    str     = data(ptrs(8,1):ptrs(8,2),:);
    linea   = regexp(str{1},'\s+','split');
    imtest  = str2double(linea(2:end));
    Nsites  = size(str,1)-1;
    haztest = zeros(Nsites,length(imtest));
    for i=2:Nsites+1
        linea = regexp(str{i},'\s+','split');
        haztest(i-1,:)= str2double(linea(2:end));
    end
end

%% ASSEMBLE SYS
sys.ptrs      = ptrs;
sys.weight    = weight;
sys.branch    = branch;
sys.gmmid     = GMM.id;
sys.gmmptr    = GMM.ptr;
sys.isREG     = find( GMM.type(sys.branch(:,2)))'; %1 for regular models, 0 for pce models
sys.isPCE     = find(~GMM.type(sys.branch(:,2)))'; %1 for regular models, 0 for pce models
sys.src1      = source1; clear source1
sys.src2      = source2; clear source2
sys.src3      = source3; clear source3
sys.src4      = source4; clear source4
sys.src5      = source5; clear source5
sys.src6      = source6; clear source6
sys.src7      = source7; clear source7
sys.mrr1      = mscl1;
sys.mrr2      = mscl2;
sys.mrr3      = mscl3;
sys.mrr4      = mscl4;
sys.mrr5      = mscl5;
sys.mrr6      = mscl6;
sys.mrr7      = mscl7;
sys.gmmlib    = GMMLIB;
sys.VS30      = VS30;
if do_validation
    sys.validation  = [imtest;haztest];
else
    sys.validation  = [];
end

%% PROCESS MODEL
n=max(sys.branch(:,1:3),[],1);
Nsrc = zeros(7,n(1));

for i=1:n(1)
    sys.src1(i)  = process_obj1(sys.src1(i) , opt.ellipsoid); Nsrc(1,i)=size(sys.src1(i).txt,1);
    sys.src2(i)  = process_obj2(sys.src2(i) , opt.ellipsoid); Nsrc(2,i)=size(sys.src2(i).txt,1);
    sys.src3(i)  = process_obj3(sys.src3(i) , opt.ellipsoid); Nsrc(3,i)=size(sys.src3(i).txt,1);
    sys.src4(i)  = process_obj4(sys.src4(i) , opt.ellipsoid); Nsrc(4,i)=size(sys.src4(i).txt,1);
    sys.src5(i)  = process_obj5(sys.src5(i) , opt.ellipsoid); Nsrc(5,i)=size(sys.src5(i).txt,1);
    sys.src6(i)  = process_obj6(sys.src6(i) , opt.ellipsoid); Nsrc(6,i)=size(sys.src6(i).txt,1);
    sys.src7(i)  = process_obj7(sys.src7(i) , opt.ellipsoid); Nsrc(7,i)=size(sys.src7(i).txt,1);
end

% process magnitude recurrence relations
Nmrr = zeros(7,n(3));
for i=1:n(3)
    sys.mrr1(i) = process_delta     (sys.mrr1(i));                    Nmrr(1,i)=size(sys.mrr1(i).source,1);
    sys.mrr2(i) = process_truncexp  (sys.mrr2(i) , opt.MagDiscrete);  Nmrr(2,i)=size(sys.mrr2(i).source,1);
    sys.mrr3(i) = process_truncnorm (sys.mrr3(i) , opt.MagDiscrete);  Nmrr(3,i)=size(sys.mrr3(i).source,1);
    sys.mrr4(i) = process_yc1985    (sys.mrr4(i) , opt.MagDiscrete);  Nmrr(4,i)=size(sys.mrr4(i).source,1);
    sys.mrr5(i) = process_magtable  (sys.mrr5(i));                    Nmrr(5,i)=size(sys.mrr5(i).source,1);
    
    if ~isempty(sys.mrr6.source)
        sys.mrr6(i) = process_catalog   (sys.mrr6(i),sys.src3(i),opt.MagDiscrete);  Nmrr(6,i)=size(sys.mrr6(i).source,1);
    end
    sys.mrr7(i) = process_trexpub (sys.mrr7(i) , opt.MagDiscrete);  Nmrr(7,i)=size(sys.mrr7(i).source,1);
end

%% RETRIEVE LABELS
labelG = cell(1,n(1));
labelM = cell(1,n(3));
numG   = cell(1,n(1));
numM   = cell(1,n(3));

for i=1:n(1)
    labelG{i} = [
        sys.src1(i).txt;
        sys.src2(i).txt;
        sys.src3(i).txt;
        sys.src4(i).txt;
        sys.src5(i).txt;
        sys.src6(i).txt;
        sys.src7(i).txt];
    numG{i}   =[
        ones(Nsrc(1,i),1)*1,(1:Nsrc(1,i))';
        ones(Nsrc(2,i),1)*2,(1:Nsrc(2,i))';
        ones(Nsrc(3,i),1)*3,(1:Nsrc(3,i))';
        ones(Nsrc(4,i),1)*4,(1:Nsrc(4,i))';
        ones(Nsrc(5,i),1)*5,(1:Nsrc(5,i))';
        ones(Nsrc(6,i),1)*6,(1:Nsrc(6,i))';
        ones(Nsrc(7,i),1)*7,(1:Nsrc(7,i))'];
end

for i=1:n(3)
    labelM{i} =[
        sys.mrr1(i).source;
        sys.mrr2(i).source;
        sys.mrr3(i).source;
        sys.mrr4(i).source;
        sys.mrr5(i).source;
        sys.mrr6(i).source];
    numM{i}=[
        ones(Nmrr(1,i),1)*1,(1:Nmrr(1,i))';
        ones(Nmrr(2,i),1)*2,(1:Nmrr(2,i))';
        ones(Nmrr(3,i),1)*3,(1:Nmrr(3,i))';
        ones(Nmrr(4,i),1)*4,(1:Nmrr(4,i))';
        ones(Nmrr(5,i),1)*5,(1:Nmrr(5,i))';
        ones(Nmrr(6,i),1)*6,(1:Nmrr(6,i))'];
end

cgm = cell(n(1),n(3));
for i=1:n(1)
    for j=1:n(3)
        [~,~,cgm{i,j}]=intersect(labelG{i},labelM{j},'stable');
    end
end

mech =cell(1,n(1));
for i=1:n(1)
    mech{i}=[
        sys.src1(i).num(:,1);
        sys.src2(i).num(:,1);
        sys.src3(i).num(:,1);
        sys.src4(i).num(:,1);
        sys.src5(i).num(:,1);
        sys.src6(i).num(:,1);
        sys.src7(i).num(:,1);];
end

% sys.Epistemic = Epistemic;
sys.labelG    = labelG;
sys.labelM    = labelM;
sys.numG      = numG;
sys.numM      = numM;
sys.Nsrc      = Nsrc;
sys.Nmrr      = Nmrr;
sys.cgm       = cgm;
sys.mech      = mech;
sys.txtPSDA   = [];
sys.txtLIBS   = [];

%% EXTRACTS PSDA TEXT
pt = min(ptrs(9:14,1)):max(ptrs(9:14,2));
if ~isnan(pt)
    sys.txtPSDA = data(pt);
end

%% EXTRACTS LIBS TEXT
pt = min(ptrs(21:24,1)):max(ptrs(21:24,2));
if ~isnan(pt)
    sys.txtLIBS = data(pt);
end

