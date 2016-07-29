imagemBase = 'MeioCheio.PNG';
img = imread(imagemBase);
cont = 100;
tamX = floor(size(img,1)/10);
tamY = floor(size(img,2)/10);

for i = 1:tamX:size(img,1)-tamX-1
   for j = 1:tamY:size(img,2)-tamY-1
       s = img(i:i+tamX-1, j:j+tamY-1);
       imwrite(s, ['i',int2str(cont),'.png']);
       cont = cont + 1;
   end
end
