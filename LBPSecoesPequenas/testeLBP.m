tam = 60;
imagemBase = 'Vazio1.PNG';
img = imread(imagemBase);
img = rgb2gray(img);
imResult = zeros(size(img));
cont = 1;

for i = 1:tam:size(img,1)-tam-1
   for j = 1:tam:size(img,2)-tam-1
       s = img(i:i+tam, j:j+tam);
       [l, u] = LBPV(s, 8,1);
       [h,x] = imhist(l,32);
       classe = RedeLBP(h);
       if(classe(1) > 0.5)
          imResult(i:i+tam, j:j+tam) = 255;
       end
   end
end

imshow(imResult);
imResult = uint8(imResult);
imshow(img+imResult);