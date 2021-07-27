function[]=sh_fillLIBS(handles,value)

if isempty(value)
    return
end
ME = pshatoolbox_methods(6);
setlib=handles.setlib(value);

handles.P11_e1.String=setlib.label;
[~,handles.P11_e2.Value]=intersect({ME.str},setlib.formulation,'stable');
