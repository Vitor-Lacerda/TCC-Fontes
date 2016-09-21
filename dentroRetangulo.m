function dentro = dentroRetangulo(rect,l,c)

dentro = 0;
if(l > rect(2) && l < rect(2) + rect(4) && c > rect(1) && c < rect(1) + rect(3))
    dentro = 1;
end