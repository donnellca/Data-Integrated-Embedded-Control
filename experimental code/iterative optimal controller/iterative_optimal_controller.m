function iterative_optimal_controller(dynamics, x_0_, x_f_, T, deltaT)

%#ok<*NUSED> 
%#ok<*GVMIS> 

global x_0 x_f N; 
x_0 = x_0_;
x_f = x_f_;
N = floor(T/deltaT);
tolerance = 0.1;

figure

%% Part 1: Achieving the terminal constraint
U = (rand(N,1)-0.5);

count = 0;
while true
    % step 1
    X = X_update(U,dynamics);
    x_N = X(:,end);
    % step 2
    H = H_update(X,U,dynamics);
    % step 3
    U = U_update(U,H,x_N);
    % step 4
    plot(X(1,:),X(2,:))
    hold on
    scatter([x_0(1),x_f(1)],[x_0(2),x_f(2)])
    hold off
    draw_frame()
    count = count + 1;
    disp(count + ": norm " +norm(x_N-x_f))
    if norm(x_N-x_f) <= tolerance
        disp("Part 1 converged in " + count + " iterations")
        break
    end
    if count >= 1000
        disp(count + " (max) iter reached")
        disp("Norm reached: " + norm(x_N-x_f))
        disp("Part 1 did not converge, no optimization will be performed")
        return
    end
end

%% Part 2: Achieving minimal control energy
U_prev = U;
U_star = zeros(size(U));
U_star_prev = U_star;

count = 0;
while true
    % step 1
    X = X_update(U,dynamics);
    x_N = X(:,end);
    % step 2
    H = H_update(X,U,dynamics);
    % step 3
    U_prev = U;
    U_star_prev = U_star;
    [U,U_star] = U_update_optimal(U,H,x_N);
    % step 4 & 5
    plot(X(1,:),X(2,:))
    hold on
    scatter([x_0(1),x_f(1)],[x_0(2),x_f(2)])
    hold off
    draw_frame()
    count = count + 1;
    disp(count + ": norm " +abs(norm(U_star) - norm(U_star_prev)) +", " +abs(norm(U)-norm(U_prev)))
    if abs(norm(U_star) - norm(U_star_prev)) <= tolerance && abs(norm(U)-norm(U_prev)) <= tolerance
        disp("Part 2 converged in " + count + " iterations")
        break
    end
    if count >= 1000
        disp(count + " (max) iter reached")
        disp("Delta U_star reached: " + (norm(U)-norm(U_prev)))
        break
    end
end

end

%% functions

function draw_frame()
    view(2)
    axis([-3 3 -3 3])
    drawnow
end

function X = X_update(U,dynamics)
    global x_0 x_f N;
    X = zeros(length(x_0),N);
    X(:,1) = x_0;
    for i=1:N-1
        x_new = dynamics(X(:,i)',U(i)) * [X(:,i);1];
        X(:,i+1) = x_new(1:end-1);
    end
end

function H = H_update(X,U,dynamics) % Calculating BI with precomputed values
    global x_0 x_f N;
    AB = dynamics(X(:,1)',U(1));
    A = AB(1:end-1,1:end-1);
    B = AB(1:end-1,end);
    H = B;
    for i = 2:N
        AB = dynamics(X(:,i)',U(i));
        A = AB(1:end-1,1:end-1);
        B = AB(1:end-1,end);
        H = [A*H, B];
    end
end

function U = U_update(U,H,x_N)
    global x_0 x_f N;
    lambda = 0.5;
    %U = U-(H'*H + lambda*eye(N)) \ (H') * (x_N-x_f);
    U = U + quadprog(H'*H + lambda*eye(N),(H') * (x_N-x_f),[],[],[],[],[],[],[],optimoptions(@quadprog,'Display','off'));
end

function [U,U_star] = U_update_optimal(U,H,x_N)
    global x_0 x_f N;
    lambda = 5;
    U_star = quadprog(lambda*eye(N),U,[],[],H,x_f-x_N,[],-3,3,optimoptions(@quadprog,'Display','off'));
    U = U + U_star;
end