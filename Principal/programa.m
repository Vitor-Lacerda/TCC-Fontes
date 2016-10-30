function programa

%Inicializacao%


videoReader = vision.VideoFileReader('1471581EntraPorBaixo1Sai.mp4','ImageColorSpace','RGB','VideoOutputDataType','uint8');
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

[secoes1,consec1] = ocupacaoSecoes(i, secoes1, 1, size(secoes1, 1));
[secoes2,consec2] = ocupacaoSecoes(i, secoes2, 1, size(secoes2, 1));


% comparaSecoes(secoesAnt1, secoes1, segundos, 1);
% comparaSecoes(secoesAnt2, secoes2, segundos, 2);

vagas = [];
vagas = vagasIniciais(vagas, secoes1, 1);
vagas = vagasIniciais(vagas, secoes2, 2);

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

        [secoes1,consec1] = ocupacaoSecoes(quadro, secoes1, 1, size(secoes1, 1));
        [secoes2,consec2] = ocupacaoSecoes(quadro, secoes2, 1, size(secoes2, 1));

        
        contQuadro = 0;
    end
    %Pinta a imagem com a ocupacao e as secoes%
    out = pintaSecoes(out, secoes1);
    out = pintaSecoes(out, secoes2);
    out = pintaVagas(out, vagas, secoes1, secoes2);
    
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
                  [secoes1,indices] = marcaMovimento(secoes1, inicioMovimentos(k,:), quadro);
                  vagas = marcaVagas(vagas, indices,1,nsecoes);
            end
            if(dentroRetangulo(rect2, inicioMovimentos(k,5), inicioMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, inicioMovimento(3), rect2(2), inicioMovimento(4)-inicioMovimento(3), rect2(4),0];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
                  [secoes2,indices] = marcaMovimento(secoes2, inicioMovimentos(k,:), quadro);
                  vagas = marcaVagas(vagas, indices,2,nsecoes);
            end
          end
          for(k = 1: size(finalMovimentos,1)) 
            %Se terminou o movimento em uma das areas%
            if(dentroRetangulo(rect1, finalMovimentos(k,5), finalMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect1(2), finalMovimento(4)-finalMovimento(3), rect1(4),0];
%                 secoes1 = atualizaVetorSecoes(secoes1, novaSecao);
                  [secoes1,indices] = marcaMovimento(secoes1, finalMovimentos(k,:), quadro);
                  vagas = marcaVagas(vagas, indices,1,nsecoes);
            end
            if(dentroRetangulo(rect2, finalMovimentos(k,5), finalMovimentos(k,6)) ~= 0)
%                 novaSecao = [2, finalMovimento(3), rect2(2), finalMovimento(4)-finalMovimento(3), rect2(4),0];
%                 secoes2 = atualizaVetorSecoes(secoes2, novaSecao);
                  [secoes2,indices] = marcaMovimento(secoes2, finalMovimentos(k,:), quadro);
                  vagas = marcaVagas(vagas, indices,2,nsecoes);
            end
          end
            
%             [secoes1, secoes2] = ocupacaoSecoes(quadro, secoes1, secoes2);
%               secoes1 = ocupacaoSecoes(quadro, secoes1, 1, size(secoes1, 1));
%               secoes2 = ocupacaoSecoes(quadro, secoes2, 1, size(secoes2, 1));
%                 comparaSecoes(secoesAnt1, secoes1, segundos, 1);
%                 comparaSecoes(secoesAnt2, secoes2, segundos, 2);

%             consecT = [consecT,consec1, consec2];
%             mediaSecoes = mean(consecT);
            
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

function vagas = contaVagas(secoes, media)
    contOcupadas = 0;
    vagas = 0;
    for i=1:size(secoes,1)
        if(secoes(i,1) == 1)
           contOcupadas = contOcupadas+1;
           if(contOcupadas >= media)
               vagas = vagas + 1;
               contOcupadas = 0;
           end
        else
           contOcupadas = 0; 
        end
        
    end


end

function nvagas = vagasIniciais(vagas, secoes, ROI)
    indices = [];
    nvagas = vagas;
    for i=1:size(secoes,1)
        if(secoes(i,1) == 1)
          indices = [indices, i];
        else
           if(size(indices,2) > 0)
            nvagas = marcaVagas(nvagas, indices, ROI, size(secoes,1));
           end
           indices = [];
        end
        
    end
    


end

function nvagas = marcaVagas(vagas, indices, ROI, max)
    nvagas = vagas;
    v = zeros(1,max+2);
    v(1:2) = [ROI, size(indices,2)];
    v(3:3+size(indices,2)-1) = indices;
    if(size(nvagas,1) == 0)
       nvagas = v; 
    else
        rois = nvagas(:,1);
        mesmaRoi = rois == ROI;
        linhas = find(mesmaRoi);
        mesmaRoi = nvagas(linhas,:);
        inds = mesmaRoi(:,2:end);
        comeco = v(3);
        final = v(3+v(2)-1);
        marcou = 0;
        for i=1:size(inds,1)
            comecoAnt = inds(i,2);
            finalAnt = inds(i,2+inds(i,1)-1);
            %Ve se a vaga nova come uma antiga
            if(comecoAnt >= comeco && finalAnt <= final)
                %Agora vale a nova
                inds(i,:) = v(2:end);
                marcou = 1;
            %ve se uma antiga come a nova
            elseif(comeco >= comecoAnt && final <= finalAnt)
                marcou = 1;
                if(inds(i,1) >= v(2)*2)
                %Separa a vaga anterior em duas se couber duas da nova na antiga%
                
                %Uma vaga nova que vai do final ate o final da anterior%
                 vagaDireita = [final+1:finalAnt];
                 if(size(vagaDireita,1) > 0)
                     indsNovos = zeros(1,max);
                     indsNovos(1:1+size(vagaDireita,2)-1) = vagaDireita;
                     vNova = [ROI, size(vagaDireita,2), indsNovos];
                     nvagas = [nvagas;vNova];
                 end
                 
                 %Modifica a vaga antiga pra ser so do comeco dela ate o
                 %final da nova%
                 vagaEsquerda = [comecoAnt:final];
                 inds(i,1) = size(vagaEsquerda,2);
                 inds(i,2:2+size(vagaEsquerda,2)-1) = vagaEsquerda;
                end
                 
            %ve se tem intersecção so%
            elseif((comeco >= comecoAnt && comeco <= finalAnt) ||  (final >= comecoAnt && final <= finalAnt))
               %quantas seçoes na interseccao%
               inters = 1;
               if(final >= comecoAnt && final <= finalAnt)
                   inters = final-comecoAnt;
               else
                   inters = finalAnt-comeco; 
               end
               
               if(inters>1)
                  marcou = 1;
                  vn = v;
                  indsN = [vn(3:3+vn(2)-1), inds(i,2:2+inds(i,1)-1)];              
                  indsN = unique(indsN);
                  inds(i,1) = size(indsN,2);
                  z = zeros(1,max);
                  z(1:1+size(indsN,2)-1) = indsN;
                  inds(i,2:end) = z;
               end
            end
        end
        
        nvagas(linhas, 2:end) = inds;
        if(marcou == 0)
           nvagas = [nvagas;v]; 
        end
    end

end

function saida = pintaVagas(quadro, vagas,secoes1, secoes2)
    saida = quadro;
    for v = 1:size(vagas,1)
        vaga = vagas(v,:);
        if(vaga(1) == 1)
            secoes = secoes1(vaga(3:3+vaga(2)-1),:);
            for k =1:size(secoes,1)
               s = secoes(k,:);
               saida(s(3)+5*v:s(3)+5*v+15, s(2):s(2)+s(4),3) = 255;
            end
        else
            secoes = secoes2(vaga(3:3+vaga(2)-1),:);
            for k =1:size(secoes,1)
               s = secoes(k,:);
               saida(s(3)+5*v:s(3)+5*v+15, s(2):s(2)+s(4),3) = 255;
            end
        end
        
    end
end




