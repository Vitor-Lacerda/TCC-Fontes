% img = imread('MeioCheio5.png');
% imshow(img);
% rect1 = getrect;
% rect1 = floor(rect1);
% 
% largura = 50;
% altura = rect1(4);
% 
% x = rect1(1);
% y = rect1(2);
% 
% cont = 100;
% 
% while(x  < (rect1(1) + rect1(3)) - largura)
%     
%     s = img(y:y+altura,x:x+largura,1:3);
%     imwrite(s,['secao',int2str(cont), '.png']);
%     
%      x = x + largura;
%      cont = cont +1;
% end



img = imread('Vazio3.png');
imshow(img);

cont = 8;

while(1)
   
    rect = getrect;
    s = img(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), 1:3);
    imwrite(s,['teste',int2str(cont),'.png']);
    
    cont = cont +1;
    
end