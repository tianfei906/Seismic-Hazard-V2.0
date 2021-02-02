function[SA]=readuserdefinedspec(T,filename)


fid      = fopen(filename);
data     = textscan(fid,'%f %f');
fclose(fid);

To  = data{1}';
SAo = data{2}';
SA  = interp1(To,SAo,T);