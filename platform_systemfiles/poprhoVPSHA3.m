
methods = handles.methods;
[~,ind] = intersect({methods.label},handles.popcorrelation.String{handles.popcorrelation.Value});

if isempty(ind)
    return
end

fun = methods(ind).func;
param.opp = 0; %
param.mechanism = 'interface';
param.direction = 'horizontal';
param.residual  = 'phi';
param.M         = 7;

rho   = zeros(3,3);
IMptr = [handles.popIM1.Value;handles.popIM2.Value;handles.popIM3.Value];
IM    = handles.opt.IM(IMptr);
for i=1:3
    for j=1:3
        rho(i,j) = fun(IM(i),IM(j),param);
    end
end
handles.uitable1.Data= rho;