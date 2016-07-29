imagemBase = 'Momento5.PNG';
img = imread(imagemBase);
img = rgb2gray(img);
imResult = zeros(size(img));
cont = 1;
tamX = floor(size(img,1)/10);
tamY = floor(size(img,2)/10);

for i = 1:tamX:size(img,1)-tamX-1
   for j = 1:tamY:size(img,2)-tamY-1
       s = img(i:i+tamX-1, j:j+tamY-1);
       [l, u] = LBPV(s, 8,1);
       [h,x] = imhist(l,32);
       h = h./sum(h);
       h = h.*100;
       classe = RedeLBP(h);
       if(classe(1) > 0.5)
          imResult(i:i+tamX-1, j:j+tamY-1) = 255;
       end
   end
end

imshow(imResult);
imResult = uint8(imResult);
imshow(img+imResult);