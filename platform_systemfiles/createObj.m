function[obj]=createObj(tag,arg1)

switch tag
    % seismic source objects
    case 'model'
        obj  = struct('id',[],'source',[]);
        
    case 'source'
        obj  = struct(...
            'txt'      , [],...
            'adp'      , [],...
            'num'      , [],...
            'vptr'     , [],...  % pointer to vertices array
            'mptr'     , [],...  % pointer to source mesh array
            'cptr'     , [],...  % pointer to connectivity array
            'vert'     , [],...  % vertices
            'center'   , [],...  % 
            'xyzm'     , [],...  % mesh coordinates array
            'conn'     , [],...  % connectivity array
            'aream'    , [],...  % sub-element area
            'hypm'     , [],...  % sub-element 
            'strike'   , [],...
            'normal'   , [],...
            'p'        , [],...
            'dsv'      , [],...
            'dip'      , []);
        
    case 'sourceDSHA'
        obj  = struct(...
            'pfun'     ,[],... 
            'branch'   ,[],...
            'txt'      , [],...
            'adp'      , [],...
            'num'      , [],...
            'vptr'     , [],...
            'mptr'     , [],...
            'vert'     , [],...
            'xyzm'     , [],...
            'conn'     , [],...
            'aream'    , [],...
            'hypm'     , [],...
            'strike'   , [],...
            'normal'   , [],...
            'p'        , [],...
            'dsv'      , [],...
            'dip'      , [],...
            'rclust'   , []);
