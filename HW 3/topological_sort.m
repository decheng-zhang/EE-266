% (d) %
function L = topological_sort( A )

% Initialization
L = [];
S = [];
for i = 1:size(A,1),
    if(all(A(:,i) == 0)) S = [S i]; end
end

% Main Algorithm
while length(S) > 0,
    n = S(1);
    S = S(2:end);
    L = [L n];
    
    for m = find(A(n,:) ~= 0),
        A(n,m) = 0;
        if(all(A(:,m) == 0)) S = [S m]; end
    end
end

if(~all(A == 0)) error('graph has at least one cycle'); end

end

