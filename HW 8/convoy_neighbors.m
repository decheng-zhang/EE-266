function [Nx, WNx] = convoy_neighbors(x,G)


  inds = find(G(x,:));
  vals = G(x,inds);

  WNx = vals';
  for i = 1:length(inds),
      Nx{i} = inds(i);
  end
end