function next_p = find_next(p,TRI,TRI_trans)
    index = pointLocation(TRI,p);
    AB = TRI_trans{index};
    A = AB(1:2,1:2);
    B = AB(3,1:2);
    next_p = p*A+B;
end