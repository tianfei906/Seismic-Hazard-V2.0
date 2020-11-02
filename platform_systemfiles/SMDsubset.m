function[]=SMDsubset(handles)
ms   = handles.m;
mech = handles.uibuttongroup1.SelectedObject.String;
if ~strcmp(mech,'all')
    Bs   = strcmpi(ms.Etype,mech);
    ms   = ms(Bs,:);
end

% Filters
Mmin=0;   if ~isempty(handles.Mmin.String);Mmin = str2double(handles.Mmin.String);end
Mmax=inf; if ~isempty(handles.Mmax.String);Mmax = str2double(handles.Mmax.String);end
Rmin=0;   if ~isempty(handles.Rmin.String);Rmin = str2double(handles.Rmin.String);end
Rmax=inf; if ~isempty(handles.Rmax.String);Rmax = str2double(handles.Rmax.String);end
Dmin=0;   if ~isempty(handles.Dmin.String);Dmin = str2double(handles.Dmin.String);end
Dmax=inf; if ~isempty(handles.Dmax.String);Dmax = str2double(handles.Dmax.String);end
Vmin=0;   if ~isempty(handles.Vmin.String);Vmin = str2double(handles.Vmin.String);end
Vmax=inf; if ~isempty(handles.Vmax.String);Vmax = str2double(handles.Vmax.String);end
Fmin=datenum('1900-01-01'); if ~isempty(handles.Fmin.String);Fmin = datenum(handles.Fmin.String);end
Fmax=today;                 if ~isempty(handles.Fmax.String);Fmax = datenum(handles.Fmax.String);end

ind1 = and(ms.Mw   >=Mmin,ms.Mw   <=Mmax);
ind2 = and(ms.Rrup >=Rmin,ms.Rrup <=Rmax);
ind3 = and(ms.Depth>=Dmin,ms.Depth<=Dmax);
ind4 = and(ms.Vs30 >=Vmin,ms.Vs30 <=Vmax);
ind5 = and(ms.Starttime>= Fmin,ms.Starttime<=Fmax);

if handles.opt.none
    ind  = (ind1.*ind2.*ind3.*ind4.*ind5)==1;
else
    Amin   = handles.opt.scaleMin;
    Amax   = handles.opt.scaleMax;
    ssdmax = handles.opt.ssdMax;
    ind6   = and(ms.amp >=Amin,ms.amp<=Amax);
    ind7   = ms.ssd <=ssdmax;
    ind    = (ind1.*ind2.*ind3.*ind4.*ind5.*ind6.*ind7)==1;
end

ms   = ms(ind,:);
eqs  = unique(ms.EarthquakeName,'stable');
if isempty(eqs)
    handles.list1.String = cell(0,1);    
    handles.list1.Value  = 0;
    handles.t.Data       = cell(0,4);
else
    B                    = strcmp(ms.EarthquakeName,eqs{1});
    handles.t.Data       = [num2cell(ms.ID(B)),ms.Station(B),num2cell(ms.amp(B)),num2cell(ms.ssd(B))];
    handles.list1.Value  = 1;
    handles.list1.String = eqs;
end

handles.count1.String=sprintf('Count: %g',length(handles.list1.Value));
handles.count2.String=sprintf('Count: %g',size(handles.t.Data,1));