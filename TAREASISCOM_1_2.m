close all
clear
%interprete de latex
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

%Extraer audio
[m,Fs]=audioread("AUDIO.wav");

%% 1
%PARAMETROS DE LA SEÑAL
Ts=1/Fs;
L=length(m);
t=(0:Ts:(L-1)/Fs)';

figure
plot(t, m);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Senal de audio');
grid on;

%% 2
M=fft(m);
% Compute the two-sided spectrum and frequency axis
M2 = abs(M);
M1=fftshift(M2);
f=linspace(-1,1,L)*Fs/2;

figure
plot(f,M1/L);
xlim([-300 300])
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Espectro de la señal de audio');
grid on;

%% 3
[MAX,f0]=max(M2/L);
f0=(f0-1)*Fs/L;

%% 4 - Calculo directo de la PSD (periodograma)
PSD = (1/(L^2)) * abs(M).^2;   % PSD [W/Hz]
PSD_shifted = fftshift(PSD);
f = linspace(-Fs/2, Fs/2, L);

figure
plot(f, PSD_shifted)
xlim([-300 300])
xlabel('Frecuencia [Hz]')
ylabel('PSD [W/Hz]')
title('Densidad espectral de potencia (Periodograma)')
grid on

% Potencia total
P_psd = sum(PSD);
P_time = mean(abs(m).^2);
fprintf('Potencia (PSD): %.3e  |  Potencia (tiempo): %.3e\n', P_psd, P_time);

%% 5
Max_freq=144.848;

%% 6
BW=280;
fs=600; %mayor a la frecuencia de Nyquist
ts=1/fs;
tiempo_final=L*(1/Fs);
N=tiempo_final/ts;
stride=round(Fs/fs);

%muestreo por arreglos(sin ceros)
ms=m(1:stride:end);
tt=t(1:stride:end);

%impulsos discretos(lugares donde no se muestreo es 0)
mss=zeros(size(m));
mss(1:stride:end)=m(1:stride:end);


%{
figure
plot(tt,ms,'o')
hold on 
plot(t,[m mss])
hold off 
%}

Ys=fft(mss);
Ys=fftshift(Ys)/length(ms);

f6s=linspace(-1,1,length(mss))*Fs/2;

figure
plot(f6s,abs(Ys))
xlim([-1200 1200])
grid on

%% 7
sound(m,Fs)

%% 8
ml=bandpass(m,[200 300],Fs);

Yl=fft(ml);
Yl=fftshift(Yl);

f8=linspace(-1,1,L)*Fs/2;
figure
plot(f8,abs(Yl)/L)
xlim([-350 350])
%sound(ml,Fs)
