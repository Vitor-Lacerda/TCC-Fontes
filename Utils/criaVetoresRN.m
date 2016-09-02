function [entrada, saida] = criaVetoresRN(endereco, categoria, nCategorias, fmt)

arquivos = dir([endereco, '*.', fmt]);
entrada = -1;
saida = -1;

for i=1:length(arquivos)
   nomeArquivo = [endereco,arquivos(i).name];
   img = imread(nomeArquivo);
   coluna = extraiCaracteristicasSecoes(img);
   if(entrada == -1)
      entrada = coluna;
      saida = zeros(nCategorias,1);
      saida(categoria) = 1;
   else
      entrada = [entrada, coluna]; 
      colSaida = zeros(nCategorias,1);
      colSaida(categoria) = 1;
      saida = [saida, colSaida];
   end
end