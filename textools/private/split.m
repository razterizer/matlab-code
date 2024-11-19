function [m,e]=split(x)

%SPLIT  Returns mantissa and exponent of a real number.
%   [m,e]=SPLIT(x), where m is the mantissa of x
%   and e is the exponent of x. Where 0<x<inf.

% Copyrigth (c) B. Rasmus Anthin.


if x>10
   a=1;
   b=10^a;
   while x/b > 10
      a=a+1;
      b=10^a;
   end
   if x/b == 10
      m=1; 
      e=a+1; 
   else
      m=x/b; 
      e=a; 
   end
else
   a=1;
   b=10^a;
   while x/b < 1
      a=a-1;
      b=10^a;
   end
   if x/b == 10
      m=1;
      e=a+1;
   else
      m=x/b;
      e=a;
   end
end
