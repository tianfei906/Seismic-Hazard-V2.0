clearvars
clc
load('C:\Users\Admin\Dropbox\0Research\2021\FRAGILITY FUNCTIONS OF METRO TUNNELS\Numerical Models\ST01 Subduction\Model ST01\CSS_Tunnels1.mat')

eq=handout.eq;
VS30=vertcat(eq.VS30);
T=eq(1).T;
To   = zeros(112,1);
Tavg = zeros(112,1);
Tm   = zeros(112,1);

for i=1:112
    % average period
    % Rathje, Faraj, Russel, Bray  - (EERI 2004)
    SA=eq(i).SAH1;
    pga = SA(1);
    ind = SA/pga>=1.2;
    To(i) = log(SA(ind)/pga)*T(ind)'/sum(log(SA(ind)/pga));
    
    
    % AVERAGE SPECTRAL PERIOD
    ind = (T>=0.05 & T<=4 & diff([0,T])<=0.05);
    Tavg(i) = (SA(ind)/pga).^2*T(ind)'/sum((SA(ind)/pga).^2);
    
    % MEAN PERIOD (in Power Spectrum)
    % Rathje, Faraj, Russel, Bray  - (EERI 2004)
    f = fftf(eq(i).time);
    U = fft(eq(i).accH1);
    fi = f(f>0.25 & f<20);
    Ci = abs(U(f>0.25 & f<20));
    Tm(i) = ((Ci.^2)*(1./fi)')/(Ci*Ci');    
    
end
To(VS30==553)   = 0.75*To(VS30==553);
Tavg(VS30==553) = 0.9*Tavg(VS30==553);
Tm(VS30==553)   = 0.85*Tm(VS30==553);
close all
hold on
plot(VS30,To,'o')
% plot(VS30,Tavg,'s')
plot(VS30,Tm,'d')
ylim([0 0.5])
xlim([500 900])
xlabel('VS30(m/s)')
ylabel('T (s)')
legend('Average Period (Rathje et. al. 2004)','Mean Period (Rathje et al. 2004)')



%% relative advantace between CSS and Fragility based risk analysis












