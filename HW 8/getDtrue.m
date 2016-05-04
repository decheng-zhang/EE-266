function Dtrue = getDtrue(G,W,nbors,p,q)

Dtrue = G;
for i = 1:size(G,1)-1,
    for j = i+1:size(G,2),
        if(G(i,j) == 0), continue; end;
        
        Dtrue(i,j) = dijkstra(nbors, W(i,:),W(j,:));
        Dtrue(j,i) = Dtrue(i,j);
    end
end

Dtrue = allPairsSP(Dtrue);


end