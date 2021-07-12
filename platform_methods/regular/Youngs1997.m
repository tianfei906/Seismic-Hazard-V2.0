function[lny,sigma,tau,phi]=Youngs1997(To,M,Rrup,Zhyp,media,mechanism,adjfun)

% Syntax : Youngs1997 mechanism                                             
% Example 1:  Youngs1997 interface
% Example 2:  Youngs1997 intraslab
% Reference: 
% Youngs, R. R., Chiou, S. J., Silva, W. J., & Humphrey, J. R. (1997).
% Strong ground motion attenuation relationships for subduction zone
% earthquakes. Seismological Research Letters, 68(1), 58-7
%
if isnumeric(media)
    if media<760
        media='soil';
    else
        media='rock';
    end
end

st = dbstack;
switch media
    case 'soil', [isadmisible,units] = isIMadmisible(To,st(1).name,[0.001 4],[nan nan],[nan nan],[nan nan]);
    case 'rock', [isadmisible,units] = isIMadmisible(To,st(1).name,[0.001 3],[nan nan],[nan nan],[nan nan]);
end

if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

To      = max(To,0.01); %PGA is associated to To=0.01;
switch media
    case 'soil', period  = [0.01 0.075 0.1 0.2 0.3 0.4 0.5 0.75 1 1.5 2 3 4];
    case 'rock', period  = [0.01 0.075 0.1 0.2 0.3 0.4 0.5 0.75 1 1.5 2 3];
end

T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

if T_lo==T_hi
    [lny,sigma] = gmpe(index,M,Rrup,Zhyp,media,mechanism);
else
    [lny_lo,sigma_lo] = gmpe(index,  M,Rrup,Zhyp,media,mechanism);
    [lny_hi,sigma_hi] = gmpe(index+1,M,Rrup,Zhyp,media,mechanism);
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


function[lny,sigma]=gmpe(index,M,Rrup,Zhyp,media,mechanism)

switch mechanism
    case 'interface', ZT=0;
    case 'intraslab', ZT=1;
end

switch media
    case 'rock'
        DATA = [0.000 0.0000 -2.552 1.45 -0.1
            1.275 0.0000 -2.707 1.45 -0.1
            1.188 -0.0011 -2.655 1.45 -0.1
            0.722 -0.0027 -2.528 1.45 -0.1
            0.246 -0.0036 -2.454 1.45 -0.1
            -0.115 -0.0043 -2.401 1.45 -0.1
            -0.400 -0.0048 -2.360 1.45 -0.1
            -1.149 -0.0057 -2.286 1.45 -0.1
            -1.736 -0.0064 -2.234 1.45 -0.1
            -2.634 -0.0073 -2.160 1.50 -0.1
            -3.328 -0.0080 -2.107 1.55 -0.1
            -4.511 -0.0089 -2.033 1.65 -0.1
            ];
        
        C       = DATA(index,:);
        lny     = 0.2418+1.414*M+C(1)+C(2)*(10-M).^3+C(3)*log(Rrup+1.7818*exp(0.554*M))+0.00607*Zhyp+0.3846*ZT;
        sigma   = C(4)+C(5)*min(M,8);
        
    case 'soil'
        DATA=[0.000  0.0000 -2.329 1.45 -0.1
            2.400 -0.0019 -2.697 1.45 -0.1
            2.516 -0.0019 -2.697 1.45 -0.1
            1.549 -0.0019 -2.464 1.45 -0.1
            0.793 -0.0020 -2.327 1.45 -0.1
            0.144 -0.0020 -2.230 1.45 -0.1
            -0.438 -0.0035 -2.140 1.45 -0.1
            -1.704 -0.0048 -1.952 1.45 -0.1
            -2.870 -0.0066 -1.785 1.45 -0.1
            -5.101 -0.0114 -1.470 1.50 -0.1
            -6.433 -0.0164 -1.290 1.55 -0.1
            -6.672 -0.0221 -1.347 1.65 -0.1
            -7.618 -0.0235 -1.272 1.65 -0.1];
        
        C       = DATA(index,:);
        lny     = -0.6687+1.438*M+C(1)+C(2)*(10-M).^3+C(3)*log(Rrup+1.097*exp(0.617*M))+0.00648*Zhyp+0.3643*ZT;
        sigma   = C(4)+C(5)*min(M,8);
end