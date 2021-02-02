function plotSBT(ax,SBT,z)

z1 = z-mean(diff(z))/2;
z2 = z+mean(diff(z))/2;
x0 = zeros(size(z));

COL = [255	0	0
158	89	46
61	92	143
0	153	153
112	202	166
208	161	114
198	224	180
255	255	0
191	143	0]/255;

for i=1:9
    ind  =find(SBT==i);
    if ~isempty(ind)
        Z    = [z1(ind) z2(ind) z2(ind) z1(ind) z1(ind)]';
        X    = [x0(ind) x0(ind) SBT(ind) SBT(ind) x0(ind)]';
        
        % draw patches
        P=patch(ax,'XData',X,'YData',Z);
        P.EdgeColor='none';
        P.FaceColor=COL(i,:);
    end
end

ax.Layer = 'top';