% EE 266 Homework 1 Problem 4 %
close all; clear all;

simple_system_data;

g = @(x,u,w,t)(-a*(x == 1)*(u ==1)*(w == 1) + ct(t)*(x==1)*(u==2));

% (a) %
Expected_Costs_A = zeros(1,size(U_seq,2));
for i = 1:size(U_seq,2),
    U = U_seq(:,i);
    Expected_cost = 0;
    for j = 1:size(W_seq,2),
        W = W_seq(:,j);
        
        cost = 0;
        x = x0;
        for k = 1:size(U_seq,1),
            u = U(k);
            w = W(k);
            cost = cost + g(x,u,w,k);
            x = u;
        end
        if(x ~= xf), 
            cost = Inf; 
        end
            
        Expected_cost = Expected_cost + cost*pw(j);
    end
    
    Expected_Costs_A(i) = Expected_cost;
end

[min_Val, best_index] = min(Expected_Costs_A);
% min_Val = 1.0000 , best_index = 15 %

% (b) %

Best_Costs_B = zeros(1,size(W_seq,2));
Best_Indices_B = zeros(1,size(W_seq,2));

for i = 1:size(W_seq,2),
    W = W_seq(:,i);
    costs = [];
    for j = 1:size(U_seq,2),
        U = U_seq(:,j);
        
        cost = 0;
        x = x0;
        for k = 1:size(U_seq,1),
            u = U(k);
            w = W(k);
            cost = cost + g(x,u,w,k);
            x = u;
        end
        if(x ~= xf), 
            cost = Inf; 
        end
        costs = [costs cost];
    end
    
    [Best_Costs_B(i),Best_Indices_B(i)] = min(costs);
end
Expected_Cost_B = Best_Costs_B*pw;
% Expected_Cost_B = -2.2400 %

% (c) %
Expected_Costs_C = zeros(1,size(phi_cl,1));
for cell = 1:size(phi_cl,1),
    phi = phi_cl{cell};
    
    for i = 1:size(W_seq,2),
        W = W_seq(:,i);
        cost = 0;
        x = x0;
        for k = 1:size(U_seq,1),
            w = W(k);
            u = phi(x,w,k);
            cost = cost + g(x,u,w,k);
            x = u;
        end
        if(x ~= xf),
            cost = Inf;
        end
        Expected_Costs_C(cell) = Expected_Costs_C(cell) + cost*pw(i);
    end 
end

[opt_val, opt_cl_policy] = min(Expected_Costs_C);
% opt_val = -1.6310, optimal indices are 632, 888, 1656, 1912 %

% (d) %
indices = find(Expected_Costs_C == opt_val);
for p = 1:length(indices),
    phi = phi_cl{indices(p)};
    costs = [];
    for i = 1:size(W_seq,2),
        W = W_seq(:,i);
        cost = 0;
        x = x0;
        for k = 1:size(U_seq,1),
            w = W(k);
            u = phi(x,w,k);
            cost = cost + g(x,u,w,k);
            x = u;
        end
        if(x ~= xf),
            cost = Inf;
        end
        costs = [costs cost];
    end 
    values = unique(costs);
    pww = zeros(length(values));
    for i = 1:length(values),
        pww(i) = sum(pw(costs == values(i)));
    end
    subplot(length(indices),1,p);
    stem(values,pww); hold on;
    title(sprintf('phi index: %d',indices(p)));
    xlabel('cost');
    ylabel('probability');
end