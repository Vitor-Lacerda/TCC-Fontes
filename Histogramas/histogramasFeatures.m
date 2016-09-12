% carro1 = imread('carroVermelho.png');
% carro2 = imread('carroPreto.png');
% vaga1 = imread('Nada1.png');
% vaga2 = imread('Nada2.png');
% 
% 
% largura = 16;
% altura = 16;
% 
% cbVaga2 = [];
% crVaga2 = [];
% contrasteVaga2 = [];
% correlacaoVaga2 = [];
% energiaVaga2 = [];
% homoVaga2 = [];
% 
% img = vaga2;
% 
% 
% for i = 1:largura:size(img,1)-largura-1
%    for j = 1:altura:size(img,2)-altura-1
%        sGrey = img(i:i+largura-1, j:j+altura-1);
%        sRgb = img(i:i+largura-1, j:j+altura-1,1:3);
%        sYCbCr = rgb2ycbcr(sRgb);
%        cbVaga2 = [cbVaga2, mean(mean(sYCbCr(:,:,2)))];
%        crVaga2 = [crVaga2, mean(mean(sYCbCr(:,:,3)))];
%        glcm = graycomatrix(sGrey);
%        stats = graycoprops(glcm, 'all');
%        contrasteVaga2 = [contrasteVaga2, stats.Contrast];
%        correlacaoVaga2 = [correlacaoVaga2, stats.Correlation];
%        energiaVaga2 = [energiaVaga2, stats.Energy];
%        homoVaga2 = [homoVaga2, stats.Homogeneity];
%    end
% end

% figure(1)
% [n,c] = hist(double(homoCarro1));s
% bar(c,n,'EdgeColor', 'r', 'FaceColor','none');
% hold on
% [n,c] = hist(double(homoCarro2));
% bar(c,n,'EdgeColor', 'g', 'FaceColor','none');
% hold on
% [n,c] = hist(double(homoVaga1));
% bar(c,n,'EdgeColor', 'b', 'FaceColor','none');
% hold on
% [n,c] = hist(double(homoVaga2));
% bar(c,n,'EdgeColor', 'y', 'FaceColor','none');
% hold on

% 
% enderecoCarros = 'C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\VagasColoridas\Ocupadas\*.png';
% enderecoVagas = 'C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\VagasColoridas\Vazias\*.png';
% 
% carros = dir(enderecoCarros);
% vagas = dir(enderecoVagas);
% 
% contrasteVagas = [];
% correlacaoVagas = [];
% energiaVagas = [];
% homoVagas = [];
% 
% for i=1:length(vagas)
%     img = imread(vagas(i).name);
%     imgGrey = rgb2gray(img);
%     glcm = graycomatrix(imgGrey);
%     stats = graycoprops(glcm,'all');
%     contrasteVagas = [contrasteVagas, stats.Contrast];
%     correlacaoVagas = [correlacaoVagas, stats.Correlation];
%     energiaVagas = [energiaVagas, stats.Energy];
%     homoVagas = [homoVagas, stats.Homogeneity];
%     
% end


figure(1)
[n,c] = hist(homoCarros);
bar(c,n,'EdgeColor', 'b', 'FaceColor','none');
hold on
[n,c] = hist(homoVagas);
bar(c,n,'EdgeColor', 'r', 'FaceColor','none');
hold off





