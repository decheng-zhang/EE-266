% EE 266 Homework 5 Problem 1 %
close all; clear all;

% Parameters %
T = 50;
C = 20;
D = 4;
q0 = 10;
P_dt = [.2 .25 .25 .2 .1];

p_fixed = 4  ;
p_whole = 2  ;
p_disc  = 1.6;
u_disc  = 6  ;
s_lin   = 0.1;
s_quad  = .05;
p_rev   = 3  ;
p_unmet = 3  ;
p_sal   = 1.5;

% Function setup %

g_order = @(u)((p_fixed + p_whole*u)*(u >= 1 && u <= u_disc) + ...
         (p_fixed + p_whole*u_disc + p_disc*(u-u_disc))*(u > u_disc));
     
g_store = @(q)(s_lin*q + s_quad*q^2);
g_rev = @(q,u,d)(-p_rev*min([q+u,d]));
g_unmet = @(q,u,d)(p_unmet*max([-q-u+d, 0]));
g_sal = @(q)(-p_sal*q);


g_t = @(q,u,d)(g_order(u) + g_store(q+u-d) + g_rev(q,u,d) + g_unmet(q,u,d));


% Dynamic Program %

% Terminal Costs %
V = [];
for i = 0:C,
    V = [V;g_sal(i)];
end

% Stage Costs %

policy = []; % Stores policy of purchase quantity %
route = [];  % Stores policy of stock to have after purchase %

% At each time %
for t = T-1:-1:1,
    v = [];
    p = [];
    r = [];
    % For each q %
    for q = 0:C,
        % For each order amount %
        Expected_Values = [];
        for u = 0:C-q,
            % evaluate costs for each demand realization (+1 for
            % Matlab's one-indexing purposes) %
            g = [g_t(q,u,0) + V(max([q+u-0,0]) +1 ,1);...
                 g_t(q,u,1) + V(max([q+u-1,0]) +1 ,1);...
                 g_t(q,u,2) + V(max([q+u-2,0]) +1 ,1);...
                 g_t(q,u,3) + V(max([q+u-3,0]) +1 ,1);...
                 g_t(q,u,4) + V(max([q+u-4,0]) +1 ,1)];

            Expected_Values = [Expected_Values P_dt*g]; 
        end
        [cur_exp_val, cur_pol] = min(Expected_Values);
        
        v = [v; cur_exp_val];
        p = [p; cur_pol-1];
        r = [r; q+cur_pol-1];
    end
    
    V = [v, V];
    policy = [p, policy];
    route = [r, route];
end

J_star = V(11,1);

% (b) %
interesting_policies = policy(:,end-3:end)';
figure;
for i = 1:4,
   subplot(2,2,i)
   plot(0:C,interesting_policies(5-i,:));
   xlabel('c');
   ylabel('# to purchase');
   title(sprintf('t = %d',T-i));
end

% (c) %
% Finding expected values of g_functions through distribution propogation %
P = eye(C+1)*P_dt(1); % Transition matrix %
for i = 1:D,
    P2 = eye(C+1)*P_dt(i+1);
    P2 = [P2(:,i+1:end) zeros(C+1,i)];
    P2(1:i,1) = P_dt(i+1);
    P = P+P2;
end

% Time varying transition matrix %
for t = 1:T-1
    Q = P;
    for q = 1:C+1,
        Q(q,:) = Q(q+policy(q,t),:);
    end
    PP{t} = Q;
end

% Finding distribution at each time %
ppi = zeros(1,21) + (1:21 == 11);
dist = ppi;
for t = 1:T-1,
    dist = [dist; dist(t,:)*PP{t}];  
end
dist = dist';


Eg_order = [];
Eg_store = [];
Eg_rev =   [];
Eg_unmet = [];
Eg_sal   = [];

for t = 1:T-1,
    gorder = [];
    gstore = [];
    grev   = [];
    gunmet = [];
    for q = 0:C,
        % g_order %
        gorder = [gorder g_order(policy(q+1,t))];
        
        % g_store %
        gs = [g_store(max([q+policy(q+1,t),0]));...
              g_store(max([q+policy(q+1,t)-1,0]));...
              g_store(max([q+policy(q+1,t)-2,0]));...
              g_store(max([q+policy(q+1,t)-3,0]));...
              g_store(max([q+policy(q+1,t)-4,0]))];
        gstore = [gstore P_dt*gs];
        
        % g_rev %
        gr = [g_rev(q,policy(q+1,t),0);...
              g_rev(q,policy(q+1,t),1);...
              g_rev(q,policy(q+1,t),2);...
              g_rev(q,policy(q+1,t),3);...
              g_rev(q,policy(q+1,t),4)];
        grev = [grev P_dt*gr];
        
        % g_unmet %
        gu = [g_unmet(q,policy(q+1,t),0);...
              g_unmet(q,policy(q+1,t),1);...
              g_unmet(q,policy(q+1,t),2);...
              g_unmet(q,policy(q+1,t),3);...
              g_unmet(q,policy(q+1,t),4)];
        gunmet = [gunmet P_dt*gu];
        
    end
    Eg_order = [Eg_order gorder*dist(:,t)];
    Eg_store = [Eg_store gstore*dist(:,t)];
    Eg_rev   = [Eg_rev   grev*dist(:,t)  ];
    Eg_unmet = [Eg_unmet gunmet*dist(:,t)];
end

Eg_order = [Eg_order 0];
Eg_store = [Eg_store 0];
Eg_rev   = [Eg_rev   0];
Eg_unmet = [Eg_unmet 0];

Eg_sal = zeros(1,T);
Eg_sal(end) = dist(:,end)'*V(:,end);


figure;
plot(1:T,Eg_order, 'm'); hold on;
plot(1:T,Eg_store, 'b');
plot(1:T,Eg_rev  , 'g');
plot(1:T,Eg_unmet, 'r');
plot(1:T,Eg_sal  , 'k');

legend('Eg^{order}','Eg^{store}','Eg^{rev}','Eg^{unmet}','Eg^{sal}');
