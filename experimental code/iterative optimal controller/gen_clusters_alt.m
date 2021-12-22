function [TRI_clus,sumd] = gen_clusters_alt(TRI_trans,k)
    list_trans = zeros(length(TRI_trans),length(TRI_trans{1}));
    for i=1:length(TRI_trans)
        list_trans(i,:) = TRI_trans{i}(end,:);
    end
    [TRI_clus,~,sumd] = kmeans(list_trans,k,'MaxIter',1000);
end