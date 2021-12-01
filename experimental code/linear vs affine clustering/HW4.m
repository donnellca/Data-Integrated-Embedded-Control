%close all
clear
rng(12)

%%
tic
[TRI_i,TRI_f] = gen_DT_unif(50000,@VanderPol);
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
[TRI_clus,sumd] = gen_clusters(TRI_trans,7);
toc
%%
plot_DT(TRI_i,TRI_f)
plot_clusters(TRI_i,TRI_clus)
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