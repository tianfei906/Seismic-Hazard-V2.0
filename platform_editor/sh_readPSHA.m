function[sys,opt,h]=sh_readPSHA(filename)


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

% add magnitude recurrence relations from catalogs
[data,catlib] = loadCAT(data);
catlib=[catlib(:,1:2),num2cell(vertcat(catlib{:,3}))];

%% OPTION POINTERS
ptrs  = nan(19,2); % Seismic Hazard Options                   (SeismicHazard)
for i=1:size(data,1)
    if strfind(data{i,1},'Option 0 '), ptrs(1,1)  =i;end % real values
    if strfind(data{i,1},'Option 1 '), ptrs(2,1)  =i;end % Logic tree weights
    if strfind(data{i,1},'Option 2 '), ptrs(3,1)  =i;end % Source Geometry
    if strfind(data{i,1},'Option 3 '), ptrs(4,1)  =i;end % GMM Library
    if strfind(data{i,1},'Option 4 '), ptrs(5,1)  =i;end % GMM Groups
    if strfind(data{i,1},'Option 5 '), ptrs(6,1)  =i;end % Magnitude Recurrence
    if strfind(data{i,1},'Option 6 '), ptrs(7,1)  =i;end % Sites
    if strfind(data{i,1},'Option 7 '), ptrs(8,1)  =i;end % Spatially Distributed Data
    if strfind(data{i,1},'Option 8 '), ptrs(9,1)  =i;end % Validation (optional)
    if strfind(data{i,1},'Option 9 '), ptrs(10,1) =i;end % Event Simulation
    
    % PSDA Options
    if strfind(data{i,1},'Option PSDA 1 '),ptrs(11,1)=i;end % PSDA setup
    if strfind(data{i,1},'Option PSDA 2 '),ptrs(12,1)=i;end % Library of Slope Displacement Models
    if strfind(data{i,1},'Option PSDA 3 '),ptrs(13,1)=i;end % REG Slope Displacement Models
    if strfind(data{i,1},'Option PSDA 4 '),ptrs(14,1)=i;end % PCE Slope Displacement Models
    if strfind(data{i,1},'Option PSDA 5 '),ptrs(15,1)=i;end % PSDA validation
    
    % Liquefaction Induced Settlement (LIS) Options
    if strfind(data{i,1},'Option LIBS 1 '),ptrs(16,1) =i;end % LIBS options
    if strfind(data{i,1},'Option LIBS 2 '),ptrs(17,1) =i;end % Building and Site Specific Parameters
    if strfind(data{i,1},'Option LIBS 3 '),ptrs(18,1) =i;end % Settlement model library
    if strfind(data{i,1},'Option LIBS 4 '),ptrs(19,1) =i;end % Settlement branches
end
ptrs = FindEndPtrs(ptrs,data);

if any(isnan(ptrs(1:5,1)))
    return
end

%% GLOBAL PARAMETERS
str              = data(ptrs(1,1):ptrs(1,2),:);
str              = regexp(str,'\ : ','split');
opt.Projection   = str{1}{2};
switch opt.Projection
    case 'ECEF'
        opt.ae=[];
    otherwise
        ref    = referenceEllipsoid(opt.Projection,'km');
        opt.ae = [ref.SemimajorAxis,ref.Eccentricity];
end
ae = opt.ae;
for i=1:length(str)
    if numel(str{i})==1
        str{i}{2}='';
    end
end

opt.Image        = str{2}{2};
opt.Boundary     = str{3}{2};
opt.ShearModulus = str2double(str{4}{2});
opt.IM           = str2IM(field2str(regexp(str{5}{2},'\s+','split')));

% immode1
if isempty(str{6}{2})
    opt.im = createObj(1,opt.IM);
    opt.immode=1;
end

if ~isempty(str{6}{2})
    userim  = eval(['[',str{6}{2},']'])'; 
    NSample = size(userim,1);
    systim  = createObj(1,opt.IM,NSample);    
    if any((size(userim)==size(systim))==0)
        % incorrect user defined input
        opt.im = createObj(1,opt.IM);
        opt.immode=1;
    else
        opt.im = userim;
        maxdiff = max(abs(userim(:)-systim(:)));
        if max(std(diff(log(userim)),[],1))<1e-7 && maxdiff<1e-7 
            opt.immode=1; % user values are indeed default values
        elseif max(std(diff(log(userim)),[],1))<1e-7 && maxdiff>=1e-7 
            opt.immode=2; % user values are logspaced but not default
        else
            opt.immode=3; % user defined values, not logspaced
        end
    end
