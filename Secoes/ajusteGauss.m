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