function h_cost = tile8_man_dist(x,t),

h_cost = 0;
for i = 0:8,
    ind = find(x == i);
    [xx,xy] = ind2sub([3 3],ind);
    
    ind2 = find(t == i);
    [tx, ty] = ind2sub([3 3],ind2);
    
    
    h_cost = h_cost + .05*(abs(xx-tx) + abs(xy-ty))^2;
end

end