function y=ne(x1,x2)
if isnumeric(x1)
   x1=bool(x1);
elseif isnumeric(x2)
   x2=bool(x2);
end
if length(x1.val)==length(x2.val)
   y=all(x1.val~=x2.val);
else
   y=0;
end
y=bool(y);