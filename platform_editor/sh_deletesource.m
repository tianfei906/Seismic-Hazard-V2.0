function[sys]=sh_deletesource(sys,geom,index)

sourcetype=sys.source{geom}{index}.sourcetype;

if sourcetype>=3
    delete(sys.source{geom}{index}.handle_depth);
end

if sourcetype>=2
    delete(sys.source{geom}{index}.handle_mesh);
end
delete(sys.source{geom}{index}.handle_edge);
delete(sys.source{geom}{index}.handle_txt);

sys.source{geom}(index)=[];
sys.labelG{geom}(index)=[];
sys.numG{geom}(index)  =[];
