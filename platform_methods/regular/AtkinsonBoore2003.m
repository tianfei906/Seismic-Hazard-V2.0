function[lny,sigma,tau,phi]=AtkinsonBoore2003(To,M,Rrup,Zhyp,media,mechanism,region,adjfun)

% Syntax : AtkinsonBoore2003 mechanism region                               

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[0 1/0.33],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end


if isnumeric(media)
    if  media<180                       ,media='nehrpe';
    elseif and(180<=media,media<=360)   ,media='nehrpd';
    elseif and(360< media,media<=760)   ,media='nehrpc';
    elseif 760<media                    ,media='nehrpb';
    end
end

To      = max(To,0.01); %PGA is associated to To=0.01;
period  = [0.01 0.04 0.1 0.2 0.4 1 2 1/0.33];
T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

if T_lo==T_hi
    [log10y,sigma,tau,phi] = gmpe(index,M,Rrup,Zhyp,media,mechanism,region);
else
    [log10y_lo,sigma_lo,tau_lo] = gmpe(index,  M,Rrup,Zhyp,media,mechanism,region);
    [log10y_hi,sigma_hi,tau_hi] = gmpe(index+1,M,Rrup,Zhyp,media,mechanism,region);
    x          = log([T_lo;T_hi]);
    Y_sa       = [log10y_lo,log10y_hi]';
    Y_sigma    = [sigma_lo,sigma_hi]';
    Y_tau      = [tau_lo,tau_hi]';
    log10y     = interp1(x,Y_sa,log(To))';
    sigma      = interp1(x,Y_sigma,log(To))';
    tau        = interp1(x,Y_tau,log(To))';
    phi        = sqrt(sigma.^2-tau.^2);
end

% log base change
lny   = log10y * log(10);
sigma = sigma  * log(10);
tau   = tau    * log(10);
phi   = phi    * log(10);

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end


function[log10y,sigma,tau,phi]=gmpe(index,M,rrup,h,media,mechanism,region)

%% PGAROCK, sl,SC,SD,SE
period  = [0.01 0.04 0.1 0.2 0.4 1 2 1/0.33];
To = period(index);
f  = 1/(max(To,1e-6));
h  = min(h,100);

switch mechanism
    case 'interface'
        M   = min(M,8.5);
        g   = 10.^(1.2-0.18*M);
        C   = [  2.991      0.03525 0.00759 -0.00206 0.19 0.24 0.29 0.23 0.20    0.11];
    case 'intraslab'
        M   = min(M,8.0);
        g   = 10.^(0.301-0.01*M);
        C   = [ -0.04713 0.6909 0.0113 -0.00202 0.19 0.24 0.29 0.27 0.23 0.14];
end

Delta = 0.00724*10.^(0.507*M);
R     = sqrt(rrup.^2+Delta.^2);
PGArx = 10.^(C(1)+C(2)*M + C(3)*h+ C(4)*R - g.*log10(R));
sl    = zeros(length(PGArx),1);
freq  = f * ones(length(PGArx),1);

ind1 = or(PGArx<=100,freq<=1);
ind2 = and(and(100<PGArx,PGArx<500),and(1<freq,freq<2));
ind3 = and(PGArx>=500,and(1<freq,freq<2));
ind4 = and(and(100<PGArx,PGArx<500),freq>=2);
ind5 = and(PGArx>=500,freq>=2);

sl(ind1) = 1;
sl(ind2) = 1-(freq(ind2)-1).*(PGArx(ind2)-100)/400;
sl(ind3) = 1-(freq(ind3)-1);
sl(ind4) = 1-(PGArx(ind4)-100)/400;
sl(ind5) = 0;

switch media
    case 'nehrpb', SC=0;SD=0;SE=0;
    case 'nehrpc', SC=1;SD=0;SE=0;
    case 'nehrpd', SC=0;SD=1;SE=0;
    case 'nehrpe', SC=0;SD=0;SE=1;
end

