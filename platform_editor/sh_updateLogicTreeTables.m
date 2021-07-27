function handles=sh_updateLogicTreeTables(handles)

w=cell2mat(handles.P2_table1.Data(:,2)); w=w/sum(w); handles.P2_table1.Data(:,2)=num2cell(w);
w=cell2mat(handles.P2_table2.Data(:,2)); w=w/sum(w); handles.P2_table2.Data(:,2)=num2cell(w);
w=cell2mat(handles.P2_table3.Data(:,2)); w=w/sum(w); handles.P2_table3.Data(:,2)=num2cell(w);

geom_weight = cell2mat(handles.P2_table1.Data(:,2)); Ngeom = length(geom_weight);
gmpe_weight = cell2mat(handles.P2_table2.Data(:,2)); Ngmpe = length(gmpe_weight);
mscl_weight = cell2mat(handles.P2_table3.Data(:,2)); Nmscl = length(mscl_weight);

[iZ,iY,iX] = meshgrid(1:Nmscl,1:Ngmpe,1:Ngeom);
branch = [iX(:),iY(:),iZ(:)];
N0     = size(branch,1);
weight = [
    geom_weight(branch(:,1)),...
    gmpe_weight(branch(:,2)),...
    mscl_weight(branch(:,3))];
weight  = prod(weight,2);
handles.P2_table4.Data=[compose('Branch %g',(1:N0)'),num2cell([branch,weight])];