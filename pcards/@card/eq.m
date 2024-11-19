function y=eq(a,b)
%==  Equal.
%   A == B does element by element comarisons between card
%   objects A and B and returns a matrix of the same size with
%   elements set to one where the relation is true and elements
%   set to zero where it is not. Both values and suits must be
%   equal for the equality to be true. Cards A and B must have
%   the same dimensions unless one is a single card. A single
%   card (scalar) can be compared to any array or matrix of cards.
%
%   Examples:
%     c = card(5,'s');
%     d = deck;
%     d==c               %find card in deck
%     d(d==c)
%     suit(d,'s')==c     %comparison independent of suit
%     d(suit(d,'s')==c)
%
%   See also CARD/NE, CARD/LT, CARD/GT, CARD/LE, CARD/GE.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

dim=size(a);
if ~isequal(dim,size(b)) & prod(dim)>1 & prod(size(b))>1
   error('Matrix dimensions must agree.')
end
y=[a(:).value]==[b(:).value] & [a(:).suit]==[b(:).suit];
y=reshape(y,dim);