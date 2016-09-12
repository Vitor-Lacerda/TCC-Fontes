
videoObj = VideoReader('Vazio.mp4');

nFrames = videoObj.NumberOfFrames;


quadro = read(videoObj,1);
quadroAnterior = [];
mapa = zeros(size(quadro,1), size(quadro,2));

limiar = 5;

for k = 1:nFrames
   
   if(k>1)
       quadro = read(videoObj, k);
       quadroGrey = rgb2gray(quadro);
       quadroAntGrey = rgb2gray(quadroAnterior);
       mapa = zeros(size(quadro,1), size(quadro,2));
       quadroDif = abs(quadroGrey - quadroAntGrey);
       
       for i = 1:8:size(quadro,1)-8
          for j = 1:8:size(quadro,2)-8
                if(sum(quadroDif(i:i+8, j:j+8)) ~= 0)
                    [x,y] = vetor(quadro(i:i+8, j:j+8), quadroAntGrey, i,j);
                    dist = sqrt( (i-x)^2 + (j-y)^2 );
                    if(dist >= limiar)
                   
                        mapa(i:i+8, j:j+8) = dist*10;
                    end
                    
                end
          end
       end
   end
    figure(1);
   imshow(quadro);
   figure(2);
   imshow(mapa);
   quadroAnterior = quadro;
end
