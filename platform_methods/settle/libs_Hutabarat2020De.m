function [varargout] = libs_Hutabarat2020De(param,PGA,M,method,varargin)

z      = param.CPT.z;
svo    = param.CPT.svo;
s_vo   = param.CPT.s_vo;
CR0    = [0;250;0;150;250;0;0;73;0;60;0;104;170;245;250];
ED0    = [0;0;5;5;5;4.999;15;15;85;85;150;150;150;150;150];
De0    = [0;0;50;50;0;0;100;100;300;300;1000;300;100;50;0];
FE     = scatteredInterpolant(CR0,ED0,De0,'linear','nearest');
Ic     = param.CPT.Ic;
qt     = param.CPT.qt;
Fr     = param.CPT.Fr;


% CR
Qtn = param.CPT.qc1ncs;
IB  = 100*(Qtn+10)./(Qtn.*Fr+70);
Ko  = 0.5;
ind = IB<=22;
Nkt = 17; % a value between 14 and 20
su  = Ko*s_vo*tand(33);
su(ind)=(qt(ind)-svo(ind))/Nkt;
za     = param.LAY.th1;
su(z>za)=0;
CR = trapz(z,su);

% ED
gw     = 9.81;
kv     = 10.^(0.952-3.04*max(min(Ic,3.27),1));               % Question here, 1<Ic<3.27;

hicr   = param.CPT.z;
zb     = param.LAY.th3;

De    = zeros(size(PGA));
for i=1:numel(De)
    m   = M(i);
    pga = PGA(i);
    
    % Factor of Safety
    switch method
        case 'BI14', LTP  = cptBI14(param.CPT,param.wt,param.Df,m,pga);
        case 'R15' , LTP  = cptR15(param.CPT,param.wt,param.Df,m,pga);
    end
    
    FSL = min(max(LTP.FS,1),3);

    % ED
    ru   = 0.5+asin((2*FSL.^-5-1)/pi);
%     idru=find(ru>=0.8);
%     ru(idru)=1.0;
%      idru=LTP.FS<=0.5;
%      ru(idru)=1.0;
    
    hexc = ru.*s_vo/gw;

%%
%     Ic_copy=Ic ;
%     Ic_copy (hexc<hicr)=0;
%     Ic_copy(or(z<za,z>zb))=0;
%     NnzIc=nnz(Ic_copy);
%     Icmean=sum(Ic_copy)/NnzIc;
%%
    Id_fslte1=LTP.FS>1;
    Ic_copy2=Ic;
    Ic_copy2(Id_fslte1)=0;
    NnzIc2=nnz(Ic_copy2);
    Icmean2=sum(Ic_copy2)/NnzIc2;

%%
    %Icmean=mean(Ic_copy);
%    kcs    = 3e-5;                            % This value is fixed
     kcs     = 10^(0.952-3.04*max(min(Icmean2,3.27),1)); 
%%
%    Intg = (kv/kcs).*(hexc-hicr);
    Intg = 1*(hexc-hicr);
    Intg (hexc<hicr)=0;
    Intg(or(z<za,z>zb))=0;
    

    
    ED    = gw*trapz(z,Intg);
    De(i) = FE(CR,ED);
end

if nargin==4
    varargout{1}=De;
    return
end

y     = varargin{1};
dist  = varargin{2};
if strcmp(dist,'pdf')
    varargout{1} = [];
elseif strcmp(dist,'cdf')
    varargout{1} = (y>=De);
elseif strcmp(dist,'ccdf')
    varargout{1} = (y<=De);
end