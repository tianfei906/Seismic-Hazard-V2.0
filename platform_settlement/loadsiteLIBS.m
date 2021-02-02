function[param]=loadsiteLIBS(filename,pypath)

fid  = fopen(filename);
if fid==-1
    return
end
data = textscan(fid,'%s','delimiter','\n');
data = data{1};
fclose(fid);

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
param = createObj('LIBSsite');
B     = regexp(data{1} ,'\:','split'); param.B     = str2double(B{2});
L     = regexp(data{2} ,'\:','split'); param.L     = str2double(L{2});
Df    = regexp(data{3} ,'\:','split'); param.Df    = str2double(Df{2});
Q     = regexp(data{4} ,'\:','split'); param.Q     = eval(['[',Q{2},']']);
type  = regexp(data{5} ,'\:','split'); param.type  = strtrim(type{2});
wt    = regexp(data{6} ,'\:','split'); param.wt    = str2double(wt{2});

cptdata = regexp(data(8:end,:),'\ ','split');
cptdata = str2double(vertcat(cptdata{:}));
cptCSV  = cptdata;

cptdata(:,3)=cptdata(:,3)/1000;
cptdata(:,4)=cptdata(:,4)/1000;
param.Data  = cptdata;
param.CPT   = interpretCPT_4(cptdata,param.wt,param.Df);

%% computes layering
p  = cd;
p2 = what('CPTLAYERSV2');
cd(p2.path)
csvwrite(fullfile(p2.path,'testdata.csv'),cptCSV);
python_path = strrep(pypath,'\','/');
csvpath  = ['"',fullfile(p2.path,'testdata.csv'),'"'];
csvpath  = strrep(csvpath,'\','/');

% res      = CPT_API(python_path,csvpath);
res       = readtable('total_boundary.csv');
res       = [0;res.allboundary;param.Data(end,1)];
param.LAY = cpt2layer(param,res);
% res
cd(p);
% unit conversion

%% PRECOMPUTE LBS AND HL
[M,PGA]=meshgrid(4:0.2:9,logsp(0.01,3,27));
[Ni,Nj]=size(M);
LBS1 = zeros(Ni,Nj);
HL1  = zeros(Ni,Nj);
LBS2 = zeros(Ni,Nj);
HL2  = zeros(Ni,Nj);

for i=1:Ni
        BI14 = cptBI14(param.CPT,param.wt, param.Df,M(i,:),PGA(i,:));
        R15  = cptR15 (param.CPT,param.wt, param.Df,M(i,:),PGA(i,:));
        LBS1(i,:)=BI14.LBS;
        LBS2(i,:)=R15.LBS;
        HL1 (i,:)=BI14.HL;
        HL2 (i,:)=R15.HL;
end

param.LBS1 = scatteredInterpolant(M(:),PGA(:),LBS1(:),'linear','nearest');
param.LBS2 = scatteredInterpolant(M(:),PGA(:),LBS2(:),'linear','nearest');
param.HL1  = scatteredInterpolant(M(:),PGA(:),HL1(:) ,'linear','nearest');
param.HL2  = scatteredInterpolant(M(:),PGA(:),HL2(:) ,'linear','nearest');

