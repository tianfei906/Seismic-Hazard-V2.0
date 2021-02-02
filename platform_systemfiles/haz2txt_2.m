function[]=haz2txt_2(FileName,PathName,WEIGHT,MRE,opt,h)

if isempty(MRE)
    return
end
[~,B]=intersect(h.param,'VS30');
id     = h.id;
p      = h.p;
VS30   = h.value(:,B);
im     = opt.im';
Nsites = size(p,1);

FNAME = [PathName,FileName];
fileID = fopen(FNAME,'w');
NIM = length(opt.IM);

str   = IM2str(opt.IM);
Le = 0;
for i=1:length(str)
    Le = max(Le,1+length(str{i}));
end
% Le    = num2str(Le);
fprintf(fileID,' ------ Seismic Hazard Analysis ------\n');
fprintf(fileID,' Number of Sites   : %g\n',Nsites);
fprintf(fileID,' Hazard Points     : %g\n',length(im));
fprintf(fileID,' Max. Distance     : %g km\n',opt.MaxDistance);
fprintf(fileID,' ---------------------------------------\n');
fprintf(fileID,' \n');

text2 = repmat(' %-10.4g',1,NIM);
text3 = '';
for i=1:NIM
    text3=[text3,sprintf('%-11s',str{i})]; %#ok<AGROW>
end

for site=1:Nsites
    LAMBDA  = nansum(MRE(site,:,:,:,:),4);
    LAMBDA  = permute(LAMBDA,[5,2,3,1,4]);
    lambda0 = prod(bsxfun(@power,LAMBDA,WEIGHT(:)),1);
    lambda0 = permute(lambda0,[3,2,1]);
    
    Tr = [100;250;475;949;2475;5000;10000;100000];
    nTr = length(Tr);
    nIM = size(lambda0,1);
    SAT = zeros(nTr,nIM);
    for ii=1:nIM
        SAT(:,ii)=robustinterp(lambda0(ii,:),im(ii,:),1./Tr,'loglog');
    end
    
    fprintf(fileID,'Site : %d \n',site);
    fprintf(fileID,'ID   : %s \n',id{site});
    if opt.ellipsoid.Code==0
        fprintf(fileID,'X(km): %6.4f\n',p(site,2));
        fprintf(fileID,'Y(km): %6.4f\n',p(site,1));
    else
        fprintf(fileID,'Lat  : %6.4f°\n',p(site,1));
        fprintf(fileID,'Lon  : %6.4f°\n',p(site,2));
        fprintf(fileID,'VS30 : %6.4g m/s \n',VS30(site));
    end
    fprintf(fileID,['Tr(yr)  ',text3,'\n']);
    fprintf(fileID,['%-7.8g',text2,'\n'],[Tr,SAT]');
    fprintf(fileID,' \n');
end
fclose(fileID);
if ispc,winopen(FNAME);end