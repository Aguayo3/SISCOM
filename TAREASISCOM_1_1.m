% calc_entropy_tiff_with_entropy.m
% Calcula la entropía de Shannon de cada imagen TIFF usando la función entropy()
% Agrupa cada 10 imágenes = 1 segundo, y calcula entropía media y espectral

clear; close all; clc;

%% --- CONFIGURACIÓN ---
carpetas={ ...
        "C:\Users\aguay\OneDrive\Documentos\GitHub\SISCUM\laminar\op1"
        "C:\Users\aguay\OneDrive\Documentos\GitHub\SISCUM\transicion\op1",
        "C:\Users\aguay\OneDrive\Documentos\GitHub\SISCUM\turbulenta\op1"};

nombre_carpetas={'laminar','transicion','turbulenta'};

%Varibleas para guardar resultados
todasimgEntropias=cell(1,length(carpetas));
todasimgNombres=cell(1,length(carpetas));

mean_entropias=cell(1,length(carpetas));
de_entropias=cell(1,length(carpetas));
img_por_segundo = 5; % 10 imágenes corresponden a 1 segundo


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
    imgEntropias=[];
    imgNombres={};

    %bucle de imagenes
    for f=1:numel(archivos)
        I=imread(fullfile(path_carpetas, archivos(f).name));
        
        %pasar a grises las fotos
        Igris=rgb2gray(I);
        %calcula la entropia
        entropia_I= entropy(Igris);
        
        imgEntropias(end+1)=entropia_I;
        imgNombres{end+1}=archivos(f).name;
    end
    % Guardar resultados de esta carpeta en la variable global
    todasimgEntropias{modo} = imgEntropias;
    todasimgNombres{modo}   = imgNombres;
    
    Nimg=numel(imgEntropias);
    Nsegundos=floor(Nimg/img_por_segundo);

    sec_Entropia_prom=zeros(1,Nsegundos);
    sec_Entropia_de=zeros(1,Nsegundos);

    for s = 1:Nsegundos
        %tomar numero de imagenes por segundo
        idx_start=(s-1)*5+1;%s=1 idx=1:10, s=2 idx=11:20
        idx_end=s*5;
        seg=imgEntropias(idx_start:idx_end);

        sec_Entropia_prom(s)=mean(seg);
        sec_Entropia_de(s)=std(seg);
    end

    mean_entropias{modo}=sec_Entropia_prom;
    de_entropias{modo}=sec_Entropia_de;
end
%% --- GRAFICAR RESULTADOS ---

figure;
subplot(2,1,1)
hold on
plot(1:50, todasimgEntropias{1}, '-o', 'DisplayName', 'Laminar');
plot(1:50, todasimgEntropias{2}, '-s', 'DisplayName', 'Transición');
plot(1:50, todasimgEntropias{3}, '-d', 'DisplayName', 'Turbulenta');

xlabel('Imagen #');
ylabel('Entropía (bits)');
title('Entropía por imagen (primeros 4 segundos)');
legend(Location='southeast');legend('boxoff')
grid on;
hold off
subplot(2,1,2);hold on
tsec=(0:Nsegundos-1) * 0.5 + 0.25; % centro de cada intervalo
errorbar(tsec,mean_entropias{1},de_entropias{1},'-o',LineWidth=1);
errorbar(tsec,mean_entropias{2},de_entropias{2},'-s',LineWidth=1);
errorbar(tsec,mean_entropias{3},de_entropias{3},'-d',LineWidth=1);
xlim([0 5])
grid on