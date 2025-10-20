close all
clear
%interprete de latex
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

%Extraer audio
[m,Fs]=audioread("AUDIO.wav");


%PARAMETROS DE LA SEÑAL
Ts=1/Fs;
L=length(m);
t=(0:Ts:(L-1)/Fs)';

%MODULACION
Uam_sc=m.*cos(2*pi*2000*t);
Uam_lc=(1+m).*cos(2*pi*2000*t);

f=Fs/2*linspace(-1,1,L);

%TRANSFORAMDA DE FOURIER
Yam_sc=fft(Uam_sc,L);
Yam_lc=fft(Uam_lc,L);

Yam_sc=fftshift(Yam_sc);
Yam_lc=fftshift(Yam_lc);

figure
plot(f,abs(Yam_sc))
xlim([2e3-1000 2e3+1000])
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Transformada de Fourier Modulacion AM-DSB-SC');
grid on

figure
plot(f,abs(Yam_lc))
ylim([0 5000])
xlim([2e3-1000 2e3+1000])
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Transformada de Fourier Modulacion AM-DSB-LC');
grid on


