% EE 266 Homework 8 Problem 4 %
close all; clear all;

s = [7 8 1 5 4 0 3 2 6];
t = [1 8 7 2 0 6 3 4 5];

h = @(x)(tile8_man_dist(x,t));
%h = @(x)(0);
nbors = @(x)(tile8_neighbors(x,h));
[dist, path, Esize] = dijkstra(nbors,s,t);


for i = 1:size(path,1),
    P{i} = path(i,:);
end

solution8tile(P);