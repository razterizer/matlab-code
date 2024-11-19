function c=faceup(c)
%FACEUP   Turn card(s) face up.
%   C = FACEUP(C) turns card C face up inependent of state.
%   Use FLIP or the ' (CTRANSPOSE) operator instead if you want
%   to flip the card.
%
%   See also CARD/FACEDN, CARD/FLIP, CARD/CTRANSPOSE, CARD/ISUP, CARD/SHOW.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   c(i).up=1;
end