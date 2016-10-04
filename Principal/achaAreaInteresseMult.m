function achaAreaInteresseMult

    i = imread('Frame.PNG');
    g = rgb2gray(i);

    [l,c,v] = find(g);

    v = double(v);

    distanciaMaxima = 100;
    minimoImagem = 100;
    minimoArea = 100;

    areas = [];
    areasFim = [];
    areasCentros = [];
    ultimaArea = 0;


    if(size(l,1) > minimoImagem)
        for k = 1:size(l,1)
            
            if(size(areas,1) == 0)
                ultimaArea = 1;
                areas(1,1) = k;
                areasFim(1) = 2;
                areasCentros(1,:) = achaCentro(areas(1,:),l,c,v);
            else
                p = [l(k), c(k)];
                dist = distancia(p, areasCentros(ultimaArea,:));
                if (dist<=distanciaMaxima)
                    areas(ultimaArea, areasFim(ultimaArea)) = k;
                    areasFim(ultimaArea) = areasFim(ultimaArea) + 1;
                    nzero = naoZeros(areas(ultimaArea,:));
                    areasCentros(ultimaArea,:) = achaCentro(nzero,l,c,v);
                else
                   marcou = false;
                   for a = 1:size(areas, 1)
                      if(a ~= ultimaArea)
                          dist = distancia(p, areasCentros(a,:));
                          if (dist<=distanciaMaxima)
                                areas(a, areasFim(a)) = k;
                                areasFim(a) = areasFim(a) + 1;
                                nzero = naoZeros(areas(a,:));
                                areasCentros(a,:) = achaCentro(nzero,l,c,v);
                                ultimaArea = a;
                                marcou = true;
                                break;
                          end
                      end
                   end
                   if(~marcou)
                    areas(end+1, 1) = k;
                    areasFim(end+1) = 2;
                    nzero = naoZeros(areas(end,:));
                    areasCentros(end+1,:) = achaCentro(nzero,l,c,v);
                    ultimaArea = size(areasCentros,1);
                   end
                    
                end
                

            end


        end


    end
    for aa = 1:size(areas,1)
        nzero = naoZeros(areas(aa,:));
        if(size(nzero,2) > minimoArea)
            limArea = pegaLimitesArea(areas(aa,:), l, c);
            i(limArea(1):limArea(2), limArea(3):limArea(4), 1) = 255;
        end
        
    end

    imshow(i);
    
end

function dist = distancia(p1,p2)
        dist = (p1(1) - p2(1))^2 + (p1(2) - p2(2))^2;
        dist = sqrt(dist);
        dist = abs(dist);
end

function centro = achaCentro(area, linha, coluna, valor)
    magTotal = sum(valor(area));
    lTotal = sum(linha(area) .* valor(area));
    cTotal = sum(coluna(area) .* valor(area));

    centro = [lTotal/magTotal , cTotal/magTotal];
    centro = floor(centro);

end

function nzero = naoZeros(vet)
    [z,zz,nzero] = find(vet,:));
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


