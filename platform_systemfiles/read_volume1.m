function[volume1]=read_volume1(t)

t=strrep(t,'volume1 ','');
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
%
Np    = length(t);
txt   = cell(Np,1);
num   = zeros(Np,9);
vert  = cell(Np,1);
vptr  = zeros(Np,2);
node2 = 0;
for i=1:Np
    node1 = node2+1;
    D=regexp(t{i},'\ ','split');
    txt{i} = D{1};
    lv        = str2double(D(11:end));
    Nnodes    = numel(lv)/3;
    lv0       = reshape(lv,3,Nnodes)';
    vert{i}   = [lv0;lv0(1,:);nan nan nan];
    num(i,:)  = str2double(D(2:10));
    node2     = size(vertcat(vert{:}),1);
    vptr(i,:) = [node1 node2-2];        
end
volume1 = createObj('source');
volume1.txt  = txt;
volume1.num  = num;
volume1.vert = vertcat(vert{:});
volume1.vptr = vptr;

