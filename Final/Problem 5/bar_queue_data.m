clear all; close all

% maximum queue length
Q1 = 5; % VIP Queue
Q2 = 10; % regular queue

% the four demand scenarios are 00, 01, 10, 11 in that order. 
% 00(none), 01(arrival for queue 1), 10 (arrival for queue 2)
% 11 (arrival for both)
p_arr = [0.2, 0.15, 0.45, 0.2];

% costs
v = [40; 10]; % reward
r = [30; 5]; % rejection cost, ie. it is a "discounted" lost sale
a = [5; 1]; % quadratic cost, penalise more heavily the VIP queue
b = [5; 5]; % linear cost