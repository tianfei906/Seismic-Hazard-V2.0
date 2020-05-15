 function[v]=compute_v(fig,opt,MapOptions,MRE,weights)
im       = opt.im;
ax1      = findall(fig,'atag','ax1');
% switch opt.SourceDeagg
%     case 'off', LiteMode = 0;
%     case 'on',  LiteMode = 1;
% end

switch MapOptions.mod
    case 1 %weithed average of hazard
     
        if MapOptions.avg(1)==1 % default weights
            weights = permute(weights(:),[5,4,3,2,1]);
            lambda  = prod(bsxfun(@power,MRE,weights),5);
        end
        
        if MapOptions.avg(2)==1
            weights = permute(MapOptions.rnd(:),[5,4,3,2,1]);
            lambda  = prod(bsxfun(@power,MRE,weights),5);
        end
        
        if MapOptions.avg(3)==1
            Per      = MapOptions.avg(4);
            lambda   = prctile(MRE,Per,5);
        end
        
    case 2 %single branch
        ptr      = MapOptions.sbh(1);
        lambda   = MRE(:,:,:,:,ptr);
end

pall={'parula','autumn','bone','colorcube','cool','copper','flag','gray','hot','hsv','jet','lines','pink','prism','spring','summer','white','winter'};
pallet = pall{MapOptions.map(2)};
set(fig,'colormap',feval(pallet));
hazard   = 1/MapOptions.map(1);
logh     = log(hazard);
logHIM   = log(lambda);

text(NaN,NaN,'','parent',ax1,'Tag','satext');
% interpolation oh hazard curves
Nsites = size(MRE,1);
v      = zeros(Nsites,1);
for j=1:Nsites
    xxx =logHIM(j,:);
    im0  = im(~isinf(xxx));
    x0  = xxx(~isinf(xxx))';
    if any([min(xxx)<logh,max(xxx)>logh,length(unique(xxx))>2]==0)
        v(j)  = 0;
    else
        v(j)  = robustinterp(x0,im0,logh,'linear');
    end
end

