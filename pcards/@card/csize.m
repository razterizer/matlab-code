function y=csize(x,cs)
%CSIZE   Modify or display graphical size of card.
%   S = CSIZE(C) returns the size of card C (or sizes of cards C
%   if it is a vector or matrix of cards).
%
%   C = CSIZE(C,S) changes the size(s) of card(s) C with specified
%   size S. The default size of a card is 1, meaning it has a height of
%   one plot unit.
%
%   See also CARD/CWIDTH, CARD/POSITION, CARD.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,2,nargin))

if nargin==1
   for i=1:length(x(:))
      y(i)=x(i).size;
   end
   y=reshape(y,size(x));
else
   y=x;
   for i=1:length(y(:))
      y(i).size=cs;
   end
end