%             'mred'     , [],...        
        
    case 'gmmlib'
        obj = struct('label',[],'txt',[],'type',[],'handle',[],'T',[],'usp',[],'Rmetric',[],'Residuals',[],'cond',[],'var',[]);
        
    case 'mscl'
        obj = struct('source',[],'adp',[],'num',[],'mptr',[],'mdata',[],'meanMo',[]);
        
    case 'site'
        obj.id        = cell(0,1);
        obj.p         = zeros(0,3);
        obj.t         = cell(0,2);
        obj.shape     = zeros(0,0);
        obj.param     = cell(0,1);
        obj.value     = zeros(0,0);
        
    case 'defaultlayers'
        obj.VS30{1}   = 760;      % Site Class
        obj.IdiniSiteClass{1}= 1; % Spectral Site class used in Idini.
        obj.To{1}     = 1;        % Fundamental Site Period
        obj.ky{1}     = 0.2;      % Yield Strength of Slops (used in PSDA2)
        obj.covky{1}  = 0;        % Coef. of variation of Yield Strength of Slops (used in PSDA2)
        obj.Ts{1}     = 0.5;      % Mean slope period (used in PSDA2)
        obj.covTs{1}  = 0;        % Coef. of variation slope period (used in PSDA2)
        
    case 'opt'
        load pshatoolbox_RealValues opt
        obj=opt;
        
    case 'hazoptions'
        obj=struct('mod',1,'avg',[1 0 0 50 0],'sbh',[1 0 0 1],'dbt',[1 0 0 50],'map',[475 1],'pce',[0 1 50],'rnd',1);
        
    case 'Rbin'
        rmin  = 0;   rmax    = 360; dr    = 40;   obj  = [(rmin:dr:rmax-dr)',(rmin:dr:rmax-dr)'+dr];
        
    case 'Mbin'
        mmin  = 5;   mmax    = 9.6; dm    = 0.2;  obj  = [(mmin:dm:mmax-dm)',(mmin:dm:mmax-dm)'+dm];
        
    case 'Ebin'
        emin  = -1;   emax    = 3;   de    = 1;  obj  = [[-inf emin];(emin:de:emax-de)',(emin:de:emax-de)'+de;[emax,inf]];
        
    case 'returnperiods'
        obj=[144;250;475;949;1462;1950;2475;4975;10000];
        
    case 'LIBSsite'
        obj = struct('B',[],'L',[],'Df',[],'Q',[],'type',[],'wt',[],'LPC',[],'th1',[],'th2',[],'N1',[],'N2',[],'meth',[],'N160',[],'qc1N',[],'thick',[],'d2mat',[],'CPT',[]);
        
    case 'interfaceEQ'
        obj.Mech  = 1;
        obj.Mag   = 7;
        obj.Ztor  = 30;
        obj.Rrup  = 100;
        obj.Rx    = sqrt(obj.Rrup.^2-obj.Ztor.^2);
        obj.Rhyp  = obj.Rrup;
        obj.Repi  = obj.Rx;
        obj.Zhyp  = obj.Ztor;
        
        Nsamples    = 40;
        obj.rpZtor  = obj.Ztor*ones(Nsamples,1);
        obj.rpRrup  = logsp(obj.rpZtor(1),400,Nsamples)';
        obj.rpRx    = sqrt(max(obj.rpRrup.^2-obj.rpZtor.^2,0));
        obj.rpRhyp  = obj.rpRrup;
        obj.rpRepi  = obj.rpRx;
        obj.rpZhyp  = obj.rpZtor;
        
    case 'crustalEQ'
        obj.Mech   = 1;
        obj.Mag    = 7;
        obj.dip    = 90;
        obj.W      = 12;
        obj.Zbot   = 999;
        obj.Ztor   = 2;
        obj.Rx     = 100;
        obj.Repi   = 100;
        obj        = getRrupRjb(obj);
        obj.Ry0    = 0;
        obj.region = 1;
        
        Nsamples   = 40;
        SC.Mag    = obj.Mag*ones(Nsamples,1);
        SC.dip    = obj.dip;
        SC.W      = obj.W;
        SC.Zbot   = obj.Zbot;
        SC.Ztor   = obj.Ztor*ones(Nsamples,1);
        SC.Rx     = [0;logsp(1,200,Nsamples-1)'];
        SC.Repi   = SC.Rx;
        SC        = getRrupRjb(SC);
        SC.Ry0    = 0*ones(Nsamples,1);
        
        obj.rpZtor = SC.Ztor;
        obj.rpRx   = SC.Rx;
        obj.rpRrup = SC.Rrup;
        obj.rpRjb  = SC.Rjb;
        obj.rpRhyp = SC.Rhyp;
        obj.rpZhyp = SC.Zhyp;
        obj.rpRy0  = SC.Ry0;
        
    case 'siteGMM'
        obj.VS30   = 760;
        obj.f0     = 1;
        obj.Z10    = 0.048;
        obj.Z25    = 0.607;
        obj.Quali  = 'soil-soft';
        obj.Idini  = 2; %1=>sI,2=>sII,..., 6=>sVI
        obj.SGS    = 1; %1=>B,2=>C,3=>D
        
    case 'optdspec'
        obj.primaryIM  = 0;
        obj.epsilon    = 0;
        obj.periods    = [0.01 0.02 0.05 0.075 0.1 0.15 0.2 0.25 0.3 0.4 0.5 0.6 0.75 1 1.5 2 2.5 3 4 5 6 7.5 10];%[0.01 0.012 0.015 0.02 0.025 0.03 0.04 0.05 0.06 0.075 0.1 0.12 0.15 0.2 0.25 0.3 0.4 0.5 0.6 0.75 0.85 1 1.2 1.5 2 2.5 3 3.5 4 5 6 7.5 8.5 10 ];
        
        obj.GRMmax     = false;
        mech           = arg1.mech{1};
        
        % user defined Mmax
        userMmax         = zeros(size(mech));
        userMmax(mech==1)= 8.0; %default interface event
        userMmax(mech==2)= 8.2; %default intraslab event
        userMmax(mech==3)= 7.0; %default shallow crustal event
        
        mechtxt = num2cell(mech);
        for i=1:length(mech)
            switch mech(i)
                case 1, mechtxt{i} = 'interface';
                case 2, mechtxt{i} = 'intraslab';
                case 3, mechtxt{i} = 'crustal';
            end
        end
        
        
        Tmax = [];
        gptr = unique(unique(arg1.gmmptr(:)))';
        for i=gptr
            Tmax = [Tmax;max(arg1.gmmlib(i).T)]; %#ok<AGROW>
        end
        Tmax  = min(Tmax);
        obj.periods  = obj.periods(obj.periods<=Tmax);
        obj.Tmax = Tmax;
        
        obj.userMmax  = [arg1.labelG{1},mechtxt,num2cell(userMmax)];
        obj.weights   = arg1.weight(:,5);
        obj.branch    = arg1.branch;
        obj.im        = [];
        obj.lambdauhs = [];
        obj.weights   = arg1.weight(:,5);
        
    case 'dslib'
        obj=struct('label',[],'fun',[],'param',[]);
        obj(1)=[];
        
    case 'scalefactorSMD'
        obj.none     = 1;
        obj.IMtarget = 'RotD50_0.05.csv';
        obj.Period   = 1;
        obj.Value    = 1;
        obj.scaleMin = 0.1;
        obj.scaleMax = 5;
        obj.ssdMax   = Inf;
        
    case 'rspmatch'
        obj = cell(16,5);
        obj{ 1,1}='MaxIter';
        obj{ 2,1}='Tol';
        obj{ 3,1}='Gamma';
        obj{ 4,1}='iModel';
        obj{ 5,1}='a1, a2, f1, f2';
        obj{ 6,1}='Scale, Per';
        obj{ 7,1}='dt flag';
        obj{ 8,1}='evmin';
        obj{ 9,1}='Groupsize';
        obj{10,1}='MaxFreq';
        obj{11,1}='f1, f2, nPole';
        obj{12,1}='iModPGA';
        obj{13,1}='iSeed, RanFactor';
        obj{14,1}='freqMatch1, freqMatch2';
        obj{15,1}='Baseline Cor Flag';
        obj{16,1}='Scale Factor';
        
        i=0;
        i=i+1;obj{i,2}='20';                obj{i,3}='20';               obj{i,4}='15';               obj{i,5}='15';
        i=i+1;obj{i,2}='0.05';              obj{i,3}='0.05';             obj{i,4}='0.05';             obj{i,5}='0.05';
        i=i+1;obj{i,2}='1.0';               obj{i,3}='1.0';              obj{i,4}='1.0';              obj{i,5}='1.0';
        i=i+1;obj{i,2}='7';                 obj{i,3}='7';                obj{i,4}='7';                obj{i,5}='7';
        i=i+1;obj{i,2}='1.25 0.25 1.0 4.0'; obj{i,3}='1.25 0.25 1.0 4.0';obj{i,4}='1.25 0.25 1.0 4.0';obj{i,5}='1.25 0.25 1.0 4.0';
        
        %i=i+1;data{i,2}='2  0';              data{i,3}='0  0';             data{i,4}='0  0';             data{i,5}='0  0';
        i=i+1;obj{i,2}='1  0';              obj{i,3}='1  0';             obj{i,4}='1  0';             obj{i,5}='1  0';
        
        i=i+1;obj{i,2}='1';                 obj{i,3}='1';                obj{i,4}='1';                obj{i,5}='1';
        i=i+1;obj{i,2}='1.0e-04';           obj{i,3}='1.0e-04';          obj{i,4}='1.0e-04';          obj{i,5}='1.0e-04';
        i=i+1;obj{i,2}='30';                obj{i,3}='30';               obj{i,4}='30';               obj{i,5}='30';
        i=i+1;obj{i,2}='35';                obj{i,3}='35';               obj{i,4}='35';               obj{i,5}='35';
        i=i+1;obj{i,2}='0.0 0.0 4';         obj{i,3}='0.0 0.0 4';        obj{i,4}='0.0 0.0 4';        obj{i,5}='0.0 0.0 4';
        i=i+1;obj{i,2}='0';                 obj{i,3}='0';                obj{i,4}='0';                obj{i,5}='0';
        i=i+1;obj{i,2}='0  0.0';            obj{i,3}='0  0.0';           obj{i,4}='0  0.0';           obj{i,5}='0  0.0';
        i=i+1;obj{i,2}='1. 35.';            obj{i,3}='0.5  35.';         obj{i,4}='0.3  35.';         obj{i,5}='0.1  35.';
        i=i+1;obj{i,2}='0';                 obj{i,3}='0';                obj{i,4}='0';                obj{i,5}='0';
        i=i+1;obj{i,2}='1.0';               obj{i,3}='1.0';              obj{i,4}='1.0';              obj{i,5}='1.0';
end

