videoReader = vision.VideoFileReader('Vazio.mp4','ImageColorSpace','Intensity','VideoOutputDataType','uint8');
converter = vision.ImageDataTypeConverter; 
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1,  'Method', 'Lucas-Kanade');
% % shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom', 'CustomBorderColor', 0);
videoPlayer = vision.VideoPlayer('Name','Motion Vector');

while ~isDone(videoReader)
    frame = step(videoReader);
    im = step(converter, frame);
    of = step(opticalFlow, im);
%     of = graythresh(of);
    out = of;
    step(videoPlayer, out);
    
end

release(videoPlayer);
release(videoReader);