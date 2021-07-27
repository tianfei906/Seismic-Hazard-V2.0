function[]=sh_saveas(handles)

%% preprocess sourcenames
labG=vertcat(handles.sys.labelG{:});
nchar=0;
for i=1:numel(labG)
    nchar=max(nchar,numel(labG{i}));
end
labelG=handles.sys.labelG;
for i=1:numel(labelG)
    for j=1:numel(labelG{i})
        N = numel(labelG{i}{j});
        if N<nchar
            labelG{i}{j}=[labelG{i}{j},repmat(' ',1,nchar-N)];
        end
    end
end

filename='test.txt';
fid=fopen(filename,'w');

% Option 1
fprintf(fid,'Option 0 - Global Parameters\n');
fprintf(fid,'Projection   : %s\n',handles.P1_projection.String{handles.P1_projection.Value});
fprintf(fid,'Image        : %s\n',handles.P1_image.String);
fprintf(fid,'Boundary     : %s\n',handles.P1_boundary.String);
fprintf(fid,'ShearModulus : %s\n',handles.P1_shermodulus.String);
fprintf(fid,'IM           : %s\n',strjoin(handles.P1_IM.String,' '));

NIM = numel(handles.P1_IM.String);
str = cell(1,NIM);
switch handles.opt.immode
    case {1,2}
        for i=1:NIM
            str{i}=sprintf('logsp(%g,%g,%s)',handles.P1_imtable.Data{1,i},handles.P1_imtable.Data{end,i},handles.P1_NSamples.String);
        end
        if NIM==1
            fprintf(fid,'im           : %s\n',str{1});
        else
            fprintf(fid,'im           : %s\n',['[',strjoin(str,';'),']']);
        end
    case 3
        for i=1:NIM
            str{i}=sprintf(strjoin(handles.P1_imtable.Data(:,i),','));
        end
        fprintf(fid,'im           : %s\n',['[',strjoin(str,';'),']']);
end


fprintf(fid,'MaxDistance  : %s\n',handles.P1_maxdist.String);
if handles.P1_IS1.Value
    fprintf(fid,'MagDiscrete  : isampling %s\n',handles.P1_IS2.String{handles.P1_IS2.Value});
end

if handles.P1_GP1.Value
    fprintf(fid,'MagDiscrete  : gauss %s\n',handles.P1_GP2.String{handles.P1_GP2.Value});
end

if handles.P1_UNI1.Value
    fprintf(fid,'MagDiscrete  : uniform %s\n',handles.P1_UNI2.String);
end

if handles.P1_sigma1.Value
    fprintf(fid,'Sigma        : \n');
end

if handles.P1_sigmaOW1.Value
    fprintf(fid,'Sigma        : overwrite %s\n',handles.P1_sigmaOW2.String);
end

if handles.P1_sigmaTR1.Value
    fprintf(fid,'Sigma        : truncate %s\n',handles.P1_sigmaTR2.String);
end

if handles.P1_rad1.Value
    fprintf(fid,'PCE          : shuffle PC %s\n',handles.P1_PCErealizations.String);
end

if handles.P1_rad2.Value
    fprintf(fid,'PCE          : shuffle MC %s\n',handles.P1_PCErealizations.String);
end

fprintf(fid,'IM1          : %s\n',handles.P1_dsha1.String{1});
fprintf(fid,'IM2          : %s\n',strjoin(handles.P1_dsha2.String,' '));
fprintf(fid,'Spatial      : %s\n',handles.P1_dsha3.String{handles.P1_dsha3.Value});
fprintf(fid,'Spectral     : %s\n',handles.P1_dsha4.String{handles.P1_dsha4.Value});
switch handles.P1_SourceDeagg.Value
    case 0, fprintf(fid,'SourceDeagg  : off\n');
    case 1, fprintf(fid,'SourceDeagg  : on\n');
end

switch handles.P1_clusters1.Value
    case 0, fprintf(fid,'Clusters     : off %s 1\n',handles.P1_clusters2.String);
    case 1, fprintf(fid,'Clusters     : on %s 1\n',handles.P1_clusters2.String);
end

