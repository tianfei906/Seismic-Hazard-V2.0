function [y]=robustinterp(X,Y,x,style)

ind = or(isnan(X+Y),isinf(X+Y));
X(ind)=[];
Y(ind)=[];

[Xu,ind]= unique(round(1e6*X)/1e6,'stable');
Yu      = Y(ind);

switch style
    case 'loglog'
        zer=find(or(Xu==0,Yu==0));
        Xu(zer)=[];
        Yu(zer)=[];
        y = exp(interp1(log(Xu),log(Yu),log(x),'pchip'));
        
    case 'linearlog'
        zer=find(or(Xu==0,Yu==0));
        Xu(zer)=[];
        Yu(zer)=[];
        y = exp(interp1(Xu,log(Yu),x,'pchip'));        
        
    case 'linear'
        if numel(Xu)==1
            y = NaN;
        else
            y = interp1(Xu,Yu,x);
        end
end
