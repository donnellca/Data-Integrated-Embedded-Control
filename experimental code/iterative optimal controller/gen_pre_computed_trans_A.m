function TRI_trans = gen_pre_computed_trans_A(TRI_i,TRI_f)
    TRI_trans = cell(length(TRI_i.ConnectivityList), 1);
    for i=1:length(TRI_i.ConnectivityList)
        points_i = TRI_i.Points(TRI_i.ConnectivityList(i,:),:);
        points_f = TRI_f.Points(TRI_f.ConnectivityList(i,:),:);
        AB = points_i\points_f;
        TRI_trans{i} = AB;
    end
end