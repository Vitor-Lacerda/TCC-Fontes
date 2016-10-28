function programa

%Inicializacao%


videoReader = vision.VideoFileReader('MeioCheioCortado.mp4','ImageColorSpace','RGB','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter;
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1,'Method', 'Lucas-Kanade');
videoPlayer = vision.VideoPlayer('Name','Estacionamento');
% shapeInserter = vision.ShapeInserter('Shape','Rectangles');


%Mostra o primeiro quadro pra determinar as regioes onde há vagas%
i = step(videoReader);
imshow(i);
rect1 = getrect;
rect2 = getrect;

rect1 = floor(rect1);
rect2 = floor(rect2);

% rect1 = [3 4 850 148];
% rect2 = [3 308 848 172];


%Determina o numero de secoes a serem criadas em cada ROI

nsecoes = 30;

%Extrai nsecoes secoes verticais de cada regiao%
secoes1 = extraiSecoes(i, rect1, nsecoes);
secoes2 = extraiSecoes(i, rect2, nsecoes);



%Determina ocupacao inicial de cada secao%

%%%Comeca a tocar o video%%%
contQuadro = 1;
% segundos = 0;
analisaMovimento = 0;
temMovimento = 0;

% %Guarda o estado anterior das seções%
% secoesAnt1 = secoes1;
% secoesAnt2 = secoes2;

% [secoes1, secoes2] = ocupacaoSecoes(i, secoes1, secoes2);
secoes1 = ocupacaoSecoes(i, secoes1, 1, size(secoes1, 1));
secoes2 = ocupacaoSecoes(i, secoes2, 1, size(secoes2, 1));

% comparaSecoes(secoesAnt1, secoes1, segundos, 1);
% comparaSecoes(secoesAnt2, secoes2, segundos, 2);

inicioMovimentos = [];
finalMovimentos = [];


while ~isDone(videoReader)
   quadro = step(videoReader);

   out = quadro;
   contQuadro = contQuadro + 1;
   %A cada segundo(30 quadros) verifica novamente a ocupacao das secoes%
    if (contQuadro > 2)
       analisaMovimento = 1; 
    end
    if(contQuadro > 30)
%         segundos = segundos+1;
%         [secoes1, secoes2] = ocupacaoSecoes(quadro, secoes1, secoes2);

        %Guarda o estado anterior das seções%
%         secoesAnt1 = secoes1;
%         secoesAnt2 = secoes2;

        secoes1 = ocupacaoSecoes(quadro, secoes1, 1, size(secoes1, 1));
        secoes2 = ocupacaoSecoes(quadro, secoes2, 1, size(secoes2, 1));
        
%         comparaSecoes(secoesAnt1, secoes1, segundos, 1);
%         comparaSecoes(secoesAnt2, secoes2, segundos, 2);
        
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
   %Extrai retangulos referentes aos movimentos na cena%
   if(analisaMovimento == 1)
    areasInteresse = achaAreaInteresseMult(mags,100, 250,250);
 
    
    %Se houve um numero maior ou igual de movimentos que antes%
%     if(centro(1) > 0 && centro(2) > 0)
    if(size(areasInteresse,1) >= size(finalMovimentos,1))
        %Se o numero de movimentos foi maior, armazena o movimento novo%
        if(size(areasInteresse,1) > size(finalMovimentos,1))
%             inicioMovimentos = [l1,l2,c1,c2,centro(1), centro(2)];
            inicioMovimentos = areasInteresse;
        end
        %Pinta os retangulos de azul na imagem de saida%
        for aa = 1:size(areasInteresse,1)
            lim = areasInteresse(aa,:);
            out(lim(1):lim(2), lim(3):lim(4), 3) = 255;
        end

        temMovimento = 1;
    else %caso um movimento tenha sumido%
        if(temMovimento ~= 0)
          
%           %Guarda o estado anterior das seções%
%             secoesAnt1 = secoes1;
%             secoesAnt2 = secoes2;
            
          for(k = 1: size(inicioMovimentos,1))
            %Se comecou o movimento em uma das areas%
            if(dentroRetangulo(rect1, inicioMovimentos(k,5), inicioMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect1(2), inicioMovimento(4)-inicioMovimento(3), rect1(4),0];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
                  secoes1 = marcaMovimento(secoes1, inicioMovimentos(k,:), quadro);
            end
            if(dentroRetangulo(rect2, inicioMovimentos(k,5), inicioMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect2(2), inicioMovimento(4)-inicioMovimento(3), rect2(4),0];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
                  secoes2 = marcaMovimento(secoes2, inicioMovimentos(k,:), quadro);
            end
          end
          for(k = 1: size(finalMovimentos,1)) 
            %Se terminou o movimento em uma das areas%
            if(dentroRetangulo(rect1, finalMovimentos(k,5), finalMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect1(2), finalMovimento(4)-finalMovimento(3), rect1(4),0];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
                  secoes1 = marcaMovimento(secoes1, finalMovimentos(k,:), quadro);
            end
            if(dentroRetangulo(rect2, finalMovimentos(k,5), finalMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect2(2), finalMovimento(4)-finalMovimento(3), rect2(4),0];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
                  secoes2 = marcaMovimento(secoes2, finalMovimentos(k,:), quadro);
            end
          end
            
%             [secoes1, secoes2] = ocupacaoSecoes(quadro, secoes1, secoes2);
%               secoes1 = ocupacaoSecoes(quadro, secoes1, 1, size(secoes1, 1));
%               secoes2 = ocupacaoSecoes(quadro, secoes2, 1, size(secoes2, 1));
%                 comparaSecoes(secoesAnt1, secoes1, segundos, 1);
%                 comparaSecoes(secoesAnt2, secoes2, segundos, 2);
            
        end
        
        temMovimento = 0;
    end
    %Atualiza os fins dos movimentos%
    finalMovimentos = areasInteresse;
   end
   step(videoPlayer, out);
   
end

release(videoPlayer);
release(videoReader);

end


function comparaSecoes(anterior, novo, t,roi)
    
    ocupadas = [];
    liberadas = [];

    for i=1:size(anterior,1)
       if(anterior(i,1)~=novo(i,1))
           if(novo(i,1) == 1)
              ocupadas = [ocupadas,i]; 
           else
              liberadas = [liberadas,i]; 
           end
           
       end
    end
    
    if(size(ocupadas,2) > 0)
        ['Tempo: ', num2str(t), ' ROI ', num2str(roi), ': Secoes ',  num2str(ocupadas), ' ocupadas,']
    end
    
    if(size(liberadas,2) > 0)
        ['Tempo: ', num2str(t), ' ROI ', num2str(roi), ': Secoes ',  num2str(liberadas), ' liberadas,']
    end

end




