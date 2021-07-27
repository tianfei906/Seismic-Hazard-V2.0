function sh_viewMscl(handles,value,forceuser)

if nargin==2
    forceuser=false;
end


mscl = handles.sys.mscl{handles.P5_pop1.Value}{value};
num  = mscl.num;

if forceuser==0
    if all(isnan(num(2:end)))
        handles.P5_datasource.Value=2;
    else
        handles.P5_datasource.Value=1;
    end
end
    
handles.P5_t1.Visible = 'off';
handles.P5_t2.Visible = 'off';
handles.P5_t3.Visible = 'off';
handles.P5_t4.Visible = 'off';
handles.P5_t5.Visible = 'off';
handles.P5_t6.Visible = 'off';

handles.P5_e1.Visible = 'off';
handles.P5_e2.Visible = 'off';
handles.P5_e3.Visible = 'off';
handles.P5_e4.Visible = 'off';
handles.P5_e5.Visible = 'off';
handles.P5_e6.Visible = 'off';

handles.P5_formulation.Value=mscl.type;

switch num(1)
    case 1, t2value = 'Rate (events/yr)';
    case 2, t2value = 'Rate (mm/yr)';
end

switch handles.P5_datasource.Value
    case 1, VIS  ='on';
    case 2, VIS  ='off';
end


handles.P5_formulationtext.Visible = VIS;
handles.P5_formulation.Visible        = VIS;

switch mscl.type
    case 1 % delta
        handles.P5_t1.Visible = VIS;
        handles.P5_t2.Visible = VIS; handles.P5_t2.String = t2value;
        handles.P5_t3.Visible = VIS; handles.P5_t3.String = 'Mchar';
        
        handles.P5_e1.Visible = VIS; handles.P5_e1.Value  = num(1);
        handles.P5_e2.Visible = VIS; handles.P5_e2.String = num(2);        
        handles.P5_e3.Visible = VIS; handles.P5_e3.String = num(3);
        
    case 2 % truncexp
        handles.P5_t1.Visible = VIS;
        handles.P5_t2.Visible = VIS; handles.P5_t2.String = t2value;
        handles.P5_t3.Visible = VIS; handles.P5_t3.String = 'b-value';
        handles.P5_t4.Visible = VIS; handles.P5_t4.String = 'Mmin';
        handles.P5_t5.Visible = VIS; handles.P5_t5.String = 'Mmax';
        
        handles.P5_e1.Visible = VIS; handles.P5_e1.Value  = num(1);
        handles.P5_e2.Visible = VIS; handles.P5_e2.String = num(2);
        handles.P5_e3.Visible = VIS; handles.P5_e3.String = num(3);
        handles.P5_e4.Visible = VIS; handles.P5_e4.String = num(4);
        handles.P5_e5.Visible = VIS; handles.P5_e5.String = num(5);
        
    case 3 % truncnorm
        handles.P5_t1.Visible = VIS; 
        handles.P5_t2.Visible = VIS; handles.P5_t2.String = t2value;
        handles.P5_t3.Visible = VIS; handles.P5_t3.String = 'Mmin';
        handles.P5_t4.Visible = VIS; handles.P5_t4.String = 'Mmax';
        handles.P5_t5.Visible = VIS; handles.P5_t5.String = 'Mchar';
        handles.P5_t6.Visible = VIS; handles.P5_t6.String = 'sigmaM';
        
        handles.P5_e1.Visible = VIS; handles.P5_e1.Value  = num(1);
        handles.P5_e2.Visible = VIS; handles.P5_e2.String = num(2);
        handles.P5_e3.Visible = VIS; handles.P5_e3.String = num(3);
        handles.P5_e4.Visible = VIS; handles.P5_e4.String = num(4);
        handles.P5_e5.Visible = VIS; handles.P5_e5.String = num(5);
        handles.P5_e6.Visible = VIS; handles.P5_e6.String = num(6);
        
    case 4 % yc1985
        handles.P5_t2.Visible = VIS; handles.P5_t2.String = t2value;
        handles.P5_t3.Visible = VIS; handles.P5_t3.String = 'b-value';
        handles.P5_t4.Visible = VIS; handles.P5_t4.String = 'Mmin';
        handles.P5_t5.Visible = VIS; handles.P5_t5.String = 'Mchar';
        
        handles.P5_e1.Visible = VIS; handles.P5_e1.Value  = num(1);
        handles.P5_e2.Visible = VIS; handles.P5_e2.String = num(2);
        handles.P5_e3.Visible = VIS; handles.P5_e3.String = num(3);
        handles.P5_e4.Visible = VIS; handles.P5_e4.String = num(4);
        handles.P5_e5.Visible = VIS; handles.P5_e5.String = num(5);
end



