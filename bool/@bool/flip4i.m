function y=flip4i(x)
%FLIP4I  Flips internal order of each nibble.
%   For instance:
%      FLIP4i([1 0 1 0  0 1 0 1  0 0 1 1])
%   results in
%      0101 1010  1100

% Copyright (c) 2002-11-29, B. Rasmus Anthin.

x=bool(x);
for i=1:4:length(x)
   if length(x)>=i+3
      y.val(i:i+3)=fliplr(x.val(i:i+3));
   else
      j=i+3-length(x);
      y.val(i:i+3)=[zeros(1,j) fliplr(x.val(i:end))];
   end
end
y=bool(y);
