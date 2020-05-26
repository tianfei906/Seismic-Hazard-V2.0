function VS30=getVs30(p,opt)

baseline = opt.baseline;
source   = opt.source;
Nsource  = length(source);
Nsites   = size(p,1);
VS30     = ones(Nsites,1)*baseline;

if Nsource ==1 && strcmp(source{1},' ')
    return
end

Lon = p(:,1);
Lat = p(:,2);

for i=Nsource:-1:1
    fname = opt.source{i};
    if contains(fname,'.kml')
        kml = kml2struct(fname);
        for jj=1:length(kml)
            vLon = kml(jj).Lon; vLon=vLon(~isnan(vLon));
            vLat = kml(jj).Lat; vLat=vLat(~isnan(vLat));
            IN  = inpolygon(Lon,Lat,vLon,vLat);
            if any(IN)
                VS30(IN)= str2double(kml(jj).Description);
            end
        end
        
    else
        DATA=load(fname);
        fldname = fields(DATA);
        fldname = fldname{1};
        
        switch fldname
            case 'raster' % tiff file (e.g., from USGS)
                source = DATA.raster; 
                Npoly = length(source);
                for j=1:Npoly
                    r = source(j);
                    IN  = inpolygon(Lat,Lon,r.box(:,2),r.box(:,1));
                    if any(IN)
                        img       = double(imread(r.tif));
                        lon       = linspace(r.box(1,1),r.box(2,1),r.nlon);
                        lat       = linspace(r.box(2,2),r.box(1,2),r.nlat);
                        [LON,LAT] = meshgrid(lon,lat);
                        VS30(IN)  = interp2(LON,LAT,img,Lon(IN),Lat(IN));
                    end
                end
            case 'microzone' %simple matfile
                source = DATA.microzone;
                Npoly = length(source);
                for j=1:Npoly
                    r = source(j);
                    IN  = inpolygon(Lon,Lat,r.Lon,r.Lat);
                    if any(IN)
                        VS30(IN)  = source(j).VS30;
                    end
                end
        end
    end
end

