function[line1]=read_line1(t)

t=strrep(t,'line1 ','');
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
Np=length(t);
txt   = cell(Np,1);
num   = zeros(Np,8);
vert  = cell(Np,1);
vptr  = zeros(Np,2);
node2 = 0;
for i=1:Np
     node1 = node2+1;
     D=regexp(t{i},'\ ','split');
     txt{i}  = D{1};
     lv      = str2double(D(10:end));
     Nnodes  = numel(lv)/3;
     lv      = reshape(lv,3,Nnodes)';
     vert{i} = [lv;nan nan nan];
     num(i,:)= str2double(D(2:9));

    node2    = size(vertcat(vert{:}),1);
    vptr(i,:)= [node1 node2-1];     
end

line1 = createObj('source');
line1.txt = txt;
line1.num  = num;
line1.vert = vertcat(vert{:});
line1.vptr = vptr;

