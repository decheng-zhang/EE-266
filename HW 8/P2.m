% EE 266 Homework 8 Problem 2 %
close all; clear all;

load('maze_data.mat');
warning('off');

% (b) %
h_b = @(x,y)(0);
nbors_b = @(x)(maze_succ(x,A,h_b,p,q));
[dist_b,path_b,Esize_b] = dijkstra(nbors_b,s,t);

for i = 1:size(path_b,1),
   Pb{i} = path_b(i,:); 
end
showPath(Pb,A);
%{

% (d) %
h_d = @(x,y)(manh([x,y],t,p,q));
nbors_d = @(x)(maze_succ(x,A,h_d,p,q));
[dist_d,path_d,Esize_d] = dijkstra(nbors_d,s,t);

for i = 1:size(path_d,1),
   Pd{i} = path_d(i,:); 
end
showPath(Pd,A);

% (g) %
Gw = zeros(size(G));
for i = 1:size(G,1),
    for j = 1:size(G,2),
        if(G(i,j) == 1), Gw(i,j) = manh(W(i,:),W(j,:),p,q); end;
    end
end

Dmanh = allPairsSP(Gw);

% (h) %
h_h = @(x,y)(heurMap([x y],t,X,Y,W,Dmanh,p,q));
nbors_h = @(x)(maze_succ(x,A,h_h,p,q));
[dist_h,path_h,Esize_h] = dijkstra(nbors_h,s,t);

for i = 1:size(path_h,1),
   Ph{i} = path_h(i,:); 
end
showPath(Ph,A);

% (i) %

Dtrue = getDtrue(G,W,nbors_h,p,q);
h_i = @(x,y)(heurMap([x y],t,X,Y,W,Dtrue,p,q));
nbors_i = @(x)(maze_succ(x,A,h_i,p,q));
[dist_i,path_i,Esize_i] = dijkstra(nbors_i,s,t);


for i = 1:size(path_i,1),
   Pi{i} = path_i(i,:); 
end
showPath(Pi,A);
%}