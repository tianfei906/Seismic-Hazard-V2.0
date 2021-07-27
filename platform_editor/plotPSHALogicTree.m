function plotPSHALogicTree(handles)
delete(findall(handles.P2_ax1,'tag','logic'));
handles.P2_ax1.ColorOrderIndex=1;

N1 = size(handles.P2_table1.Data,1);
N2 = size(handles.P2_table2.Data,1);
N3 = size(handles.P2_table3.Data,1);

x1  = [0 1 2];  LT1 = buildLTLine(x1,N1);
x2  = x1+3;     LT2 = buildLTLine(x2,N2);
x3  = x1+6;     LT3 = buildLTLine(x3,N3);


plot(handles.P2_ax1,LT1(:,1),LT1(:,2),'.-','tag','logic'),handles.P2_ax1.ColorOrderIndex=1;
plot(handles.P2_ax1,LT2(:,1),LT2(:,2),'.-','tag','logic'),handles.P2_ax1.ColorOrderIndex=1;
plot(handles.P2_ax1,LT3(:,1),LT3(:,2),'.-','tag','logic'),handles.P2_ax1.ColorOrderIndex=1;
axis(handles.P2_ax1,'tight')

function LT = buildLTLine(x,N)
if N==1
    y  = 0;
else
    y  = linspace(-1,1,N);
end
LT = [x(1) 0;NaN NaN];
for i=1:N
    nLT = [x(1) 0;x(2) y(i);x(3) y(i);NaN NaN];
    LT  = [LT;nLT]; %#ok<*AGROW>
end