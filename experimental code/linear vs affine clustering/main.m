%close all
clear
rng(12)

%%
tic
[TRI_i,TRI_f] = gen_DT_unif(50000,@nonlin);
toc
TRI_trans = gen_pre_computed_trans(TRI_i,TRI_f);
toc

%%
% err_curve = zeros(30,2);
% for i = 1:30
%     [TRI_clus,sumd] = gen_clusters(TRI_trans,i*2+4);
%     err_curve(i,:) = [i*2+4,mean(sumd)];
% end
% toc

%%
figure
gif('rand affine alt2.gif','DelayTime',1/3)
for i=5:10:100%[2,3,4,5,6,7,8,9,11,12,13,14,16,17,18,20,21,22,24,25,27,29,30,32,34,35,36,37,38,40,41,43,45,47,49,51,54,57,60,64,67,72,76,81,87,93,100]
    clf
    [TRI_clus,sumd] = gen_clusters_alt2(TRI_trans,i);
    [n,bin] = hist(TRI_clus,unique(TRI_clus));
    [~,idx] = sort(-n);
    a=bin(idx);
    color = ['r','g','b','c','m','y','k'];
    axis([-3 3 -3 3])
    title("Simple Harmonic Oscillator",{"Uniform Distribution","Clusters: "+i})
    hold on
    for n=1:length(a)
        triplot(TRI_i.ConnectivityList(TRI_clus==a(n),:),TRI_i.Points(:,1),TRI_i.Points(:,2),color(mod(n,7)+1))
    end
    hold off
    gif
end
for m = 1:10
    gif
end
toc
%%
% plot_DT(TRI_i,TRI_f)
% plot_clusters(TRI_i,TRI_clus)
% figure
% plot(err_curve(:,1),err_curve(:,2))

%% functions
function dxdt = VanderPol(~,x)
    dxdt = zeros(size(x));
    dxdt(1) = x(2);
    dxdt(2) = (1-x(1)*x(1))*x(2)-x(1);
end

function dthetadt = pendulum(~, theta)
    dthetadt = zeros(size(theta));
    dthetadt(1) = theta(2);
    dthetadt(2) = -9.8*sin(theta(1));
end

function dxdt = nonlin(~,x)
    dxdt = zeros(size(x));
    dxdt(1) = x(2);
    dxdt(2) = x(1)*x(2);
end