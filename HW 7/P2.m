% EE 266 Homework 7 Problem 2 %
close all; clear all;

linear_quadratic_extensions_data;

% (b) %
f = quadratic_function(P,q,r);
ans1 = f([x;y]);

gy = f(y,length(y));
ans2 = gy(x);

% (e) %
ybar = zeros(size(yvals{1}));
for i = 1:nyvals,
    ybar = ybar + ypmf(i)*yvals{i};
end

var = zeros(length(yvals{1}),length(yvals{1}));
for i = 1:length(yvals{1}),
    for j = i:length(yvals{1}),
        Exy = 0;
        for k = 1:nyvals,
            yy = yvals{k};
            Exy = Exy + ypmf(k)*yy(i)*yy(j);
        end
        var(i,j) = Exy - ybar(i)*ybar(j);
        var(j,i) = var(i,j);
    end
end

h = Expect(f,ybar,var);
ans3 = h(x);
disp(ans3);

ans4 = 0;
for i = 1:nyvals,
    ans4 = ans4 + ypmf(i)*f([x;yvals{i}]);
end
disp(ans4);