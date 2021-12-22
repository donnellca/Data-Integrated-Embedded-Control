function [trans,A,B] = gen_trans(i,TRI_i,TRI_f)
    points_i = [TRI_i.Points(TRI_i.ConnectivityList(i,:),:),[1;1;1]];
    points_f = [TRI_f.Points(TRI_f.ConnectivityList(i,:),:),[1;1;1]];
    AB = points_i\points_f;
    A = AB(1:2,1:2);
    B = AB(3,1:2);
    trans = @(p) p*A+B;
end