end

opt.maxdist  = str2double(str{7}{2});
Mag = regexp(str{8}{2},'\ ','split');
Mag{2}=str2double(Mag{2});
switch Mag{1}
    case 'isampling', opt.msample = [1 Mag{2}];
    case 'gauss'    , opt.msample = [2 Mag{2}];
    case 'uniform'  , opt.msample = [3 Mag{2}];
end

sig = regexp(str{9}{2},'\ ','split');
if isempty(sig{1})
    opt.strunc = [0 1 1 0];
    opt.pd     = makedist('normal');
elseif strcmpi(sig{1},'overwrite')
    std2       = str2double(sig{2});
    opt.strunc = [1 0 std2 0];
    opt.pd     = makedist('normal');
elseif strcmpi(sig{1},'truncate')
    std2       = str2double(sig{2});
    opt.strunc = [2 1 1 0.5*(1-erf(std2/sqrt(2)))];
    opt.pd     = truncate(makedist('normal'),-inf,std2);
end

cgmm             = regexp(str{10}{2},'\ ','split');
opt.PCE          = {cgmm{1},cgmm{2},str2double(cgmm{3})};
opt.IM1          = str2IM(field2str(regexp(str{11}{2},'\s+','split')));
opt.IM2          = str2IM(field2str(regexp(str{12}{2},'\s+','split')));
opt.Spatial      = str2func(strrep(str{13}{2},'@',''));
opt.Spectral     = str2func(strrep(str{14}{2},'@',''));
opt.SourceDeagg  = strcmp(str{15}{2},'on');
aux              = regexp(str{16}{2},'\ ','split');
opt.Clusters     = [strcmp(aux{1},{'on'}),str2double(aux(2:3))];

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
weight  = [weight,ones(N0,1)];
branch  = [branch,ones(N0,1)];
weight  = [weight,prod(weight,2)];
brnames = repmat({''},N0,4); % branchnames, for legends only

%% READS SOURCES
emptysource      = createObj(9.1);
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

source = cell(1,Ngeom);
labelG = cell(1,Ngeom);
numG   = cell(1,Ngeom);
for i=1:Ngeom
    % geom label
    sname = regexp(str{pt(i,1)-1},'\ ','split');
    IND   = branch(:,1)==i;
    if numel(sname)>2
        brnames(IND,1)=repmat({strjoin(sname(3:end),' ')},sum(IND),1);
    else
        brnames(IND,1)=repmat({sprintf('Geom %g',i)},sum(IND),1);
    end
    
    Ns =pt(i,2)-pt(i,1)+1;
    source{i}=cell(Ns,1);
    labelG{i}=cell(Ns,1);
    numG{i}  =zeros(Ns,1);
    stri = str(pt(i,1):pt(i,2));
    stri = strrep(stri,' | ',' ');
    stri = strrep(stri,' interface '       ,' 1 ');
    stri = strrep(stri,' intraslab '       ,' 2 ');
    stri = strrep(stri,' crustal '         ,' 3 ');
    stri = strrep(stri,' background '      ,' 8 ');
    stri = strrep(stri,' strike-slip '     ,' 0 ');
    stri = strrep(stri,' normal '          ,' -90 ');
    stri = strrep(stri,' normal-oblique '  ,' -45 ');
    stri = strrep(stri,' reverse '         ,' 90 ');
    stri = strrep(stri,' reverse-oblique ' ,' 45 ');
    stri = strrep(stri,' null '            ,' 1 ');
    stri = strrep(stri,' wc1994 '          ,' 2 ');
    stri = strrep(stri,' ellsworth '       ,' 3 ');
    stri = strrep(stri,' hanksbakun2001 '  ,' 4 ');
    stri = strrep(stri,' somerville1999 '  ,' 5 ');
    stri = strrep(stri,' wc1994r '         ,' 6 ');
    stri = strrep(stri,' wc1994s '         ,' 7 ');
    stri = strrep(stri,' strasser2010 '    ,' 8 ');
    for j=1:Ns
        if contains(stri{j},'point1');  source{i}{j} = read_point1(stri(j),emptysource);end
        if contains(stri{j},'line1');   source{i}{j} = read_line1(stri(j),emptysource);end
        if contains(stri{j},'area1');   source{i}{j} = read_area1(stri(j),ae,emptysource);end
        if contains(stri{j},'area2');   source{i}{j} = read_area2(stri(j),emptysource);end
        if contains(stri{j},'volume1'); source{i}{j} = read_volume1(stri(j),emptysource);end
        
        source{i}{j}.txt =source{i}{j}.txt{1};
        labelG{i}{j}     =source{i}{j}.txt;
        numG{i}(j)       =source{i}{j}.sourcetype;
        if numG{i}(j)==3.2
            source{i}{j}.adp=source{i}{j}.adp{1};
        end
        
    end
