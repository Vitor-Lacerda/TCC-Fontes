function uniformesPC = LBPUni(imagem, P, R)

[linhas, colunas] = size(imagem);

uniformCount = 0;

for x = 1 + R:linhas - R
   for y = 1 + R:colunas - R
       gc = imagem(x,y);
       gps = zeros(P,1);
       for p = 1:P
          offX = round(R*sin(2*pi*p/P));
          offY = round(R*cos(2*pi*p/P));
          
          gp = imagem(x + offX, y + offY);
          gps(p) = gp;
           
       end
       
       U = 0;
       U = U + abs(S(gps(P) - gc) - S(gps(1) - gc));
       
       for p = 2:P-1
         U = U + abs (S(gps(p) - gc) - S(gps(p-1) - gc));
       end
       
       
       
       
       if U<=2
           uniformCount = uniformCount + 1;
       end
   end
end

uniformesPC = 100*uniformCount/((linhas-2*R)*(colunas-2*R));
