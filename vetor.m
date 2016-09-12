function [posx, posy] = vetor(bloco, quadroAnterior, i,j)

menorSoma = 64*256;
posx = i;
posy = j;


for x = i-4:i+4
   for y = j-4:j+4
   
       if(x>=1 && y>=1 && x<size(quadroAnterior,1) - 8 && y<size(quadroAnterior,2) - 8)
           
           dif = abs(bloco - quadroAnterior(x:x+8,y:y+8));
           somaDif = sum(dif);
           if somaDif < menorSoma
               posx = x;
               posy = y;
               menorSoma = somaDif;
           end
           
       end  
   end 
end