% EE 266 Homework 6 Problem 2 %
close all; clear all;

randn('seed',1);
ITERS = 10000;

rho = 0.1;
n = 4;
sig = 1;

Q = eye(n);
R = rho*eye(n);
A = eye(n);
B = eye(n) - [zeros(n,1), [eye(n-1); zeros(1,n-1)]];
W = zeros(n,n);
W(end,end) = sig^2;


f = @(x,u,d)(x + B*u - [zeros(n-1,1); d]);
g = @(x,u)(.5*x'*x + rho/2*u'*u);


P = R;%eye(n);
K = -(R + B'*P*B)\(B'*P*A);
for iter = 1:ITERS,
    mat = A+B*K;
    P = Q + K'*R*K + mat'*P*mat;
    K = -(R + B'*P*B)\(B'*P*A);
end


mu = @(x)(K*x);
Javg = .5*trace(P*W);
disp(Javg); % For verification of monte_carlo avg %

% MONTE CARLO SIMULATION %
time_series = [];
costs = [];
for trial = 1:100,
    %disp(trial);
    x = zeros(n,1);
    cost = 0;
    for i = 1:ITERS,
        d = sig*randn(1,1);
        u = mu(x);
        if(trial == 1) time_series = [time_series, g(x,u)]; end;
        %if(i >= 10), 
            cost = cost + g(x,u); 
        %end;
        %if(i < 10), disp(x); end;
        x = f(x,u,d);
    end
    cost = cost/(ITERS);
    costs = [costs cost];
end

hist(costs);
disp(mean(costs)); % For verification of Javg %
