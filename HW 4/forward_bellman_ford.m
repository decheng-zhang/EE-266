function [p,wp] = forward_bellman_ford(W,s,t),

n = size(W,1);
v = Inf*ones(n,1);
v(s) = 0;
chain = t*ones(n,1);

for i = 1:n,
    vtemp = W' + ones(n,1)*v';
    [vtemp, x] = min(vtemp,[],2);
    y = (vtemp < v);
    vtemp = min(vtemp,v);
    z = x.*(y==1) + chain.*(y==0);
    if(vtemp == v) break; end;
    chain = z;
    v = vtemp;
end
wp = v(t);


p = t;
current_node = t;
while current_node ~= s,
    current_node = chain(current_node);
    p = [current_node p];
end
end