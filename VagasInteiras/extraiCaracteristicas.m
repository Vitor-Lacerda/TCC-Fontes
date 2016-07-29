function colunaAtributos = extraiCaracteristicas(img)

%Lê a imagem que se deseja extrair as características e converte para uma
%imagem em níveis de cinza.

%img = imread('ComCarro.png');
if ~ismatrix(img)
    img = rgb2gray(img);
end

%Pega os limites do intervalo de tamIntervalo níveis que tem mais ocorrências na
%imagem.

tamIntervalo = 50;
histogramaImg = imhist(img, 256);

limitesIntervalo = picoHistograma(histogramaImg, tamIntervalo);

%Pega a porcentagem de ocorrencias do nivel mais comum histograma
%Pega o valor de nivel de cinza mais comum da imagem

[ocorrenciasNivelMaisComum, nivelMaisComum] = max(histogramaImg);
total = size(img,1) * size(img,2);
porcentagemNivelMaisComum = 100*ocorrenciasNivelMaisComum/total;


%Extrai a porcentagem de pixels com descritor uniforme (U<=2) da imagem

%imgEQ = histeq(img);

%[vetorLBP,uniformePC] = LBP(img, 8, 1);
uniformePC = LBPUni(img, 8,1);

%nLinhas = size(vetorLBP, 2) + 5;


%Separa bordas através do método de Sobel(padrão)
imBordas = edge(img);

%Pega os componentes conectados da imagem que contém as bordas
CC = bwconncomp(imBordas);

%Identifica o componente conectado de maior area e a maior area dele
structArea = regionprops(CC,'area');
arrayArea = [structArea.Area];
[maiorArea, idx]  = max(arrayArea);

%Pega o comprimento do eixo maior e do eixo menor do elipse que contém o
%componente conectado de maior area
structExMaior = regionprops(CC,'MajorAxisLength');
arrayExMaior = [structExMaior.MajorAxisLength];
valorExMaior = arrayExMaior(idx);

structExMenor = regionprops(CC, 'MinorAxisLength');
arrayExMenor = [structExMenor.MinorAxisLength];
valorExMenor = arrayExMenor(idx);



colunaAtributos = zeros(8 , 1);

colunaAtributos(1) = limitesIntervalo(1);
colunaAtributos(2) = limitesIntervalo(2);
colunaAtributos(3) = porcentagemNivelMaisComum;
colunaAtributos(4) = nivelMaisComum;
colunaAtributos(5) = uniformePC;
colunaAtributos(6) = maiorArea;
colunaAtributos(7) = valorExMaior;
colunaAtributos(8) = valorExMenor;









