function y=suit(x,suit)
%SUIT   Set or display suit.
%   S = SUIT(C) shows the current suit(s) S for card(s) C.
%   The returned suits S is a matrix with single lower case
%   characters each corresponding to the first letter of the suit
%   of each card in the pack/shoe (matrix). If C is a single card
%   then S is a single character corresponding to the first letter
%   of the suit of that card.
%
%   C = SUIT(C,S) alters the suit of the card(s) C
%   to suit S if S is a scalar suit. If S is a matrix with the same
%   dimensions as C, then each card in C is assigned a suit from a 
%   corresponding element in S. In the latter case, the S matrix must
%   contain either integer values between 1 and 4 or NaNs, or characters
%   'c', 'd', 'h', 's' and '*' (case insensitive).
%
%   Allowed values of suits S are the strings and
%   corresponding numbers:
%       'CLUBS'     = 1
%       'DIAMONDS'  = 2
%       'HEARTS'    = 3
%       'SPADES'    = 4
%       '*'         = NaN       (Joker)
%   however, the SUIT method only considers the first letter
%   so the remaining characters are redundant. Strings are
%   case insensitive.
%
%   Examples:
%     c = card(5,'s')
%     format long      %change to display format long
%     suit(c)
%     c = suit(c,'hearts')
%     c = suit(c,'Diamonds')
%     c = suit(c,'SPADES')
%     c = suit(c,4)
%     c = suit(c,'cLuBs')
%     c = suit(c,'d')
%     format short e
%     c = cards(2)
%     c = suit(c,'diamonds')
%     c = suit(c,['cd';'h*'])
%     c = suit(c,[1 2;3 NaN])
%     suit(c)
%     c = suit(c,'*')
%     format           %change back to short format
%
%   See also CARD/VALUE, CARD/CHANGE, CARD/JOKER, CARD.

% Copyright (c) 2005-06-13, B. Rasmus Anthin.

error(nargchk(1,2,nargin))

%SUITS='sdch';
SUITS='cdhs*';

wrnmsg='Cannot change value of a joker/wild card. Use CHANGE instead.';
errmsg1='Invalid suit.';
errmsg2='Matrix dimensions must agree.';

if nargin==2
   y=x;
   if (ischar(suit) & length(suit)>1 & all(suit(2)~=SUITS)) | prod(size(suit))==1   %single suit
      for i=1:length(y(:))
         if y(i).suit~='*' | suit(1)=='*' | isnan(suit(1))
            y(i).suit=suitchk(suit);
            if suit(1)=='*' | isnan(suit(1)), y(i).value=NaN; end
         else
            warning(wrnmsg)
         end
      end
   elseif isequal(size(y),size(suit))                                       %multiple suits
      if all(ismember(suit,SUITS)) | isnumeric(suit)
         for i=1:length(y(:))
            if y(i).suit~='*' | suit(i)=='*' | isnan(suit(i))
               y(i).suit=suitchk(suit(i));
               if suit(i)=='*' | isnan(suit(i)), y(i).value=NaN; end
            else
               warning(wrnmsg)
            end
         end
      else
         error(errmsg1)
      end
   else
      error(errmsg2)
   end
   
else
   for i=1:length(x(:))
      y(i)=x(i).suit;
   end
   y=reshape(y,size(x));
end




function y=suitchk(s)
SUITS='cdhs*';
errmsg='Invalid suit.';
if ischar(s)                              %string input
   s=lower(s(1));
   if any(s==SUITS)
      y=s;
   else
      error(errmsg)
   end
elseif isnumeric(s) & length(s(:))==1    %integer input
   if 0<s & s<5
      y=SUITS(s);
   elseif isnan(s)
      y='*';
   else
      error(errmsg)
   end
else
   error(errmsg)
end