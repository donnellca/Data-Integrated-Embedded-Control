close all
figure
gif('voronoi.gif')
for i=5:round(length(T_i)/3)
    DT1_i = delaunayTriangulation(transpose(T_i(:,1:i*3)));
    %DT1_f = triangulation(DT1_i.ConnectivityList,transpose(T_f));
    voronoi(DT1_i)
    %triplot(DT1_i,'b')
    %hold on
    %triplot(DT1_f,'r')
    %hold off
    axis([-3 3 -3 3])
    gif
    %drawnow
end
gif('clear')