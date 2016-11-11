function limitesAreas =  achaAreaInteresseMult(g, distanciaMaxima, minimoImagem, minimoArea)

%     i = imread('Poucos.PNG');
%     g = rgb2gray(i);

    [l,c,v] = find(g);

    v = double(v);
% 
%     distanciaMaxima = 100;
%     minimoImagem = 100;
%     minimoArea = 100;

    areas = zeros(50, 1000);
    limites = zeros(50, 4);
    areasFim = ones(50);
    areasCentros = zeros(50,5);
    ultimaArea = 1;
    contAreas = 0;


    if(size(l,1) > minimoImagem)
        for k = 1:size(l,1)
            %Se nao tiver nenhuma area coloca o indice k na primeira
%             if(size(areas,1) == 0)
            if contAreas == 0
%                 ultimaArea = 1;
                areas(1,1) = k;
                areasFim(1) = 2; %Final da area 1 e o indice 2
                nzero = naoZeros(areas(1,:));
                areasCentros(1,:) = achaCentro(nzero,l,c,v);
                limites(1,:) = [l(k),l(k),c(k),c(k)];
                contAreas = contAreas + 1;
            else
               %Caso contrario ve se o ponto se encaixa em alguma das areas
                p = [l(k), c(k)]; %p e o ponto analisado
                
                %Comeca olhando a ultima area aonde eu pus um ponto pra ser
                %mais rapido
                dist = distancia(p, areasCentros(ultimaArea,:));
                %Se tiver perto suficiente do centro, coloca nela e
                %recalcula o centro
                if (dist<=distanciaMaxima)
                    areas(ultimaArea, areasFim(ultimaArea)) = k;
                    areasFim(ultimaArea) = areasFim(ultimaArea) + 1;
                    nzero = naoZeros(areas(ultimaArea,:));
%                     areasCentros(ultimaArea,:) = achaCentro(nzero,l,c,v);
                    areasCentros(ultimaArea,:) = atualizaCentro(areasCentros(ultimaArea,:), k, l,c,v);
                       if(p(1) < limites(ultimaArea,1))
                            limites(ultimaArea,1) = p(1);
                       elseif (p(1) > limites(ultimaArea,2))
                           limites(ultimaArea,2) = p(1);
                       end
                       
                       if(p(2) < limites(ultimaArea,3))
                            limites(ultimaArea,3) = p(2);
                       elseif (p(2) > limites(ultimaArea,4))
                           limites(ultimaArea,4) = p(2);
                       end
                else
                   %Se nao, procura outra area dentre as marcadas
                   marcou = false;
%                    for a = 1:size(areas, 1)
                   for a = 1:contAreas
                      if(a ~= ultimaArea)
                          dist = distancia(p, areasCentros(a,:));
                          if (dist<=distanciaMaxima)
                                areas(a, areasFim(a)) = k;
                                areasFim(a) = areasFim(a) + 1;
%                                 nzero = naoZeros(areas(a,:));
%                                 areasCentros(a,:) = achaCentro(nzero,l,c,v);
                                areasCentros(a,:) = atualizaCentro(areasCentros(a,:), k, l,c,v);
                                ultimaArea = a;
                                marcou = true;
                                if(p(1) < limites(a,1))
                                    limites(a,1) = p(1);
                                elseif (p(1) > limites(a,2))
                                    limites(a,2) = p(1);
                                end
                                
                                if(p(2) < limites(a,3))
                                    limites(a,3) = p(2);
                                elseif (p(2) > limites(a,4))
                                    limites(a,4) = p(2);
                                end
                                break;
                          end
                      end
                   end
                   %Se nao entrou em nenhuma, cria outra
                   if(~marcou)
                    areas(contAreas+1, 1) = k;
                    areasFim(contAreas+1) = 2;
                    nzero = naoZeros(areas(contAreas+1,:));
                    areasCentros(contAreas+1,:) = achaCentro(nzero,l,c,v);
                    %ultimaArea = size(areasCentros,1);
                    ultimaArea = contAreas + 1;
                    limites(contAreas + 1,:) = [l(k),l(k),c(k),c(k)];
                    contAreas = contAreas + 1;
                   end
                    
                end
                

            end


        end


    end

    
    limitesAreas = [];
    %Percorre cada area encontrada e acha os pontos delimitadores pra
    %retornar
    for aa = 1:size(areas,1)
        if(sum(areas(aa,:) > 0))
            nzero = naoZeros(areas(aa,:));
            if(size(nzero,2) > minimoArea)
%                 limArea = pegaLimitesArea(areas(aa,:), l, c);
                limArea = limites(aa,:);
                limArea(end+1:end+2) = areasCentros(aa,1:2);
                limitesAreas = [limitesAreas;limArea];
            end
        else
            break;
        end
    end
    
    
%     for aa = 1:size(areas,1)
%         nzero = naoZeros(areas(aa,:));
%         if(size(nzero,2) > minimoArea)
%             limArea = pegaLimitesArea(areas(aa,:), l, c);
%             i(limArea(1):limArea(2), limArea(3):limArea(4), 1) = 255;
%         end
%         
%     end
% 
%     imshow(i);
    
end

function dist = distancia(p1,p2)
        dist = (p1(1) - p2(1))^2 + (p1(2) - p2(2))^2;
        dist = sqrt(dist);
        dist = abs(dist);
end

function centro = atualizaCentro(ant, i, linha, coluna, valor)
    l = linha(i) * valor(i);
    c = coluna(i) * valor(i);
    v = valor(i);
    
    lNovo = ant(3) + l;
    cNovo = ant(4) + c;
    vNovo = ant(5) + v;
    
    centro = [lNovo/vNovo, cNovo/vNovo, lNovo, cNovo, vNovo];

end

function centro = achaCentro(area, linha, coluna, valor)
    magTotal = sum(valor(area));
    lTotal = sum(linha(area) .* valor(area));
    cTotal = sum(coluna(area) .* valor(area));

    centro = [lTotal/magTotal , cTotal/magTotal, lTotal, cTotal, magTotal];
    centro = floor(centro);

end

function nzero = naoZeros(vet)
    [z,zz,nzero] = find(vet);
end

function limArea = pegaLimitesArea(area, linha, coluna)
   
   minL = max(linha);
   maxL = min(linha);
   minC = max(coluna);
   maxC = min(coluna);

   for k = 1:size(area,2)
       if(area(k) > 0)
            p = area(k);
            if(linha(p) < minL)
             minL = linha(p); 
            elseif(linha(p) > maxL)
                maxL = linha(p);
            end
            
            if(coluna(p) < minC)
                minC = coluna(p);
            elseif(coluna(p) > maxC)
                maxC = coluna(p);
            end 
           
       end
       
   end
   
   limArea = [minL,maxL, minC, maxC];
        

end


