function y=ge(x1,x2)
if isnumeric(x1)
   x1=bool(x1);
elseif isnumeric(x2)
   x2=bool(x2);
end
y=bool(b2d(x1)>=b2d(x2));