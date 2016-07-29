function [vetorLBP, uniformsPC] = LBPV(imagem, P, R)

[linhas, colunas] = size(imagem);

vetorLBP = zeros(linhas,colunas);

index = 1;
uniformCount = 0;

for x = 1 + R:linhas - R
   for y = 1 + R:colunas - R
       gc = imagem(x,y);
       gps = zeros(1,P);
       for p = 1:P
          offX = round(R*sin(2*pi*p/P));
          offY = round(R*cos(2*pi*p/P));
          
          gp = imagem(x + offX, y + offY);
          gps(p) = gp;
           
       end
       
       LBPdessepixel = 2^P + 1;
       U = 0;
       U = U + abs(S(gps(P) - gc) - S(gps(1) - gc));   
       %for i = 0:P-1
            LBP = 0;
            %for p = 0:P-1
            for p = 1:P
                %LBP = LBP + (S(gps(mod(p + i,P)+1) - gc)*2^(p));
                LBP = LBP + (S(gps(p) - gc)*2^(p-1));
                %if p>1 && i == 0
                 %  U = U + abs (S(gps(p+1) - gc) - S(gps(p) - gc));
                   %U = U + abs (S(gps(p) - gc) - S(gps(p-1) - gc));
                %end
            end
            if LBP < LBPdessepixel
               LBPdessepixel = LBP;
            end
       %end

       if U<=2
           uniformCount = uniformCount + 1;
       end
       
       
       
       vetorLBP(x,y) = LBPdessepixel;
       index = index + 1;
   end
end

vetorLBP = uint8(vetorLBP);


uniformsPC = 100*uniformCount/((linhas-2*R)*(colunas-2*R));
