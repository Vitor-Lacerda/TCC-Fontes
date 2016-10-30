function [nSecoes, indices] = marcaMovimento(secoes, movimento, quadro)
%comita pls
    indices = [];

    for i = 1:size(secoes,1)
        if( secoes(i,2) >= movimento(3) && secoes(i,2) <= movimento (4) ) || ( secoes(i,2)+secoes(i,4) >= movimento(3) &&  secoes(i,2)+secoes(i,4) <= movimento(4) )  
            secoes(i, 8) = 0;
            secoes(i,7) = 0;
            indices = [indices,i];
        end  
    end
    nSecoes = secoes;
    if(size(indices,2) > 0)
        nSecoes = ocupacaoSecoes(quadro, nSecoes, indices(1), indices(end));
    end
end

