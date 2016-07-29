function [percent, errosCarro, errosVaga] = teste()


[in, out] = geradorVetoresRede('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\OutrosTestes\Carros\','C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\OutrosTestes\Vagas\');

total = size(in,2);
acertos = 0;
errosCarro = 0;
errosVaga = 0;


for i = 1:total
    classe = RedeSecoes(in(:,i));
    alvo = out(:,i);
    erro = abs(classe(1) - alvo(1));
    if(erro <= 0.4)
       acertos = acertos + 1;        
    else
        if(alvo(1) == 1)
           errosVaga = errosVaga + 1;
        else
           errosCarro = errosCarro + 1; 
        end 
    end
end

percent = 100*acertos/total;
