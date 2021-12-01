function next_p = gen_next(p,TRI_i,TRI_f)
    index = pointLocation(TRI_i,p);
    points_i = [TRI_i.Points(TRI_i.ConnectivityList(index,:),:),[1;1;1]];
    points_f = [TRI_f.Points(TRI_f.ConnectivityList(index,:),:),[1;1;1]];
    AB = points_i\points_f;
    A = AB(1:2,1:2);
    B = AB(3,1:2);
    next_p = p*A+B;
end

