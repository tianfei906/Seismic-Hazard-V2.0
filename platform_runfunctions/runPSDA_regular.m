function[handles]=runPSDA_regular(handles)
delete(findall(handles.ax1,'type','line'));
drawnow
d         = handles.paramPSDA.d;
Nd        = length(d);
T1        = handles.T1;
T2        = handles.T2;
T3        = handles.T3;
[~,IJK]   = main_psda(T1,T2,T3);
Nbranches = size(IJK,1);
SMLIB     = handles.sys.SMLIB;
h         = handles.h;
Nsites    = size(h.p,1);
Nsources  = max(sum(handles.sys.Nsrc,1));
id        = {handles.sys.SMLIB.id};
optimizeD = handles.paramPSDA.optimize;
lambdaD   = nan(Nsites,Nd,Nsources,Nbranches);


fprintf('\n');
spat  = 'Site %-17g | Branch %-3g of %-49g Runtime:  %-4.3f s\n';
t0 = tic;
fprintf('                               SLOPE DISPLACEMENT HAZARD \n');
fprintf('-----------------------------------------------------------------------------------------------------------\n');

hd0   = zeros(size(d));
allky = handles.allky;
allTs = handles.allTs;


for site_ptr=1:Nsites
    brptr =1:Nbranches;
    brptr((cell2mat(T1(:,2))==0))=[];
    T2site = buildPSDA_T2(handles.paramPSDA,allky(site_ptr,:),allTs(site_ptr,:));
    
    for branch_ptr=brptr
        ti=tic;
        indT1    = IJK(branch_ptr,1); % pointer to scenario and Tm value
        indT2    = IJK(branch_ptr,2); % pointer to Ky and Ts values
        indT3    = IJK(branch_ptr,3); % pointer to analyses models
        geomptr  = handles.sys.branch(indT1,1);
        
        % compute site-specific Ts and ky values
        
        Ts       = T2site{indT2,2};
        ky       = T2site{indT2,3};
        B        = zeros(4,1);
        
        [~,B(1)] = intersect(id,T3{indT3,2}); fun1 = SMLIB(B(1)).func; % interface
        [~,B(2)] = intersect(id,T3{indT3,3}); fun2 = SMLIB(B(2)).func; % slab
        [~,B(3)] = intersect(id,T3{indT3,4}); fun3 = SMLIB(B(3)).func; % crustal
        [~,B(4)] = intersect(id,T3{indT3,5}); fun4 = SMLIB(B(4)).func; % background
        
        % run sources
        if ~isempty(handles.haz.lambda1)
            indlist = sum(permute(sum(handles.haz.lambda1(site_ptr,:,:,:,indT1),3,'omitnan'),[2 4 1 3]),1,'omitnan');
            indlist = find(indlist);
        else
            indlist = sum(permute(sum(handles.haz.MRD(site_ptr,:,:,:,indT1),3,'omitnan'),[2 4 1 3]),1,'omitnan');
            indlist = find(indlist);
        end
        for source_ptr = indlist
            mechptr = handles.sys.mech{geomptr}(source_ptr);
            Bs      = B(mechptr);
            switch mechptr
                case 1 , fun = fun1; % 'interface'
                case 2 , fun = fun2; % 'intraslab'
                case 3 , fun = fun3; % 'crustal'
                case 8 , fun = fun4; % 'crustal'
            end
            
            param      = SMLIB(Bs).param;
            integrator = SMLIB(Bs).integrator;
            Safactor   = SMLIB(Bs).Safactor;
            IMslope    = Safactor*Ts.*(Safactor>=0)+Safactor.*(Safactor<0);
            hd         = hd0;
            
            if integrator==1 % magnitude dependent models
                [~,IM_ptr] = intersect(handles.haz.IM1,IMslope);
                im         = handles.haz.im1(:,IM_ptr);
                deagg      = handles.haz.deagg1(site_ptr,:,IM_ptr,source_ptr,indT1);
                deagg      = permute(deagg ,[2,1]);
                if ~isempty(deagg{1})
                    hd  = integrate_Mw_dependent(fun,d,ky,Ts,im,deagg,optimizeD);
                end
            end
            
            if integrator==2 % magnitude independent models
                [~,IM_ptr] = intersect(handles.haz.IM1,IMslope);
                im         = handles.haz.im1(:,IM_ptr);
                lambda     = handles.haz.lambda1(site_ptr,:,IM_ptr,source_ptr,indT1);
                lambda     = permute(lambda,[2,1]);
                if max(lambda)>0
                    hd      = integrate_Mw_independent(fun,d,ky,Ts,im,lambda);
                end
            end
            
            if integrator==3 % Ellen's PGA-PGV model (Rigid Slopes)
                [~,rho_ptr]= intersect(handles.haz.corrlist,param(1));                
                [X1,X2]    = meshgrid(handles.haz.im2(:,1),handles.haz.im2(:,2));
                MRD        = handles.haz.MRD(site_ptr,:,:,source_ptr,indT1,rho_ptr);
                MRD        = permute(MRD,[2 3 1]);
                if max(MRD(:))>0
                    hd     = fun(ky,[],X1,X2,d,'convolute',MRD);
                end
                
            end
            
            if integrator==4 % Ellen PGA-PGV unified model (Rigid and Flexible)
                [~,rho_ptr]= intersect(handles.haz.corrlist,param(1));
                im         = handles.haz.im2;
                MRD        = handles.haz.MRD(site_ptr,:,:,source_ptr,indT1,rho_ptr);
                MRD        = permute(MRD,[2 3 1]);
                
                [Tm,dP] = trlognpdf_psda(param(3:5));
                if max(MRD(:))>0
                    for ix = 1:length(Tm)
                        [X1,X2,MRDk] = computeMRDk(Ts, Tm(ix), im, MRD,param(2));
                        dhd        = fun(ky,Ts,X1,X2,d,'convolute',MRDk);
                        hd         = hd+dP(ix)*dhd;
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
