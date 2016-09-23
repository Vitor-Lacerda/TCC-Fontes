%Inicializacao%
videoReader = vision.VideoFileReader('Vazio.mp4','ImageColorSpace','RGB','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter;
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1,'Method', 'Lucas-Kanade');
videoPlayer = vision.VideoPlayer('Name','Estacionamento');
shapeInserter = vision.ShapeInserter('Shape','Rectangles');


%Mostra o primeiro quadro pra determinar as regioes onde há vagas%
i = step(videoReader);
imshow(i);
rect1 = getrect;
rect2 = getrect;

rect1 = floor(rect1);
rect2 = floor(rect2);

%Extrai 30 secoes verticais de cada regiao%
secoes1 = extraiSecoes(i, rect1, 30);
secoes2 = extraiSecoes(i, rect2, 30);

%Determina ocupacao inicial de cada secao%
[secoes1, secoes2] = ocupacaoSecoes(i, secoes1, secoes2);


%%%Comeca a tocar o video%%%
contQuadro = 1;
temMovimento = 0;
inicioMovimento = [0,0,0,0,0,0];
finalMovimento = [0,0,0,0,0,0];

while ~isDone(videoReader)
   quadro = step(videoReader);

   out = quadro;
   contQuadro = contQuadro + 1;
   %A cada segundo(30 quadros) verifica novamente a ocupacao das secoes%
    if(contQuadro > 30)
        [secoes1, secoes2] = ocupacaoSecoes(quadro, secoes1, secoes2);
        contQuadro = 0;
    end
    %Pinta a imagem com a ocupacao e as secoes%
    out = pintaSecoes(out, secoes1);
    out = pintaSecoes(out, secoes2);
    
    %Configura a imagem pra ferramente opticalflow%
    im = rgb2gray(quadro);
    im = step(converter, im);
    %Usa opticalFlow pra pegar os vetores de movimento da imagem%
    mags = step(opticalFlow, im);
    
%     mags = abs(components);
    %Limiariza a imagem. Todos vetores menores que 220 ficam com valor 0%
    mags = mags .* 255;
    mags = uint8(mags);
    mags = threshBinary(mags, 220, 0, 255);
   %Extrai um centro de massa e uma area de pontos de interesse ao seu
   %redor%
   %l1 = linha inicial, l2 = linha final, c1 = coluna inicial, c2 = coluna
   %final%
    [l1, l2, c1, c2, centro] = achaAreaInteresse(mags,100, 100);
    
    %Se tiver retornado alguma coisa%
    if(centro(1) > 0 && centro(2) > 0)
        %Se nao tiver movimento comeca 1%
        if(temMovimento == 0)
            inicioMovimento = [l1,l2,c1,c2,centro(1), centro(2)];
        end
        %Atualiza o fim do movimento%
        finalMovimento = [l1,l2,c1,c2,centro(1),centro(2)];
        out(l1:l2,c1:c2, 3) = 255;
        temMovimento = 1;
    else %caso nao encontre movimento, se ja tinha antes%
        if(temMovimento ~= 0)
            
            
%             %Se comecou o movimento em uma das areas%
%             if(dentroRetangulo(rect1, inicioMovimento(5), inicioMovimento(6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect1(2), inicioMovimento(4)-inicioMovimento(3), rect1(4)];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
%             end
%             if(dentroRetangulo(rect2, inicioMovimento(5), inicioMovimento(6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect2(2), inicioMovimento(4)-inicioMovimento(3), rect2(4)];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
%             end
%             
%             %Se terminou o movimento em uma das areas%
%             if(dentroRetangulo(rect1, finalMovimento(5), finalMovimento(6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect1(2), finalMovimento(4)-finalMovimento(3), rect1(4)];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
%             end
%             if(dentroRetangulo(rect2, finalMovimento(5), finalMovimento(6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect2(2), finalMovimento(4)-finalMovimento(3), rect2(4)];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
%             end
%             
%             [secoes1, secoes2] = ocupacaoSecoes(quadro, secoes1, secoes2);
            
        end
        
        temMovimento = 0;
    end

   
   step(videoPlayer, out);
end

release(videoPlayer);
release(videoReader);




