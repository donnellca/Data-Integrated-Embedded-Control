function plot_DT(TRI_i,TRI_f)

    figure
    axis([-3 3 -3 3])
    hold on
    triplot(TRI_i,'b')
    triplot(TRI_f,'r')
    hold off
    
%     figure
%     axis([-3 3 -3 3])
%     voronoi(TRI_i)

end