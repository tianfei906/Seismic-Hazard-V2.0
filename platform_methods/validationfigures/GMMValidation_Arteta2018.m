function [handles]=GMMValidation_Arteta2018(handles,filename)

switch filename
    case 'Arteta2018_1.png'
        % Figure 10a from Abrahamson 2016
        handles.e1.String=7.2;
        handles.e2.String=120;
        handles.e3.Value=1;
        handles.e3.Value=1;
        handles.epsilon = [-1 0 1];
        plotgmpe(handles);
        handles.ax1.XLim=[0.01 10];
        handles.ax1.YLim=[0.0001 1];
        handles.ax1.XScale='log';
        handles.ax1.YScale='log';
end