%%
switch [mechanism,region]
    case 'interfacegeneral'
        DATA = [
            2.9910    0.03525  0.00759 -0.00206  0.19  0.24  0.29  0.23  0.20  0.11  0.24
            2.8753    0.07052  0.01004 -0.00278  0.15  0.20  0.20  0.26  0.22  0.14  0.26
            2.7789    0.09841  0.00974 -0.00287  0.15  0.23  0.20  0.27  0.25  0.10  0.30
            2.6638    0.12386  0.00884 -0.00280  0.15  0.27  0.25  0.28  0.25  0.13  0.28
            2.5249    0.14770  0.00728 -0.00235  0.13  0.37  0.38  0.29  0.25  0.15  0.26
            2.1442    0.13450  0.00521 -0.00110  0.10  0.30  0.55  0.34  0.28  0.19  0.31
            2.1907    0.07148  0.00224  0.00000  0.10  0.25  0.40  0.34  0.29  0.18  0.33
            2.3010    0.02237  0.00012  0.00000  0.10  0.25  0.36  0.36  0.31  0.18  0.36];
        
    case 'intraslabgeneral'
        DATA=[
            -0.047130  0.69090  0.01130  -0.00202  0.19 0.24  0.29 0.27  0.23  0.14  0.23
            0.506970  0.63273  0.01275  -0.00234  0.15 0.20  0.20 0.25  0.24  0.07  0.23
            0.439280  0.66675  0.01080  -0.00219  0.15 0.23  0.20 0.28  0.27  0.07  0.25
            0.515890  0.69186  0.00572  -0.00192  0.15 0.27  0.25 0.28  0.26  0.10  0.23
            0.005445  0.77270  0.00173  -0.00178  0.13 0.37  0.38 0.28  0.26  0.10  0.26
            -1.021330  0.87890  0.00130  -0.00173  0.10 0.30  0.55 0.29  0.27  0.11  0.25
            -2.392340  0.99640  0.00364  -0.00118  0.10 0.25  0.40 0.30  0.28  0.11  0.23
            -3.700120  1.11690  0.00615  -0.00045  0.10 0.25  0.36 0.30  0.29  0.08  0.23];
        
    case 'interfacecascadia'
        DATA = [
            2.79      0.03525  0.00759 -0.00206  0.19  0.24  0.29  0.23  0.20  0.11  0.24
            2.60      0.07052  0.01004 -0.00278  0.15  0.20  0.20  0.26  0.22  0.14  0.26
            2.50      0.09841  0.00974 -0.00287  0.15  0.23  0.20  0.27  0.25  0.10  0.30
            2.54      0.12386  0.00884 -0.00280  0.15  0.27  0.25  0.28  0.25  0.13  0.28
            2.50      0.14770  0.00728 -0.00235  0.13  0.37  0.38  0.29  0.25  0.15  0.26
            2.18      0.13450  0.00521 -0.00110  0.10  0.30  0.55  0.34  0.28  0.19  0.31
            2.33      0.07148  0.00224  0.00000  0.10  0.25  0.40  0.34  0.29  0.18  0.33
            2.36      0.02237  0.00012  0.00000  0.10  0.25  0.36  0.36  0.31  0.18  0.36];
        
    case 'intraslabcascadia'
        DATA=[
            -0.25      0.69090  0.01130  -0.00202  0.19 0.24  0.29 0.27  0.23  0.14  0.23
            0.23      0.63273  0.01275  -0.00234  0.15 0.20  0.20 0.25  0.24  0.07  0.23
            0.16      0.66675  0.01080  -0.00219  0.15 0.23  0.20 0.28  0.27  0.07  0.25
            0.40      0.69186  0.00572  -0.00192  0.15 0.27  0.25 0.28  0.26  0.10  0.23
            -0.01      0.77270  0.00173  -0.00178  0.13 0.37  0.38 0.28  0.26  0.10  0.26
            -0.98      0.87890  0.00130  -0.00173  0.10 0.30  0.55 0.29  0.27  0.11  0.25
            -2.25      0.99640  0.00364  -0.00118  0.10 0.25  0.40 0.30  0.28  0.11  0.23
            -3.64      1.11690  0.00615  -0.00045  0.10 0.25  0.36 0.30  0.29  0.08  0.23];
        
    case 'interfacejapan'
        DATA = [
            3.14      0.03525  0.00759 -0.00206  0.19  0.24  0.29  0.23  0.20  0.11  0.24
            3.05      0.07052  0.01004 -0.00278  0.15  0.20  0.20  0.26  0.22  0.14  0.26
            2.95      0.09841  0.00974 -0.00287  0.15  0.23  0.20  0.27  0.25  0.10  0.30
            2.84      0.12386  0.00884 -0.00280  0.15  0.27  0.25  0.28  0.25  0.13  0.28
            2.58      0.14770  0.00728 -0.00235  0.13  0.37  0.38  0.29  0.25  0.15  0.26
            2.18      0.13450  0.00521 -0.00110  0.10  0.30  0.55  0.34  0.28  0.19  0.31
            2.14      0.07148  0.00224  0.00000  0.10  0.25  0.40  0.34  0.29  0.18  0.33
            2.27      0.02237  0.00012  0.00000  0.10  0.25  0.36  0.36  0.31  0.18  0.36];
        
    case 'intraslabjapan'
        DATA=[
            0.10      0.69090  0.01130  -0.00202  0.19 0.24  0.29 0.27  0.23  0.14  0.23
            0.68      0.63273  0.01275  -0.00234  0.15 0.20  0.20 0.25  0.24  0.07  0.23
            0.61      0.66675  0.01080  -0.00219  0.15 0.23  0.20 0.28  0.27  0.07  0.25
            0.70      0.69186  0.00572  -0.00192  0.15 0.27  0.25 0.28  0.26  0.10  0.23
            0.07      0.77270  0.00173  -0.00178  0.13 0.37  0.38 0.28  0.26  0.10  0.26
            -0.98      0.87890  0.00130  -0.00173  0.10 0.30  0.55 0.29  0.27  0.11  0.25
            -2.44      0.99640  0.00364  -0.00118  0.10 0.25  0.40 0.30  0.28  0.11  0.23
            -3.73      1.11690  0.00615  -0.00045  0.10 0.25  0.36 0.30  0.29  0.08  0.23];
end

switch mechanism
    case 'interface', IND = and(M>=7.5,rrup<300);
    case 'intraslab', IND = and(M>=6.5,rrup<100);
end
C   = DATA(index,:);
s1  = C(9);
s2  = C(10);
s22 = C(11);
sigma = M*0;
sigma(~IND) = sqrt(s1^2 + s2^2);
sigma( IND) = sqrt(s1^2 + s22^2);
tau    = s1*ones(size(M));
phi    = sqrt(sigma.^2-tau.^2);
log10y = C(1)+C(2)*M + C(3)*h+ C(4)*R - g.*log10(R) + C(5)*sl*SC+C(6)*sl*SD+C(7)*sl*SE;

