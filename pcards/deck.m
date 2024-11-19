function d=deck
%DECK  Creates a deck of cards.
%   D = DECK  creates a deck of cards, that is, a 13x4 matrix
%   with the four suits (clubs, diamonds, hearts and spades)
%   along the columns and the 13 values (ace, 2, 3, ..., king)
%   along the rows. Cards are distributed according to the layout
%   used by the CARDS function.
%
%   See also CARDS, CARD, CARD/LAYOUT.

% Copyright (c) 2005-06-14, B. Rasmus Anthin.

error(nargchk(0,0,nargin))

d=cards(13,4);
for i=1:13
   for j=1:4
      d(i,j)=change(d(i,j),i,j);
   end
end
      