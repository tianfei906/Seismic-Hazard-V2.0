function[]=sh_fillPSDA(handles,value)

if isempty(value)
    return
end
ME = pshatoolbox_methods(5);

smlib=handles.smlib(value);

handles.P10_e1.String=smlib.label;
[~,handles.P10_e2.Value]=intersect({ME.str},smlib.formulation,'stable');

handles.P10_t3.Visible='off';
handles.P10_t4.Visible='off';
handles.P10_t5.Visible='off';
handles.P10_t6.Visible='off';
handles.P10_t7.Visible='off';

handles.P10_e3.Visible='off'; handles.P10_e3.Style='edit';
handles.P10_e4.Visible='off'; handles.P10_e4.Style='edit';
handles.P10_e5.Visible='off';
handles.P10_e6.Visible='off';
handles.P10_e7.Visible='off';


switch smlib.formulation
    %     case 'BMT2017M'
    %     case 'BT2007'
    %     case 'BT2007M'
    %     case 'BM2019M'
    %     case 'J07M'
    %     case 'J07Ia'
    %     case 'RS09M'
    %     case 'AM1988'
    %     case 'psda_null'
    
    case 'BMT2017_cdmM'
        handles.P10_t3.Visible='on';handles.P10_t3.String='Hazard';
        handles.P10_t4.Visible='on';handles.P10_t4.String='Integration';
        handles.P10_e3.Visible='on';handles.P10_e3.Style='popupmenu';handles.P10_e3.String={'full','average'};
        handles.P10_e4.Visible='on';handles.P10_e4.Style='popupmenu';handles.P10_e4.String={'PC','MC'};
        [~,handles.P10_e3.Value]=intersect(handles.P10_e3.String,smlib.param{1});
        [~,handles.P10_e4.Value]=intersect(handles.P10_e4.String,smlib.param{2});
        
    case 'BT2007_cdm'
        handles.P10_t3.Visible='on';handles.P10_t3.String='Hazard';
        handles.P10_t4.Visible='on';handles.P10_t4.String='Integration';
        handles.P10_e3.Visible='on';handles.P10_e3.Style='popupmenu';handles.P10_e3.String={'full','average'};
        handles.P10_e4.Visible='on';handles.P10_e4.Style='popupmenu';handles.P10_e4.String={'PC','MC'};
        [~,handles.P10_e3.Value]=intersect(handles.P10_e3.String,smlib.param{1});
        [~,handles.P10_e4.Value]=intersect(handles.P10_e4.String,smlib.param{2});
        
    case 'BT2007_cdmM'
        handles.P10_t3.Visible='on';handles.P10_t3.String='Hazard';
        handles.P10_t4.Visible='on';handles.P10_t4.String='Integration';
        handles.P10_e3.Visible='on';handles.P10_e3.Style='popupmenu';handles.P10_e3.String={'full','average'};
        handles.P10_e4.Visible='on';handles.P10_e4.Style='popupmenu';handles.P10_e4.String={'PC','MC'};
        [~,handles.P10_e3.Value]=intersect(handles.P10_e3.String,smlib.param{1});
        [~,handles.P10_e4.Value]=intersect(handles.P10_e4.String,smlib.param{2});
        
    case 'RA2011'
        handles.P10_t3.Visible='on';handles.P10_t3.String='rho(PGA,PGV)';
        handles.P10_t4.Visible='on';handles.P10_t4.String='rhok(PGA,PGV)';
        handles.P10_t5.Visible='on';handles.P10_t5.String='Tm (s)';
        handles.P10_t6.Visible='on';handles.P10_t6.String='Tm cov';
        handles.P10_t7.Visible='on';handles.P10_t7.String='Tm samples';
        handles.P10_e3.Visible='on';handles.P10_e3.String=smlib.param{1};
        handles.P10_e4.Visible='on';handles.P10_e4.String=smlib.param{2};
        handles.P10_e5.Visible='on';handles.P10_e5.String=smlib.param{3};
        handles.P10_e6.Visible='on';handles.P10_e6.String=smlib.param{4};
        handles.P10_e7.Visible='on';handles.P10_e7.String=smlib.param{5};
        
    case 'RS09V'
        handles.P10_t3.Visible='on';handles.P10_t3.String='rho(PGA,PGV)';
        handles.P10_e3.Visible='on';handles.P10_e3.String=smlib.param{1};
        
end