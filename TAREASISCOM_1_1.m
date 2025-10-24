% Calcula la entropía de Shannon de cada imagen TIFF usando la función entropy()
% Agrupa cada 10 imágenes = 1 segundo, y calcula entropía media y espectral

%interprete de latex
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

clear; close all; clc;

function H = renyi_entropy(I, alpha)
    % Normalizar a distribución de probabilidad
    counts = imhist(I);        % histograma de niveles 0-255
    p = counts / sum(counts);  % probabilidad
    p = p(p>0);                % quitar ceros para evitar log(0)
    
    % Entropía de Rényi
    H = 1/(1-alpha) * log2(sum(p.^alpha));
end

%% --- CONFIGURACIÓN ---
carpetas={ ... %<-- Cambia las rutas
        "laminar\op1"
        "transicion\op1",
        "turbulenta\op1"};

nombre_carpetas={'laminar','transicion','turbulenta'};

%Varibleas para guardar resultados
todasimgEntropias=cell(1,length(carpetas));%<--aca se alamcenan las entropoias todasentropias{1}
todasimgRenyi=cell(1,length(carpetas));

mean_entropias=cell(1,length(carpetas));
de_entropias=cell(1,length(carpetas));

mean_renyi=cell(1,length(carpetas));
de_renyi=cell(1,length(carpetas));

img_por_segundo = 5; % 10 imágenes corresponden a 1 segundo

%alpha entropia de renyi
alpha=0.5;

%% BUcle principal para 3 carpetas
for modo=1:length(carpetas)

    path_carpetas=carpetas{modo};
    patron_archivo=fullfile(path_carpetas,'*.tiff');
    archivos= dir(patron_archivo);
    
    max_imag=5*10;
    if numel(archivos) > max_imag
        archivos=archivos(1:max_imag);
    end

    %Varibleas para guardar resultados
    imgEntropiasRenyi=[];
    imgEntropias=[];
    
    %bucle de imagenes
    for f=1:numel(archivos)
        I=imread(fullfile(path_carpetas, archivos(f).name));
        
        %pasar a grises las fotos
        Igris=rgb2gray(I);
        %calcula la entropia
        entropia_I= entropy(Igris);
        %calculo entropia de renyi
        entropia_renyi = renyi_entropy(Igris, alpha);
        
        %almacenamiento de entropias
        imgEntropias(end+1)=entropia_I;
        imgEntropiasRenyi(end+1)=entropia_renyi;
    end

    % Guardar resultados de esta carpeta en la variable global
    todasimgEntropias{modo} = imgEntropias;
    todasimgRenyi{modo}=imgEntropiasRenyi;

    Nimg=numel(imgEntropias);
    Nsegundos=floor(Nimg/img_por_segundo);
   
    %varaibles para almacenar shannon
    sec_Entropia_prom=zeros(1,Nsegundos);
    sec_Entropia_de=zeros(1,Nsegundos);
    %varaibles para almacenar renyi
    sec_EntropiaRenyi_prom = zeros(1,Nsegundos);
    sec_EntropiaRenyi_de = zeros(1,Nsegundos);

    for s = 1:Nsegundos
        %tomar numero de imagenes por segundo
        idx_start=(s-1)*5+1;%s=1 idx=1:10, s=2 idx=11:20
        idx_end=s*5;
        seg=imgEntropias(idx_start:idx_end);
        segRenyi=imgEntropiasRenyi(idx_start:idx_end);

        %entropia de shanon/s
        sec_Entropia_prom(s)=mean(seg);
        sec_Entropia_de(s)=std(seg);

        %entropia de renyi/s
        sec_EntropiaRenyi_prom(s) = mean(segRenyi);
        sec_EntropiaRenyi_de(s) = std(segRenyi);
    end

    mean_entropias{modo}=sec_Entropia_prom;
    de_entropias{modo}=sec_Entropia_de;
    
    mean_renyi{modo}=sec_EntropiaRenyi_prom;
    de_renyi{modo} = sec_EntropiaRenyi_de;
end
%% --- GRAFICAR RESULTADOS ---

figure('Name', 'Entropía de Shannon', 'NumberTitle', 'off');
subplot(2,1,1)
hold on
plot(1:50, todasimgEntropias{1}, '-o', 'DisplayName', 'Laminar','LineWidth',1);
plot(1:50, todasimgEntropias{2}, '-s', 'DisplayName', 'Transición','LineWidth',1);
plot(1:50, todasimgEntropias{3}, '-d', 'DisplayName', 'Turbulenta','LineWidth',1);
xlabel('\# Imagen');
ylabel('Entropía [bits]');
title('Entropía por imagen');
legend(Location='southeast');legend('boxoff')
grid on;
hold off
subplot(2,1,2);hold on
tsec=(0:Nsegundos-1) * 0.5 + 0.25; % centro de cada intervalo
errorbar(tsec,mean_entropias{1},de_entropias{1},'-o',LineWidth=1,DisplayName='Laminar');
errorbar(tsec,mean_entropias{2},de_entropias{2},'-s',LineWidth=1,DisplayName='Transición');
errorbar(tsec,mean_entropias{3},de_entropias{3},'-d',LineWidth=1,DisplayName='Turbulenta');
xlim([0 5])
xlabel('Tiempo [s]')
title('Entropía promedio y desviacion estandar por segundo');
ylabel('Entropía [bits]');
grid on
legend(Location='southeast');legend('boxoff')
sgtitle('Entropía de Shannon');

figure('Name', ['Entropía de Renyi α_ ',num2str(alpha)], 'NumberTitle', 'off');
subplot(2,1,1)
hold on
plot(1:50, todasimgRenyi{1}, '-o', 'DisplayName', 'Laminar','LineWidth',1);
plot(1:50, todasimgRenyi{2}, '-s', 'DisplayName', 'Transición','LineWidth',1);
plot(1:50, todasimgRenyi{3}, '-d', 'DisplayName', 'Turbulenta','LineWidth',1);
xlabel('\# Imagen');
ylabel('Entropía [bits]');
title('Entropía por imagen');
legend(Location='southeast');legend('boxoff')
grid on;
hold off

subplot(2,1,2);hold on
tsec=(0:Nsegundos-1) * 0.5 + 0.25; % centro de cada intervalo
errorbar(tsec,mean_renyi{1},de_renyi{1},'-o',LineWidth=1,DisplayName='Laminar');
errorbar(tsec,mean_renyi{2},de_renyi{2},'-s',LineWidth=1,DisplayName='Transición');
errorbar(tsec,mean_renyi{3},de_renyi{3},'-d',LineWidth=1,DisplayName='Turbulenta');
xlim([0 5])
legend(Location='southeast');legend('boxoff')
xlabel('Tiempo [s]')
title('Entropía promedio y desviacion estandar por segundo');
ylabel('Entropía [bits]');
grid on
hold off
sgtitle(['Entropía de Rényi α = ',num2str(alpha)]);