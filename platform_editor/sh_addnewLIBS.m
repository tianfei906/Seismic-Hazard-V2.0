function[setlib]=sh_addnewLIBS(handles,sh_mode)

if isempty(handles.P11_list.Value)
    return
end

ME = pshatoolbox_methods(6,handles.P11_e2.Value);
newsetlib= struct('label',[],'formulation',[]);
newsetlib.label=handles.P11_e1.String;
newsetlib.formulation=ME.str;

oldnames={handles.setlib.label}';
setlib=handles.setlib;

switch sh_mode
    case 'add',    setlib(end+1)=newsetlib;
    case 'update', setlib(handles.P11_list.Value)=newsetlib;
end

handles.P11_list.String={setlib.label};

% update P11_table
handles.P11_table.ColumnFormat{:,2}={setlib.label};
handles.P11_table.ColumnFormat{:,3}={setlib.label};
handles.P11_table.ColumnFormat{:,4}={setlib.label};
handles.P11_table.ColumnFormat{:,5}={setlib.label};

a=setdiff(oldnames,{setlib.label}');
if ~isempty(a)
    c=strcmp(handles.P11_table.Data(:,2:5),a{1});
    for i=1:size(c,1)
        for j=1:size(c,2)
            if c(i,j)
                handles.P11_table.Data{i,j+1}=newsetlib.label;
            end
        end
    end
end