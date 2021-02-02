function[p2]=mGMPEupdateparam_cond(t1,p1,t2,p2)

% updates p2 with the corresponding values in p1
t1 = lower(t1);
t2 = lower(t2);
Np2 = numel(p2);

% --------- change to vs30 -------------- 
t2 = strrep(t2,'media','vs30');

for i=1:Np2
    t2i = t2{i};
    if ismember(t2i,t1) && ~strcmp(t2i,'region')
        [~,B]=intersect(t1,t2i);
        p2{i}=p1{B};
    end
end
