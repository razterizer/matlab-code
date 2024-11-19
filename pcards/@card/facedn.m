function c=facedn(c)
%FACEDN   Turn card(s) face down.
%   C = FACEDN(C) turns card C face down inependent of state.
%   Use FLIP or the ' (CTRANSPOSE) operator instead if you want
%   to flip the card.
%
%   See also CARD/FACEUP, CARD/FLIP, CARD/CTRANSPOSE, CARD/ISUP, CARD/SHOW.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   c(i).up=0;
end