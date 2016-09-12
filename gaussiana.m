function f = gaussiana(x, media, desvio)

variancia = desvio^2;

den = sqrt(2*pi*variancia);
e = exp((-(x-media)^2)/(2*variancia));

f = 1/den;
f = f*e;