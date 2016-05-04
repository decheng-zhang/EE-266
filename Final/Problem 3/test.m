% Problem 3 Test notes %
close all; clear all;

randn('seed',0);
T = 40;
b = .1;
X = 20;

ITERS = 1000;
results = zeros(1,1000);
for i = 1:ITERS,
    result = 0;
    p = randn(1,1);
    x = X;
    for t = 1:T,
        k = Inf;%factorial(T-t+1)/b;
        u = x/k;
        u = 0;
        %u = max([0 sqrt(x)]);
        %disp(u);
        %u = x/2;
        if t == T, u = x; end;
        w = randn(1,1);
        p = p-u*b+w;
        x = max([0 x-u]);
        result = result + u*p;
    end
    if x ~= 0, result = Inf; end;
    results(i) = result;
end
hist(results);
disp(mean(results));