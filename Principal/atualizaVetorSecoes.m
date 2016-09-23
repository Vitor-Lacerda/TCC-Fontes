function nsecoes = atualizaVetorSecoes(secoes, nova)

    indices = [];

    for i = 1:size(secoes,1)
        if( (secoes(i, 2) >= nova(2) && secoes(i,2) <= nova(2) + nova(4)) || (secoes(i,2) + secoes(i,4) >=nova(2) && secoes(i,2) + secoes(i,4) <= nova(2) +nova(4)) )
            indices = [indices,i];
        end  
    end
    
    nsecoes = secoes;
    
    if(size(indices, 2) ~= 0)
        nsecoes = secoes(~ismember(1:size(secoes, 1), indices), :);

        insert = min(indices);
        if(insert == 1)
           nsecoes = [nova;nsecoes];
           nsecoes(2,2) = nova(2) + nova(4) + 1;
        else
          if(insert == size(nsecoes,1))
             nsecoes = [nsecoes;nova];
             nsecoes(end-1, 4) = nova(2) - nsecoes(end-1, 2) -1;
          else
             a = nsecoes(1:insert-1,:);
             b = nsecoes(insert:end,:);
             nsecoes = [a;nova;b];
             nsecoes(insert+1,2) = nova(2) + nova(4) + 1;
             nsecoes(insert-1, 4) = nova(2) - nsecoes(insert-1, 2) - 1;
             
          end
            
        end   
        
        
        
    end
    
    
    
end

