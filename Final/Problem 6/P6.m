% EE 266 Final Problem 6 %
surgeon_data;

% (a) %
for i = 1:41,
    V{42,i,1} = 0;
    V{42,i,2} = 0;
    V{i,42,1} = 0;
    V{i,42,2} = 0;
end

V{41,41,1} = 1;
V{41,41,2} = 1;

for i = 41:-1:1,
    for j = 41:-1:1,
        if (i == 41 && j == 41), continue; end;
        if (i == 1 && j == 1),
            [V{1,1,1},U{1,1,1}] = max([V{2,1,1}, V{1,2,2}]);        
            break;
        end
        if(ismember([i,j],C,'rows'))
            V{i,j,1} = 0; V{i,j,2} = 0;
            continue;
        end
        
        for d = 1:2,
            p1 = p_same_dir;
            p2 = p_same_dir;
            if d == 1, p2 = p_change_dir;
            else p1 = p_change_dir; end;
            
            exp_1 = p1*[V{i+1,j,1}; V{i,j+1,2}];
            exp_2 = p2*[V{i,j+1,2}; V{i+1,j,1}];
            
            [V{i,j,d}, U{i,j,d}] = max([exp_1, exp_2]);
        end
    end
end
success_prob = V{1,1,1};



% (b) %
% policy plot %
pol{1} = [1;0];
pol{2} = [0;1];
pol{3} = [0;0];

x = []; y = [];
a1 = []; b1 = [];
a2 = []; b2 = [];
VV1 = zeros(41,41);
VV2 = zeros(41,41);
for i = 1:41,
    for j = 1:41,
        x = [x,i]; y = [y, j];
        
        u1 = U{i,j,1};
        if(size(u1,1)==0) u1 = 3; end;
        if(V{i,j,1} == 0) u1 = 3; end; % For aesthetics %
        u2 = U{i,j,2};
        if(size(u2,1)==0) u2 = 3; end;
        if(V{i,j,2} == 0) u2 = 3; end; % For aesthetics %
        
        a1 = [a1, pol{u1}(1)];
        b1 = [b1, pol{u1}(2)];
        a2 = [a2, pol{u2}(1)];
        b2 = [b2, pol{u2}(2)];
        
        if(size(V{i,j,1},1) ~= 0) VV1(i,j) = V{i,j,1}; end;
        if(size(V{i,j,2},1) ~= 0) VV2(i,j) = V{i,j,2}; end;
    end
end
figure;
subplot(211);
a1(end-1) = a1(end-1)*1.5; b1(end-1) = b1(end-1)*1.5; % For aesthetics %
quiver(x,y,a1,b1);                                    %  (arrow size)  %
title('Policy when coming from below');

subplot(212);
a2(end-1) = a2(end-1)*1.5; b2(end-1) = b2(end-1)*1.5; % For aesthetics %
quiver(x,y,a2,b2);                                    %  (arrow size)  %
title('Policy when coming from the left');

figure;
subplot(211);
surf(VV1); title('Value function when coming from south');
subplot(212);
surf(VV2); title('Value function when coming from west');

% (c) %
rand('seed',0);
success = 0;
count = 0;
while(~success),
    count = count + 1;
    x = start;
    dir = 1;
    
    arrows = [];
    path = start;
    while(1),
        u = U{x(1),x(2),dir};
        p = p_same_dir;
        if(u ~= dir) p = p_change_dir; end;
        if(all(x == start)) p = [1 0]; end;
        
        % Change directions if unsuccessful %
        if(rand(1,1) > p(1)) u = 3-u; end;
        x = x + pol{u};
        
        arrows = [arrows, pol{u}];
        path = [path, x];
        
        if(ismember(x',C,'rows')),break; end;
        if(x(1) == 42), break; end;
        if(x(2) == 42), break; end;
        if(all(x == target)),
            success = 1;
            break;
        end
    end
end
arrows = [arrows,[0;0]];
arrows(:,2:end) = .2*arrows(:,2:end); % For aesthetics %
                                      %  (arrow size)  %
                                      disp(count);
figure
plot(target(1),target(2),'ro');
axis([1 l 1 l]);
hold on
plot(start(1),start(2),'r.');
plot(C(:,1),C(:,2),'bx');
quiver(path(1,:),path(2,:),arrows(1,:),arrows(2,:),'g');
title('Successful path');


% For verification %
counts = [];
for i = 1:10,
    success = 0;
    count = 0;
    while(~success),
        count = count + 1;
        x = start;
        dir = 1;
    
        arrows = [];
        path = start;
        while(1),
            u = U{x(1),x(2),dir};
            p = p_same_dir;
            if(u ~= dir) p = p_change_dir; end;
            if(all(x == start)) p = [1 0]; end;
        
            % Change directions if unsuccessful %
            if(rand(1,1) > p(1)) u = 3-u; end;
            x = x + pol{u};
        
            arrows = [arrows, pol{u}];
            path = [path, x];
        
            if(ismember(x',C,'rows')),break; end;
            if(x(1) == 42), break; end;
            if(x(2) == 42), break; end;
            if(all(x == target)),
                success = 1;
                break;
            end
        end
    end
    
    counts = [counts count];
    
end
figure;
hist(counts,10);
disp(mean(counts));



















