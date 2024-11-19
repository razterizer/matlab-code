function c=flip(c)
%FLIP   Flip card(s) down or up.
%   C = FLIP(C) flips card(s) up if it is face down and
%   flips it face down when it is in face up position.
%
%   This method is equivalent to the ' (CTRANSPOSE) operator.
%
%   Example:
%     c = card('a','s')
%     table([5 3])
%     c = plot(c);
%     pause
%     c = flip(c)      %flip card
%     c = plot(c);     %update view
%
%   See also CARD/CTRANSPOSE, CARD/FACEUP, CARD/ISUP, CARD/SHOW.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   c(i).up=~c(i).up;
end