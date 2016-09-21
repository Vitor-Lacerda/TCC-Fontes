videoReader = vision.VideoFileReader('Vazio.mp4','ImageColorSpace','RGB','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter; 
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1,'Method', 'Lucas-Kanade');
% % shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 0);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');


temMovimento = 0;
inicioMovimento = [0,0,0,0,0,0];
finalMovimento = [0,0,0,0,0,0];

imshow(step(videoReader));
rect1 = getrect;
rect2 = getrect;

rect1 = floor(rect1);
rect2 = floor(rect2);


contQuadros = 0;


while ~isDone(videoReader)
    frame = step(videoReader);
    
    contQuadros = contQuadros + 1;
    if(contQuadros > 30)
        ocup = plotOcupacao(frame,rect1,rect2);
        imshow(ocup);
        contQuadros = 0;
    end
    
    
    im = rgb2gray(frame);
    im = step(converter, im);
    mags = step(opticalFlow, im);
    
%     mags = abs(components);
    mags = mags .* 255;
    mags = uint8(mags);
    mags = threshBinary(mags, 220, 0, 255);
   
    [l1, l2, c1, c2, centro] = achaAreaInteresse(mags,100, 100);
    

    out = zeros(size(mags,1), size(mags,2), 3);
    out(:,:,1) = mags;
    out(:,:,2) = mags;
    out(:,:,3) = mags;
    
    if(centro(1) > 0 && centro(2) > 0)
        if(temMovimento == 0)
            inicioMovimento = [l1,l2,c1,c2,centro(1), centro(2)];
        end
        finalMovimento = [l1,l2,c1,c2,centro(1),centro(2)];
        out(l1:l2,c1:c2, 1) = 255;
        temMovimento = 1;
    else
        if(temMovimento ~= 0)
            
            areaInteresse = [];
            
            if(dentroRetangulo(rect1, inicioMovimento(5), inicioMovimento(6)) ~= 0 || dentroRetangulo(rect2, inicioMovimento(5), inicioMovimento(6)) ~= 0)
                areaInteresse = inicioMovimento;
                 imgArea = frame(areaInteresse(1):areaInteresse(2),areaInteresse(3):areaInteresse(4), 1:3);
%                  imshow(imgArea);
            end
            
            if(dentroRetangulo(rect1, finalMovimento(5), finalMovimento(6)) ~= 0 || dentroRetangulo(rect2, finalMovimento(5), finalMovimento(6)) ~= 0)
               areaInteresse = finalMovimento;
                imgArea = frame(areaInteresse(1):areaInteresse(2),areaInteresse(3):areaInteresse(4), 1:3);
%                 imshow(imgArea);
            end
            
        end
        
        temMovimento = 0;
    end
    
    step(videoPlayer, out);
    
        
end

release(videoPlayer);
release(videoReader);