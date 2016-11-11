function parcelas = extraiParcelas( imagem, roi, tamanho)

    xr = roi(:,1);
    yr = roi(:,2);
    
    parcelas = [];

    for c = 1:tamanho:size(imagem,2)-tamanho
        for l =1:tamanho:size(imagem,1)-tamanho
            [IN,ON] = inpolygon(c,l,xr,yr);
            if(IN > 0 || ON > 0)
               p = [2, c,l,tamanho,tamanho,0,0,0,0];
               %%novaSecao = [classe, x,y,largura,altura, classe anterior, votos,
        %%estavel, vaga]
               parcelas = [parcelas;p];
               
            end
           
        
        end
    end
    
  
end

