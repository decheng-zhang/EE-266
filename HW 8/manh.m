function dist = manh(x,t,p,q);
    dist = p*abs(x(1)-t(1));
    dist = dist + q*abs(x(2)-t(2));
end