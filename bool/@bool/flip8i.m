function y=flip8i(x)
%FLIP8I  Flips internal order of each byte.
%   For instance:
%      FLIP8i([1 0 1 0  0 1 0 1  0 0 1 1])
%   results in
%      1010 0101  0000 1100

% Copyright (c) 2002-11-29, B. Rasmus Anthin.

x=bool(x);
for i=1:8:length(x)
   if length(x)>=i+7
      y.val(i:i+7)=fliplr(x.val(i:i+7));
   else
      j=i+7-length(x);
      y.val(i:i+7)=[zeros(1,j) fliplr(x.val(i:end))];
   end
end
y=bool(y);
