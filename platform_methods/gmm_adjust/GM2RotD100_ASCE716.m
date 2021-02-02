function amp=RotD100_ASCE716(T)

if and(0<=T,T<0.2)
    amp = 1.1;
elseif and(0.2<=T,T<1.0)
    amp=1.1+0.25*(T-0.2);
elseif and(1.0<=T,T<5.0)
    amp=1.3+0.05*(T-1.0);
elseif 5<=T
    amp=1.5;
else
    amp=NaN;
end
