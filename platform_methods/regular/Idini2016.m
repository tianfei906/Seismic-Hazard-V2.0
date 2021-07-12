function[lny,sigma,tau,phi]=Idini2016(To,M,Rrup,Rhyp,Zhyp,Vs30,mechanism,spectrum,adjfun)

% Syntax : Idini2016 mechanism spectype                                     
% Benjamn Idini, Fabian Rojas, Sergio Ruiz, Cesar Pasten

st = dbstack;
[isadmisible,units] = isIMadmisible(To,st(1).name,[0 10],[nan nan],[nan nan],[nan nan]);
if isadmisible==0
    lny   = nan(size(M));
    sigma = nan(size(M));
    tau   = nan(size(M));
    phi   = nan(size(M));
    return
end

To      = max(To,0.001); %PGA is associated to To=0.001;
period  =[0.001;0.01;0.02;0.03;0.05;0.07;0.10;0.15;0.20;0.25;0.30;0.40;0.50;0.75;1.00;1.50;2.00;3.00;4.00;5.00;7.50;10.00];
T_lo    = max(period(period<=To));
T_hi    = min(period(period>=To));
index   = find(abs((period - T_lo)) < 1e-6); % Identify the period

switch mechanism
    case 'interface', R=Rrup.*(M>=7.7)+Rhyp.*(M<7.7);
    case 'intraslab', R=Rhyp;
end

if T_lo==T_hi
    [log10y,sigma,tau,phi] = gmpe(index,M,R,Zhyp,mechanism,spectrum,Vs30);
else
    [lny_lo,sigma_lo,tau_lo] = gmpe(index,  M,R,Zhyp,mechanism,spectrum,Vs30);
    [lny_hi,sigma_hi,tau_hi] = gmpe(index+1,M,R,Zhyp,mechanism,spectrum,Vs30);
    x          = log([T_lo;T_hi]);
    Y_sa       = [lny_lo,lny_hi]';
    Y_sigma    = [sigma_lo,sigma_hi]';
    Y_tau      = [tau_lo,tau_hi]';
    log10y     = interp1(x,Y_sa,log(To))';
    sigma      = interp1(x,Y_sigma,log(To))';
    tau        = interp1(x,Y_tau,log(To))';
    phi        = sqrt(sigma.^2-tau.^2);
end

% log base conversion
lny    = log10y * log(10);
sigma  = sigma  * log(10);
tau    = tau    * log(10);
phi    = phi    * log(10);

% unit convertion
lny  = lny+log(units);

% modifier
if exist('adjfun','var')
    SF  = feval(adjfun,To); 
    lny = lny+log(SF);
end

function[log10y,sigma,tau,phi]=gmpe(index,M,R,Zhyp,mechanism,spectrum,Vs30)

