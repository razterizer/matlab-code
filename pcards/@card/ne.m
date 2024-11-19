function y=ne(a,b)
%~=  Not equal.
%   A ~= B does element by element comarisons between card
%   objects A and B and returns a matrix of the same size with
%   elements set to one where the relation is true and elements
%   set to zero where it is not. The suits must be
%   equal for the relation to be true. Cards A and B must have
%   the same dimensions unless one is a single card. A single
%   card (scalar) can be compared to any array or matrix of cards.
%
%   See also CARD/EQ, CARD/LT, CARD/LE, CARD/GT, CARD/GE.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-16.

dim=size(a);
if ~isequal(dim,size(b)) & prod(dim)>1 & prod(size(b))>1
   error('Matrix dimensions must agree.')
end
y=[a(:).value]~=[b(:).value] & [a(:).suit]==[b(:).suit];
y=reshape(y,dim);