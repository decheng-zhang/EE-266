function hx = heurMap(x,t,X,Y,W,D,p,q)

xpts = waypts(x,X,Y,W);
tpts = waypts(t,X,Y,W);

if(size(xpts,1) == size(tpts,1)),
    if(all(all(xpts == tpts))), hx = manh(x,t,p,q); return; end;
end


dists = Inf*ones(size(xpts,1),size(tpts(1)));
for i = 1:size(xpts,1),
    for j = 1:size(tpts,1),
        dists(i,j) = manh(x,xpts(i,:),p,q) + D(i,j) + ...
            manh(tpts(j,:),t,p,q);
    end
end

hx = min(dists(:));

end