inputs = [];
outputs = [];
carros = dir('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\TreinamentoSecoes\Carros\*.png');

for i=1:length(carros)
    img = imread(carros(i).name);
    %img = rgb2gray(img);

    [l, u] = LBPV(img,8,1);
    [h,x] = imhist(l,256);
    inputs = [inputs, h];
    o = zeros(2,1);
    o(1) = 1;
    outputs = [outputs, o];
end

vagas = dir('C:\Users\Avell G1711 NEW\Documents\MATLAB\Imagens\TreinamentoSecoes\Vagas\*.png');

for i=1:length(vagas)
    img = imread(vagas(i).name);
    %img = rgb2gray(img);

    [l, u] = LBPV(img,8,1);
    [h,x] = imhist(l,256);
    inputs = [inputs, h];
    o = zeros(2,1);
    o(2) = 1;
    outputs = [outputs, o];
end


seed = randperm(size(inputs,2));
inputF = inputs(:,seed);
outputF = outputs(:,seed);
