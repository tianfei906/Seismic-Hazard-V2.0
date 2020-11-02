function[e]=SMDpredict(T,fun,ms)
%#ok<*NASGU>

str   = func2str(fun);
M     = num2cell(ms.Mw);
rrup  = num2cell(ms.Rrup);
rhyp  = num2cell(ms.Rhyp);
rjb   = num2cell(ms.Rjb);
ztor  = num2cell(ms.Depth); % approximation
zhyp  = num2cell(ms.Depth);
mech  = ms.Etype;
VS30  = num2cell(ms.Vs30);

Nspec = length(M);
Nper  = length(T);
mu    = nan(Nspec,Nper);
sig   = nan(Nspec,Nper);

IF  = strcmp(mech,'interface');
IS  = strcmp(mech,'intraslab');
SUB = or(IF,IS);

% ojo aca: Tag=11->GM, tag=13 -> RotD50
switch str
    case 'Youngs1997',                    tag='GM_0.05.csv';     param = [M,rrup,zhyp,VS30,mech];
    case 'AtkinsonBoore2003',             tag='GM_0.05.csv';     param = [M,rrup,zhyp,VS30,mech,r('general')];
    case 'Zhao2006',                      tag='RotD50_0.05.csv'; param = [M,rrup,zhyp,VS30,mech];
    case 'Mcverry2006',                   tag='RotD50_0.05.csv'; param = [M,rrup,zhyp,VS30,mech,r(0)];
    case 'ContrerasBoroschek2012',        tag='RotD50_0.05.csv'; param = [M,rrup,zhyp,VS30];
    case 'BCHydro2012',                   tag='RotD50_0.05.csv'; param = [M,rrup,rhyp,zhyp,VS30,mech,r('forearc'),r('central')];
    case 'BCHydro2018',                   tag='RotD50_0.05.csv'; param = [M,rrup,ztor,VS30,mech];
    case 'Kuehn2020',                     tag='RotD50_0.05.csv'; param = [M,rrup,ztor,VS30,mech,r('central_america_s'),r(0),r(0),r(0.0408),r(0.607),r(0)];
    case 'Parker2020',                    tag='RotD50_0.05.csv'; param = [M,rrup,zhyp,VS30,r(2),mech,r('global')];
    case 'Arteta2018',                    tag='RotD50_0.05.csv'; param = [M,rhyp,VS30,r('forearc')];
    case 'Idini2016',                     tag='RotD50_0.05.csv'; param = [M,rrup,rhyp,zhyp,VS30,mech,r('si')];
    case 'MontalvaBastias2017',           tag='RotD50_0.05.csv'; param = [M,rrup,rhyp,zhyp,VS30,mech,r('forearc')];
    case 'MontalvaBastias2017HQ',         tag='RotD50_0.05.csv'; param = [M,rrup,rhyp,zhyp,VS30,mech,r('forearc')];
    case 'SiberRisk2019',                 tag='RotD50_0.05.csv'; param = [M,rrup,rhyp,zhyp,VS30,mech];
    case 'Garcia2005',                    tag='GM_0.05.csv';     param = [M,rrup,rhyp,zhyp,r('horizontal')];
    case 'Jaimes2006',                    tag='GM_0.05.csv';     param = [M,rrup];
    case 'Jaimes2015',                    tag='GM_0.05.csv';     param = [M,rrup,r('cu')];
    case 'GarciaJaimes2017',              tag='GM_0.05.csv';     param = [M,rrup,r('horizontal')];
    case 'Bernal2014',                    tag='GM_0.05.csv';     param = [M,rrup,zhyp,mech];
    case 'Arroyo2010',                    tag='GM_0.05.csv';     param = [M,rrup];
    case 'Kanno2006',                     tag='RotD50_0.05.csv'; param = [M,rrup,zhyp,VS30];
    case 'medianPCEbchydro',              tag='RotD50_0.05.csv'; param = [M,rrup,VS30];
        
        %case 'Montalva2018',                 tag='RotD50_0.05.csv'; param = [M,rrup,rhyp,zhyp,VS30,r(1),mech];
end

% computes mean and standard deriation
parfor i=1:Nspec
    if SUB(i)
        param_i=param(i,:);
        for j=1:Nper
            [mu(i,j),sig(i,j)]=fun(T(j),param_i{:});
        end
    end
end

% computes residuals
ptrs = ms.ID+1;
lnSa = log(SMDreadspec(T,tag,ptrs));

e = (lnSa-mu)./sig;

    function [rx]=r(x)
        if ischar(x)
            rx=repmat({x},Nspec,1);
        else
            on = ones(Nspec,1);
            rx = num2cell(on*x);
        end
    end
end