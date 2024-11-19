function y=isup(c)
%ISUP   True for cards that are turned face up.
%   ISUP(C) returns 1 for card(s) that are turned face up
%   and 0 otherwise.
%
%   See also CARD/FACEUP, CARD/FACEDN, CARD/FLIP, CARD/ISVISIBLE, CARD/ISJOKER.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   y(i)=c(i).up;
end
y=reshape(y,size(c));