function yy=nbc2(n)

%NBC2  Generates a matrix of variables in nbc.
%   NBC2(N) gives as output a table of N variables coded in nbc,
%   (Natural Binary Code).
%
%   See also GRAYC2.
%

% Copyright (c), B. Rasmus Anthin.

yy=zeros(2^n,n);
%for j=1:n
%   for i=1:2^n
%      yy(i,j)=round(mod((i-1)/(2^(j-1)),2)-.45);
%   end
%end
for i=n:-1:1
   for j=0:2^(n-i)-1
      yy((2^(i-1)+1:2^i)+j*2^i,i)=ones(2^(i-1),1);
  	end
end
%y((5:8),3)=ones(4,1);

%y((3:4),2)=ones(2,1);
%y((3:4)+4,2)=ones(2,1);

%y((2:2),1)=ones(1,1);
%y((2:2)+2,1)=ones(1,1);
%y((2:2)+4,1)=ones(1,1);
%y((2:2)+6,1)=ones(1,1);
%--------------------

%y((4+1:8),3)=ones(4,1);

%y((2+1:4),2)=ones(2,1);
%y((2+1:4)+4,2)=ones(2,1);

%y((1+1:2),1)=ones(1,1);
%y((1+1:2)+2,1)=ones(1,1);
%y((1+1:2)+4,1)=ones(1,1);
%y((1+1:2)+6,1)=ones(1,1);