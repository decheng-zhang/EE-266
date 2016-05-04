% EE 266 Homework 3 Problem 1 %
close all; clear all;

passage_time_data;
T = 100;
Q = P;
Q(1,:) = (1:6 == 1);

% (a) %
probs_f = zeros(1,T);
x0 = 2; xf = 1;
Qt = eye(6);
for t = 1:length(probs_f),
    Qs = Qt*Q;
    probs_f(t) = Qs(x0,xf) - Qt(x0,xf);
    Qt = Qs;
end
figure;
plot(1:T, probs_f);
title('f(t)');


% (c) %

Q2 = [Q, zeros(6,6); zeros(6,6), Q];
Q2(1,:) = [zeros(1,6),.4, .3, 0, .3, 0, 0];
xf = 7;
Qt2 = eye(12);
probs_s = zeros(1,T);
for t = 1:length(probs_s),
    Qs2 = Qt2*Q2;
    probs_s(t) = Qs2(x0,xf)-Qt2(x0,xf);
    Qt2 = Qs2;
end

figure;
plot(1:T, probs_s);
title('s(t)');

figure;
plot(1:T,probs_f+probs_s);
title('f(t) + s(t)');


% (e) %
probs_r = zeros(1,T);
Q3 = [P, [.4;0;.3;.3;0;0]; zeros(1,6),1];
Q3(1,1) = 0;
x0 = 1;

Qt3 = eye(7);
for t = 1:length(probs_r),
    Qs3 = Qt3*Q3;
    probs_r(t) = Qs3(x0,xf)-Qt3(x0,xf);
    Qt3 = Qs3;
end

figure;
plot(1:T,probs_r);
title('r(t)');


% (f) %
s = conv(probs_f,probs_r);
figure;
plot(1:length(s),s);
title('s(t)');