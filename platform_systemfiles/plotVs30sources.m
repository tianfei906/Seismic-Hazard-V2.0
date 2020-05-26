function plotVs30sources(handles)

if strcmp(handles.VS30.source,' ')
    delete(findall(handles.ax1,'tag','microzone'))
    delete(findall(handles.ax1,'tag','raster'))
    return
end

for jj = 1:length(handles.VS30.source)
    fname = handles.VS30.source{jj};
    [~,~,ex]=fileparts(fname);
    
    switch ex
        case '.mat'
            DATA = load(fname);
            if isfield(DATA,'microzone')
                for i=1:length(DATA.microzone)
                    LAT=DATA.microzone(i).Lat;LAT(isnan(LAT))=[];
                    LON=DATA.microzone(i).Lon;LON(isnan(LON))=[];
                    VS30=DATA.microzone(i).Vs30;
                    col=getpatchcolor(VS30);
                    patch(handles.ax1,LON,LAT,col,'tag','microzone','visible','off')
                end
            end
            if isfield(DATA,'raster')
                for i=1:length(DATA.raster)
                    LON = DATA.raster(i).box([1 2 2 1],1);
                    LAT = DATA.raster(i).box([1 1 2 2],2);
                    patch(handles.ax1,LON,LAT,[0.92941       0.6902      0.12941],'facealpha',0.3,'tag','raster','visible','off','edgecolor','k')
                end
            end
        case '.kml'
          DATA = kml2struct(fname);  
          for i=1:length(DATA)
              LAT=DATA(i).Lat;LAT(isnan(LAT))=[];
              LON=DATA(i).Lon;LON(isnan(LON))=[];
              VS30=str2double(DATA(i).Description);
              col=getpatchcolor(VS30);
              patch(handles.ax1,LON,LAT,col,'tag','microzone','visible','off')
          end
    end
end


function [c]=getpatchcolor(Vs30)

if         900<=Vs30            , c = [0 0.6 0];
elseif and(500<=Vs30,Vs30<900)  , c = [0.4824 0.8078 0.1569];
elseif and(350<=Vs30,Vs30<500)  , c = [1 1 0];
elseif and(180<=Vs30,Vs30<350)  , c = [1 0.6 0.2];
elseif Vs30<180                 , c = [1 0 0];
end

