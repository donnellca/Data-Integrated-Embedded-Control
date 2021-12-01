function [TRI_clus,sumd] = gen_clusters(TRI_trans,k)
    list_trans = zeros(length(TRI_trans),numel(TRI_trans{1}));
    for i=1:length(TRI_trans)
        list_trans(i,:) = reshape(TRI_trans{i},1,[]);
    end
    [TRI_clus,~,sumd] = kmeans(list_trans,k,'MaxIter',1000);
end