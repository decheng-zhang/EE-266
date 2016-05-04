% EE 266 Homework 2 Problem 5 %
close all; clear all;

% (a) %
P = [.75 .05 .2 0 0;
     .05 .15 .15 .65 0;
     .25 .3 .1 0 .35;
      0 .15 0 .4 .45;
      0 0 .2 .35 .45];
  
ppi = [.3 .1 .2 .3 .1];

T = 50;

pT = zeros(1,5);
for t = 0:T,
    pT = pT + ppi*(P^t);
end
pT = pT/(T+1);

% (b) %
rand('seed',0);

total_iters = [10 100 1000];


p_hats = zeros(1,length(total_iters));
for iters = total_iters,
    p_ts = zeros(1,iters);
    for sample = 1:iters,
        r = rand(1,1);
        x = 0;
        if r < .3, x = 1; 
        elseif r < .4, x = 2;
        elseif r < .6, x = 3;
        elseif r < .7, x = 4;
        else x = 5; end;
        
        p_ts(sample) = p_ts(sample) + (x==1);
        
        
        for i = 1:T,
            r = rand(1,1);
            if x==1,
                if r < .05, x = 2;
                elseif r < .25, x = 3; end;
            elseif x == 2,
                if r < .05, x = 1;
                elseif r < .2, x = 3;
                elseif r < .85, x = 4; end;
            elseif x == 3,
                if r < .25, x = 1;
                elseif r < .55, x = 2;
                elseif r < .9, x = 5; end;
            elseif x == 4,
                if r < .15, x = 2;
                elseif r < .6, x = 5; end;
            else
                if r < .2, x = 3;
                elseif r < .55 x = 4; end;
            end
                
            p_ts(sample) = p_ts(sample) + (x==1);
        end
    
        p_ts(sample) = p_ts(sample)/(T+1);
    end
    p_hats(find(total_iters == iters)) = mean(p_ts);
end


semilogx(total_iters,p_hats);