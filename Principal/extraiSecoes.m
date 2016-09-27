function secoes = extraiSecoes( imagem, rect, numero)
%EXTRAISECOES Retorna um vetor onde cada linha representa uma secao da
%imagem.

    largura = floor(rect(3)/numero);
  
    x = rect(1);
    y = rect(2);
    altura = rect(4);
    
    secoes = [];

    while(x  < (rect(1) + rect(3)) - largura)
        novaSecao = [2,x,y,largura, altura, 0];
        secoes = [secoes;novaSecao]; 
        x = x + largura;
    end
  
end

