carros = dir('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\TreinamentoSecoes\Carros\*.png');
caracteristicasCarros = [];

for i=1:length(carros)
    img = imread(carros(i).name);
    coluna = extraiCaracteristicas(img);
    caracteristicasCarros = [caracteristicasCarros, coluna];
end

vagas = dir('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\TreinamentoSecoes\Vagas\*.png');
caracteristicasVagas = [];

for i=1:length(vagas)
   img = imread(vagas(i).name);
   coluna = extraiCaracteristicas(img);
   caracteristicasVagas = [caracteristicasVagas, coluna];
end

figure(1)
plot(caracteristicasCarros(1,:));
hold on
plot(caracteristicasCarros(2,:));
plot(caracteristicasVagas(1,:), 'g');
plot(caracteristicasVagas(2,:), 'g');
hold off
title('Intervalo mais comum');

figure(2)
plot(caracteristicasCarros(3,:));
hold on
plot(caracteristicasVagas(3,:), 'g');
hold off
title('% nivel mais comum');

figure(3)
plot(caracteristicasCarros(4,:));
hold on
plot(caracteristicasVagas(4,:), 'g');
hold off
title('Nivel mais comum');

figure(4)
plot(caracteristicasCarros(5,:));
hold on
plot(caracteristicasVagas(5,:), 'g');
hold off
title('% pixel uniformes LBP');

figure(5)
plot(caracteristicasCarros(6,:));
hold on
plot(caracteristicasVagas(6,:), 'g');
hold off
title('area maior objeto');

figure(6)
plot(caracteristicasCarros(7,:));
hold on
plot(caracteristicasVagas(7,:), 'g');
hold off
title('eixo maior');

figure(7)
plot(caracteristicasCarros(8,:));
hold on
plot(caracteristicasVagas(8,:), 'g');
hold off
title('eixo menor');



