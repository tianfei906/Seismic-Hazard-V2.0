function[]=sh_adddefaultPSDA(handles,value)

ME = pshatoolbox_methods(5,value);

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


switch ME.str
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
        handles.P10_e3.Value=1;
        handles.P10_e4.Value=1;
        
    case 'BT2007_cdm'
        handles.P10_t3.Visible='on';handles.P10_t3.String='Hazard';
        handles.P10_t4.Visible='on';handles.P10_t4.String='Integration';
        handles.P10_e3.Visible='on';handles.P10_e3.Style='popupmenu';handles.P10_e3.String={'full','average'};
        handles.P10_e4.Visible='on';handles.P10_e4.Style='popupmenu';handles.P10_e4.String={'PC','MC'};
        handles.P10_e3.Value=1;
        handles.P10_e4.Value=1;
        
    case 'BT2007_cdmM'
        handles.P10_t3.Visible='on';handles.P10_t3.String='Hazard';
        handles.P10_t4.Visible='on';handles.P10_t4.String='Integration';
        handles.P10_e3.Visible='on';handles.P10_e3.Style='popupmenu';handles.P10_e3.String={'full','average'};
        handles.P10_e4.Visible='on';handles.P10_e4.Style='popupmenu';handles.P10_e4.String={'PC','MC'};
        handles.P10_e3.Value=1;
        handles.P10_e4.Value=1;
        
    case 'RA2011'
        handles.P10_t3.Visible='on';handles.P10_t3.String='rho(PGA,PGV)';
        handles.P10_t4.Visible='on';handles.P10_t4.String='rhok(PGA,PGV)';
        handles.P10_t5.Visible='on';handles.P10_t5.String='Tm (s)';
        handles.P10_t6.Visible='on';handles.P10_t6.String='Tm cov';
        handles.P10_t7.Visible='on';handles.P10_t7.String='Tm samples';
        handles.P10_e3.Visible='on';handles.P10_e3.String=0.6;
        handles.P10_e4.Visible='on';handles.P10_e4.String=0.6;
        handles.P10_e5.Visible='on';handles.P10_e5.String=0.5;
        handles.P10_e6.Visible='on';handles.P10_e6.String=0.1;
        handles.P10_e7.Visible='on';handles.P10_e7.String=1;
        
    case 'RS09V'
        handles.P10_t3.Visible='on';handles.P10_t3.String='rho(PGA,PGV)';
        handles.P10_e3.Visible='on';handles.P10_e3.String=0.6;
        
end