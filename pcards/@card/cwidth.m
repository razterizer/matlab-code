function y=cwidth(c)
%CWIDTH   Get graphical width of card.
%   W = CWIDTH(C) returns the width of card C (or widths of cards C
%   if it is a vector or matrix of cards).
%
%   See also CARD/CSIZE, CARD/POSITION.

% Copyright (c) 2005-06-18, B. Rasmus Anthin.


error(nargchk(1,1,nargin))
load aspect

for i=1:length(c(:))
   y(i)=c(i).size*aspect;
end
y=reshape(y,size(c));