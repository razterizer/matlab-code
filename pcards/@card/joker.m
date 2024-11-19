function c=joker(c)
%JOKER   Set to joker.
%   C = JOKER(C) sets all cards in C to jokers (wild cards). This method is
%   equivalent to C = CHANGE(C,'*','*') or C = CHANGE(C,NaN,NaN)
%   (or any other combination with NaN or '*').
%
%   Comparisons between any card with a joker (wild) card results in zeros.
%   For instance C == C returns zero if C is a joker card.
%
%   To be able to revert a wild card back to a normal card you must
%   use the CHANGE method. Using the VALUE and SUIT methods individually
%   won't have any effect on a wild card.
%
%   See also CARD/ISJOKER, CARD/CHANGE, CARD.

% Copyright (c) 2005-06-16, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   c(i).value=NaN;
   c(i).suit='*';
end