function[]=haz2txt_3(FileName,MRE,WEIGHT,opt,h,idx)

MRE     = nansum(MRE,4); % contracts sources
MRE     = permute(MRE,[1 2 5 3 4]);
WEIGHT  = permute(WEIGHT,[2 3 1]);
MRE     = prod(bsxfun(@power,MRE,WEIGHT),3);

if isempty(MRE)
    return
end

if isempty(idx) % no site clusters
    Nsites = size(MRE,1);
    fileID = fopen(FileName,'w');
    im  = opt.im';
    PGA = nan(Nsites,1);
    for i=1:Nsites
        PGA(i)=robustinterp(MRE(i,:),im,1/475,'loglog');
    end
    fprintf(fileID,'%g\n',PGA);
    fclose(fileID);
    
else % with site clustes
    Nsites = length(idx);
    fileID = fopen(FileName,'w');
    im  = opt.im';
    PGA = nan(Nsites,1);
    for i=1:Nsites
        ii = idx(i);
        PGA(i)=robustinterp(MRE(ii,:),im,1/475,'loglog');
    end
    fprintf(fileID,'%g\n',PGA);
    fclose(fileID);
end