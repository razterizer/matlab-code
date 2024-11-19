function y=ctranspose(x)
%CTRANSPOSE   Flips a card.
%   C' flips a card from being face up to face down or
%   from face down to face up.
%
%   To transpose a matrix of cards, issue the .' (TRANSPOSE)
%   operator instead.
%
%   See also CARD/FLIP, CARD/FACEUP, CARD/FACEDN, CARD/ISUP.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

y=flip(x);