function [TRI_i,TRI_f] = gen_DT_time(samps, odefun)

time = 0:0.05:(round(samps*0.05));
%sample_0 = rand(1,2)*6-3;
sample_0 = [0.1,0.1];
[~,sample_f] = ode23(odefun,time,sample_0);

T_i = zeros(length(time)-1,2);
T_f = T_i;
for i=1:(length(time)-1)
    T_i(i,:) = sample_f(i,:);
    T_f(i,:) = sample_f(i+1,:);
end

TRI_i = delaunayTriangulation(T_i);
TRI_f = triangulation(TRI_i.ConnectivityList,T_f);

end