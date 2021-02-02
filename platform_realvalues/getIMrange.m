function[]=getIMrange(filename,site_ptr,haz)

[sys,opt,h]=loadPSHA(filename);

Nim = length(opt.IM);
on  = ones(1,Nim);

r1 = ((2*on).^((-10:-1)'));
r2 = ((2*on).^((1:5)'));

im  = [0*on;opt.im(1,:).*r1;opt.im;opt.im(end,:).*r2];

opt.im = im;
MRE = runlogictree1(sys,opt,h,site_ptr);

% retrieves site hazard
MRE = MRE(site_ptr,:,:,:,:);

% contracts sources
MRE = permute(nansum(MRE,4),[2 3 5 1 4]);

% combines logic tree branches
weight = permute(sys.weight(:,end),[2 3 1]);
MRE    = prod(bsxfun(@power,MRE,weight),3);

IM1    = nan(size(on));
IM2    = nan(size(on));
Nmin   = mean(MRE(1,:));

for i=1:Nim
    ind1 = find(abs(MRE(:,i)-Nmin)<1e-2);
    ind1 = ind1(end);
    IM1(i)=im(ind1,i);
    
    xx = MRE(:,i);
    yy = im(:,i);
    jnd = and(xx<0.1*Nmin,xx>0);
    xx = xx(jnd);
    yy = yy(jnd);
    IM2(i)=robustinterp(xx,yy,haz,'loglog');
end

IM1
IM2
