function [X] = sir_simulate(X0,P1,P2,T)
    [m n] = size(X0);
    X = nan(m,n,T+1);
    X(:,:,1) = X0;

    for t = 1:T
        for i = 1:m
            for j = 1:n
                has_infected_neighbor = ...
                    (i > 1 && X(i-1,j,t) == 2) || ... % north
                    (i < m && X(i+1,j,t) == 2) || ... % south
                    (j > 1 && X(i,j-1,t) == 2) || ... % west
                    (j < n && X(i,j+1,t) == 2); % east

                if has_infected_neighbor
                    X(i,j,t+1) = sample( P1(X(i,j,t),:) );
                else
                    X(i,j,t+1) = sample( P2(X(i,j,t),:) );
                end
            end
        end
    end
end
