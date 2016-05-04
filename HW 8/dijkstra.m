function [dist , path, Esize] = dijkstra(neighbors , s , t)

v = 0;
F = s;
E = [];
Pf = zeros(1,length(s));
Pe = [];

while(length(F) > 0),
    [val, ind] = min(v);
    val = val(end); % Get the last input index value %
    ind = ind(end); % Get the last input index       %
    
    node = F(ind,:);
    pred = Pf(ind,:);
    if(all(node == t)), break; end;

    
    v(ind,:) = []; % Remove index from F %
    F(ind,:) = [];
    Pf(ind,:) = [];
    
    % Insert index into E %
    E = [E; node];
    Pe = [Pe; pred];
    
    [nbors, vals] = neighbors(node);
    
    for i = 1:length(nbors),
        nbor_node = nbors{i};
        if(sum(ismember(F, nbor_node, 'rows')) ~= 0), continue; end;
        if(sum(ismember(E, nbor_node, 'rows')) ~= 0), continue; end;
        
        F = [F; nbor_node];
        Pf = [Pf; node];
        v = [v; val + vals(i)];
    end
end

dist = val;
path = [pred;node];
node = pred;
while(~all(node == s)),
    ind = find(ismember(E,node,'rows'));
    pred = Pe(ind,:);
    path = [pred;path];
    node = pred; 
end

Esize = size(E,1);

end