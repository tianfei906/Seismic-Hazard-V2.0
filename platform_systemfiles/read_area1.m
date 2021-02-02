function[area1]=read_area1(t,ellipsoid)

t=strrep(t,'area1 ','');
t=strrep(t,' | ',' ');
t=strrep(t,' interface '       ,' 1 ');
t=strrep(t,' intraslab '       ,' 2 ');
t=strrep(t,' crustal '         ,' 3 ');
t=strrep(t,' strike-slip '     ,' 0 ');
t=strrep(t,' normal '          ,' -90 ');
t=strrep(t,' normal-oblique '  ,' -45 ');
t=strrep(t,' reverse '         ,' 90 ');
t=strrep(t,' reverse-oblique ' ,' 45 ');
t=strrep(t,' null '            ,' 1 ');
t=strrep(t,' wc1994 '          ,' 2 ');
t=strrep(t,' ellsworth '       ,' 3 ');
t=strrep(t,' hanksbakun2001 '  ,' 4 ');
t=strrep(t,' somerville1999 '  ,' 5 ');
t=strrep(t,' wc1994r '         ,' 6 ');
t=strrep(t,' wc1994s '         ,' 7 ');
t=strrep(t,' strasser2010 '    ,' 8 ');

Np    = length(t);
txt   = cell(Np,1);
num   = zeros(Np,11);
vert  = cell(Np,1);
vptr  = zeros(Np,2);
adp   = cell(Np,1);
node2 = 0;
for i=1:Np
    node1 = node2+1;
    D      = regexp(t{i},'\ ','split');
    [~,B]  = intersect(D,{'leak','rigid'});
    txt{i} = D{1};
    
    if B==9  % 3D polygone
        lv      = str2double(D(10:end));
        Nnodes  = numel(lv)/3;
        lv      = reshape(lv,3,Nnodes)';
        vert{i} = [lv;lv(1,:);nan nan nan];
        switch D{9}
            case 'leak'  , num(i,:)= [str2double(D(2:6)) nan nan nan str2double(D(7:8)) 0];
            case 'rigid' , num(i,:)= [str2double(D(2:6)) nan nan nan str2double(D(7:8)) 1];
        end
        vptr(i,:)=[node1 node2];
    end
    
    if B==12 % trace + USD + LSD
        lv      = str2double(D(13:end));
        Nnodes  = numel(lv)/2;
        
        switch D{12}
            case 'leak'  , num(i,:)= [str2double(D(2:11)) 0];
            case 'rigid' , num(i,:)= [str2double(D(2:11)) 1];
        end        
        
        DIP     = num(i,6);
        USD     = num(i,7);
        LSD     = num(i,8);
        lv      = reshape(lv,2,Nnodes)';
        lv0     = area2convert(lv,DIP,USD,LSD,ellipsoid);
        vert{i} = [lv0;lv0(1,:);nan nan nan];
    end
    
    if B==7  % from matfile
        adp{i} = D{8};
        switch D{7}
            case 'leak'  , num(i,:)= [str2double(D(2:6)),nan(1,5), 0];
            case 'rigid' , num(i,:)= [str2double(D(2:6)),nan(1,5), 1];
        end        
        load(adp{i},'geom')
        vert{i} = [geom.vertices;geom.vertices(1,:);nan nan nan];
    end
    
    node2    = size(vertcat(vert{:}),1);
    vptr(i,:)=[node1 node2-2];
end
area1 = createObj('source');
area1.txt  = txt;
area1.num  = num;
area1.vert = vertcat(vert{:});
area1.vptr = vptr;
area1.adp  = adp;
