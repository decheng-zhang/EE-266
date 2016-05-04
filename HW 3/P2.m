% EE 266 Homework 3 Problem 2 %
close all; clear all;

class_decomposition_data;

A = ceil(P);
R = reachable_states(A);
C = R.*R';

t = zeros(1,n);
for i = 1:n,
    if(~all(R(i,:) == C(i,:))) t(i) = 1; end;
end

[~, I] = sort(t,'descend');
Rnew = [];
for i = 1:n,
    Rnew = [Rnew R(:,I(i))];
end

[Rfinal, RIA, RIC] = unique(Rnew,'rows');
nnew = size(Rfinal,1);

% (e) %
At = zeros(nnew,nnew);
for i = 1:nnew,
    for j = 1:nnew,
        if(i ~= j),
            for x = find(RIC' == i),
                for y = find(RIC' == j),
                    if(R(x,y) == 1) 
                        At(i,j) = 1; 
                    end
                end
            end
        end
    end
end

L = topological_sort(At');

% (f) %
for i = 1:nnew,
    if(size(find(L==i),2) == 0) L = [L i]; end;
end

Inds = [];
for i = L,
    for j = 1:length(RIC),
        if(RIC(j) == i) Inds = [j Inds]; end
    end
end

newP = zeros(n,n);
for i = 1:n,
    for j = 1:n,
        newP(i,j) = P(Inds(i),Inds(j));
    end
end

spy(newP);
