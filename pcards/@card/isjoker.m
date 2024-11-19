function y=isjoker(c)
%ISJOKER   True for joker cards.
%   ISJOKER(C) returns 1 for card(s) that are set to Joker(s)
%   (wild cards) and 0 otherwise.
%
%   See also CARD/JOKER, CARD/ISVISIBLE, CARD/ISUP.

% Copyright (c) 2005-06-16, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   y(i)=isnan(c(i).value);
end
y=reshape(y,size(c));