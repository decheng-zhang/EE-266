% EE 266 Homework 7 Problem 3 %
close all; clear all;

ss_lqsc_data;

f = linear_function([A,B,eye(n)],zeros(n,1));
g = quadratic_function(P,q,r);

[val,pol] = ss_lqsc(f,g,wbar,wvar);