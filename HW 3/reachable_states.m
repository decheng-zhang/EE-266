% EE 266 Homework 3 Problem 2 %
% (a) %
function R = reachable_states( A )
n = size(A,1);
Rnew = A;
R = NaN*ones(size(A));
while ~all(all(R == Rnew)),
    R = Rnew;
    
    for i = 1:n,
        % iterate over all states k we know are reachable from i %
        for k = find(R(i,:)==1),
            % iterate over all states j we know are reachable from k %
            for j = find(R(k,:) == 1),
                Rnew(i,j) = 1;
            end
        end
    end
end

end