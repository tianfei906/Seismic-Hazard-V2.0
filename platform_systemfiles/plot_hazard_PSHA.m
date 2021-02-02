function plot_hazard_PSHA(fig,haz,opt,isPCE,MRE,MREPCE,validation,weights,labelG,mech,idx,brnames,holdcolorbar)
            
ax2          = findall(fig,'tag','ax2');
addLeg       = findall(fig,'tag','addLeg');
ExportHazard = findall(fig,'tag','ExportHazard');

if isempty(MRE)
    return
end

ch=findall(ax2,'Type','line'); delete(ch);
ch=findall(fig,'type','legend');delete(ch);


if nargin ==12
   holdcolorbar=false;
end

if holdcolorbar==0
    ch=findall(fig,'tag','Colorbar'); delete(ch);
end

switch haz.mod
    case 1, [str,tit] = plotHazMode1(fig,haz,opt,isPCE,MRE,MREPCE,validation,weights,idx,brnames); % plots averaged seismic hazard
    case 2, [str,tit] = plotHazMode2(fig,haz,opt,MRE,labelG,mech,idx,brnames);                     % plots single branch hazard for GMMs of type REGULAR
    case 3, [str,tit] = plotHazMode3(fig,haz,opt,MREPCE,idx,brnames);                              % plots single branch hazard for GMMs of type PCE
end

Leg=legend(ax2,strrep(str,'_',' '));
Leg.Title.String=tit;

switch addLeg.Value
    case 0,Leg.Visible='off';
    case 1,Leg.Visible='on';
end
Leg.FontSize=8;
Leg.EdgeColor=[1 1 1];
Leg.Location='SouthWest';
Leg.Tag='hazardlegend';
set(ExportHazard,'enable','on');
