function [Nx, WNx] = get_neighbors(x,W)

w = W(x,:);
Nx_vec = find(w);
WNx = w(w~=0);

for i = 1:length(WNx),
    Nx{i} = Nx_vec(i);
end

end