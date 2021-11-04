
clear

time = 0:0.05:10;
samps = 25;
%parpool %preallocates parallel computing pool, only needs to be done once
rng(12)
sample_0 = rand(2,samps)*6-3;
sample_f = zeros(2,length(sample_0),length(time));
%[t,y] = ode23(@odefun,time,sample_0(:,1));

%%
for i=1:length(sample_0) % always works, only speeds up computation w/ Parallel Computing Toolbox
    [t,y] = ode23(@odefun,time,sample_0(:,i));
    %y = y([1 end],:);
    sample_f(:,i,:) = permute(y,[2 3 1]);
end

T_i = zeros(2,length(sample_0)*(length(time)-1));
T_f = T_i;
C_i = T_i;
C_f = T_i;
for i=1:length(sample_0)
    for k=1:(length(time)-1)
        l = (i-1)*(length(time)-1)+k;
        T_i(:,l) = sample_f(:,i,k);
        if k ~= length(time)-1
            C_i(:,l) = [l;l+1];
        end
        T_f(:,l) = sample_f(:,i,k+1);
        if k ~= 1
            C_f(:,l) = [l-1,l];
        end

    end
end
B_i = C_i(:,C_i(1,:)~=0);
B_f = C_f(:,C_f(1,:)~=0);

%%
close all

figure
axis([-3 3 -3 3])
hold on
scatter(T_i(1,:),T_i(2,:),'b')
scatter(sample_0(1,:),sample_0(2,:),'r')
hold off

figure
axis([-3 3 -3 3])
hold on
for i=1:length(sample_0)
    plot(squeeze(sample_f(1,i,:)),squeeze(sample_f(2,i,:)))
end
hold off

figure
axis([-3 3 -3 3])
hold on
DT1_i = delaunayTriangulation(transpose(T_i));
DT1_f = triangulation(DT1_i.ConnectivityList,transpose(T_f));
%voronoi(DT1_i)
triplot(DT1_i,'b')
triplot(DT1_f,'r')
hold off

% figure
% axis([-3 3 -3 3])
% hold on
% DT2_i = delaunayTriangulation(transpose(T_i),transpose(B_i));
% %DT2_f = delaunayTriangulation(transpose(T_f),edges(DT2_i));
% triplot(DT2_i,'b')
% %triplot(DT2_f,'r')
% hold off

figure
axis([-3 3 -3 3])
hold on
voronoi(DT1_i)
hold off

% figure
% axis([-3 3 -3 3])
% hold on
% voronoi(DT2_i)
% hold off

% figure
% DT2 = delaunayTriangulation(transpose(T),transpose(B));
% triplot(DT2)
% axis([-3 3 -3 3])

% hold on
% for i=1:length(sample_0)
%     triplot(delaunayTriangulation(transpose(squeeze(sample_f(:,i,:)))))
% end
% hold off
%% functions
function dxdt = odefun(t,x) %#ok<INUSL> 
    dxdt = zeros(size(x));
    dxdt(1) = x(2);
    dxdt(2) = (1-x(1)*x(1))*x(2)-x(1);
end