function [TRI_i,TRI_f] = gen_DT_unif(samps, deltaT, odefun)

time = [0,deltaT];
sample_0 = rand(samps,2)*6-3;
sample_f = zeros(length(sample_0),2);
if samps > 100
    parfor i=1:size(sample_0,1) 
        [~,y] = ode23(odefun,time,sample_0(i,:));
        sample_f(i,:) = y(end,:);
    end
else
    for i=1:size(sample_0,1) 
        [~,y] = ode23(@odefun,time,sample_0(i,:));
        sample_f(i,:) = y(end,:);
    end
end

T_i = zeros(size(sample_0,2)*(length(time)-1),2);
T_f = T_i;
for i=1:size(sample_0,1)
    T_i(i,:) = sample_0(i,:);
    T_f(i,:) = sample_f(i,:);
end

TRI_i = delaunayTriangulation(T_i);
TRI_f = triangulation(TRI_i.ConnectivityList,T_f);

end