end

%% READS GMPE LIBRRY
str = data(ptrs(4,1):ptrs(4,2),:);
Ngmpe = size(str,1);
GMMLIB(1,1:Ngmpe) = createObj(6);

methods = pshatoolbox_methods(1);
strs    = {methods.str};

for i=1:size(str,1)
    linea = regexp(str{i},'\s+','split');
    GMMLIB(i).txt=linea;
    GMMLIB(i).label=linea{2};
    linea = linea(3:end);
    model  = linea{1};
    [~,cgm]  = intersect(strs,model);
    id = methods(cgm).id;
    GMMLIB(i).id    = id;
    GMMLIB(i).type  = methods(cgm).type;
    GMMLIB(i).handle=methods(cgm).func;
    GMMLIB(i).str   =methods(cgm).str;
    [GMMLIB(i).T,GMMLIB(i).Rmetric]=mGMPE_info(id);
    
    txt = linea(2:end);
    num = str2double(txt);
    isd = ~isnan(num);
    txt(isd)=num2cell(num(isd));
    GMMLIB(i).usp=txt;
end

% PRE-PROCESS CONDITIONAL MODELS
for i=1:length(GMMLIB)
    if GMMLIB(i).type==3 %cond'
        usp = GMMLIB(i).usp;
        condmodel          = GMMLIB(usp{end});        
        id                 = GMMLIB(i).id;
        [~,Rmetric1]       = mGMPE_info(id);
        Rmetric2           = condmodel.Rmetric;
        GMMLIB(i).Rmetric  = or(Rmetric1,Rmetric2);
        GMMLIB(i).cond     = {condmodel.handle,condmodel.id};        
        GMMLIB(i).usp{end} = condmodel.str;
        GMMLIB(i).usp=condmodel.usp;
    end
end

% PRE-PROCESS FRANKY MODELS
for i=1:length(GMMLIB)
    if GMMLIB(i).type==4 %frn'
        usp     = cell2mat(GMMLIB(i).usp);
        Ndepend = length(usp);
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
    
    % branch name
    IND   = branch(:,2)==i;
    brnames(IND,2)=repmat(id(i),sum(IND),1);
    
end
GMM.id  = id;
GMM.ptr = ptr;

%% READ MAGNITUDE SCALING RELATIONS
str = data(ptrs(6,1):ptrs(6,2),:);
pt  = zeros(Nmscl,2); j=1;
pt(end)=size(str,1);
emptyms = createObj(8);

mscl = cell(1,Nmscl);
% numM = cell(1,Nmscl);

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
    sname = regexp(str{pt(i,1)-1},'\ ','split');
    IND   = branch(:,3)==i;
    if numel(sname)>2
        brnames(IND,3)=repmat({strjoin(sname(3:end),' ')},sum(IND),1);
    else
        brnames(IND,3)=repmat({sprintf('Mscl %i',i)},sum(IND),1);
    end
    
    stri = str(pt(i,1):pt(i,2));
    Ns   = diff(pt(i,:))+1;
    mscl{i}=cell(Ns,1);
    for j=1:Ns        
        if contains(stri{j},'delta');         mscl{i}{j} = read_mscl1(stri(j),1,emptyms);end
        if contains(stri{j},'truncexp');      mscl{i}{j} = read_mscl1(stri(j),2,emptyms);end
        if contains(stri{j},'truncnorm');     mscl{i}{j} = read_mscl1(stri(j),3,emptyms);end
        if contains(stri{j},'delyc1985ta');   mscl{i}{j} = read_mscl1(stri(j),4,emptyms);end
    end
end

%% COMPILE BRANCH NAMES
for i=1:N0
    str = brnames(i,1:3);
    str = strjoin(str,',');
    if strcmp(str(1),',')  ,str=str(2:end);  end
    if strcmp(str(end),','),str=str(1:end-1);end
    str = strrep(str,'_',' ');
    brnames{i,4}=str;
end

