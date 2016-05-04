% EE 266 Homework 4 Problem 1 (a) %
function [p,wp] = bellman_ford(W,s,t)

n = size(W,1);
v = Inf*ones(n,1);
v(t) = 0;
chain = t*ones(n,1);

for i = 1:n,
    
    vtemp = W + ones(n,1)*v';
    [vtemp, x] = min(vtemp,[],2);
    y = (vtemp < v);
    vtemp = min(vtemp,v);
    z = x.*(y==1) + chain.*(y==0);
    if(vtemp == v), break; end;
    chain = z;
    v = vtemp;
end
wp = v(s);

p = s;
current_node = s;
while current_node ~= t,
    current_node = chain(current_node);
    p = [p current_node];
end

end