function dentro = dentroPoli(poli, centroY, centroX)

[IN,ON] = inpolygon(centroX, centroY, poli(:,1), poli(:,2));
dentro = (IN) > 0;


    
