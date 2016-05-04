function [val , pol] = ss_lqsc(f,g,wbar,wvar)

ITERS = 1000;

[n,m] = size(f.A);
m = m-2*n;

val = min(g,m);
for i = 1:ITERS,
    ff = Expect(val(f),wbar,wvar);
    [val, pol] = min(g+ff,m);
end

end