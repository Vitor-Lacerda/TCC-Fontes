function bin = threshBinary(img, thresh, minValue, maxValue)

tam = size(img,1) * size(img,2);
bin = img;

for i=1:tam
%    if img(i) > thresh
%        bin(i) = maxValue;
%    else
%        bin(i) = minValue;
%    end
    if img(i) < thresh
       bin(i) = minValue;
    end
end