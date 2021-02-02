function[accm]=rspmatch(T,Q,dt,acc,data,xi)

% input:
% T,Q = target response spectrum (Sa in g')
% time,acc = source acceleration time history (acc in g')
%
% output
% accm  = modified acceleration time history

%% Deletes existing files
FILENAMES={'Run0.tgt','Run0.acc','all.inp','temp.inp',...
    'Run1.inp','Run2.inp','Run3.inp','Run4.inp',...
    'Run1.acc','Run2.acc','Run3.acc','Run4.acc',...
    'Run1.rsp','Run2.rsp','Run3.rsp','Run4.rsp',...
    'Run1.unm','Run2.unm','Run3.unm','Run4.unm'};

for i=1:length(FILENAMES)
    if exist(FILENAMES{i},'file')
        delete(FILENAMES{i});
    end
end

%% TARGET SPECTRUM
Npoints = length(T);
fid = fopen(FILENAMES{1},'wt');
fprintf(fid,'Target Spectrum\n');
fprintf(fid,'%d 1\n',Npoints);
fprintf(fid,'%f\n',xi);
f = 1./flipud(T(:))';
z = zeros(1,Npoints);
t = z+1000;
Q = flipud(Q(:))';
fprintf(fid,'%f %d %d %f\n',[f;z;t;Q]);
fclose(fid);

%% ACCELERATION SEED FILE
Npoints = length(acc);
fid = fopen(FILENAMES{2},'wt');
fprintf(fid,'Seed acceleration File\n');
fprintf(fid,' %d    %g 0\n',[Npoints,dt]);
rm5   = mod(Npoints,5);
Line3 = reshape(acc(1:end-rm5),5,(Npoints-rm5)/5);
Line4 = acc(end-rm5+1:end);
fprintf(fid,'  %13.5e  %13.5e  %13.5e  %13.5e  %13.5e\n',Line3);
if rm5>0
    fprintf(fid,['  ',repmat('%13.5e  ',1,rm5),'\n'],Line4);
end

fclose(fid);

%% CREATE RSPM09 INPUT FILES
Nrun = 0;
for j=2:size(data,2)
    if ~isempty(data{1,j})
        Nrun=Nrun+1;
    end
end

for i=1:Nrun
    fname = ['Run',num2str(i),'.inp'];
    fid = fopen(fname, 'wt');
    for k=1:16
        fprintf(fid,'%s\n',data{k,i+1});
    end
    fprintf(fid,'%s\n','Run0.tgt');
    fprintf(fid,'%s\n',['Run',num2str(i-1),'.acc']);
    fprintf(fid,'%s\n',['Run',num2str(i),'.acc']);
    fprintf(fid,'%s\n',['Run',num2str(i),'.rsp']);
    fprintf(fid,'%s\n',['Run',num2str(i),'.unm']);
    fclose(fid);
end

fname = 'all.inp';
fid = fopen(fname, 'wt');
fprintf(fid,'%s\n',[num2str(Nrun),'     ! Total number of passes']);
for i=1:Nrun
    fprintf(fid,'%s\n',['Run',num2str(i),'.inp']);
end
fclose(fid);

fname = 'temp.inp';
fid = fopen(fname, 'wt');
fprintf(fid,'all.inp');
fclose(fid);
system(['rspm09.exe<' 'temp.inp']);

%% COMPILE DATA
fid = fopen(['Run',num2str(Nrun),'.acc'], 'r');
fgetl(fid);
L2=textscan(fid,'%f%f%f',1);
L3=textscan(fid,'%f%f%f%f%f');
Np   = L2{1};
accm  = cell2mat(L3)';
accm  = accm(1:Np);
pad  = L2{3};
accm(1:pad)=[];
fclose(fid);

for i=1:length(FILENAMES)
    if exist(FILENAMES{i},'file')
        delete(FILENAMES{i});
    end
end
