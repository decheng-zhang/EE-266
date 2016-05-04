% EE 266 Homework 2 Problem 1 %
close all; clear all;

% (a) , (b) %
rand('seed',1);
squarea = @(n)(2^n);
numDims = 15;
numSamples = 1e6;

B = zeros(1,numDims); % (a) %
S = zeros(1,numDims); % (b) %
F = zeros(1,numDims);
eps = .1;

for n = 1:numDims,
    B_count = 0;
    S_count = 0;
    for i = 1:numSamples,
        random_pt = 2*rand(n,1)-ones(n,1); % Generate [-1,1]^n
        a = norm(random_pt,2);
        if(a <= 1),
            B_count = B_count + 1;
            if(a >= 1-eps),
                S_count = S_count + 1;
            end
        end
    end
    pB = B_count/numSamples;
    B(n) = pB*squarea(n);
    pS = S_count/numSamples;
    S(n) = pS/squarea(n);
    F(n) = S(n)/B(n);
end

figure;
plot(1:numDims,B);
xlabel('n');
ylabel('B(n)');
figure;
plot(1:numDims,F);
xlabel('n');
ylabel('F(n)');