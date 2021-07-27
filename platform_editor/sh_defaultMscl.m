function sh_defaultMscl(handles,value)

% mscl = handles.sys.mscl{handles.P5_pop1.Value}{value};
% num  = mscl.num;

handles.P5_t4.Visible = 'off';
handles.P5_t5.Visible = 'off';
handles.P5_t6.Visible = 'off';

handles.P5_e4.Visible = 'off';
handles.P5_e5.Visible = 'off';
handles.P5_e6.Visible = 'off';

handles.P5_e1.Value  = 1;
handles.P5_e2.String = 1;
handles.P5_t2.String = 'Rate (events/yr)';

switch value
    case 1 % delta
        handles.P5_t3.String = 'Mchar';
        handles.P5_e3.String = 7;
        
    case 2 % truncexp
        handles.P5_t3.String = 'b-value';
        handles.P5_t4.Visible = 'on'; handles.P5_t4.String = 'Mmin';
        handles.P5_t5.Visible = 'on'; handles.P5_t5.String = 'Mmax';
        handles.P5_e3.String = 1;
        handles.P5_e4.Visible = 'on'; handles.P5_e4.String = 5;
        handles.P5_e5.Visible = 'on'; handles.P5_e5.String = 7.5;
        
    case 3 % truncnorm
        handles.P5_t3.String = 'Mmin';
        handles.P5_t4.Visible = 'on'; handles.P5_t4.String = 'Mmax';
        handles.P5_t5.Visible = 'on'; handles.P5_t5.String = 'Mchar';
        handles.P5_t6.Visible = 'on'; handles.P5_t6.String = 'sigmaM';
        handles.P5_e3.String = 1;
        handles.P5_e4.Visible = 'on'; handles.P5_e4.String = 7.5;
        handles.P5_e5.Visible = 'on'; handles.P5_e5.String = 7;
        handles.P5_e6.Visible = 'on'; handles.P5_e6.String = 0.25;
        
    case 4 % yc1985
        handles.P5_t3.String = 'b-value';
        handles.P5_t4.Visible = 'on'; handles.P5_t4.String = 'Mmin';
        handles.P5_t5.Visible = 'on'; handles.P5_t5.String = 'Mchar';
        handles.P5_e3.String = 1;
        handles.P5_e4.Visible = 'on'; handles.P5_e4.String = 5;
        handles.P5_e5.Visible = 'on'; handles.P5_e5.String = 7.5;
end

