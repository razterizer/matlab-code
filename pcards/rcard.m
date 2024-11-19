function [c,I]=rcard(m,n)
%RCARD   Uniformly distributed random cards.
%   C = RCARD(N) is an N-by-N matrix with random cards (uniformly
%   distributed).
%   C = RCARD(M,N) and RCARD([M,N]) are M-by-N matrices with random
%   cards.
%   C = RCARD is a single card with random value and suit.
%
%   Note that it is the suits and values of the cards in the matrix
%   that are randomized. The layout of the cards (created by RCARD)
%   when plotted is the same as used by the CARDS function
%   (i.e. uniformly spaced and dealt downwards).
%
%   C = RCARD(C) randomizes the values and suits for each card
%   in the card matrix C. All other properties of the cards remain
%   unaltered except for their suits and values which will be random.
%
%   [Co, I] = RCARD(C) randomizes the order of the cards in the
%   card matrix C. The output I contains indices such that the
%   output Co = reshape(C(I),size(C)).
%   The extra output argument causes RCARD to randomize the order of
%   the cards rather than assigning random values and suits to the
%   cards, as above.
%
%   See also CARDS, DECK, CARD, CARD/LAYOUT.

% Copyright (c) 2005-06-14, B. Rasmus Anthin.
% Revision: 2005-06-16.

error(nargchk(0,2,nargin))

if ~nargin
   m=1;n=1;
end

if ~iscard(m)
   if nargin==1
      if length(m(:))==1
         n=m;
      elseif length(m(:))==2
         n=m(2);
         m=m(1);
      else
         error('Unsupported dimension format.')
      end
   end
   c=cards(m,n);
else
   c=m;
end

if nargout==2
   [r,I]=sort(rand(1,length(c(:))));
   c=reshape(c(I),size(c));
else
   for i=1:length(c(:))
      c(i)=change(c(i),ceil(13*rand),ceil(4*rand));
   end
end