carros = dir('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\TreinamentoSecoes\Carros\*.png');
caracteristicasCarros = [];
outCarros = [];

for i=1:length(carros)
    img = imread(carros(i).name);
    glcm = graycomatrix(img);
    stats = graycoprops(glcm, 'all');
    coluna = [stats.Contrast;stats.Correlation;stats.Energy;stats.Homogeneity];
    caracteristicasCarros = [caracteristicasCarros, coluna];
    colout = [1;0];
    outCarros = [outCarros, colout];
end

vagas = dir('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\TreinamentoSecoes\Vagas\*.png');
caracteristicasVagas = [];
outVagas = [];

for i=1:length(vagas)
   img = imread(vagas(i).name);
   glcm = graycomatrix(img);
   stats = graycoprops(glcm, 'all');
   coluna = [stats.Contrast;stats.Correlation;stats.Energy;stats.Homogeneity];
   caracteristicasVagas = [caracteristicasVagas, coluna];
   colout = [0;1];
   outVagas = [outVagas, colout];
end

entrada = [caracteristicasCarros,caracteristicasVagas];
saida = [outCarros, outVagas];
seed = randperm(size(entrada,2));
entradaRede = entrada(:,seed);
saidaRede = saida(:,seed);

% plot(caracteristicasCarros, 'r');
% hold on
% plot(caracteristicasVagas,'g');
% hold off