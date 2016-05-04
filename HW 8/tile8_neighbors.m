function [Nx , WNx] = tile8_neighbors(x,h)


[zx,zy] = ind2sub([3 3],find(x == 0));

swapInds = [];
if(zx > 1), swapInds = [swapInds; [zx-1, zy]]; end;
if(zx < 3), swapInds = [swapInds; [zx+1, zy]]; end;
if(zy > 1), swapInds = [swapInds; [zx, zy-1]]; end;
if(zy < 3), swapInds = [swapInds; [zx, zy+1]]; end;

WNx = [];
xx = reshape(x,3,3);
hxx = h(x); % Cached since it is used for each neighbor %
for i = 1:size(swapInds,1),
    xy = xx;
    xy(zx,zy) = xx(swapInds(i,1),swapInds(i,2));
    xy(swapInds(i,1),swapInds(i,2)) = 0;
    xy = xy(:)';
    Nx{i} = xy;
    WNx = [WNx; 1 + h(xy) - hxx];
end

end