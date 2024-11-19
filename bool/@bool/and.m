function y=and(x1,x2)
if isnumeric(x1)
   x1=bool(x1);
elseif isnumeric(x2)
   x2=bool(x2);
end
y.val=and(x1.val,x2.val);
y=bool(y);