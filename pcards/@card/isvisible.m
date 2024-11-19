function y=isvisible(c)
%ISVISIBLE   True for visible cards.
%   ISVISIBLE(C) returns 1 for those cards that are visible
%   and 0 otherwise.
%
%   See also CARD/SHOW, CARD/HIDE, CARD/ISUP, CARD/ISJOKER.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   y(i)=c(i).vis;
end
y=reshape(y,size(c));