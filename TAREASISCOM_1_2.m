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
f0=(f0-1)*Fs/L

%% 4 - Calculo directo de la PSD (periodograma)
PSD = (1/(Fs*L)) * abs(M).^2;   % PSD [W/Hz]
PSD_shifted = fftshift(PSD);
f = linspace(-Fs/2, Fs/2, L);

figure
plot(f, PSD_shifted)
xlim([0 300])
xlabel('Frecuencia [Hz]')
ylabel('PSD [W/Hz]')
title('Densidad espectral de potencia (Periodograma)')
grid on
hold on
plot(f,ones(size(f))*84.3325e-6)
hold off
% Potencia total
df = Fs/L;
P_psd = sum(PSD)*df;
P_time = mean(m.^2);
fprintf('Potencia (PSD): %.6e  |  Potencia (tiempo): %.6e\n', P_psd, P_time);

%% 5