%   1        2       3       4       5       6           7           8         9         10     11       12         13      14      15      16
%   sII      sIII	 sIV	 sV	     sVI	 c3          c5          dc3	   sigmar	 c1     c2       c9         c8      dc1     dc2     sigmae
Co=[
    -0.584	-0.322	-0.109	-0.095	-0.212	-0.97558	-0.00174	-0.52745	0.232	-2.8548	0.7741	-0.03958	0.00586	2.5699	-0.4761	0.172
    -0.523	-0.262	-0.100	-0.092	-0.193	-1.02993	-0.00175	-0.50466	0.231	-2.8424	0.8052	-0.04135	0.00584	2.7370	-0.5191	0.173
    -0.459	-0.208	-0.092	-0.089	-0.177	-1.08567	-0.00176	-0.48043	0.233	-2.8337	0.8383	-0.04325	0.00583	2.9087	-0.5640	0.176
    -0.390	-0.160	-0.085	-0.088	-0.164	-1.15951	-0.00176	-0.42490	0.235	-2.8235	0.8838	-0.04595	0.00586	3.0735	-0.6227	0.178
    -0.306	-0.088	-0.075	-0.090	-0.146	-1.28640	-0.00178	-0.31239	0.241	-2.7358	0.9539	-0.05033	0.00621	3.2147	-0.7079	0.190
    -0.351	-0.056	-0.069	-0.096	-0.141	-1.34644	-0.00181	-0.17995	0.251	-2.6004	0.9808	-0.05225	0.00603	3.0851	-0.7425	0.213
    -0.524	-0.087	-0.070	-0.113	-0.156	-1.32353	-0.00182	-0.13208	0.255	-2.4891	0.9544	-0.05060	0.00571	2.8091	-0.7055	0.195
    -0.691	-0.336	-0.095	-0.166	-0.245	-1.17687	-0.00183	-0.26451	0.255	-2.6505	0.9232	-0.04879	0.00560	2.6260	-0.6270	0.160
    -0.671	-0.547	-0.127	-0.209	-0.359	-1.04508	-0.00182	-0.39105	0.268	-3.0096	0.9426	-0.05034	0.00573	2.6063	-0.5976	0.157
    -0.584	-0.674	-0.178	-0.235	-0.444	-0.94363	-0.00178	-0.34348	0.264	-3.3321	0.9578	-0.05143	0.00507	2.3654	-0.5820	0.142
    -0.506	-0.730	-0.258	-0.234	-0.491	-0.84814	-0.00173	-0.36695	0.260	-3.5422	0.9441	-0.05052	0.00428	2.2017	-0.5412	0.141
    -0.386	-0.718	-0.423	-0.164	-0.535	-0.69278	-0.00166	-0.46301	0.263	-3.3985	0.7773	-0.03885	0.00308	1.6367	-0.3448	0.157
    -0.300	-0.635	-0.537	-0.110	-0.557	-0.57899	-0.00161	-0.54098	0.261	-2.8041	0.5069	-0.01973	0.00257	0.7621	-0.0617	0.152
    -0.276	-0.395	-0.575	-0.358	-0.599	-0.56887	-0.00158	-0.46266	0.252	-4.4588	0.8691	-0.04179	0.00135	2.1003	-0.4349	0.146
    -0.275	-0.254	-0.462	-0.670	-0.584	-0.53282	-0.00154	-0.42314	0.247	-5.3391	1.0167	-0.04999	0.00045	2.5610	-0.5678	0.153
    -0.249	-0.238	-0.300	-0.801	-0.522	-0.46263	-0.00145	-0.58519	0.246	-6.1204	1.1005	-0.05426	0.00068	2.8923	-0.5898	0.152
    -0.218	-0.231	-0.220	-0.746	-0.479	-0.40594	-0.00139	-0.65999	0.245	-7.0334	1.2501	-0.06356	0.00051	3.3941	-0.7009	0.157
    -0.180	-0.219	-0.210	-0.628	-0.461	-0.33957	-0.00137	-0.79004	0.231	-8.2507	1.4652	-0.07797	0.00066	4.0033	-0.8465	0.155
    -0.171	-0.218	-0.212	-0.531	-0.448	-0.26479	-0.00137	-0.86545	0.228	-8.7433	1.4827	-0.07863	0.00063	3.9337	-0.8134	0.160
    -0.168	-0.218	-0.203	-0.438	-0.439	-0.22333	-0.00137	-0.88735	0.232	-8.9927	1.4630	-0.07638	0.00067	3.7576	-0.7642	0.167
    -0.168	-0.218	-0.153	-0.256	-0.435	-0.30346	-0.00131	-0.91259	0.231	-9.8245	1.6383	-0.08620	0.00108	4.3948	-0.9313	0.164
    -0.168	-0.218	-0.125	-0.231	-0.435	-0.33771	-0.00117	-0.96363	0.204	-9.8671	1.5877	-0.08168	0.00014	4.3875	-0.8892	0.176];

C = Co(index,:);
switch lower(spectrum)
    case {'si'  ,1}, sTa  = 0; Vs30 = 1530; % Just to make sure FS=0;
    case {'sii' ,2}, sTa  = C(1);
    case {'siii',3}, sTa  = C(2);
    case {'siv' ,4}, sTa  = C(3);
    case {'sv'  ,5}, sTa  = C(4);
    case {'svi' ,6}, sTa  = C(5);
end

c3     = C(6);
c5     = C(7);
dc3    = C(8);
phi    = C(9)*ones(size(M)); % intra-event
c1     = C(10);
c2     = C(11);
c9     = C(12);
c8     = C(13);
dc1    = C(14);
dc2    = C(15);
tau    = C(16)*ones(size(M));

sigma = sqrt(tau.^2+phi.^2);
ho     = 50; %km 
Vref   = 1530; %m/s
c4     = 0.1;
c6     = 5;
c7     = 0.35;

switch lower(mechanism)
    case 'interface', Feve = 0; dfM = c9*M.^2;
    case 'intraslab', Feve = 1; dfM = dc1+dc2*M;
end

% source contribution term
if Feve==0
    Zhyp = zeros(size(Zhyp));
end
FF = c1+c2*M+c8*(Zhyp-ho)*Feve+dfM;

% path contribution term
Mr = 5;
Ro = (1-Feve)*c6*10.^(c7*(M-Mr));
g  = (c3+c4*(M-Mr)+dc3*Feve);
FD = g.*log10(R+Ro)+c5*R;

% site specific response
FS = sTa*log10(Vs30/Vref);

% model regresion
log10y  = (FF+FD+FS);


