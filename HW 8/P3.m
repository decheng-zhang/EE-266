% EE 266 Homework 8 Problem 3 %
close all; clear all;

load('convoy.mat');

nbors = @(x)(convoy_neighbors(x,G));
[maxBandits , path, Esize] = convoy_dijkstra(nbors,1,23);

reqd_guard = 2*maxBandits;