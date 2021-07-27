function[smlib]=sh_addnewPSDA(handles,sh_mode)

if isempty(handles.P10_list.Value)
    return
end
ME = pshatoolbox_methods(5,handles.P10_e2.Value);
newsmlib= struct('label',[],'formulation',[],'param',[]);
newsmlib.label=handles.P10_e1.String;
newsmlib.formulation=ME.str;

oldnames={handles.smlib.label}';

switch ME.str
    
    case 'BMT2017_cdmM'
        newsmlib.param={handles.P10_e3.String{handles.P10_e3.Value},handles.P10_e4.String{handles.P10_e4.Value}};
        
    case 'BT2007_cdm'
        newsmlib.param={handles.P10_e3.String{handles.P10_e3.Value},handles.P10_e4.String{handles.P10_e4.Value}};
        
    case 'BT2007_cdmM'
        newsmlib.param={handles.P10_e3.String{handles.P10_e3.Value},handles.P10_e4.String{handles.P10_e4.Value}};
        
    case 'RA2011'
	    newsmlib.param={handles.P10_e3.String,handles.P10_e4.String,handles.P10_e5.String,handles.P10_e6.String,handles.P10_e7.String};
    case 'RS09V'
        newsmlib.param={handles.P10_e3.String};
end

smlib=handles.smlib;

switch sh_mode
    case 'add',    smlib(end+1)=newsmlib;
    case 'update', smlib(handles.P10_list.Value)=newsmlib;
end

handles.P10_list.String={smlib.label};

% update P10_table
handles.P10_table.ColumnFormat{:,2}={smlib.label};
handles.P10_table.ColumnFormat{:,3}={smlib.label};
handles.P10_table.ColumnFormat{:,4}={smlib.label};
handles.P10_table.ColumnFormat{:,5}={smlib.label};

a=setdiff(oldnames,{smlib.label}');
if ~isempty(a)
    c=strcmp(handles.P10_table.Data(:,2:5),a{1});
    for i=1:size(c,1)
        for j=1:size(c,2)
            if c(i,j)
                handles.P10_table.Data{i,j+1}=newsmlib.label;
            end
        end
    end
end