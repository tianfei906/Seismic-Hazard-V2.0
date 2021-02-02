function[handles]=runLIBS_regular2(handles)
delete(findall(handles.ax1,'type','line'));
drawnow

optlib = handles.optlib;
S      = optlib.sett;
Nsett  = length(S);
IJK    = handles.IJK;
T1     = handles.T1;
T3     = handles.T3;

Nbranches = size(IJK,1);
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

hd0 = zeros(size(S));

%% Computes Q and Sa Values for each scenario
nQ    = optlib.nQ;
Qlist = zeros(Nbranches,Nsites);
for j=1:Nsites
    Qj = trlognpdf_psda([handles.param(j).Q nQ]);
    Qlist(:,j) = repmat(Qj,Nbranches/nQ,1);
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
            
            if integrator==0 % magnitude dependent models, Juang2013Dv, Hutabarat2020De
                IMsite     = str2IM(setLIB(Bs).IM);
                [~,IM_ptr] = intersect(handles.haz.IM,IMsite);
                im         = handles.haz.im(:,IM_ptr);
                deagg      = handles.haz.deagg(site_ptr,:,IM_ptr,source_ptr,indT1);
                deagg      = permute(deagg ,[2,1]);
                
                if ~isempty(deagg{1})
                    hd  = integrateLIBS_Mw_dependent2(fun,S,param,im,deagg);
                end
            end
            
            if integrator==1 % magnitude independent models, Bullock Models
                IMsite     = str2IM(setLIB(Bs).IM);
                [~,IM_ptr] = intersect(handles.haz.IM,IMsite);
                im         = handles.haz.im(:,IM_ptr);
                lambda     = handles.haz.lambda(site_ptr,:,IM_ptr,source_ptr,indT1);
                lambda     = permute(lambda,[2,1]);
                
                if max(lambda)>0
                    param.Q = Qlist(branch_ptr,site_ptr);
                    hd      = integrateLIBS_Mw_independent(fun,S,param,im,lambda);
                end
            end
            
            if integrator==3 % BrayMacedo2017Ds and BrayMacedo2017LIBS - full range of LBS and HL values
                CAV=handles.haz.im3(:,1);
                PGA=handles.haz.im3(:,2);
                SA1=handles.haz.im3(:,3);
                
                MRD = handles.haz.MRD3(site_ptr,:,:,:,source_ptr,indT1);
                MRD = permute(MRD,[2 3 4 1]);
                Pm  = handles.haz.Pm{site_ptr,source_ptr,indT1};
                source  = buildmodelin(handles.sys,handles.sys.branch(indT1,:),handles.opt);
                M = source(source_ptr).mscl(:,1);
                if max(MRD(:))>0
                    param.Q   = Qlist(branch_ptr,site_ptr);
                    hd= fun(param,S,CAV,PGA,SA1,M,Pm,MRD,'BI14')*0.5+...
                        fun(param,S,CAV,PGA,SA1,M,Pm,MRD,'R15' )*0.5;
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
