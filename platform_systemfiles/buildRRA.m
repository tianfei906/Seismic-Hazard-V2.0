function[radio,err]=buildRRA(hypm,aream,C,RA)

aream  = aream(:);
Nc     = size(C,1);

% search radius
err    = zeros(Nc,1);
rmin   = min(1,0.5*sqrt(min(aream)));
radio  = rmin*ones(Nc,1);

if RA==0
    return
end

rtest  = linspace(rmin,1500,500)';
r2     = rtest.^2;
for i=1:Nc
    RAtest = inf(500,1);
    Ci     = C(i,:);
    d2s    = sum((hypm-Ci).^2,2);
    for j=1:500
        IND      = d2s<r2(j);
        RAtest(j)= sum(aream.*IND);
        if RAtest(j)>RA
            break
        end
    end
    k = max(1,j-1);
    radio(i)=rtest(k);
    err(i)  =abs(1-RAtest(k)/RA)*100;
end


