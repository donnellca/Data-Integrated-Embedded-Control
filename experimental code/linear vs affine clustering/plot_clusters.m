function plot_clusters(TRI,TRI_clus)
    [n,bin] = hist(TRI_clus,unique(TRI_clus));
    [~,idx] = sort(-n);
    a=bin(idx);
    color = ['r','g','b','c','m','y','k'];
    figure
    axis([-3 3 -3 3])
    hold on
    for i=1:length(a)
        triplot(TRI.ConnectivityList(TRI_clus==a(i),:),TRI.Points(:,1),TRI.Points(:,2),color(mod(i,7)+1))
    end
    hold off
    figure
    axis([-3 3 -3 3])
    hold on
    for i=1:7
        con = unique(TRI.ConnectivityList(TRI_clus==a(i),:));
        scatter(TRI.Points(con,1),TRI.Points(con,2),color(mod(i,7)+1))
    end
    hold off
end

