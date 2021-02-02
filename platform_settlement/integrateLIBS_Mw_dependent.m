function hd=integrateLIBS_Mw_dependent(fun,d,param,Sa,deagg)

lambda = zeros(size(deagg));
for i=1:length(deagg)
    lambda(i)=nansum(deagg{i}(:,3));
end

Mlist = vertcat(deagg{:});
Mlist = unique(Mlist(:,1));

if numel(Mlist)>1
    applyCorr = false;
    [Sa,Mag,deriv,Deag]=PSHA2PSDA(deagg,Sa,lambda,applyCorr);
    Nrm       = size(Mag,1);
    Nim       = size(Sa ,2);
    roc       = repmat(deriv,Nrm,1);
    Sa        = repmat(Sa,Nrm,1);
    M         = repmat(Mag,1,Nim);
    Nd        = length(d);
    hd        = zeros(1,Nd);
    for i=1:Nd
        di      = d(i);
        PD      = fun(param,Sa,M,di,'ccdf');
        dlambda = nansum((roc.*PD).*(Deag/100),2);
        hd(i)   = sum(dlambda(:));
    end
    
else
    Nrm = size(deagg{1},1);
    Nim = size(deagg,1);
    lambdaSa  = zeros(Nrm,Nim);
    for i=1:Nim
        lambdaSa(:,i)=deagg{i}(:,3);
    end
    Sa   = repmat(Sa(:)',Nrm,1);
    M    = repmat(deagg{1}(:,1),1,Nim);
    Nd      = length(d);
    hd = zeros(1,Nd);
    for i=1:Nd
        di      = d(i);
        PD      = fun(param,Sa,M,di,'ccdf');
        rateD   = diff(-lambdaSa,1,2).*(PD(:,1:end-1)+PD(:,2:end))/2;
        dlambda = sum(rateD,2);
        hd(i)   = sum(dlambda);
    end
end
