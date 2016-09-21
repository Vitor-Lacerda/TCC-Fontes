function quadroPlot = plotOcupacao(i,rect1,rect2)
%     videoObj = VideoReader('Vazio.mp4');
%     videoPlayer = vision.VideoPlayer('Name','Estacionamento');

%     nFrames = videoObj.NumberOfFrames;

    figure(1);
%     i = read(videoObj, 1);
%     i = step(videoObj);
%     imshow(i);
%     rect1 = getrect;
%     rect2 = getrect;
% 
%     rect1 = floor(rect1);
%     rect2 = floor(rect2);
%     
    largura1 = floor(rect1(3)/30);
    largura2 = floor(rect2(3)/30);
    
    x = rect1(1);
    y = rect1(2);
    altura = rect1(4);
    
    secoes1 = [];

    while(x  < (rect1(1) + rect1(3)) - largura1)
        novaSecao = [2,x,y,largura1, altura];
        secoes1 = [secoes1;novaSecao]; 
        x = x + largura1;
    end

    x = rect2(1);
    y = rect2(2);
    altura = rect2(4);

    secoes2 = [];

    while(x  < (rect2(1) + rect2(3)) - largura2)
        novaSecao = [2,x,y,largura2, altura];
        secoes2 = [secoes2;novaSecao]; 
        x = x + largura2;
    end

%     for k = 1:33:nFrames
%         figure(1);
%         quadro = read(videoObj, k);
        quadroPlot = percorreQuadro(i, secoes1);
        quadroPlot = percorreQuadro(quadroPlot, secoes2);
%         imshow(quadroPlot);
        
%     end
    
        
%     release(videoPlayer);
%     release(videoReader);
end




function cc = checaClasse(c)
    cc = 2;
    if(c(1) >= 0.6)
        cc = 1;
    end
end

function quadroPlot = percorreQuadro(quadro, secoes)
        
        quadroPlot = quadro;
        for i = 1:size(secoes,1)
            s = secoes(i,:);
            c = classeSecao(quadro, secoes, i);
            c = ajusteGauss(c, secoes, i);
%             [m,ind] = max(c);
            secoes(i,1) = checaClasse(c);
            quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),secoes(i,1)) = 255;
%           quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),2) = 255*c(2);
            quadroPlot(s(3):s(3)+s(5),s(2),1:3) = 0;
            quadroPlot(s(3),s(2):s(2)+s(4),1:3) = 0;

        end

        

end




