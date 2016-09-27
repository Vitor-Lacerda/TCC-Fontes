function nSecoes = marcaMovimento( secoes, movimento, tipo )
%MARCAMOVIMENTO encontra as secoes que o movimento intercepta e muda o tipo
%dela. -1 para saida e 1 para entrada

    for i = 1:size(secoes,1)
        if( secoes(i,2) >= movimento(3) && secoes(i,2) <= movimento (4) ) || ( secoes(i,2)+secoes(i,4) >= movimento(3) &&  secoes(i,2)+secoes(i,4) <= movimento(4) )  
            secoes(i, 6) = tipo;
        end  
    end

    nSecoes = secoes;

end

