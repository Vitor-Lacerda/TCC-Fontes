tam = 60;
imagemBase = 'MeioCheio2.PNG';
img = imread(imagemBase);
cont = 1;

for i = 1:tam:size(img,1)-tam-1
   for j = 1:tam:size(img,2)-tam-1
       s = img(i:i+tam, j:j+tam);
       imwrite(s, ['i',int2str(cont),'.png']);
       cont = cont + 1;
   end
end
