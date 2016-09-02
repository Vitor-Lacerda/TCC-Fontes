
videoObj = VideoReader('Vazio.mp4');

nFrames = videoObj.NumberOfFrames;
vidAltura = videoObj.Height;
vidLargura = videoObj.Width;

figure(1);
i = read(videoObj, 1);
imshow(i);
rect1 = getrect;
rect2 = getrect;



for k = 1:33: nFrames
   figure(1);
   quadro = read(videoObj, k);
   quadroPlot = plotOcupacaoImagem(quadro, rect1, rect2);
   imshow(quadroPlot);
   
end