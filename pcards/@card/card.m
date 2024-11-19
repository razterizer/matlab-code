function c=card(varargin)
%CARD   Construct card object.
%   C = CARD(X) constructs a card object from a struct with the proper fields
%   (if X is a card object the constructor will be transparent for it).
%
%   C = CARD(VALUE,SUIT) creates a card object with specified value and suit.
%   The values are in the range 1 - 13 and can be either in double or string
%   format. Royal cards (11-13) can be replaced with values 'JACK', 'QUEEN'
%   and 'KING', and the ace (1) can be replaced with 'ACE'.
%   Suits range from 'CLUBS', 'DIAMONDS', 'HEARTS' and 'SPADES',
%   however only the first character will suffice.
%   All strings are case insensitive.
%   SUIT can also be an integer between 1 and 4 corresponding to the previous
%   mentioned suits in order, but it is advicable to stick with strings in
%   most cases.
%
%   C = CARD(...,UP) where UP specifies whether the card is dealt face up or not.
%   If it is face down UP is zero, any other value (or 1) means it is face up.
%   Defaults to 1.
%   
%   C = CARD(...,UP,SIZE,X,Y,VISIBLE) sets the graphical properties of the
%   card, i.e. its SIZE (defaults to 1), lower left corner position X and Y
%   (defaults to (0,0)). VISIBLE is set to zero if the card is hidden, any other
%   value means it is visible (default is 1).
%
%   C = CARD(...,UP,SIZE,X,Y,VISIBLE,LAYER) alters the layer property of the
%   card (default is 0). The layer property tells the plot command in which order
%   cards in a card matrix are to be plotted so that higher layer values are
%   plotted last, thus appearing on top of cards on lower layers.
%   If cards that are not entirely (graphically) separated and they lie on the
%   same layer, then the latter card is plotted on top of the former (latter as
%   in higher row number or column number).
%
%   Examples:
%     c = card(5,'c')              %5 of clubs
%     c = card('5','Clubs')        %5 of clubs
%     c = card('a','s')            %ace of spades
%     c = card(1,'spades')         %ace of spades
%     c = card('jack','hearts',0)  %turn card face down
%     format long
%     c = card(13,'d')
%     format short
%     c = card('13','d',1,1,1.5,0.5,0)  %hide card
%     c = card('K','d',1,1,1.5,0.5,1)
%     table([5 5])
%     c = plot(c);
%
%   See also CARDS, CARD/DISPLAY, ISCARD, CARD/PLOT, CARD/SUIT, CARD/VALUE,
%            CARD/JOKER, CARD/FACEDN, CARD/HIDE.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-16.

error(nargchk(1,8,nargin))

if nargin==1
   x=varargin{1};
   if isempty(x)
      c=x;
   elseif isstruct(x)
      c=class(x,'card');
   elseif iscard(x)
      c=x;
   else
      error('Invalid argument.')
   end
else
   c.h=[];              %plot handles
   if nargin<8
      c.layer=0;
   else
      c.layer=varargin{8};
   end
   if nargin<4     %plotting options
      c.size=1;         %plot size
      c.x=0;            %plot position x
      c.y=0;            %plot position y
      c.vis=1;          %not hidden
   else
      c.size=varargin{4};
      c.x=varargin{5};
      c.y=varargin{6};
      c.vis=varargin{7};
   end
   if nargin<3
      c.up=1;         %face up
   else
      c.up=varargin{3};
   end
   
   v=varargin{1};
   c.value=v;
   if ischar(v)
      if ~isletter(v(1))
         if v=='*'
            c.value=NaN;
         else
            c.value=str2num(v);
         end
      else
         switch(lower(v(1)))
         case 'a'
            c.value=1;
         case 'j'
            c.value=11;
         case 'q'
            c.value=12;
         case 'k'
            c.value=13;
         otherwise
            error('Invalid value.')
         end
      end
   end
   if ~isnan(c.value) & (c.value<1 | c.value>13)
      error('Value out of range.')
   end
   
   s=varargin{2};
   SUITS='cdhs*';
   c.suit=lower(s(1));
   if ischar(c.suit) & ~any(c.suit==SUITS)
      error('Invalid suit.')
   end

   if ~ischar(c.suit)
      if 0<c.suit & c.suit<5
         c.suit=SUITS(c.suit);
      elseif isnan(c.suit)
         c.suit='*';
      else
         error('Invalid suit.')
      end
   end
   
   if isnan(c.value), c.suit='*';end
   if c.suit=='*', c.value=NaN;end
   
   c=class(c,'card');
end