function [minL, maxL, minC, maxC, centro] = achaAreaInteresse(g, distanciaMaxima, minimoValores)

% i = imread('Frame.PNG');
% g = rgb2gray(i);
% 
% g(107196) = 230;
% g(74273) = 225;
% g(233480) = 255;
% g(260847) = 255;
% g(134628) = 245;
% g(174951) = 230;

[l,c,v] = find(g);

v = double(v);

% distanciaMaxima = 100;

if(size(l,1) > minimoValores)
    magTotal = sum(v);
    lTotal = sum(l .* v);
    cTotal = sum(c .* v);

    centro = [lTotal/magTotal , cTotal/magTotal];
    centro = floor(centro);
    
    minL = centro(1);
    maxL = centro(1);
    minC = centro(2);
    maxC = centro(2);

    for k = 1:size(l,1)
        dist = (l(k) - centro(1))^2 + (c(k) - centro(2))^2;
        dist = sqrt(dist);
        dist = abs(dist);
        
        if(dist <= distanciaMaxima)
           
            if(l(k) < minL)
                minL = l(k);
            elseif(l(k) > maxL)
                maxL = l(k);
            end
            
            if(c(k) < minC)
                minC = c(k);
            elseif(c(k) > maxC)
                maxC = c(k);
            end 
        end
    end

else
    centro = [-1,-1];
    minL = centro(1);
    maxL = centro(1);
    minC = centro(2);
    maxC = centro(2);
end

% 
% 
% 
% 
% i(minL:maxL,minC:maxC, 1) = 255;
% 
% imshow(i);

