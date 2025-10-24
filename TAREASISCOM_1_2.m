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

a=figure;
plot(t, m,LineWidth=1);
xlabel('Tiempo [s]');
ylabel('Amplitud');
l={'Se\~nal m(t)'};
legend(l,location='north',FontSize=11)
grid on;
%% 2

M=fft(m);
M2 = abs(M);
M1=fftshift(M2);
f=linspace(-1,1,L)*Fs/2;

figure;
plot(f,M1/L,LineWidth=1,Color='#008F39');
xlim([-300 300])
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
legend('Se\~nal M(f)',location='north',FontSize=11)
grid on;

%% 3
[MAX,f0]=max(M2);
f0=(f0-1)*Fs/L;
fprintf('La frecuencia fundamental es %.4f [Hz] \n',f0);

%% 4 - Calculo directo de la PSD (periodograma)
PSD = (1/(Fs*L)) * abs(M).^2;   % PSD [W/Hz]
PSD_shifted = fftshift(PSD);
f = linspace(-Fs/2, Fs/2, L);

figure
plot(f, (PSD_shifted),Color='#841A1B')
xlim([-300 300])
xlabel('Frecuencia [Hz]')
ylabel('PSD [W/Hz]')
legend('PSD(f) de m(t)',location='north',FontSize=11)
grid on
%% 5
PSD_acumulada=cumtrapz(PSD_shifted);
figure
plot(f, PSD_acumulada, Color='#0072BD',LineWidth=1.5)
xlim([-300 300])
xlabel('Frecuencia [Hz]')
ylabel('PSD Acumulada')
legend('PSD Acumulada', location='north', FontSize=11)
grid on;


%% 6
BW=280;
fs=600; %mayor a la frecuencia de muestreo de Nyquist y que sea multiplo de Fs para que stride sea entero

ts=1/fs;
tiempo_final=L*(1/Fs);
stride=round(Fs/fs);
N=tiempo_final/ts;


%impulsos discretos(lugares donde no se muestreo es 0)
mss=zeros(size(m));
mss(1:stride:end)=m(1:stride:end);


Ys=fft(mss);
Ys=fftshift(Ys)/N;

f6s=linspace(-1,1,length(mss))*Fs/2;

figure
plot(t,mss,'-b',DisplayName='m(kT)')
hold on
plot(t,m,'r',DisplayName='m(t)')
hold off
xlim([0 100*ts])
legend(location='north',FontSize=11)
grid on
xlabel('Tiempo [s]')
ylabel('Amplitud')


figure
plot(f6s,abs(Ys),Color='#008F39',DisplayName='Se\~nal M(f) muestreada')
xlim([-1800 1800])
xlabel('Frecuencia [Hz]')
ylabel('Magnitud')
legend(location='north',FontSize=11)
xticks(-1800:600:1800)
grid on

%% 7
sound(m,Fs)

%% 8
%filtrado de señal
ml=bandpass(m,[200 300],Fs);

%calculo de espectro
Yl=fft(ml);
Yl=fftshift(Yl);

f8=linspace(-1,1,L)*Fs/2;

%escuchar sonido filtrado
sound(4*ml,Fs)

figure
hold on
plot(f,M1/L,LineWidth=1,Color='#008F39',DisplayName='Se\~nal M(f)');
xlim([-300 300])
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');

grid on;
plot(f8,abs(Yl)/L,displayname='Se\~nal Ml(f)')
hold off
legend(location='north',FontSize=11)


