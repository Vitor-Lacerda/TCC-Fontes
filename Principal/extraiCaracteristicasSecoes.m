function colunaAtributos = extraiCaracteristicasSecoes(img)

imgYCbCr = rgb2ycbcr(img);
imgCinza = imgYCbCr(:,:,1);

glcm = graycomatrix(imgCinza);
features = graycoprops(glcm,'all');

mediaCb = mean(mean(imgYCbCr(:,:,2)));
mediaCr = mean(mean(imgYCbCr(:,:,3)));

colunaAtributos = zeros(6 , 1);
colunaAtributos(1) = features.Contrast;
colunaAtributos(2) = features.Correlation;
colunaAtributos(3) = features.Energy;
colunaAtributos(4) = features.Homogeneity;
colunaAtributos(5) = mediaCb;
colunaAtributos(6) = mediaCr;











