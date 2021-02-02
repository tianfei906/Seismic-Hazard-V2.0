function layering = CPT_API(python_path,path)
layerno =-999;
run_com = strcat(python_path, " run_analysis.py ",   path,  " ",string(layerno));
disp(run_com)
system(run_com);
layering = readtable('total_boundary.csv');
end