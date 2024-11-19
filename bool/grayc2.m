function yy=grayc2(n)

%GRAYC2  Generates a matrix of variables in Gray code.
%   GRAYC2(n) gives as output a table of n variables coded in Gray code.
%
%   See also NBC2.
%

% Copyright (c), B. Rasmus Anthin.

yy=zeros(2^n,n);


for i=1:n
   yy(2^(i-1)+1:2^i,i)=ones(2^(i-1),1);
end
for j=1:n-1
   yy(2^j+1:2^(j+1),1:j)=yy(2^j:-1:1,1:j);
end
