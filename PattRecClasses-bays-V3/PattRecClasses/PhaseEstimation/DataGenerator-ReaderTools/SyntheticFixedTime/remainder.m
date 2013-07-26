% remaider function: this function is writen to set the rem(nX,X)=X

 %gives the remainder of a divide b
 
function remainder = remainder(a,b)
    
    if rem(a,b)==0
        remainder = b;
    else
        remainder = rem(a,b);
    end

end