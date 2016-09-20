videoReader = vision.VideoFileReader('Vazio.mp4','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter; 
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1,  'Method', 'Lucas-Kanade', 'OutputValue', 'Horizontal and vertical components in complex form');
% % shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 0);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');


while ~isDone(videoReader)
    frame = step(videoReader);
    im = step(converter, frame);
    components = step(opticalFlow, im);
    
    mags = abs(components);
    mags = mags .* 255;
    mags = uint8(mags);
    mags = threshBinary(mags, 220, 0, 255);
   
    [l1, l2, c1, c2, centro] = achaAreaInteresse(mags,100, 100);

    out = zeros(size(mags,1), size(mags,2), 3);
    out(:,:,1) = mags;
    out(:,:,2) = mags;
    out(:,:,3) = mags;
    
    if(centro(1) > 0 && centro(2) > 0)
        out(l1:l2,c1:c2, 1) = 255;
    end
    
    step(videoPlayer, out);
        
end

release(videoPlayer);
release(videoReader);