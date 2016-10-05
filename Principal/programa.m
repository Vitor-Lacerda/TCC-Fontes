%Inicializacao%


videoReader = vision.VideoFileReader('Vazio.mp4','ImageColorSpace','RGB','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter;
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1,'Method', 'Lucas-Kanade');
videoPlayer = vision.VideoPlayer('Name','Estacionamento');
shapeInserter = vision.ShapeInserter('Shape','Rectangles');


%Mostra o primeiro quadro pra determinar as regioes onde h� vagas%
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
inicioMovimentos = [];
finalMovimentos = [];


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
   
    areasInteresse = achaAreaInteresseMult(mags,100, 250,250);
 
    
    %Se tiver retornado alguma coisa%
%     if(centro(1) > 0 && centro(2) > 0)
    if(size(areasInteresse,1) >= size(finalMovimentos,1))
        %Se nao tiver movimento comeca um%
        if(size(areasInteresse,1) > size(finalMovimentos,1))
%             inicioMovimentos = [l1,l2,c1,c2,centro(1), centro(2)];
            inicioMovimentos = areasInteresse;
        end
        %Atualiza o fim do movimento%
%         finalMovimentos = [l1,l2,c1,c2,centro(1),centro(2)];
        
%         out(l1:l2,c1:c2, 3) = 255;
        for aa = 1:size(areasInteresse,1)
            lim = areasInteresse(aa,:);
            out(lim(1):lim(2), lim(3):lim(4), 3) = 255;
        end

        temMovimento = 1;
    else %caso nao encontre movimento, se ja tinha antes%
        if(temMovimento ~= 0)
          for(k = 1: size(inicioMovimentos,1))
            %Se comecou o movimento em uma das areas%
            if(dentroRetangulo(rect1, inicioMovimentos(k,5), inicioMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect1(2), inicioMovimento(4)-inicioMovimento(3), rect1(4),0];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
                  secoes1 = marcaMovimento(secoes1, inicioMovimentos(k,:));
            end
            if(dentroRetangulo(rect2, inicioMovimentos(k,5), inicioMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect2(2), inicioMovimento(4)-inicioMovimento(3), rect2(4),0];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
                  secoes2 = marcaMovimento(secoes2, inicioMovimentos(k,:));
            end
          end
          for(k = 1: size(finalMovimentos,1)) 
            %Se terminou o movimento em uma das areas%
            if(dentroRetangulo(rect1, finalMovimentos(k,5), finalMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect1(2), finalMovimento(4)-finalMovimento(3), rect1(4),0];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
                  secoes1 = marcaMovimento(secoes1, finalMovimentos(k,:));
            end
            if(dentroRetangulo(rect2, finalMovimentos(k,5), finalMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect2(2), finalMovimento(4)-finalMovimento(3), rect2(4),0];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
                  secoes2 = marcaMovimento(secoes2, finalMovimentos(k,:));
            end
          end
            
            [secoes1, secoes2] = ocupacaoSecoes(quadro, secoes1, secoes2);
            
        end
        
        temMovimento = 0;
    end
    finalMovimentos = areasInteresse;

   step(videoPlayer, out);
end

release(videoPlayer);
release(videoReader);




