function cost = Ecost(q,u,vv,f,g,p_arr)

inds{1} = f(q,u,[0;0]) + [1;1];
inds{2} = f(q,u,[1;0]) + [1;1];
inds{3} = f(q,u,[0;1]) + [1;1];
inds{4} = f(q,u,[1;1]) + [1;1];

cost = p_arr(1)*(g(q,u,[0;0]) + vv(inds{1}(1),inds{1}(2)))...
     + p_arr(2)*(g(q,u,[1;0]) + vv(inds{2}(1),inds{2}(2)))...
     + p_arr(3)*(g(q,u,[0;1]) + vv(inds{3}(1),inds{3}(2)))...
     + p_arr(4)*(g(q,u,[1;1]) + vv(inds{4}(1),inds{4}(2)));
 
end