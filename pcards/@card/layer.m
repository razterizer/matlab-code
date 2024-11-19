function y=layer(x,l)
%LAYER   Set or display layer.
%   L = LAYER(C) shows the current layer(s) for
%   card(s) C.
%
%   C = LAYER(C,L) sets the layer level of card(s) C
%   to level(s) L, where higher layer values means that
%   cards will be plotted on top of cards with lower
%   layer values. For matrices with cards,
%   overlapping cards with same layer will
%   be plotted such that cards with higher row/column
%   entries will come on top of cards with lower
%   row/column entries.
%   If L is a scalar, all cards in C will be set to that
%   layer value. If L is a matrix of same size as C, then
%   each element in L will affect each card in the C matrix
%   individually.
%
%   See also CARD, CARD/LAYOUT, CARD/POSITION.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-16.

error(nargchk(1,2,nargin))

if nargin==1
   for i=1:length(x(:))
      y(i)=x(i).layer;
   end
   y=reshape(y,size(x));
else
   y=x;
   for i=1:length(y(:))
      if prod(size(l))==1
         y(i).layer=l;
      elseif isequal(size(y),size(l))
         y(i).layer=l(i);
      else
         error('Matrix dimensions must agree.')
      end
   end
end