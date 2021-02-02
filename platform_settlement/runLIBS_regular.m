function[handles]=runLIBS_regular(handles)
delete(findall(handles.ax1,'type','line'));
drawnow

optlib = handles.optlib;
sett   = optlib.sett;
Nsett  = length(sett);
IJK    = handles.IJK;
T1     = handles.T1;
T3     = handles.T3;

Nbranches = size(IJK,1);
nPGA      = optlib.nPGA;
setLIB    = handles.setLIB;
h         = handles.h;
Nsites    = size(h.p,1);
Nsources  = max(sum(handles.sys.Nsrc,1));
id        = {setLIB.label};
lambdaD   = nan(Nsites,Nsett,Nsources,Nbranches);


fprintf('\n');
spat  = 'Site %-17g | Branch %-3g of %-49g Runtime:  %-4.3f s\n';
t0 = tic;
fprintf('                                BUILDING SETTLEMENT HAZARD \n');
fprintf('-----------------------------------------------------------------------------------------------------------\n');

hd0 = zeros(size(sett));

%% Computes Q and Sa Values for each scenario
nQ    = optlib.nQ;
Qlist = zeros(Nbranches,Nsites);
for j=1:Nsites
    Qj = trlognpdf_psda([handles.param(j).Q nQ]);
    Qlist(:,j) = repmat(Qj,nPGA,1);
end

