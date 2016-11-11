function Nsecoes = ocupacaoSecoes(i,secoes, amostragem)
        
        Nsecoes = percorreQuadro(i, secoes, amostragem);

end


function cc = checaClasse(c)
    cc = 2;
    if(c(1) >= 0.6)
        cc = 1;
    end
end

function classe = classeSecao(quadro, composto)

linhas = composto(:,3);
colunas = composto(:,2);
largura = composto(1,4);
altura = largura;

comecoY = min(linhas);
finalY = max(linhas)+altura;

comecoX = min(colunas);
finalX = max(colunas) + largura;


secao = quadro(comecoY:finalY,comecoX:finalX,1:3);

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

function nsecoes = percorreQuadro(quadro, secoes, amostragem)
        

%         quadroPlot = quadro;
        for i = 1:amostragem:size(secoes,1)
            
    %             s = secoes(i,:);
                
                composto = [];
                if(size(secoes,1) - i >= amostragem)
                 composto = secoes(i:i+amostragem,:);             
                else
                 composto = secoes(i:end, :); 
                end
                
                c = classeSecao(quadro, composto);
%                 c = ajusteGauss(c, secoes, i);

    %             c(1) = c(1) + (0.2 * secoes(i,6));
    %             c(2) = c(2) - (0.2 * secoes(i,6));

                cc = checaClasse(c);

                if(size(secoes,1) - i >= amostragem)
                 secoes(i:i+amostragem,1) = cc;             
                else
                 secoes(i:end, 1) = cc; 
                end


    %             quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),1) = 255*c(1);
    %             quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),2) = 255*c(2);
    %             quadroPlot(s(3):s(3)+s(5),s(2),1:3) = 0;
    %             quadroPlot(s(3),s(2):s(2)+s(4),1:3) = 0;
            
        end
        
%         imshow(quadroPlot);
        
        nsecoes = secoes;

end




