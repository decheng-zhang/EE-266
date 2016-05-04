% EE 266 Homework 3 Problem 3 %
close all; clear all;

link_matrix_data;

% (a) %
ppi = ones(1,n)/n;
o = L*ones(n,1);

P = zeros(n,n);

for i = 1:n,
    if(o(i) > 0),
        P(i,:) = (theta/o(i) * (L(i,:) == 1)) + ...
                 ((1-theta)/(n-o(i)-1) * (L(i,:) == 0));
    else,
        P(i,:) = ones(1,n)/(n-1);
    end
    P(i,i) = 0;
end

t10 = ppi*(P^10);
[maxprob10, ind10] = max(t10);
t100 = t10*(P^90);
[maxprob100, ind100] = max(t100);

% (b) %

% Monte Carlo simulation %
iters = 100000;
rand('seed',1);
endt = 50;

J = zeros(1,iters);
for i = 1:iters
    [~,x] = max(ppi.*rand(1,n));
    for j = 1:endt-1,
        % choose next state %
        [~,y] = max(P(x,:).*rand(1,n));
        % add to J based on transition %
        J(i) = J(i) + R(x,y);

        x = y;
    end 
end

J_MC = mean(J);


% Distribution propogation %
expected_costs = sum(R.*P,2);

J_DP = 0;
for t = 0:endt-1,
    dist = ppi*(P^t);
    J_DP = J_DP + dist*expected_costs;
end


% Value iteration %
g = expected_costs;

J_VI = 0;
v = g;
for i = 1:endt-1,
    v = g + P*v;
end
J_VI = ppi*v;