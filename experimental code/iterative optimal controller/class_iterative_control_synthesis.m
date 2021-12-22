clear
clc
close all

syms xi1 xi2 xi3 xi4 xi5 dt

m1 = 0.8;
m2 = 0.5;
l = 0.5;
g = 9.81;
F = [xi3;
     xi4;
     1/(m1+m2*(1-cos(xi2)^2))*(l*m2*sin(xi2)*xi4^2+xi5+m2*g*cos(xi2)*sin(xi2));
     -1/(l*m1+l*m2*(1-cos(xi2)^2))*(l*m2*cos(xi2)*sin(xi2)*(xi4)^2+xi5*cos(xi2)+(m1+m2)*g*sin(xi2));
     0];
F = simplify(F);

p = 3;

[Phi,Psi_p,JPhi] = compute_Phi_and_JPhi(p,F,[xi1 xi2 xi3 xi4 xi5],dt);
disp( 'Done!' );


F = matlabFunction(F(1:4),'Vars',[xi1 xi2 xi3 xi4 xi5]);

% save('cartpole_model.mat','Phi','Psi_p','JPhi','p','F')

%% Part 1: Steer

x0 = [0;0;0;0];
x_target = [1;pi;0;0];

dt = 0.005;
T = 2;
iter_max = ceil(T/dt);

u = zeros(iter_max,1); 
u_min = -10; u_max = 10;
options = optimoptions(@quadprog,'Display','off');

while true
    x = x0;
    x_traj = [];

    for iter = 1:iter_max
        % Prepare A,B to later calculate H
        R_big = JPhi(dt,x(1),x(2),x(3),x(4),u(iter));       
        A_store{iter} = R_big(1:4,1:4);     % A in Ax+Bu    
        B_store{iter} = R_big(1:4,5:5);     % B in Ax+Bu

        % The actual trajectory using adaptive step size mechanism
        [~, x_trajJ_fine] = adaptive_taylor(p,Phi,Psi_p,[0 dt],[x;u(iter)]); 
        x = x_trajJ_fine(end,:)'; % the end of this sequence is x[k+1]
        x = x(1:4);
        x_traj = [x_traj x];      
    end
    
    
    error = norm(x-x_target)
    if error <= 0.001
        break
    end
    % Calculate H
    H = B_store{1};
    for iter = 2:iter_max
        H = [A_store{iter}*H, B_store{iter}];
    end
    u = u + quadprog(H'*H+0.001*error^2*eye(iter_max), (x-x_target)'*H, [],[],[],[],u_min-u,u_max-u,[],options);
    
end 
step1_u = u;
display('done1')
figure(2)
plot_steer = plot(step1_u,'LineWidth',2);


%% Part2: Minimum Energy  
gama = 5;
u = step1_u;
options = optimoptions(@quadprog,'Display','off');

for rep=1:500
    x = x0;
    x_traj = [];

    for iter = 1:iter_max
        % Prepare A,B to later calculate H
        R_big = JPhi(dt,x(1),x(2),x(3),x(4),u(iter));       
        A_store{iter} = R_big(1:4,1:4);     % A in Ax+Bu    
        B_store{iter} = R_big(1:4,5:5);     % B in Ax+Bu

        % The actual trajectory using adaptive step size mechanism
        [~, x_trajJ_fine] = adaptive_taylor(p,Phi,Psi_p,[0 dt],[x;u(iter)]); 
        x = x_trajJ_fine(end,:)'; % the end of this sequence is x[k+1]
        x = x(1:4);
        x_traj = [x_traj x];      
    end
        
    error = norm(x-x_target);

    % Calculate H
    H = B_store{1};
    for iter = 2:iter_max
        H = [A_store{iter}*H, B_store{iter}];
    end
    
    
    % Update u
    du = quadprog((1+gama)*eye(iter_max),u,[],[],H,x_target-x,[],[],[],options);
    u = u + du;        

    fprintf('rep=%.0f; |xn-x_target| = %.4f; |u| = %.4f; |du| = %.4f; \n',...
            [rep, error, norm(u), norm(du)]);
    
    if norm(du)<0.01
        break
    end
end 

figure(2)
hold on
plot_optimal = plot(u,'LineWidth',2);
set(gca,'FontSize',12)
legend([plot_steer,plot_optimal],{'nominal input','energy optimal input'},'Location','best','FontSize',12);

%% Animation
close all
L = 0.3;
H = 0.1; 

figure

LB = min(x_traj(1,:))-1;
UB = max(x_traj(1,:))+1;

for k = 1:5:length(x_traj)
    
    clf    
    hold on
    
    % plot cart
    rectangle('Position', [x_traj(1,k)-0.5*L -H L H],'FaceColor','b','EdgeColor','b')    
    
    % plot pole
    plot([x_traj(1,k) x_traj(1,k)+3*L*sin(x_traj(2,k))],[0 -3*L*cos(x_traj(2,k))],'Color','k','LineWidth',2.5);
    
    % plot mass
    scatter([x_traj(1,k)+3*L*sin(x_traj(2,k))], [-3*L*cos(x_traj(2,k))],100,'r','filled');
    plot([-1 2],[-0.1 -0.1],'k');
    axis equal
    axis([-1 2 -1.3 1.3])
    set(gcf, 'Units', 'pixels', 'Position', [600, 500, 950, 500]);

    %pause(0.5)
    drawnow;

end


%% Discretization and Linearization scheme

function [Phi,Psi_p,JPhi] = compute_Phi_and_JPhi(p,F,xi,dt)
Id = [];

for i = 1:length(xi)
    Id = [Id; xi(i)];
end

J = eye(length(xi));  % Identity 
Psi = Id;             % [xi1; xi2; xi3; xi4; xi5] 

Phi_syms = Psi;       % [xi1; xi2; xi3; xi4; xi5] 
JPhi_syms = J;        % Identity 

for k_deg = 1:p
    tic
    
    Psi = J*F;
    Psi = simplify(Psi); % Calculate Psi 
    
      J = jacobian(Psi,xi); 
      J = simplify(J);   % Jacobian of Psi 
      
    % Taylor approxi. of the flow (discretization purpose) 
    Phi_syms = Phi_syms + (dt^k_deg/factorial(k_deg))*Psi;
    % Taylor approxi. of the jacobian of flow (linearization purpose)
    JPhi_syms = JPhi_syms + (dt^k_deg/factorial(k_deg))*J;
   
    toc
end
% Turn symbolic expressions into functions 
Phi = matlabFunction(simplify(Phi_syms),'Vars',[dt xi]);  % The flow 
Psi_p = matlabFunction(simplify(Psi),'Vars',xi);          % The last Psi 
JPhi = matlabFunction(simplify(JPhi_syms),'Vars',[dt xi]);% Jacobian of the flow

end

% Numerical integration with adaptive dt
function [t_store, x_trajJ] = adaptive_taylor(p,Phi,Psi_p,interval,x0)

xJ = x0;
x_trajJ = [xJ];

err_tol = 10e-9;

t = interval(1);
t_store = [t];
dt_store = [];

while t < interval(2)
    T = num2cell(xJ);
    dt = min((err_tol*factorial(p)/norm(Psi_p(T{:}),inf))^(1/p),interval(2)-t);
    t = t+dt;
    t_store = [t_store t];
    dt_store = [dt_store, dt];
    
    xJ = Phi(dt,T{:});
    x_trajJ = [x_trajJ xJ];
    
end

t_store = transpose(t_store);
x_trajJ = transpose(x_trajJ);

end






