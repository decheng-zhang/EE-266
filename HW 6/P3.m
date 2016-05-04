% EE 266 Homework 6 Problem 3 %
close all; clear all;

lqsc_example_data;

terminal_qf = quadratic_function(pT,qT,rT);
gT = @(x)(terminal_qf(x));
ITERS = 10000;

v{T+1} = quadratic_function(pT,qT,rT);

PP{T+1} = pT;
for t = T-1:-1:0,
    Ks = zeros(m,n);
    Ps = zeros(n,n);
    for w = 1:k,
        qf = quadratic_function(P{t+1,w},q{t+1,w},r{t+1,w});
        [xs,us] = min(qf,m);
        Q = xs.P;
        R = us.A;
        R = R*R';
        Aw = A{t+1,w};
        Bw = B{t+1,w};
        
        Kw = -(R+Bw'*PP{t+2}*Bw)\(Bw'*PP{t+2}*Aw);
        mat = Aw + Bw*Kw;
        PPw = Q + Kw'*R*Kw + mat'*PP{t+2}*mat;
        
        Ks = Ks + Kw*p(t+1,w);
        Ps = Ps + PPw*p(t+1,w);
    end
    
    K{t+1} = Ks;
    PP{t+1} = Ps;
    
end



% Monte Carlo Simulation %

g = @(x,u,P,q,r)(.5*[x;u]'*P*[x;u] + q'*[x;u] + .5*r);
f = @(x,u,A,B,c)(A*x+B*u+c);

costs = [];
for iter = 1:ITERS;
    x = x0;
    cost = 0;
    for t = 0:T-1,
        %u = K{t+1}*x;
        u = zeros(m,1);
        wInd = sum(cumsum(p(t+1,:)) < rand(1,1)) + 1;
        PPP = P{t+1,wInd};
        qqq = q{t+1,wInd};
        rrr = r{t+1,wInd};
        AAA = A{t+1,wInd};
        BBB = B{t+1,wInd};
        ccc = c{t+1,wInd};
        
        cost = cost + g(x,u,PPP,qqq,rrr);
        x = f(x,u,AAA,BBB,ccc);
        
    end
    cost = cost + terminal_qf(x);
    costs = [costs cost];
end

hist(log10(costs));
    
    