figure(1);
img = imread('Vazio2.png');
img = rgb2gray(img);
imResult = zeros(size(img));
imshow(img);
rect1 = getrect;
rect2 = getrect;

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
    secaoImg = img(y:y+altura,x:x+largura1);
    coluna = extraiCaracteristicas(secaoImg);
    classe = Rede3Classes(coluna);
    [m, i] = max(classe);
    ocupacao1 = [ocupacao1, i];
    
    imResult(y:y+altura,x:x+largura1,i) = 255;
    
    
     x = x + largura1;
end


x = rect2(1);
y = rect2(2);
altura = rect2(4);

while(x < (rect2(1) + rect2(3)) - largura2)
    
    secaoImg = img(y:y+altura,x:x+largura2); 
    coluna = extraiCaracteristicas(secaoImg);
    classe = Rede3Classes(coluna);
    
    [m, i] = max(classe);
    ocupacao2 = [ocupacao2, i];
    
    imResult(y:y+altura,x:x+largura1,i) = 255;
    
     x = x + largura2;
end

figure
bar(ocupacao1);
figure
bar(ocupacao2);
% figure
% imshow(imResult);
% imResult = uint8(imResult);
figure
imshow(imResult);



