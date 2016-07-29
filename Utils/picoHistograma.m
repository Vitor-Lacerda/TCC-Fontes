function limites = picoHistograma(histograma, tamInterval)
limites = [0,0];
somaIntervalo = 0;


for c = 1:1:tamInterval
    somaIntervalo = histograma(c);
end

p = somaIntervalo;

for i = 2:1:256-tamInterval
    somaIntervalo = somaIntervalo - histograma(i-1);
    somaIntervalo = somaIntervalo + histograma(i-1 + tamInterval);
    
    if somaIntervalo > p
        p = somaIntervalo;
        limites = [i, i+tamInterval - 1];
    end
end

    
    