%% READS SITES
h = createObj(11);
if ~isnan(ptrs(7,1))
    str = data(ptrs(7,1):ptrs(7,2),:);
    newline = regexp(str{1},'\ ','split');
    Nelem   = length(newline);
    if Nelem==1 && contains(newline,'.txt')
        h = ss_readtxtPSHA(newline{1});
    else
        str    = regexp(str,'\ ','split');
        str    = vertcat(str{:});
        h.id   = str(:,1);
        h.p    = str2double(str(:,2:4));
        h.p(:,3)=h.p(:,3)/1000; % elelation must be input in meters a.m.s.l
        str(:,1:4)=[];
        h.param=str(1,1:2:end);
        str(:,1:2:end)=[];
        h.value =str2double(str);
    end
end

%% READ LAYERS
if ~isnan(ptrs(8,1))
    str = data(ptrs(8,1):ptrs(8,2),:);
    Nlayers = size(str,1);
    
    for ii=1:Nlayers
        str_i = regexp(str{ii},'\ ','split');
        dat   = str_i(3:end);
        dat2  = str2double(dat);
        dat(~isnan(dat2))=num2cell(dat2(~isnan(dat2)));
        layer.(str_i{2})=dat(:);
    end
    
    for ii=1:length(h.param)
        fd  =h.param{ii};
        IND = isnan(h.value(:,ii));
        if any(IND)
            h.value(IND,ii)=layerdatainterp(h.p(IND,1:2),layer.(fd),fd);
        end
    end
else
    layer=createObj(12,h.param);
end

%% READS VALIDATION HAZARD CURVES (optional)
do_validation=0;
if ~isnan(ptrs(9,1))
    do_validation=1;
    str     = data(ptrs(9,1):ptrs(9,2),:);
    leg     = cell(numel(str),1);
    linea   = regexp(str{1},'\s+','split');
    leg{1}  = linea{1};
    imtest  = str2double(linea(2:end));
    Nsites  = size(str,1)-1;
    haztest = zeros(Nsites,length(imtest));
    for i=2:Nsites+1
        linea = regexp(str{i},'\s+','split');
        leg{i}=linea{1};
        haztest(i-1,:)= str2double(linea(2:end));
    end
end

%% READS EVENTS
if ~isnan(ptrs(10,1))
    str = data(ptrs(10,1):ptrs(10,2),:);
    str = regexp(str,'\ ','split');
    event = vertcat(str{:});
    event(:,3:6)=num2cell(str2double(event(:,3:6)));
else
    event = cell(0,6);
end

%% ASSEMBLE SYS
sys.ptrs      = ptrs;
sys.weight    = weight;
sys.branch    = branch;
sys.gmmid     = GMM.id;
sys.gmmptr    = GMM.ptr;
Nbranch       = size(branch,1);
sys.isREG     = zeros(1,Nbranch);
sys.isPCE     = zeros(1,Nbranch);
for i=1:Nbranch
    sys.isREG(i)=all(vertcat((GMMLIB(GMM.ptr(1,:)).type))~=5);
    sys.isPCE(i)=all(vertcat((GMMLIB(GMM.ptr(1,:)).type))==5);
end
sys.isREG     = find(sys.isREG);
sys.isPCE     = find(sys.isPCE);
sys.gmmlib    = GMMLIB;
sys.layer     = layer;
sys.validation= [];
sys.validation_legend= [];

if do_validation
    sys.validation        = [imtest;haztest];
    sys.validation_legend = leg;
end

%% PROCESS MODEL
n    = max(sys.branch(:,1:3),[],1);
% process seismic sources
for i=1:n(1)
    Ns = numel(source{i});
    for j=1:Ns
        sourcetype=round(source{i}{j}.sourcetype);
        switch sourcetype
            case 1,   source{i}{j} = process_point1 (source{i}{j}, ae);
            case 2,   source{i}{j} = process_line1  (source{i}{j}, ae);
            case 3,   source{i}{j} = process_area1  (source{i}{j}, ae); 
            case 4,   source{i}{j} = process_area2  (source{i}{j}, ae);
            case 5,   source{i}{j} = process_volume1(source{i}{j}, ae); 
        end
    end
end

sys.source    = source;
sys.mscl    = mscl;

%% SAVE ALL
sys.brnames   = brnames;
sys.labelG    = labelG;
sys.numG      = numG;
sys.catlib    = [brnames(unique(branch(:,3),'rows','stable'),3),catlib];
sys.event     = event;
sys.txtPSDA   = [];
sys.txtLIBS   = [];

%% EXTRACTS PSDA TEXT
pt = min(ptrs(11:15,1)):max(ptrs(11:15,2));
if ~isnan(pt)
    sys.txtPSDA = data(pt);
end

%% EXTRACTS LIBS TEXT
pt = min(ptrs(16:19,1)):max(ptrs(16:19,2));
if ~isnan(pt)
    sys.txtLIBS = data(pt);
end


