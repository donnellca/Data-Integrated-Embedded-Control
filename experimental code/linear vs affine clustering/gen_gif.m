close all
figure
gif('Delaunay.gif')
for i=5:length(T_i)
    DT = delaunayTriangulation(transpose(T_i(:,1:i*3)));
    triplot(DT.ConnectivityList,T_i(1,:),T_i(2,:),'b')
    hold on
    triplot(DT.ConnectivityList,T_f(1,:),T_f(2,:),'r')
    hold off
    axis([-3 3 -3 3])
    gif
    %drawnow
end
gif('clear')