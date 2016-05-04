% EE 266 Homework 7 Problem 4 %
close all; clear all;

crossbar_switch_data;

% (b) %
T = 10000;
%{
x = poissrnd(lambda);
total_cost = 0;
for i = 1:T,
    inds = [];
    xx = x;
    for j = 1:min([m n]),
        [M,I] = max(xx(:));
        if(M == 0), break; end;
        [row,col] = ind2sub([m n],I);
        xx(row,:) = -Inf*ones(1,n);
        xx(:,col) = -Inf*ones(m,1);
        inds = [inds; [row, col]];
    end
    
    u = zeros(m,n);
    for j = 1:min([m n size(inds,1)]),
        u(inds(j,1),inds(j,2)) = 1;
    end
    w = poissrnd(lambda);
    x = x+w-u;
    
    total_cost = total_cost - Cr*sum(sum(u));
    
    overflow = x - B*ones(size(x));
    overflow = max(overflow,0);
    total_cost = total_cost + Cd*sum(sum(overflow));
    
    x = clip(x,0,B);
    total_cost = total_cost + Cb*sum(sum(x));
end

Jbavg = total_cost/T;
%}
% (d) %
rho = [3;0;0];

warning('off');
Px = diag(lambda(:));
Pu = (rho(1)/(m*n))*eye(m*n);
for i = 1:m,
    Q = zeros(m,n);
    Q(i,:) = ones(1,n);
    Q = Q(:);
    Q = (rho(2)/m)*Q*Q';
    Pu = Pu + Q;
end
for j = 1:n,
    Q = zeros(m,n);
    Q(:,j) = ones(m,1);
    Q = Q(:);
    Q = (rho(3)/n)*Q*Q';
    Pu = Pu + Q;
end
qu = -(rho(1)/(m*n) + rho(2)/m + rho(3)/n)*ones(m*n,1);

P = [Px, zeros(m*n,m*n); zeros(m*n,m*n), Pu];
q = [zeros(m*n,1);qu];
r = [.25,1,1]*rho;

g = quadratic_function(P,q,r);
f = linear_function([eye(m*n), eye(m*n), eye(m*n)],zeros(m*n,1));


[val,pol] = ss_lqsc(f,g,lambda(:),diag(lambda(:)));
val.r = 0;
% Monte Carlo Simulation %
%{
x = poissrnd(lambda);
total_cost = 0;
for i = 1:T,
    inds = [];
    xx = pol(x(:));
    xx = reshape(xx,m,n);
    xx(x == 0) = -Inf;
    for j = 1:min([m n]),
        [M,I] = max(xx(:));
        [row,col] = ind2sub([m n],I);
        xx(row,:) = -Inf*ones(1,n);
        xx(:,col) = -Inf*ones(m,1);
        inds = [inds; [row, col]];
    end
    
    u = zeros(m,n);
    for j = 1:min([m n size(inds,1)]),
        if(x(inds(j,1),inds(j,2)) <= 0), break; end;
        u(inds(j,1),inds(j,2)) = 1;
    end
    w = poissrnd(lambda);
    x = x+w-u;
    total_cost = total_cost - Cr*sum(sum(u));
    
    overflow = x - B*ones(size(x));
    overflow = max(overflow,0);
    total_cost = total_cost + Cd*sum(sum(overflow));
    
    x = clip(x,0,B);
    total_cost = total_cost + Cb*sum(sum(x));
end

Jdavg = total_cost/T;
%}

% (e) %
z = 1:m;
x = poissrnd(lambda);
total_cost = 0;

for i = 1:T,
    u = zeros(m,n);
    lowest_est_cost = Inf;
    for p = z,
        for q = z(z ~= p),
            for y = z(z~= p & z~= q);
                uu = zeros(m,n);
                if(x(p,1) ~= 0), uu(p,1) = 1; end;
                if(x(q,2) ~= 0), uu(q,2) = 1; end;
                if(x(y,3) ~= 0), uu(y,3) = 1; end;
                
                est_cost = -Cr*sum(sum(uu));
                est_cost = est_cost + Cb*sum(sum(clip(x-uu+lambda,0,B)));
        est_cost = est_cost + Cd*sum(sum(clip(x-uu+lambda-B*ones(size(x)),0,100000*ones(size(x)))));
                
                vectorized_x = clip(x-uu+lambda,0,B);
                est_cost = est_cost + val(vectorized_x(:));
                
                if(est_cost < lowest_est_cost),
                    lowest_est_cost = est_cost;
                    u = uu;
                end
            end
        end
    end
    
    
    
    
    w = poissrnd(lambda);
    x = x+w-u;
    
    total_cost = total_cost - Cr*sum(sum(u));
    
    overflow = x - B*ones(size(x));
    overflow = max(overflow,0);
    total_cost = total_cost + Cd*sum(sum(overflow));
    
    x = clip(x,0,B);
    total_cost = total_cost + Cb*sum(sum(x));
end

Jeavg = total_cost/T;