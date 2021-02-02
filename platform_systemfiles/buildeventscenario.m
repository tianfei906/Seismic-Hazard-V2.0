function[scenarios,source]=buildeventscenario(sys,opt,val1)

event       = sys.event;
sys.branch  = sys.branch(val1,:);
source_all  = buildDSHAmodel2(sys,opt,[]);


source     = source_all;
% aca voy
Nev   = length(event);
scenarios  = zeros(Nev,9); % the 9th component is rate=0
scenarios(:,2)   = vertcat(event.Mw);
for i=1:Nev
    Mw    = scenarios(i,2);
    dist2 = zeros(numel(source_all),1);
    jnd   = zeros(numel(source_all),1);
    C0    = gps2xyz(event(i).loc,opt.ellipsoid);
    for j=1:numel(source_all)
        hypm = source_all(j).hypm;
        [dist2(j),jnd(j)]=min(sum((hypm-C0).^2,2));
    end
    [~,knd]=min(dist2);
    jnd    = jnd(knd);
    
    source(i)         = source_all(knd);
    source(i).mscl    = [Mw 0];
    source(i).rclust  = event_rclust(source(i),Mw,jnd);
    scenarios(i,:)    = [knd,Mw,source(i).rclust.C,source(i).rclust.normal,0];
end
