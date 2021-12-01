function TRI_trans = gen_pre_computed_trans(TRI_i,TRI_f)
    TRI_trans = cell(length(TRI_i.ConnectivityList), 1);
    for i=1:length(TRI_i.ConnectivityList)
        points_i = [TRI_i.Points(TRI_i.ConnectivityList(i,:),:),[1;1;1]];
        points_f = [TRI_f.Points(TRI_f.ConnectivityList(i,:),:),[1;1;1]];
        AB = points_i\points_f;
        TRI_trans{i} = AB;
    end
end