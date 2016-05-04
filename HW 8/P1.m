% EE 266 Homework 8 Problem 1 %
close all; clear all;

load('facebook_data.mat');
n = size(W,1);
% (a) %
[Nx_a, WNx_a] = get_neighbors(246,W);

% (c) %
nbors = @(x)(get_neighbors(x,W));
[dist, path] = dijkstra(nbors,800,3000);

rand('seed',0);
for i = 1:5,
    s{i} = ceil(n*rand(1,1));
    t{i} = ceil(n*rand(1,1));
    % Ensure that s ~= t %
    while(s{i} == t{i}), t{i} = ceil(n*rand(1,1)); end;
    
    [d, p] = dijkstra(nbors,s{i},t{i});
    dists{i} = d;
    paths{i} = p;
end


