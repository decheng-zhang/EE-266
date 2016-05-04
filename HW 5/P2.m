% EE 266 Homework 5 Problem 2 %
close all; clear all;

T = 50;
mu = 0;
sig = .2;
S = 10;

% (b) %
prices = .6:.1:2;
p = 1./(sqrt(2*pi)*sig*prices).*exp(-((log(prices)-mu).^2)/(2*sig^2));
p = p'/sum(p);
D = 15;


% Terminal Costs %
V = zeros(S+1,1); % zero terminal cost %

% Stage Costs %
for t = T-1:-1:0,
    cur_policy = zeros(S+1,D);
    cur_value = zeros(S+1,D);
    for x = 1:S,
        for pind = 1:D,
            %disp([t x prices(pind)]);
            cur_policy(x+1,pind) = ...
                (prices(pind) + V(x,1) > V(x+1,1));
            %disp([prices(pind) + V(x,1) , V(x+1,1)]);
            if(cur_policy(x+1,pind) == 1),
                cur_value(x+1,pind) = ...
                    .4*(prices(pind) + V(x,1)) + .6*V(x+1,1);
            else
                cur_value(x+1,pind) = V(x+1,1);
            end
        end
    end
    
    policy{t+1} = cur_policy;
    V = [cur_value*p , V];
end

% Plotting value functions at times t = 0,45,48,49,50 %
plot(0:10,V(:,1),'r'); hold on;
plot(0:10,V(:,46),'g');
plot(0:10,V(:,49),'m');
plot(0:10,V(:,50),'b');
plot(0:10,V(:,51),'k');

legend('t = 0','t = 45','t = 48','t = 49','t = 50');
title('Plot of Value functions');
xlabel('S')
ylabel('V_t(S)');


% Plotting policies at times t = 0,20,40,45 %
Ts = [0 20 40 45];
figure; 

for i = 1:4,
    subplot(2,2,i);
    spy(policy{Ts(i)+1});
    set(gca,'XTick',1:1:15);
    set(gca,'XTickLabel',[.6:.1:2]);
    set(gca,'YTick',1:1:11);
    set(gca,'YTickLabel',[0:1:10]);
    
    xlabel('price');
    ylabel('shares owned');
    title(sprintf('t = %d',Ts(i)));
end

% (c) %
policy2 = prices > prices*p; % price > expected value of prices %

% Terminal Costs %
V2 = zeros(S+1,1); % zero terminal cost %

% Stage Costs %
for t = T-1:-1:0,
    cur_value = zeros(S+1,D);
    for x = 1:S,
        for pind = 1:D,
            if(policy2(pind) == 1),
                cur_value(x+1,pind) = ...
                    .4*(prices(pind) + V2(x,1)) + .6*V2(x+1,1);
            else
                cur_value(x+1,pind) = V2(x+1,1);
            end
        end
    end
    V2 = [cur_value*p , V2];
end

% (d) %
% For threshhold policy %
prob_of_selling_one = .4*policy2*p;
% Cumulative Binomial with probability prob_of_selling_one %
prob_unsold_thresh = binocdf(S-1,T,prob_of_selling_one);

% For optimal policy %
ppi = 0:S == S;
dist = ppi;
for t = 0:T-1,
    P = zeros(S+1,S+1);  % time varying transition matrix %
    P(1,1) = 1;
    cur_pol = policy{t+1};
    for i = 1:S,
        sell_prob = cur_pol(i+1,:)*p;
        P(i+1,i+1) = .6*sell_prob + (1-sell_prob);
        P(i+1,i) = .4*sell_prob;
    end
    dist = dist*P;
end

prob_unsold_opt = 1-dist(1);


% (e) %
% Always try to sell policy %
P = .6*eye(S+1,S+1);
P(1,1) = 1;
for i = 2:S+1,
    P(i,i-1) = .4;
end

dist2 = ppi;
for t = 0:T-1,
    dist2 = dist2*P;
end

V3 = zeros(S+1,1);
for t = T-1:-1:0,
    cur_value = zeros(S+1,D);
    for x = 1:S,
        for pind = 1:D,
            cur_value(x+1,pind) = ...
                .4*(prices(pind) + V3(x,1)) + .6*V3(x+1,1);
        end
    end
    V3 = [cur_value*p , V3];
end