%% Computes LBS and HL values for Bray and Macedo
if any(isfield(handles.haz,{'im2','im3'}))
    [PGA,M]=deal(zeros(nPGA,Nsites));
    
    for site_ptr=1:Nsites
        param     = handles.param(site_ptr);
        h         = handles.h;
        h.p       = h.p(site_ptr,:);
        h.param   = h.param;
        h.value   = h.value(site_ptr,:);
        
        % computes Magnitude and PGA percentiles
        pga_ptr = find(handles.haz.IM==0);
        lambda  = handles.haz.lambda(site_ptr,:,pga_ptr,:,:);
        lambda  = nansum(lambda,4);
        lambda  = permute(lambda,[2 5 1 3 4]);
        
        Tret = optlib.RetPeriod;
        for ll=1:nPGA
            opt0    = handles.opt;
            opt0.im = handles.haz.im(:,pga_ptr);
            im      = robustinterp(lambda(:,ll),opt0.im,1/Tret,'loglog');
            opt0.dflag = [true false false];
            source  = buildmodelin(handles.sys,handles.sys.branch(ll,:),opt0);
            deagg   = runhazard2(im,0,h,opt0,source,Nsources,1);
            deagg   = vertcat(deagg{:});
            
            deagg(:,2)=log(deagg(:,2));
            IND=isinf(deagg(:,2));
            deagg(IND,:)=[];
            
            M(ll,site_ptr)   = (deagg(:,1)'*deagg(:,2))/sum(deagg(:,2));
            PGA(ll,site_ptr) = im;
        end
    end
    
    if nPGA>2
        M    = prctile(M  ,[25;50;75]);
        PGA  = prctile(PGA,[25;50;75]);
        wPGA = [0.25 0.5 0.25];
    else
        M    = prctile(M  ,50);
        PGA  = prctile(PGA,50);
        wPGA = 1;
    end
    
    [LBS1,LBS2,HL1,HL2]=deal(M*0);
    for ii=1:numel(M)
        BI14   = cptBI14(param.CPT, param.wt, param.Df,M(ii), PGA(ii));
        R15    = cptR15 (param.CPT, param.wt, param.Df,M(ii), PGA(ii));
        LBS1(ii)= BI14.LBS;
        LBS2(ii)= R15.LBS;
        HL1(ii) = BI14.HL;
        HL2(ii) = R15.HL;
    end
end

%% Runs Settlement Hazard Analysis
for site_ptr=1:Nsites
    brptr =1:Nbranches;
    brptr((cell2mat(T1(:,2))==0))=[];
    param = handles.param(site_ptr);
    
    h           = handles.h;
    h.p         = h.p(site_ptr,:);
    h.param     = h.param;
    h.value     = h.value(site_ptr,:);
    
    for branch_ptr=brptr
        ti=tic;
        indT1    = IJK(branch_ptr,1); % pointer to hazaes model
        indT3    = IJK(branch_ptr,3); % pointer to settlement model
        geomptr  = handles.sys.branch(indT1,1);
        
        % site/building parameters
        B        = zeros(3,1);
        [~,B(1)] = intersect(id,T3{indT3,2}); fun1 = setLIB(B(1)).func; % interface
        [~,B(2)] = intersect(id,T3{indT3,3}); fun2 = setLIB(B(2)).func; % slab
        [~,B(3)] = intersect(id,T3{indT3,4}); fun3 = setLIB(B(3)).func; % crustal
        
        % run sources
        if ~isempty(handles.haz.lambda)
            indlist = nansum(permute(nansum(handles.haz.lambda(site_ptr,:,:,:,indT1),3),[2 4 1 3]),1);
            indlist = find(indlist);
        else
            indlist = nansum(permute(nansum(handles.haz.MRD(site_ptr,:,:,:,indT1),3),[2 4 1 3]),1);
            indlist = find(indlist);
        end
        
        for source_ptr = indlist
            fprintf('B%g - S%g\n',branch_ptr,source_ptr);
            mechptr = handles.sys.mech{geomptr}(source_ptr);
            Bs      = B(mechptr);
            switch mechptr
                case 1 , fun = fun1; % 'interface'
                case 2 , fun = fun2; % 'intraslab'
                case 3 , fun = fun3; % 'crustal'
            end
            
            integrator = setLIB(Bs).integrator;
            hd         = hd0;
            
            if integrator==0 % magnitude dependent models
                IMsite     = str2IM(setLIB(Bs).IM);
                [~,IM_ptr] = intersect(handles.haz.IM,IMsite);
                im         = handles.haz.im(:,IM_ptr);
                deagg      = handles.haz.deagg(site_ptr,:,IM_ptr,source_ptr,indT1);
                deagg      = permute(deagg ,[2,1]);
                
                if ~isempty(deagg{1})
                    hd  = integrateLIBS_Mw_dependent2(fun,sett,param,im,deagg);
                end
            end
            
            if integrator==1 % magnitude independent models
                IMsite     = str2IM(setLIB(Bs).IM);
                [~,IM_ptr] = intersect(handles.haz.IM,IMsite);
                im         = handles.haz.im(:,IM_ptr);
                lambda     = handles.haz.lambda(site_ptr,:,IM_ptr,source_ptr,indT1);
                lambda     = permute(lambda,[2,1]);
                
                if max(lambda)>0
                    param.Q = Qlist(branch_ptr,site_ptr);
                    hd      = integrateLIBS_Mw_independent(fun,sett,param,im,lambda);
                end
            end
            
            if integrator==2
                im2         = handles.haz.im2;
                [CAVdp,Sa1] = meshgrid(im2(:,1),im2(:,2));
                im2 = [CAVdp(:),Sa1(:)];
                MRD = handles.haz.MRD2(site_ptr,:,:,source_ptr,indT1);
                MRD = permute(MRD,[2 3 1]);
                if max(MRD(:))>0
                    param.Q   = Qlist(branch_ptr,site_ptr);
                    
                    for jj=1:numel(wPGA)
                        param.LBS = LBS1(jj,site_ptr); param.HL = HL1(jj,site_ptr); hd1 = fun(param,im2,sett,'convolute',MRD);
                        param.LBS = LBS2(jj,site_ptr); param.HL = HL2(jj,site_ptr); hd2 = fun(param,im2,sett,'convolute',MRD);
                        hd        = hd + (hd1+hd2)*wPGA(jj)*(1/2);
                    end
                end
            end
            
            if integrator==3
                CAV=handles.haz.im3(:,1);
                PGA=handles.haz.im3(:,2);
                SA1=handles.haz.im3(:,3);
                
                MRD = handles.haz.MRD3(site_ptr,:,:,:,source_ptr,indT1);
                MRD = permute(MRD,[2 3 4 1]);
                Pm  = handles.haz.Pm{site_ptr,source_ptr,indT1};
                source  = buildmodelin(handles.sys,handles.sys.branch(indT1,:),opt0);
                M = source(source_ptr).mscl(:,1);
                % --------------------------------------------------------
                if max(MRD(:))>0
                    param.Q   = Qlist(branch_ptr,site_ptr);
                    for jj=1:numel(wPGA)
                        param.LBS = LBS1(jj,site_ptr);param.HL  = HL1(jj,site_ptr); hd1 = fun(param,CAV,PGA,SA1,M,Pm,sett,MRD);
                        param.LBS = LBS2(jj,site_ptr);param.HL  = HL2(jj,site_ptr); hd2 = fun(param,CAV,PGA,SA1,M,Pm,sett,MRD);
                        hd        = hd + (hd1+hd2)*wPGA(jj)*(1/2);
                    end
                end
            end
            
            lambdaD(site_ptr,:,source_ptr,branch_ptr) = hd;
        end
        fprintf(spat,site_ptr,branch_ptr,Nbranches,toc(ti))
    end
end
handles.lambdaD=lambdaD;

fprintf('-----------------------------------------------------------------------------------------------------------\n');
fprintf('%-88sTotal:     %-4.3f s\n','',toc(t0));
handles.butt2.Value=1;
