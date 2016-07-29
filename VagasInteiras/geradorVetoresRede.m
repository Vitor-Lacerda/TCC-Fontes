function [input, output] = geradorVetoresRede(endereco1, endereco2)

%'C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\OutrosTestes\Carros\'
%'C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\OutrosTestes\Vagas\'

[inputCarros, outputCarros] = criaVetoresRN(endereco1,1, 'png');
[inputVagas, outputVagas] = criaVetoresRN(endereco2,2, 'png');

inputRede = [inputCarros,inputVagas];
outputRede = [outputCarros, outputVagas];

seed = randperm(size(inputRede,2));
input = inputRede(:,seed);
output = outputRede(:,seed);
