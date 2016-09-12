function imPlot = plotOcupacaoImagem(img, rect1, rect2)

imResult = img;

rect1 = floor(rect1);
rect2 = floor(rect2);

largura1 = floor(rect1(3)/30);
largura2 = floor(rect2(3)/30);

ocupacao1 = [];
ocupacao2 = [];

x = rect1(1);
y = rect1(2);
altura = rect1(4);
cont = 200;

while(x  < (rect1(1) + rect1(3)) - largura1)
    
    limiteX = x+largura1;
    secaoImg = img(y:y+altura,x:x+largura1,1:3);
%     figure(2)
%     imshow(secaoImg);
    coluna = extraiCaracteristicasSecoes(secaoImg);
    classe = RedeNeural(coluna);
    
    
    
    if(classe(1) > 0.6)
        ocupacao1 = [ocupacao1, 1];
        i=1;
    else
        ocupacao1 = [ocupacao1, 2];
        i=2;
    end
    
        
    
    imResult(y:y+altura,x:x+largura1,i) = 255;
    imResult(y:y+altura,x,1:3) = 0;
    imResult(y,x:x+largura2,1:3) = 0;
    
    
     x = x + largura1;
end


x = rect2(1);
y = rect2(2);
altura = rect2(4);

while(x < (rect2(1) + rect2(3)) - largura2)
    
    secaoImg = img(y:y+altura,x:x+largura2,1:3); 
    coluna = extraiCaracteristicasSecoes(secaoImg);
    classe = RedeNeural(coluna);
    
    if(classe(1) > 0.6)
        ocupacao2 = [ocupacao2, 1];
        i =1;
    else
        ocupacao2 = [ocupacao2, 2];
        i=2;
    end
    
    imResult(y:y+altura,x:x+largura2,i) = 255;
    imResult(y:y+altura,x,1:3) = 0;
    imResult(y,x:x+largura2,1:3) = 0;
    
     x = x + largura2;
end

% figure
% bar(ocupacao1);
% figure
% bar(ocupacao2);
% figure
% imshow(imResult);
% imResult = uint8(imResult);
% figure
% imshow(img);
% hold on
% h = imshow(imResult);
% hold off
% h.AlphaData = uint8(imResult);

imPlot = imResult;



