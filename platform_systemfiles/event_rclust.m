function[rclust]=event_rclust(source,Mw,jnd)
%#ok<*AGROW>
rclust = source.rclust;

rclust.idx   = jnd;
rclust.C     = source.hypm(jnd,:);
rclust.m     = Mw;
rclust.RA    = rupRelation(Mw,0,source.numgeom(3));
rclust.rateR = 0;
rclust.normal= source.normal(jnd,:);

%% computes magnitudes

if source.numgeom(11)==1
    rclust.radio = buildRRA(source.hypm,source.aream,rclust.C,rclust.RA);
else
    rclust.radio = sqrt(rclust.RA'/pi);
end


