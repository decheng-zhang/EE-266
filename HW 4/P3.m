% EE 266 Homework 4 Problem 3 %
close all; clear all;

job_sched_data;

P = Inf*ones(n+2,n+2);
P(1,:) = [Inf -w 0];
P(:,end) = zeros(n+2,1);

for i = 1:n,
    for j = 1:n,
        if(i ~= j && b(i) <= a(j)),
            P(i+1,j+1) = -w(j);
        end
    end
end

[jobs,weight] = bellman_ford(P,1,n+2);

jobs = jobs(2:end-1);
jobs = jobs - ones(1,length(jobs));
weight = -weight;