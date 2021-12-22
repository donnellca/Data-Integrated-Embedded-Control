%#ok<*UNRCH> 
%#ok<*INUSL> 
%#ok<*INUSD> 

close all
clear
rng(12)
gcp(); % parallel pools

%%
color = ['r','g','b','c','m','y','k'];

deltaT = 0.05;
samples = 10000;

%%
tic
u = linspace(-3,3,sqrt(samples)); 
U_trans = cell(length(u),3);
for i=1:length(u)
    u_i = u(i);
    [TRI_i,TRI_f] = gen_DT_unif(samples,deltaT,@(x,t) VanderPol(x,t,u_i));
    TRI_trans = gen_pre_computed_trans(TRI_i,TRI_f);
    U_trans(i,:) = {u_i,TRI_i,TRI_trans};
    disp(i)
    toc
end
toc

%%
tic
err_curve = [];
figure
%gif('rand affine alt2.gif','DelayTime',1/3)
for i=[2,4,6,8,11,13,16,18,21,24,27,30,34,37,40,43,47,51,57,64,72,81,93,100]
    disp(i)
    clf
    [TRI_clus,C,sumd] = gen_clusters(TRI_trans,i);
    err_curve(end+1,:) = [i,mean(sumd)];
    [n,bin] = hist(TRI_clus,unique(TRI_clus));
    [~,idx] = sort(-n);
    a=bin(idx);
%     axis([-3 3 -3 3])
%     %title("Simple Harmonic Oscillator",{"Uniform Distribution","Clusters: "+i})
%     hold on
%     for n=1:length(a)
%         triplot(TRI_i.ConnectivityList(TRI_clus==a(n),:),TRI_i.Points(:,1),TRI_i.Points(:,2),color(mod(n,7)+1))
%     end
%     drawnow
%     hold off
    %gif
    if mean(sumd) < 1
        break
    end
end
% for m = 1:10
%      gif
% end
figure; plot(err_curve(:,1),err_curve(:,2))
figure
axis([-3 3 -3 3])
title("Clusters: "+i)
hold on
for n=1:length(a)
triplot(TRI_i.ConnectivityList(TRI_clus==a(n),:),TRI_i.Points(:,1),TRI_i.Points(:,2),color(mod(n,7)+1))
end
hold off
toc

%%

for i=1:length(u)
    TRI_i = U_trans{i,2};
    TRI_trans = U_trans{i,3};
    [TRI_clus,C,sumd] = gen_clusters(TRI_trans,64);
end

%%

T=2;
x_0 = [0;1];
x_f = [1;0];

dynamics = @(p,u) find_AB(p,u,U_trans);

iterative_optimal_controller(dynamics, x_0, x_f, T, deltaT)

%% functions
function dxdt = VanderPol(t,x,u)
    dxdt = zeros(size(x));
    dxdt(1) = x(2);
    dxdt(2) = (1-x(1)*x(1))*x(2)-x(1)+u;
end

function dthetadt = pendulum(t, theta,u)
    dthetadt = zeros(size(theta));
    dthetadt(1) = theta(2);
    dthetadt(2) = -9.8*sin(theta(1))+u;
end

function dxdt = nonlin(t,x,u) 
    dxdt = zeros(size(x));
    dxdt(1) = x(2);
    dxdt(2) = x(1)*x(2)+u;
end