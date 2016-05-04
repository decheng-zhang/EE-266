% EE 266 Homework 4 Problem 4 %
close all; clear all;

knapsack_data;

N = n*W + 2;
sz = [n W];
P = Inf*ones(N,N);


P(:,end) = 0; % Every node goes to the end with 0 cost %

for i = 1:n,
    % The start node goes to every other node with its given weight and %
    % value %
    if(w(i) <= W), P(1,sub2ind(sz,i,w(i)) + 1) = -v(i); end;
    
    for j = i+1:n,
       
        for k = 1:W,
            if(k + w(j) <= W) P(sub2ind(sz,i,k)+1,sub2ind(sz,j,k+w(j))+1) = -v(j); end
        end
    end
end


[p,wp] = bellman_ford(P,1,N);

wp = -wp;
p = p(2:end-1);
p = p - ones(1,length(p));


items = [];
for i = 1:length(p),
    [newItem, ~] = ind2sub(sz,p(i));
    items = [items newItem];
end