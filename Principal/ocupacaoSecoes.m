function [Nsecoes1, Nsecoes2] = ocupacaoSecoes(i,secoes1, secoes2)

        Nsecoes1 = percorreQuadro(i, secoes1);
        Nsecoes2 = percorreQuadro(i, secoes2);

end


function cc = checaClasse(c)
    cc = 2;
    if(c(1) >= 0.6)
        cc = 1;
    end
end

function classe = classeSecao(quadro, vetorSecoes, i)

s = vetorSecoes(i,:);
secao = quadro(s(3):s(3)+s(5), s(2):s(2)+s(4),1:3);

coluna = extraiCaracteristicasSecoes(secao);
classe = RedeVagas(coluna);

end

function valorAjustado = ajusteGauss(valor, vetorSecoes, i)

    valorAjustado = valor;

    for n = i-2:i+2
        if( (n >= 1) && (n <= size(vetorSecoes,1)) && (n~=i))
            f = gaussiana(i,n,0.5);
            sn = vetorSecoes(n,:);
            cn = sn(1);
            valorAjustado(cn) = valorAjustado(cn) * (1+f);
            rcn = 3 - cn; % se cn = 1, rcn = 2 e vice-versa
            valorAjustado(rcn) = valorAjustado(rcn) * (1-f);
            if(valorAjustado(cn) > 1)
                valorAjustado(cn) = 1;
            end
        end
    end
 end

function nsecoes = percorreQuadro(quadro, secoes)
        
%         quadroPlot = quadro;
        for i = 1:size(secoes,1)
            s = secoes(i,:);
            c = classeSecao(quadro, secoes, i);
            c = ajusteGauss(c, secoes, i);
            
            c(1) = c(1) + (0.2 * secoes(i,6));
            c(2) = c(2) - (0.2 * secoes(i,6));
            
            secoes(i,1) = checaClasse(c);
%             quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),1) = 255*c(1);
%             quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),2) = 255*c(2);
%             quadroPlot(s(3):s(3)+s(5),s(2),1:3) = 0;
%             quadroPlot(s(3),s(2):s(2)+s(4),1:3) = 0;
        end
        
%         imshow(quadroPlot);
        
        nsecoes = secoes;

end




