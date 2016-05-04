% EE 266 Homework 1 Problem 1%
close all; clear all;

% (a) %
% Policies:
%
% Prescient - Since p0 and p1 are both known, we sell B at the higher
%             price.
%
% No Knowledge - Since we do not know anything about realizations of p0 and
%                p1, we must choose based on their expected values. Since
%                mu1 is larger than mu0, we always choose to sell B at mu1.
%
% Partial Knowledge - We now know p0 but not p1. We should choose to sell
%                     at the price with the higher expected value. The
%                     expected value for p0 is the known realization p0 and
%                     the expected value for p1 is exp(mu1 + sigma1^2/2).
%                     Therefore, we choose to sell B at p0 iff p0 is
%                     greater than the expected value exp(mu1 + sigma1^2/2)
%                     of p1. Otherwise, we sell B at p1.
%

% (b) %
randn('seed',1);
iters = 100000;
mu0 = 0;
mu1 = .1;
sigma0 = .4;
sigma1 = .4;
B = 10;


Pres = [];
NoKnow = [];
Partial = [];
for i = 1:iters,
    % parameter setup %
    logp0 = mu0 + sigma0*randn(1,1);
    logp1 = mu1 + sigma1*randn(1,1);
    p0 = exp(logp0);
    p1 = exp(logp1);
    
    % Prescient Information %
    Pres = [Pres B*max([p0, p1])];
    
    % No knowledge case %
    NoKnow = [NoKnow B*p1];
    
    % Partial knowledge case %
    if p0 > exp(mu1 + (sigma1^2)/2),
        x = p0;
    else
        x = p1;
    end
    Partial = [Partial B*x];
    
end
[counts1,centers1] = hist(Pres,100);
[counts2,centers2] = hist(NoKnow,100);
[counts3,centers3] = hist(Partial,100);
close all;
figure;
plot(centers1,counts1/iters,'k-');
hold on;
plot(centers2,counts2/iters,'b-');
plot(centers3,counts3/iters,'g-');
legend(sprintf('Prescient Knowledge\t\t mean: %d',mean(Pres)),...
    sprintf('No Knowledge\t\t mean: %d',mean(NoKnow)),...
    sprintf('Partial Knowledge\t\t mean: %d',mean(Partial)));
