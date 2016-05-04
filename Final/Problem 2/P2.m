% EE 266 Final Problem 2 %
close all; clear all;

% (a) %
dist = 25;
pia = [1 0 0 0];
Pa = [0 0 .5 .5; 1/3 0 1/3 1/3; 0 .5 0 .5; 0 0 0 1];
cmfa = zeros(1,dist);
pa{1} = pia*Pa;
cmfa(1) = pa{1}(4);
for i = 2:dist,
    pa{i} = pa{i-1}*Pa;
    cmfa(i) = pa{i}(4);
end
pmfa = cmfa - [0, cmfa(1:end-1)];
plot(0:dist,[0, pmfa]);
disp(pmfa(10));


% (b) %
pib = [1 zeros(1,7)];
Pb = [0 0 .5 .5 zeros(1,4); zeros(1,4) 1/3 0 1/3 1/3;...
      0 .5 0 .5 zeros(1,4); 0 .5 .5 zeros(1,5); ...
      [zeros(4,4), Pa]];
cmfb = zeros(1,dist);
pb{1} = pib*Pb;
cmfb(1) = pb{1}(8);
for i = 2:dist,
    pb{i} = pb{i-1}*Pb;
    cmfb(i) = pb{i}(8);
end
pmfb = cmfb - [0 cmfb(1:end-1)];
hold on;
plot(0:dist, [0, pmfb],'k');
disp(pmfb(10));


% (c) %
pic = [1 zeros(1,15)];
Pc = [0 0 .5 .5 zeros(1,12); zeros(1,4) 1/3 0 1/3 1/3 zeros(1,8);...
      zeros(1,9) .5 0 .5 zeros(1,4); 0 .5 .5 zeros(1,13);...
      zeros(1,6) .5 .5 zeros(1,8); zeros(1,4) 1/3 0 1/3 1/3 zeros(1,8);...
      zeros(1,13) .5 0 .5; zeros(1,5) .5 .5 zeros(1,9);...
      zeros(1,10) .5 .5 zeros(1,4); zeros(1,12) 1/3 0 1/3 1/3;...
      zeros(1,9) .5 0 .5 zeros(1,4); zeros(1,9) .5 .5 zeros(1,5);...
      zeros(1,14) .5 .5; zeros(1,12) 1/3 0 1/3 1/3;...
      zeros(1,13) .5 0 .5; zeros(1,15) 1];
  
cmfc = zeros(1,dist);
pc{1} = pic*Pc;
cmfc(1) = pc{1}(16);
for i = 2:dist,
    pc{i} = pc{i-1}*Pc;
    cmfc(i) = pc{i}(16);
end
pmfc = cmfc - [0 cmfc(1:end-1)];
hold on;
plot(0:dist, [0 ,pmfc],'r');
disp(pmfc(10));

legend('(a)','(b)','(c)');
xlabel('t');
ylabel('P(\tau = t | x_0 = a)');
title('Combined pmf plots for hitting times');