% Option 1
fprintf(fid,'\nOption 1 - Logic Tree Weights\n');
fprintf(fid,'Geom Weight : %s\n',strjoin(handles.P2_table1.Data(:,2),' '));
fprintf(fid,'Gmpe Weight : %s\n',strjoin(handles.P2_table2.Data(:,2),' '));
fprintf(fid,'Mscl Weight : %s\n',strjoin(handles.P2_table3.Data(:,2),' '));

% Source Geometry
fprintf(fid,'\nOption 2 - Source Geometry\n');
Ngeom = numel(handles.sys.source);
for i=1:Ngeom
    fprintf(fid,'geometry %g\n',i);
    for j=1:numel(handles.sys.source{i})
        source =handles.sys.source{i}{j};
        id     = labelG{i}{j};
        num    = source.num;
        if num(2)~=-999
            sof = rake2sof(num(2));
        else
            sof = '-999';
        end
        RA     = handles.P3_table.ColumnFormat{5}{num(3)};
        RAsig  = num(4);
        GMMptr = num(5);
        
        switch num(1)
            case 1,mech='interface';
            case 2,mech='intraslab';
            case 3,mech='crustal';
            case 8,mech='background';
        end
        commons= sprintf('%s %s %s %s %g %g',id,mech,sof,RA,RAsig,GMMptr);
        
        switch source.sourcetype
            case 1
                strike= num(6);
                dip   = num(7);
                vert = strjoin(num2cell(source.vert),' ');
                fprintf(fid,'point1 %s %g %g | %s\n',commons,strike,dip,vert);
            case 2
                dip   = num(6);
                Lmax  = num(7);
                Nref  = num(8);
                vert = source.vert(1:end-1,:)';
                vert = strjoin(num2cell(vert(:)'),' ');
                fprintf(fid,'line1 %s %g %g %g | %s\n',commons,dip,Lmax,Nref,vert);
            case 3.1
                Leng=num(6);
                Lmax=num(9);
                Nref=num(10);
                AvgD=num(11);
                switch num(12)
                    case 0,btype='leak';
                    case 1,btype='rigid';
                end
                vert = source.vert(1:end-2,:)';
                vert = strjoin(num2cell(vert(:)'),' ');
                
                fprintf(fid,'area1 %s %g %g %g %g %s | %s\n',commons,Leng,Lmax,Nref,AvgD,btype,vert);
            case 3.2
                dip   = num(6);
                USD   = num(7);
                LSD   = num(8);
                Lmax  = num(9);
                Nref  = num(10);
                AvgD  = num(11);
                switch num(12)
                    case 0,btype='leak';
                    case 1,btype='rigid';
                end
                vert = source.vert(1:(end-2)/2,1:2)';
                vert = strjoin(num2cell(vert(:)'),' ');
                fprintf(fid,'area1 %s %g %g %g %g %g %g %s | %s\n',commons,dip,USD,LSD,Lmax,Nref,AvgD,btype,vert);
                
            case 3.3
                AvgD  = num(11);
                switch num(12)
                    case 0,btype='leak';
                    case 1,btype='rigid';
                end
                adp=source.adp{1};
                fprintf(fid,'area1 %s %g %s | %s\n',commons,AvgD,btype,adp);
                
            case 4
                strike  = num(6);
                dip     = num(7);
                Leng    = num(8);
                Width   = num(9);
                RAratio = num(10);
                AvgD    = num(11);
                vert    = source.vert(1:end-2,:)';
                vert    = strjoin(num2cell(vert(:)'),' ');
                fprintf(fid,'area2 %s %g %g %g %g %g %g | %s\n',commons,strike,dip,Leng,Width,RAratio,AvgD,vert);
                
            case 5
                Lmax   = num(6);
                Nref   = num(7);
                Thick  = num(8);
                Slices = num(9);
                vert   = source.vert(1:end-2,:)';
                vert   = strjoin(num2cell(vert(:)'),' ');
                fprintf(fid,'volumne1 %s %g %g %g %g | %s\n',commons,Lmax,Nref,Thick,Slices,vert);
        end
        
    end
end

fprintf(fid,'\nOption 3 - GMPE Library\n');
gmmlib=handles.sys.gmmlib;
NAMES=char({gmmlib.label});
for i=1:numel(gmmlib)
    fprintf(fid,'gmm %s %s\n',NAMES(i,:),strjoin(gmmlib(i).txt(3:end),' '));
end

fprintf(fid,'\nOption 4 - GMPE GROUPS\n');
lab = {gmmlib.label};
gmmgroups = handles.P4_table.Data;
Ncols = size(gmmgroups,2);
for i=2:Ncols
    [~,B]=intersect(lab,gmmgroups(:,i),'stable');
    gmmgroups(:,i)=num2cell(B);
end
NAMES=char(gmmgroups(:,1));
for i=1:size(gmmgroups,1)
    fprintf(fid,'gmmgroup %s  %s\n',NAMES(i,:),strjoin(gmmgroups(i,2:end),' '));
end

fprintf(fid,'\nOption 5 - MAGNITUDE SCALING RELATIONS\n');
Nmscl = numel(handles.sys.mscl);
labG  = vertcat(labelG{:});
for i=1:Nmscl
    fprintf(fid,'seismicity %g\n',i);
    mscl = handles.sys.mscl{i};
    if ~strcmp(handles.P5_table.Data{i,2},'none')
       fprintf(fid,'catalog %s\n',strjoin(handles.P5_table.Data(i,:),' '));
    end
    for j=1:numel(mscl)
        num = mscl{j}.num;
        if all(~isnan(num(2:end)))
            switch mscl{j}.type
                case 1, formulation='delta';
                case 2, formulation='truncexp';
                case 3, formulation='truncnorm';
                case 4, formulation='wc1985';
            end
            
            switch num(1)
                case 1, rec='NM';
                case 2, rec='SR';
            end
            lab = labG{j};
            values = strjoin(num2cell(num(2:end)),' ');
            fprintf(fid,'%s %s %s %s\n',formulation,lab,rec,values);
        end
    end
end

fprintf(fid,'\nOption 6 - SITES\n');
NAMES = char(handles.h.id);
val   = handles.h.value;
sval  = cell(1,2*size(val,2));
sval(1:2:end)= handles.h.param;


for i=1:numel(handles.h.id)
    coord = strjoin(handles.h.p(i,:),' ');
    sval(2:2:end)=num2cell(handles.h.value(i,:));
    fprintf(fid,'%s %s %s\n',NAMES(i,:),coord,strjoin(sval,' '));
end

fprintf(fid,'\nOption 7 - Spacial distributed data\n');
fld=fields(handles.sys.layer);
for i=1:numel(fld)
    fprintf(fid,'layer %s %s\n',fld{i},strjoin(handles.sys.layer.(fld{i}),' '));
end

if ~isempty(handles.sys.validation)
    fprintf(fid,'\nOption 8 - Verification Hazard Curve (Optional)\n');
    for i=1:size(handles.sys.validation,1)
        fprintf(fid,'%s %s\n',handles.sys.validation_legend{i},strjoin(handles.sys.validation(i,:),' '));
    end
end

if ~isempty(handles.sys.event)
    fprintf(fid,'\nOption 9 - Event Simulation (optional)\n');
    for i=1:size(handles.sys.event,1)
        fprintf(fid,'%s\n',strjoin(handles.sys.event(i,:),' '));
    end
end

if handles.P10_Enable.Value==1
    fprintf(fid,'\nOption PSDA 1 - PSDA setup\n');
    fprintf(fid,'d         : logsp(%s,%s,%s) \n',handles.P10_Dmin.String,handles.P10_Dmax.String,handles.P10_Nsta.String);
    fprintf(fid,'realSa    : %s\n',handles.P10_realSa.String);
    fprintf(fid,'realD     : %s\n',handles.P10_realD.String);
    fprintf(fid,'rng       : %s\n','shuffle');
    fprintf(fid,'optimize  : %s\n','on');
    fprintf(fid,'kysamples : %s\n',handles.P10_ky.String);
    fprintf(fid,'Tssamples : %s\n',handles.P10_Ts.String);
    
    fprintf(fid,'\nOption PSDA 2 Library of Slope Displacement Models\n');
    smlib=handles.smlib;
    Nlib=numel(smlib);
    NAME = char(smlib.label);
    FORM = char(smlib.formulation);
    for i=1:Nlib
        st =sprintf('psda %s %s %s',NAME(i,:),FORM(i,:),strjoin(smlib(i).param,' '));
        fprintf(fid,'%s\n',strtrim(st));
    end
    
    if ~isempty(handles.P10_table.Data)
        fprintf(fid,'\nOption PSDA 3 Slope Displacement Models\n');
        COL1=char(handles.P10_table.Data(:,1));
        COL2=char(handles.P10_table.Data(:,2));
        COL3=char(handles.P10_table.Data(:,3));
        COL4=char(handles.P10_table.Data(:,4));
        COL5=char(handles.P10_table.Data(:,5));
        COL6=cell2mat(handles.P10_table.Data(:,6));
        for i=1:size(handles.P10_table.Data,1)
            s=strjoin({COL1(i,:),COL2(i,:),COL3(i,:),COL4(i,:),COL5(i,:),COL6(i,:)},' ');
            fprintf(fid,'%s\n',strtrim(s));
        end        
    end
    
    if ~isempty(handles.P10_table2.Data)
        fprintf(fid,'\nOption PSDA 4 Slope Displacement Models with PC\n');
        COL1=char(handles.P10_table2.Data(:,1));
        COL2=char(handles.P10_table2.Data(:,2));
        COL3=char(handles.P10_table2.Data(:,3));
        COL4=char(handles.P10_table2.Data(:,4));
        COL5=char(handles.P10_table2.Data(:,5));
        COL6=char(handles.P10_table2.Data(:,6));
        for i=1:size(handles.P10_table2.Data,1)
            s=strjoin({COL1(1,:),'hazard',COL2(1,:),COL3(1,:),COL4(1,:),COL5(1,:),COL6(1,:)},' ');
            s=strrep(s,',',' ');
            fprintf(fid,'%s\n',strtrim(s));
        end
    end    
    
end

if handles.P11_Enable.Value==1
    fprintf(fid,'\nOption LIBS 1 - Liquefaction Analysis Options\n');
    fprintf(fid,'analysis   : FPBBA              # FPBBA or PBPA\n');
    fprintf(fid,'settlement : logsp(%s,%s,%s) \n',handles.P11_Smin.String,handles.P11_Smax.String,handles.P11_Nsta.String);
    fprintf(fid,'tilt       : %s\n','logsp(1,40,20)     # degrees');
    fprintf(fid,'nQ         : %s\n',handles.P11_Qsamples.String);
    fprintf(fid,'corr       : %s\n',handles.P11_corrmodel.String{handles.P11_corrmodel.Value});
    fprintf(fid,'pypath     : %s\n','"C:/Users/gcandia/AppData/Local/Programs/Python/Python36/python.exe"');
  
    fprintf(fid,'\nOption LIBS 2 - Building and Site Specific Parameters\n');
    data=handles.P11_CPT.Data;
    NAME=char(data(:,1));
    CPT =char(data(:,2));
    for i=1:size(data,1)
        s=strtrim(strjoin({NAME(i,:),CPT(i,:)},' '));
        fprintf(fid,'%s\n',s);
    end
    
    fprintf(fid,'\nOption LIBS 3 Settlement model library\n');
    setlib=handles.setlib;
    Nlib=numel(setlib);
    NAME = char(setlib.label);
    FORM = char(setlib.formulation);
    for i=1:Nlib
        st =sprintf('libs %s %s',NAME(i,:),FORM(i,:));
        fprintf(fid,'%s\n',strtrim(st));
    end
    
    fprintf(fid,'\nOption LIBS 4 - Settlement branches\n');
    COL1=char(handles.P11_table.Data(:,1));
    COL2=char(handles.P11_table.Data(:,2));
    COL3=char(handles.P11_table.Data(:,3));
    COL4=char(handles.P11_table.Data(:,4));
    COL5=char(handles.P11_table.Data(:,5));
    COL6=cell2mat(handles.P11_table.Data(:,6));
    for i=1:size(handles.P11_table.Data,1)
        s=strjoin({COL1(i,:),COL2(i,:),COL3(i,:),COL4(i,:),COL5(i,:),COL6(i,:)},' ');
        fprintf(fid,'%s\n',strtrim(s));
    end
    
end

fclose(fid);
winopen(filename)
