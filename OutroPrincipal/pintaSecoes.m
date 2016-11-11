function quadroPlot  = pintaSecoes( quadro, secoes )
    quadroPlot = quadro;
    for i = 1:size(secoes,1)
            s = secoes(i,:);
            quadroPlot(s(3):s(3)+s(5), s(2):s(2)+s(4),s(1)) = 255;
            if(s(9) ~= 0)
             for(j = 1:s(9))
              quadroPlot(s(3):s(3)+8, s(2)+2*j ,1:3) = 0;
             end
            end
            quadroPlot(s(3):s(3)+s(5),s(2),1:3) = 0;
            quadroPlot(s(3),s(2):s(2)+s(4),1:3) = 0;

     end


end

