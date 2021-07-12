function[lny,sigma,tau,phi]=Sadigh1997(To,M,Rrup,media,SOF,adjfun)
% Syntax : Sadigh1997 SOF                                                   

% Sadigh, K., Chang, C. Y., Egan, J. A., Makdisi, F., & Youngs, R. R.
% (1997). Attenuation relationships for shallow crustal earthquakes
% based on California strong motion data. Seismological research letters,
% 68(1), 180-189.

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[0 4],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end


if isnumeric(media)
    if media<760 , media='deepsoil';
    else         , media='rock';
    end
end

To      = max(To,0.02); %PGA is associated to To=0.02;
period  = [0.02 0.075 0.10 0.20 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00 4.00];
T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

if T_lo==T_hi
    [lny,sigma] = gmpe(index,M,Rrup,SOF,media);
else
    [lny_lo,sigma_lo] = gmpe(index,  M,Rrup,SOF,media);
    [lny_hi,sigma_hi] = gmpe(index+1,M,Rrup,SOF,media);
    x          = log([T_lo;T_hi]);
    Y_sa       = [lny_lo,lny_hi]';
    Y_sigma    = [sigma_lo,sigma_hi]';
    lny        = interp1(x,Y_sa,log(To))';
    sigma      = interp1(x,Y_sigma,log(To))';
end

tau   = nan(size(M));
phi   = nan(size(M));

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end

function[lny,sigma]=gmpe(index,M,Rrup,SOF,media)

switch lower(media)
    case 'rock'
        
        switch lower(SOF)
            case 'strike-slip'     , amp = 1.0;
            case 'normal'          , amp = nan; %error('Normal mechanism not defined in Sadigh et al. 1997')
            case 'normal-oblique'  , amp = nan; %error('Normal mechanism not defined in Sadigh et al. 1997')
            case 'reverse'         , amp = 1.2;
            case 'reverse-oblique' , amp = 1.2;
            case 'unspecified'     , amp = 1.0;
        end
        
        % REGRESSION FOR M<=6.5
        DATA = [-0.624 1.0 0.000 -2.100 1.29649 0.250 0.0
            0.110 1.0 0.006 -2.128 1.29649 0.250 -0.082
            0.275 1.0 0.006 -2.148 1.29649 0.250 -0.041
            0.153 1.0 -0.004 -2.080 1.29649 0.250 0.0
            -0.057 1.0 -0.017 -2.028 1.29649 0.250 0.0
            -0.298 1.0 -0.028 -1.990 1.29649 0.250 0.0
            -0.588 1.0 -0.040 -1.945 1.29649 0.250 0.0
            -1.208 1.0 -0.050 -1.865 1.29649 0.250 0.0
            -1.705 1.0 -0.055 -1.800 1.29649 0.250 0.0
            -2.407 1.0 -0.065 -1.725 1.29649 0.250 0.0
            -2.945 1.0 -0.070 -1.670 1.29649 0.250 0.0
            -3.700 1.0 -0.080 -1.610 1.29649 0.250 0.0
            -4.230 1.0 -0.100 -1.570 1.29649 0.250 0.0];
        
        C    = DATA(index,:);
        lny1 = C(1)+C(2)*M+C(3)*(8.5-M).^2.5+C(4)*log(Rrup+exp(C(5)+C(6)*M))+C(7)*log(Rrup+2);
        
        % REGRESSION FOR M>6.5
        DATA = [-1.274 1.1 0.000 -2.100 -0.48451 0.524 0.0
            -0.540 1.1 0.006 -2.128 -0.48451 0.524 -0.082
            -0.375 1.1 0.006 -2.148 -0.48451 0.524 -0.041
            -0.497 1.1 -0.004 -2.080 -0.48451 0.524 0.0
            -0.707 1.1 -0.017 -2.028 -0.48451 0.524 0.0
            -0.948 1.1 -0.028 -1.990 -0.48451 0.524 0.0
            -1.238 1.1 -0.040 -1.945 -0.48451 0.524 0.0
            -1.858 1.1 -0.050 -1.865 -0.48451 0.524 0.0
            -2.355 1.1 -0.055 -1.800 -0.48451 0.524 0.0
            -3.057 1.1 -0.065 -1.725 -0.48451 0.524 0.0
            -3.595 1.1 -0.070 -1.670 -0.48451 0.524 0.0
            -4.350 1.1 -0.080 -1.610 -0.48451 0.524 0.0
            -4.880 1.1 -0.100 -1.570 -0.48451 0.524 0.0];
        
        C    = DATA(index,:);
        lny2 = C(1)+C(2)*M+C(3)*(8.5-M) .^2.5+C(4)*log(Rrup+exp(C(5)+C(6)*M))+C(7)*log(Rrup+2);
        
        % FINAL REGRESSION
        lny = zeros(size(M));
        lny(M<=6.5)=log(amp)+lny1(M<=6.5);
        lny(M> 6.5)=log(amp)+lny2(M> 6.5);
        
        DATA = [1.39 0.14 0.38 7.21
                1.4     0.14 0.39 7.21
                1.41 0.14 0.40 7.21
                1.43 0.14 0.42 7.21
                1.45 0.14 0.44 7.21
                1.48 0.14 0.47 7.21
                1.5     0.14 0.49 7.21
                1.52 0.14 0.51 7.21
                1.53 0.14 0.52 7.21
                1.53 0.14 0.52 7.21
                1.53 0.14 0.52 7.21
                1.53 0.14 0.52 7.21
                1.53 0.14 0.52 7.21];
        
        C    = DATA(index,:);
        sigma = C(1)-C(2)*M;
        sigma(M>=C(4))=C(3);
        
    case 'deepsoil'
        DATA =[0.0 0.0 0.000 1.52 0.16
            0.4572 0.4572 0.005 1.54 0.16
            0.6395 0.6395 0.005 1.54 0.16
            0.9187 0.9187 -0.004 1.565 0.16
            0.9547 0.9547 -0.014 1.58 0.16
            0.9251 0.9005 -0.024 1.595 0.16
            0.8494 0.8285 -0.033 1.61 0.16
            0.7010 0.6802 -0.051 1.635 0.16
            0.5665 0.5075 -0.065 1.66 0.16
            0.3235 0.2215 -0.090 1.69 0.16
            0.1001 -0.0526 -0.108 1.7 0.16
            -0.2801 -0.4905 -0.139 1.71 0.16
            -0.6274 -0.8907 -0.160 1.71 0.16];
            C  = DATA(index,:);
        
        switch lower(SOF)
            case 'strike-slip'     , C1=-2.17; C6=C(1);
            case 'normal'          , C1=nan;   C6=nan;
            case 'normal-oblique'  , C1=nan;   C6=nan;
            case 'reverse'         , C1=-1.92; C6=C(2);
            case 'reverse-oblique' , C1=-1.92; C6=C(2);
            case 'unspecified'     , C1=-2.17; C6=C(1);
        end
        
        C2=1.0;
        C3=1.70;
        C4=2.1863*ones(size(M));C4(M>6.5)=0.3825;
        C5=0.32*ones(size(M));  C5(M>6.5)=0.5882;
        C7=C(3);
        lny = C1+C2*M-C3*log(Rrup+C4.*exp(C5.*M))+C6+C7*(8.5-M).^2.5;
        sigma = C(4)-C(5)*min(M,7);
end

lny(M>8.5)=-inf;

