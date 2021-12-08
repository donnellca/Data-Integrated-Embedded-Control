function [TRI_clus,sumd] = gen_clusters_alt2(TRI_trans,k)
    list_trans = zeros(length(TRI_trans),4);
    for i=1:length(TRI_trans)
        list_trans(i,:) = reshape(TRI_trans{i}(1:2,1:2),1,[]);
    end
    [TRI_clus,~,sumd] = kmeans(list_trans,k,'MaxIter',1000);
end