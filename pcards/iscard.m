function y=iscard(x)
%ISCARD  True for card objects.
%   ISCARD(C) returns 1 if C is a card object and 0 otherwise.
%
%   See also CARD.

% Copyright (c) 2005-06-09, B. Rasmus Anthin

error(nargchk(1,1,nargin))

y=isa(x,'card');