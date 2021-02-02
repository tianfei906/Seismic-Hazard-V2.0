function[IM]=SMDreadspec(T,fname,ptrs)

% retrieves data
Np     = length(ptrs);
% [ptrs,IND0]   = sort(ptrs);
% empirical threshold for cputimes (machine dependent).
% Below 113 ground motions, its faster to
% read each GM separately. Above 113, its faster to read the entire
% database and retrieved the GMs needed.
thresh = 113; 
if Np>thresh
    IM0 = readtable(fname);
    T0  = table2array(IM0(1,2:end));
    IM0 = table2array(IM0(1+ptrs,2:end));
    T0(1)=0.001;
    Tfix = max(T,0.001);
    notnan =~isnan(sum(IM0,2));
    IM   = nan(size(IM0,1),length(Tfix));    
    IM(notnan,:)   = exp(interp1(log(T0'),log(IM0(notnan,:)'),log(Tfix)','pchip'))';
    
    if any(T<0.001)
        II = ones(1,sum(T<0.001));
        IM(:,T<0.001)=IM0(:,II);
    end
else
    tic
    skip  = diff([0;ptrs(:)])-1;
    fid   = fopen(fname,'r');
    
    % reads period list
    T0    = fgetl(fid);
    T0    = str2double(regexp(T0,'\,','split'));
    T0(1) = [];
    T0(1) = 0.001;
    IM0   = cell(Np,1);
    for i=1:Np
        line1  = textscan(fid,'%s',1,'headerLines',skip(i),'delimiter','\n');
        IM0{i} = line1{1}{1};
    end
    % interpolates spectra
    IM0  = regexp(IM0,'\,','split');
    IM0  = str2double(vertcat(IM0{:}));
    IM0(:,1)=[];
    Tfix = max(T,0.001);
    
    % handles PGA ambiguity
    notnan =~isnan(sum(IM0,2));
    IM   = nan(size(IM0,1),length(Tfix));
    IM(notnan,:)   = exp(interp1(log(T0'),log(IM0(notnan,:)'),log(Tfix)','pchip'))';
    if any(T<0.001)
        II = ones(1,sum(T<0.001));
        IM(:,T<0.001)=IM0(:,II);
    end
    fclose(fid);
end
% IM = IM(IND0,:);
