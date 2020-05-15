function [handles]=GMMValidation_Sadigh1997(handles,filename)

switch filename
    
    case 'Sadigh1997_1.png'
        handles.e2.String='1';  %Rrup
        handles.e3.Value=2;     % media:  1 deepsoil or 2 rock
        handles.e4.Value=1;     % mechanism: 
        
        handles.e1.String=5.5;   plotgmpe(handles);
        handles.e1.String=6.5;   plotgmpe(handles);
        handles.e1.String=7.5;   plotgmpe(handles);
        handles.e1.String=8.5;   plotgmpe(handles);
        handles.ax1.XLim=[0.01  10];
        handles.ax1.YLim=[0.0007 2];
        handles.ax1.XScale='log';
        handles.ax1.YScale='log';
        
    case 'Sadigh1997_2.png'
        handles.e2.String=10;  %Rrup
        handles.e3.Value=2;     % media:  1 deepsoil or 2 rock
        handles.e4.Value=1;     % mechanism: 
        handles.e1.String=5.5;   plotgmpe(handles);
        handles.e1.String=6.5;   plotgmpe(handles);
        handles.e1.String=7.5;   plotgmpe(handles);
        handles.e1.String=8.5;   plotgmpe(handles);
        handles.ax1.XLim=[0.01  10];
        handles.ax1.YLim=[0.0007 2];
        handles.ax1.XScale='log';
        handles.ax1.YScale='log';
        
    case 'Sadigh1997_3.png'
        handles.e2.String=30;  %Rrup
        handles.e3.Value=2;     % media:  1 deepsoil or 2 rock
        handles.e4.Value=1;     % mechanism: 
        handles.e1.String=5.5;   plotgmpe(handles);
        handles.e1.String=6.5;   plotgmpe(handles);
        handles.e1.String=7.5;   plotgmpe(handles);
        handles.e1.String=8.5;   plotgmpe(handles);
        handles.ax1.XLim=[0.01  10];
        handles.ax1.YLim=[0.0007 2];
        handles.ax1.XScale='log';
        handles.ax1.YScale='log';
        
    case 'Sadigh1997_4.png'
        handles.e2.String=70;  %Rrup
        handles.e3.Value=2;     % media:  1 deepsoil or 2 rock
        handles.e4.Value=1;     % mechanism: 
        
        handles.e1.String=5.5;   plotgmpe(handles);
        handles.e1.String=6.5;   plotgmpe(handles);
        handles.e1.String=7.5;   plotgmpe(handles);
        handles.e1.String=8.5;   plotgmpe(handles);
        handles.ax1.XLim=[0.01  10];
        handles.ax1.YLim=[0.0007 2];
        handles.ax1.XScale='log';
        handles.ax1.YScale='log';
        
end