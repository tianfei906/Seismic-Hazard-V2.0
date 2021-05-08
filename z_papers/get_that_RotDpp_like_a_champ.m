function[RotDpp]=get_that_RotDpp_like_a_champ(dt,H1,H2,xi,pp,T)
% dt  time increment of ground motion acceleration histories
% H1  horizontal component 1 of ground acceleration
% H2  horizontal component 1 of ground acceleration
% xi  damping ratio, e.g. x=0.05 for 5% critical damping
% pp  percentile e.g., pp=50 for 50th percentile
% T   periods used to compute ground motion rotations

% RotDpp _ pp-percentile of the geometric mean of components H1 and H2
% rotated between 0 and 90 degrees. The units of RotDpp are the same units
% of H1 and H2

th   = 0:2:88;
Nth  = numel(th);
Nper = numel(T);
SA   = zeros(Nth,Nper);

for i=1:Nth
    A       = [cosd(th(i)),-sind(th(i));sind(th(i)) cosd(th(i))];
    HH      = A*[H1;H2];
    S1      = freqspec(dt,HH(1,:),T,xi);
    S2      = freqspec(dt,HH(2,:),T,xi);
    SA(i,:) = sqrt(S1.*S2);
end
RotDpp = prctile(SA,pp,1);

function[Sa]=freqspec(h,udd,To,xi)

% Pads with zeros
Nper    = length(To);
N       = size(udd,2);
f       = (0:N-1)/(h*N);
mid     = ceil(N/2)+1;
f(mid:N)= f(mid:N)-1/h;
w       = 2*pi*f;
Sa      = nan(1,Nper);
U       = fft(udd,N,2);

for j=1:Nper
    wo    = 2*pi/To(j);
    H     = 1+w.^2./(wo^2-w.^2+2*1i*xi*wo*w);
    udd   = ifft(H.*U,N,2,'symmetric');
    Sa(j) = max(abs(udd),[],2);
end
