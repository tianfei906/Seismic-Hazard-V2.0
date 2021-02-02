function [lnDs,sigDs] = pseudoProbaBMDs(param,im3,M,method)
Q       = param.Q;
B       = param.B;

CAVdp   = im3(:,1)/980.66;  % cm/s to g*sec
PGA     = im3(:,2);
Sa1     = im3(:,3);

switch method
    case 'BI14'
        BI14    = cptBI14(param.CPT,param.wt,param.Df,M, PGA);
        LBS     = BI14.LBS;
        HL      = BI14.HL;
    case 'R15'
        R15     = cptR15(param.CPT,param.wt,param.Df,M, PGA);
        LBS     = R15.LBS;
        HL      = R15.HL;
end

HL    = max(HL,0.1);
sigDs = 0.50;
lnDs  = -8.35+4.59*log(Q)-0.42*(log(Q))^2+0.072*LBS+0.58*log(tanh(HL/6))-0.02*B+0.84*log(CAVdp)+0.41*log(Sa1);
ind   = LBS>16;
lnDs(ind) = -7.48+4.59*log(Q)-0.42*(log(Q))^2+0.014*LBS(ind)+0.58*log(tanh(HL(ind)/6))-0.02*B+0.84*log(CAVdp(ind))+0.41*log(Sa1(ind));

