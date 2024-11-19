function yy=logsp(x1,x2)

%LOGSP  Makes a log10-spaced vector.
%   LOGSP(x1,x2), returns a logarithmically spaced vector,
%   ranging from x1 to x2. Where 0<x1<inf, 0<x2<inf.
%

% Copyright (c) B. Rasmus Anthin.

[m1,e1]=split(x1);
[m2,e2]=split(x2);

i=1;
for e=e1:e2
   if e==e1
      for m=m1:9
         yy(1,i)=m*10^e;
         i=i+1;
      end
   elseif e==e2
      for m=1:m2
         yy(1,i)=m*10^e;
         i=i+1;
      end
   else
      for m=1:9
         yy(1,i)=m*10^e;
         i=i+1;
      end
   end
end
