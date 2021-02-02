function[deaggD]=DeaggLIBS_regular(handles)
delete(findall(handles.ax1,'type','line'));drawnow

d         = handles.d;
T1        = handles.T1;
T2        = handles.T2;
T3        = handles.T3;
[~,IJK]   = main_settle(T1,T2,T3);
setLIB     = handles.setLIB;
indT1     = IJK(1); % pointer to scenario
indT3     = IJK(3); % pointer to analyses models
geomptr   = handles.sys.branch(indT1(1),1);
Nsources  = numel(handles.sys.labelG{geomptr});
id        = {handles.setLIB.label};
site_ptr  = 1;
B         = zeros(3,1);
[~,B(1)]  = intersect(id,T3{indT3,2}); fun1 = setLIB(B(1)).func; % interface
[~,B(2)]  = intersect(id,T3{indT3,3}); fun2 = setLIB(B(2)).func; % slab
[~,B(3)]  = intersect(id,T3{indT3,4}); fun3 = setLIB(B(3)).func; % crustal
deaggD = zeros(0,3);
param  = handles.param;
% run sources
for source_ptr=1:Nsources
    mechanism = handles.sys.mech{geomptr}(source_ptr);
    
    switch mechanism
        case 1 , fun = fun1; Bs=B(1);
        case 2 , fun = fun2; Bs=B(2);
        case 3 , fun = fun3; Bs=B(3);
    end
    
    % param      = SMLIB(Bs).param;
    integrator = setLIB(Bs).integrator;
    IMsettle    = str2IM(setLIB(Bs).IM);
    
    if integrator==0 % magnitude dependent models
        %         [~,IM_ptr] = intersect(handles.haz.IM,IMsettle);
        %         im         = handles.haz.im(:,IM_ptr);
        %         deagg      = handles.haz.deagg(site_ptr,:,IM_ptr,source_ptr,indT1);
        %         deagg      = permute(deagg ,[2,1]);
        %         if ~isempty(deagg{1})
        %             rateD    = deaggLIBS_Mw_dependent(fun,d,param,im,deagg);
        %             deaggD   = [deaggD;[deagg{1}(:,1:2),rateD]]; %#ok<AGROW>
        %         end
    end
    
    if integrator==1 % magnitude independent models
        [~,IM_ptr] = intersect(handles.haz.IM,IMsettle);
        im         = handles.haz.im(:,IM_ptr);
        deagg      = handles.haz.deagg(site_ptr,:,IM_ptr,source_ptr,indT1);
        deagg      = permute(deagg,[2,1]);
        if ~isempty(deagg{1})
            rateD  = deaggLIBS_Mw_independent(fun,d,param,im,deagg);
            deaggD = [deaggD;[deagg{1}(:,1:2),rateD]]; %#ok<AGROW>
        end
    end
end

% function rateD=deaggLIBS_Mw_dependent(fun,d,param,CAV,deagg)
% 
% Nrm = size(deagg{1},1);
% Nim = size(deagg,1);
% lambdaSa  = zeros(Nrm,Nim);
% for i=1:Nim
%     lambdaSa(:,i)=deagg{i}(:,3);
% end
% CAV     = repmat(CAV(:)',Nrm,1);
% M       = repmat(deagg{1}(:,1),1,Nim);
% PD      = fun(ky,Ts,CAV,M,d,'ccdf');
% rateD   = diff(-lambdaSa,1,2).*(PD(:,1:end-1)+PD(:,2:end))/2;
% rateD   = sum(rateD,2);


function rateD=deaggLIBS_Mw_independent(fun,d,param,CAV,deagg)

Nrm = size(deagg{1},1);
Nim = size(deagg,1);
lambdaSa  = zeros(Nrm,Nim);
for i=1:Nim
    lambdaSa(:,i)=deagg{i}(:,3);
end
CAV      = repmat(CAV(:)',Nrm,1);
PD      = fun(param,CAV,d,'ccdf');
rateD   = diff(-lambdaSa,1,2).*(PD(:,1:end-1)+PD(:,2:end))/2;
rateD   = sum(rateD,2);


