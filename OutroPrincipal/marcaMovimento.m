function [nSecoes, indices] = marcaMovimento(secoes, movimento, quadro, amostragem)
    indices = [];

    for i = 1:size(secoes,1)
        if((secoes(i,2) >= movimento(3) && secoes(i,2) <= movimento (4) ) || ( secoes(i,2)+secoes(i,4) >= movimento(3) &&  secoes(i,2)+secoes(i,4) <= movimento(4)))
%             if((secoes(i,3) >= movimento(1) && secoes(i,3) <= movimento(2)) || (secoes(i,3)+secoes(i,5) >= movimento(1) &&  secoes(i,3)+secoes(i,5) <= movimento(2)))  
            secoes(i, 8) = 0;
            secoes(i,7) = 0;
            indices = [indices,i];
%             end
        end  
    end
    nSecoes = secoes;
    if(size(indices,2) > 0)
        indices = sort(indices);
        nSecoes = ocupacaoSecoes(quadro, nSecoes, amostragem);
    end
end

