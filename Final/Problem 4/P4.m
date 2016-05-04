% EE 266 Final Problem 4 %
close all; clear all;

% (b) %
T = 15;
gam = 50;
p = zeros(1,T);
for i = 1:T,
    p(i) = min([1, .5 + .01*i]);
end

us = zeros(1,T);
v_Sbar = zeros(1,T);
v_S = 1:T;
for k = T:-1:1,
    expected_Sbar = 0;
    for i = 1:k-1,
        mult = 1;
        for j = i+1:k-1,
            mult = mult*(1-p(j));
        end
        expected_Sbar = expected_Sbar + mult*p(i)*i;
    end
    expression2 = gam;
    for j = 1:k-1,
        expression2 = expression2*(1-p(j));
    end
    expected_Sbar = expected_Sbar + expression2;
    v_Sbar(k) = expected_Sbar;
    if(expected_Sbar > k) us(k) = 1; end;
end

t = T-1:-1:0;
plot(t,v_S,'g',t,v_Sbar,'r');
xlabel('time t');
ylabel('Expected cost of S or Sbar assuming unparked with free spot');
legend('v(S)', 'v(Sbar)');

% (c) %
t = T:-1:0;
v_Pbar = v_Sbar;
temp = v_Pbar(us == 0);
v_Pbar(us == 0) = temp(1)*ones(size(v_Pbar(us == 0)));
v_Pbar = [v_Pbar v_Pbar(end)];
plot(t,v_Pbar,'r',t,zeros(1,T+1),'g');
legend('v(Pbar)','v(P)');
xlabel('time t');
ylabel('Value function of P and Pbar');
