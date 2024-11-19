function c=change(c,v,s)
%CHANGE   Change value and suit of card(s).
%   C = CHANGE(C,V,S) changes the value and suit of card(s) C
%   to value V and suit S.
%
%   See also CARD, CARD/VALUE, CARD/SUIT.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-16.

error(nargchk(3,3,nargin))

for i=1:length(c(:))
   if isnan(c(i).value)
      c(i).value=0;
      c(i).suit='-';
   end
end
c=value(c,v);
c=suit(c,s);