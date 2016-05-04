function wpind = waypts(x,X,Y,W)

  if(ismember(x,W,'rows')), wpind = x; return; end;

  n = size(W,1);
  wpind = [];

  for i = 1:n,
      w = W(i,:);
    
      % Check for horizontal obstacles %
      continuing = 0;
      for hz = 1:length(X),
          if (w(2) < X(hz) && x(2) > X(hz)), continuing = 1; end;
          if (w(2) > X(hz) && x(2) < X(hz)), continuing = 1; end;
      end
      if continuing == 1, continue; end;
    
    
      % Check for vertical obstacles %
      for vt = 1:length(Y),
          if (w(1) < Y(vt) && x(1) > Y(vt)), continuing = 1; end;
          if (w(1) > Y(vt) && x(1) < Y(vt)), continuing = 1; end;
      end
      if continuing == 1, continue; end;
    
    
      wpind = [wpind; w];
  end

end