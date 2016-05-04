% EE 266 Final Problem 5 %
bar_queue_data;
T = 101;

V{T+1} = zeros(Q1+1,Q2+1);
f = @(q,u,d)(min([Q1;Q2], max(0,q+d-u)));
g = @(q,u,d)(a'*(q.^2) + b'*q + r'*max(0, q + d - u - [Q1;Q2]));
h = @(q,u,d)(-v'*u);
g1 = @(q,u,d)(a(1)*q(1)^2 + b(1)*q(1));
g2 = @(q,u,d)(a(2)*q(2)^2 + b(2)*q(2));
gr = @(q,u,d)(r'*max(0,q+d-u-[Q1;Q2]));


Eg1{T+1} = zeros(Q1+1,Q2+1);
Eg2{T+1} = zeros(Q1+1,Q2+1);
Egrw{T+1}= zeros(Q1+1,Q2+1);
Egrj{T+1}= zeros(Q1+1,Q2+1);

for t = T-1:-1:0,
    Vtp1 = V{t+2};
    Eg1tp1 = Eg1{t+2};
    Eg2tp1 = Eg2{t+2};
    Erjtp1 = Egrj{t+2};
    Erwtp1 = Egrw{t+2};
    
    VV = zeros(Q1+1,Q2+1);
    mu1 = zeros(Q1+1,Q2+1);
    mu2 = zeros(Q1+1,Q2+1);
    
    exg1 = zeros(Q1+1,Q2+1);
    exg2 = zeros(Q1+1,Q2+1);
    exrj = zeros(Q1+1,Q2+1);
    exrw = zeros(Q1+1,Q2+1);
    
    for q1 = 0:Q1,
        for q2 = 0:Q2,
            q = [q1;q2];
            mu_t = zeros(2,1);
            if(q1 == 0 && q2 == 0),
                mu1(q1+1,q2+1) = 0; 
                mu2(q1+1,q2+1) = 0; 
                VV(q1+1,q2+1) = Ecost(q,mu_t,Vtp1,f,g,p_arr);
                continue;
            elseif(q1 == 0 && q2 ~= 0),
                mu_t = [0;1];
                VV(q1+1,q2+1) = Ecost(q,mu_t,Vtp1,f,g,p_arr) + h(q,mu_t,0);
            elseif(q2 == 0),
                mu_t = [1;0];
                VV(q1+1,q2+1) = Ecost(q,mu_t,Vtp1,f,g,p_arr) + h(q,mu_t,0);
            else
                exp_cost1 = Ecost(q,[1;0],Vtp1,f,g,p_arr) + h(q,[1;0]);
                exp_cost2 = Ecost(q,[0;1],Vtp1,f,g,p_arr) + h(q,[0;1]);
                [val, ind] = min([exp_cost1, exp_cost2]);
                if ind == 1, mu_t = [1;0];
                else mu_t = [0;1]; end;
                
                VV(q1+1,q2+1) = val;
            end
            exg1(q1+1,q2+1) = Ecost(q,mu_t,Eg1tp1,f,g1,p_arr);
            exg2(q1+1,q2+1) = Ecost(q,mu_t,Eg2tp1,f,g2,p_arr);
            exrj(q1+1,q2+1) = Ecost(q,mu_t,Erjtp1,f,gr,p_arr);
            exrw(q1+1,q2+1) = Ecost(q,mu_t,Erwtp1,f,h,p_arr);
            
            
            mu1(q1+1,q2+1) = mu_t(1);
            mu2(q1+1,q2+1) = mu_t(2);
        end
    end
    
    V{t+1} = VV;
    Mu1{t+1} = mu1;
    Mu2{t+1} = mu2;
    
    Eg1{t+1} = exg1;
    Eg2{t+1} = exg2;
    Egrj{t+1} = exrj;
    Egrw{t+1} = exrw;
end
expected_total_cost = V{1}(1,1);

% (a) %
ts = [0,20,40,60,80,100] + ones(1,6);
figure;
for i = 1:6,
    t = ts(i);
    policy1 = Mu1{t};
    policy2 = Mu2{t};
    subplot(3,2,i);
    spy(policy1,'g'); hold on;
    spy(policy2,'k');
    xlabel(sprintf('t = %d',t-1));
    
    set(gca,'XTick',1:1:Q2+1);
    set(gca,'XTickLabel',[0:1:Q2]);
    set(gca,'YTick',1:1:Q1+1);
    set(gca,'YTickLabel',[0:1:Q1]);
end

figure;
for i = 1:6,
    t = ts(i);
    val = V{t};
    subplot(3,2,i);
    waterfall(val);
    xlabel(sprintf('t = %d',t-1));
    
    set(gca,'XTick',1:1:Q2+1);
    set(gca,'XTickLabel',[0:1:Q2]);
    set(gca,'YTick',1:1:Q1+1);
    set(gca,'YTickLabel',[0:1:Q1]);
end

% (b) %
% Finding distribution of queue sizes at each time %

dist{1} = zeros(Q1+1,Q2+1);
dist{1}(1,1) = 1;
Exp_g1 = zeros(1,T);
Exp_g2 = zeros(1,T);
Exp_rj = zeros(1,T);
Exp_rw = zeros(1,T);


for t = 0:T-1,
     cur_dist = dist{t+1};
     next_dist = zeros(Q1+1,Q2+1);
     
     for q1 = 0:Q1,
         for q2 = 0:Q2,
             u = [Mu1{t+1}(q1+1,q2+1); Mu2{t+1}(q1+1,q2+1)];
             cond_dist = zeros(Q1+1,Q2+1);
             inds = f([q1;q2],u,[0;0]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(1);
             
             inds = f([q1;q2],u,[1;0]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(2);
             
             inds = f([q1;q2],u,[0;1]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(3);
             
             inds = f([q1;q2],u,[1;1]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(4);
             
             next_dist = next_dist + cur_dist(q1+1,q2+1)*cond_dist;
         end
     end
     Exp_g1(t+1) = sum(sum(Eg1{t+1}.*cur_dist));
     Exp_g2(t+1) = sum(sum(Eg2{t+1}.*cur_dist));
     Exp_rj(t+1) = sum(sum(Egrj{t+1}.*cur_dist));
     Exp_rw(t+1) = sum(sum(Egrw{t+1}.*cur_dist));
     
     
     dist{t+2} = next_dist;
end

figure;
plot(0:T-1,Exp_g1,'k'); hold on;
plot(0:T-1,Exp_g2,'b');
plot(0:T-1,Exp_rj,'r');
plot(0:T-1,Exp_rw,'g');

legend('Eg^{(1)}','Eg^{(2)}','Eg_{rj}','Eg_{rw}');



% (c) %
mu1 = [zeros(1,Q2+1); ones(Q1,Q2+1)];
mu2 = [[0 ones(1,Q2)]; zeros(Q1,Q2+1)];

figure;
policy1 = mu1;
policy2 = mu2;
spy(policy1,'g'); hold on;
spy(policy2,'k');
    
set(gca,'XTick',1:1:Q2+1);
set(gca,'XTickLabel',[0:1:Q2]);
set(gca,'YTick',1:1:Q1+1);
set(gca,'YTickLabel',[0:1:Q1]);


Eg1c{T+1} = zeros(Q1+1,Q2+1);
Eg2c{T+1} = zeros(Q1+1,Q2+1);
Egrwc{T+1}= zeros(Q1+1,Q2+1);
Egrjc{T+1}= zeros(Q1+1,Q2+1);

Vc{T+1} = zeros(Q1+1,Q2+1);

for t = T-1:-1:0,
    Vtp1 = Vc{t+2};
    VV = zeros(Q1+1,Q2+1);
    
    exg1 = zeros(Q1+1,Q2+1);
    exg2 = zeros(Q1+1,Q2+1);
    exrj = zeros(Q1+1,Q2+1);
    exrw = zeros(Q1+1,Q2+1);
    
    for q1 = 0:Q1,
        for q2 = 0:Q2,
            q = [q1;q2];
            mu_t = [mu1(q1+1,q2+1); mu2(q1+1,q2+1)];
            
            val = Ecost(q,mu_t,Vtp1,f,g,p_arr) + h(q,mu_t,0);
                
            exg1(q1+1,q2+1) = Ecost(q,mu_t,Eg1tp1,f,g1,p_arr);
            exg2(q1+1,q2+1) = Ecost(q,mu_t,Eg2tp1,f,g2,p_arr);
            exrj(q1+1,q2+1) = Ecost(q,mu_t,Erjtp1,f,gr,p_arr);
            exrw(q1+1,q2+1) = Ecost(q,mu_t,Erwtp1,f,h,p_arr);
            
            VV(q1+1,q2+1) = val;
        end
    end
    
    Eg1c{t+1} = exg1;
    Eg2c{t+1} = exg2;
    Egrjc{t+1} = exrj;
    Egrwc{t+1} = exrw;
    
    Vc{t+1} = VV;
end
heur_mean_total_cost = Vc{1}(1,1);

figure;
for i = 1:6,
    t = ts(i);
    val = Vc{t};
    subplot(3,2,i);
    waterfall(val);
    xlabel(sprintf('t = %d',t-1));
    
    set(gca,'XTick',1:1:Q2+1);
    set(gca,'XTickLabel',[0:1:Q2]);
    set(gca,'YTick',1:1:Q1+1);
    set(gca,'YTickLabel',[0:1:Q1]);
end

dist{1} = zeros(Q1+1,Q2+1);
dist{1}(1,1) = 1;
Exp_g1c = zeros(1,T);
Exp_g2c = zeros(1,T);
Exp_rjc = zeros(1,T);
Exp_rwc = zeros(1,T);


for t = 0:T-1,
     cur_dist = dist{t+1};
     next_dist = zeros(Q1+1,Q2+1);
     
     for q1 = 0:Q1,
         for q2 = 0:Q2,
             u = [Mu1{t+1}(q1+1,q2+1); Mu2{t+1}(q1+1,q2+1)];
             cond_dist = zeros(Q1+1,Q2+1);
             inds = f([q1;q2],u,[0;0]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(1);
             
             inds = f([q1;q2],u,[1;0]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(2);
             
             inds = f([q1;q2],u,[0;1]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(3);
             
             inds = f([q1;q2],u,[1;1]);
             cond_dist(inds(1)+1,inds(2)+1) = p_arr(4);
             
             next_dist = next_dist + cur_dist(q1+1,q2+1)*cond_dist;
         end
     end
     Exp_g1c(t+1) = sum(sum(Eg1c{t+1}.*cur_dist));
     Exp_g2c(t+1) = sum(sum(Eg2c{t+1}.*cur_dist));
     Exp_rjc(t+1) = sum(sum(Egrjc{t+1}.*cur_dist));
     Exp_rwc(t+1) = sum(sum(Egrwc{t+1}.*cur_dist));
     
     
     dist{t+2} = next_dist;
end

figure;
plot(0:T-1,Exp_g1c,'k'); hold on;
plot(0:T-1,Exp_g2c,'b');
plot(0:T-1,Exp_rjc,'r');
plot(0:T-1,Exp_rwc,'g');

legend('Eg^{(1)}','Eg^{(2)}','Eg_{rj}','Eg_{rw}');



% (d) %
% plotting a single trajectory %

rand('seed',0);

qo = zeros(2,1);
opt_cost = 0;
opt_costs = 0;

qh = qo;
heur_cost = 0;
heur_costs = 0;

d{1} = [0;0]; d{2} = [1;0]; d{3} = [0;1]; d{4} = [1;1];

for t = 1:T-1,
    disturb_ind = sum(rand > cumsum(p_arr)) + 1;
    dd = d{disturb_ind};
    qopt = qo(:,t);
    qheur= qh(:,t);

    uopt = [Mu1{t+1}(qopt(1)+1,qopt(2)+1);Mu2{t+1}(qopt(1)+1,qopt(2)+1)];
    uheur = [mu1(qheur(1)+1,qheur(2)+1) ; mu2(qheur(1)+1,qheur(2)+1)];
    
    
    opt_cost = opt_cost + g(qopt,uopt,dd) + h(qopt,uopt,dd);
    opt_costs = [opt_costs opt_cost];
    heur_cost=heur_cost + g(qheur,uheur,dd)+h(qheur,uheur,dd);
    heur_costs = [heur_costs heur_cost];
    
    qo = [qo, f(qopt ,uopt ,dd)];
    qh = [qh, f(qheur,uheur,dd)];
end

subplot(311);
plot(0:T-1,qo(1,:),'g',0:T-1,qh(1,:),'r');
ylabel('q_1'); xlabel('t');
legend('opt','heur');
subplot(312);
plot(0:T-1,qo(2,:),'g',0:T-1,qh(2,:),'r');
ylabel('q_2'); xlabel('t');
legend('opt','heur');
subplot(313);
plot(0:T-1,opt_costs,'g',0:T-1,heur_costs,'r');
xlabel('t'); ylabel('cum. cost');
legend('opt','heur');

