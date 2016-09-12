function classe = classeSecao(quadro, vetorSecoes, i)

s = vetorSecoes(i,:);
secao = quadro(s(3):s(3)+s(5), s(2):s(2)+s(4),1:3);

coluna = extraiCaracteristicasSecoes(secao);
classe = RedeVagas(coluna);

% for n = i - 2:i+2
%     if( (n >= 1) && (n <= size(vetorSecoes,1)) && (n~=i))
%         f = gaussiana(i,n,1);
%         sn = vetorSecoes(n,:);
%         cn = sn(1);
%         classe(cn) = classe(cn) * (1+f);
% %         rcn = 3 - cn; % se cn = 1, rcn = 2 e vice-versa
% %         classe(rcn) = classe(rcn) * (1-f);
%         if(classe(cn) > 1)
%             classe(cn) = 1;
%         end
%         
%     end
% end