function c=cards(m,n)
%CARDS   Card array.
%   CARDS(N)  is an N-by-N matrix of card objects.
%   CARDS(M,N) or CARDS([M,N]) is a M-by-N matrix of card objects.
%   CARDS(SIZE(A)) is a matrix of card objects with the same size of
%   matrix A.
%
%   The resulting card matrix has its cards arranged in such a way
%   that when plotted, they are separated by xstep = 100% and ystep = 50%.
%   Also when plotted, the card at row = column = 1 is located
%   at the topmost leftmost card on the table.
%   The cards are distributed on layers that are increasing with the
%   row number (cards are dealt downwards).
%   The size of the cards (height) is unity and the lowest
%   leftmost card of the pack is having its lower left corner at (0,0).
%   All cards are visible, turned face up and have value and suit
%   ace of clubs.
%
%   See also DECK, CARD, CARD/LAYOUT.

% Copyright (c) 2005-06-13, B. Rasmus Anthin.

error(nargchk(1,2,nargin))
load card/private/aspect

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
wrnmsg='Size vector should be a row vector with integer elements.';
if floor(m)~=m
   warning(wrnmsg)
   m=0;
elseif m<1
   m=0;
end
if floor(n)~=n
   warning(wrnmsg)
   n=0;
elseif n<1
   n=0;
end
if ~m | ~n
   c=zeros(m,n);         %in order to mimic the behaviour of zeros
end
for i=1:m
   for j=1:n
      c(i,j).h=[];
      c(i,j).layer=i; %m-i;
      c(i,j).size=1;
      c(i,j).x=(j-1)*aspect;
      c(i,j).y=(m-i)/2;
      c(i,j).vis=1;
      c(i,j).up=1;
      c(i,j).value=1;
      c(i,j).suit='c';
      %c(i,j)=card(c(i,j));
   end
end
if ~isempty(c)
   c=card(c);
end