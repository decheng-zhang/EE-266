% EE 266 Homework 5 Problem 3 %
close all; clear all;

appliance_sched_data;
e_c = flipud(e_c); % This is necessary since the code starts with e_c(end)%

% (a) % Minimum mean cost schedule (open-loop) %

V = [0; Inf*ones(C,1)];
policy = [];

for t = T-1:-1:0,
    cur_val = [0; Inf*ones(C,1)];
    pols = zeros(C+1,1);
    for c = 1:C,
        [cur_val(c+1), pols(c+1)] = ...
            min([e_c(c)*p_mu(t+1) + V(c,1), V(c+1,1)]);
        
        pols(c+1) = (pols(c+1) == 1);
    end
    V = [cur_val V];
    policy = [pols policy];
end

inds = [];
total = C+1;
for t = 1:T,
    if(total == 1) break; end
    if(policy(total,t) == 1), 
        total = total - 1; 
        inds = [inds t];
    end
end

EJ = p_mu(inds)*e_c;
disp(EJ); % for histogram verification %

% monte-carlo histogram %
iters = 100000;

mu = zeros(1,T);
var = zeros(1,T);
std = zeros(1,T);
for i = 1:T,
    pmu = p_mu(i);
    pvar = p_var(i);
    mu(i) = log(pmu^2/sqrt(pmu^2 + pvar));
    var(i) = log(1+pvar/(pmu^2));
    std(i) = sqrt(var(i));
end
mu_abridged = mu(inds);
std_abridged = std(inds);

sums = [];
for iter = 1:iters;
    sum = 0;
    for i = 1:C,
        z = std_abridged(i)*randn(1,1) + mu_abridged(i);
        w = exp(z);
        sum = sum+e_c(i)*w;
    end
    sums = [sums sum];
end
disp(mean(sums)); % for verification %
hist(sums,20);


% (b) %
% pdf %
f = @(p,m,v)(lognpdf(p,m*ones(size(p)),v*ones(size(p))));
warning('off');
V = [0; Inf*ones(C,1)];

for t = T-1:-1:0,
    cur_val = [0; Inf*ones(C,1)];
    for c = 1:C,
        term1 = 0;
        if(V(c,1) ~= Inf),
            term1 = integral(@(x)((e_c(c)*x+V(c,1)*ones(size(x))).*...
                    f(x,mu(t+1),var(t+1))),0,V(c+1,1)-V(c,1));
        else term1 = Inf; end;
                
        term2 = 0;
        if(V(c+1,1) ~= Inf),
            % using (1-integral) for numerical stability reasons %
            term2 = V(c+1,1)*(1-integral(@(x)(f(x,mu(t+1),var(t+1))),0, ...
                    V(c+1,1)-V(c,1)));
        else term2 = Inf; end;

        if(term2 == Inf), cur_val(c+1) = term1;
        else cur_val(c+1) = term1+term2;  end;
    end
    V = [cur_val V];
end
disp(V(end,1)); % for verification %

% Histogram of J %
figure;
sums = [];
for iter = 1:iters;
    sum = 0;
    c = C;
    for t = 1:T,
        if(c == 0), break; end;
        z = std(t)*randn(1,1) + mu(t);
        w = exp(z);
        if(e_c(c)*w < V(c+1,t)-V(c,t)),
            sum = sum + e_c(c)*w;
            c = c-1;
        end
    end
    sums = [sums sum];
end
disp(mean(sums)); % for verification %
hist(sums,20);











