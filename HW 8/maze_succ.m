function [Nbors,costs] = maze_succ(x,A,h,p,q)
    xx = x(1);
    yy = x(2);
    n = size(A,1);
    count = 0;
    costs = [];

    if(xx > 1),
        if(A(xx-1,yy) ~= 0),
            Nbors{count+1} = [xx-1,yy];
            costs = [costs; p + h(xx-1,yy) - h(xx,yy)];
            count = count + 1;
        end
    end
    
    if(yy > 1),
        if(A(xx,yy-1) ~= 0),
            Nbors{count+1} = [xx,yy-1];
            costs = [costs; q + h(xx,yy-1) - h(xx,yy)];
            count = count + 1;
        end
    end
    
    if(xx < n),
        if(A(xx+1,yy) ~= 0),
            Nbors{count+1} = [xx+1,yy];
            costs = [costs; p + h(xx+1,yy) - h(xx,yy)];
            count = count + 1;
        end
    end
    
    if(yy < n),
        if(A(xx,yy+1) ~= 0),
            Nbors{count+1} = [xx,yy+1];
            costs = [costs; q + h(xx,yy+1) - h(xx,yy)];
            count = count +1;
        end
    end
end