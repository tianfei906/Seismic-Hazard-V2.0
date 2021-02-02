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
