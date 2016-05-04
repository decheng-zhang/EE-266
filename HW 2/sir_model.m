%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clean up the workplace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all ; close all ; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 10;
P1 = [0.6 0.4 0.0 0.0; 
      0.2 0.6 0.1 0.1; 
      0.0 0.0 1.0 0.0;
      0.0 0.0 0.0 1.0];
P2 = [1.0 0.0 0.0 0.0; 
      0.2 0.6 0.1 0.1; 
      0.0 0.0 1.0 0.0;
      0.0 0.0 0.0 1.0];
X0 = ones(n,n) + sparse(2,3,1,n,n) + sparse(3,2,1,n,n);
X0 = X0 + sparse(3,7,1,n,n) + sparse(4,6,1,n,n);
X0 = X0 + sparse(6,4,1,n,n) + sparse(7,3,1,n,n);
X0 = X0 + sparse(8,9,1,n,n) + sparse(9,8,1,n,n);
T = 50;
NMC = 1e2;
iters = 10000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate trajectories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples = zeros(1,iters);
for i = 1:iters,
    disp(i);
    X = sir_simulate(X0,P1,P2,T);
    samples(i) = sum(sum((X(:,:,T+1)==3)));
end

expected_dead = mean(samples);


%{
% plot the population
figure();
for t = 0:T
    plot_population(X(:,:,t+1));
    title(sprintf('t = %d' , t));
    input('<press any key to continue>');
end

% make an area plot
A = nan(T+1,3);
for t = 1:(T+1)
    for i = 1:3
        A(t,i) = sum(sum(X(:,:,t) == i));
    end
end

figure();
h = area(0:T , A);
set(h(1) , 'FaceColor' , [0 0 1]);
set(h(2) , 'FaceColor' , [1.0 0.6 0]);
set(h(3) , 'FaceColor' , [1.0 0.0 0]);
xlim([0 T]);
ylim([0 n^2]);
xlabel('t');
ylabel('number of individuals');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make a histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = nan(NMC,1);
for i = 1:NMC
    X = sir_simulate(X0,P1,P2,T);
    r(i) = sum(sum(X(:,:,T+1) == 3)) / (n^2);
end

bins = linspace(0 , 1 , 10);
figure()
bar(bins , histc(r,bins)/NMC)
xlim([0 1]);
ylim([0 1]);
xlabel('fraction removed')
ylabel('frequency')
%}