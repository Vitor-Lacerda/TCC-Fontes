img = imread('MeioCheio5.png');
imshow(img);
rect1 = getrect;
rect1 = floor(rect1);

largura = 50;
altura = rect1(4);

x = rect1(1);
y = rect1(2);

cont = 100;

while(x  < (rect1(1) + rect1(3)) - largura)
    
    s = img(y:y+altura,x:x+largura,1:3);
    imwrite(s,['secao',int2str(cont), '.png']);
    
     x = x + largura;
     cont = cont +1;
end



