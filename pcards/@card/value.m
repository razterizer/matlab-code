function y=value(x,value)
%VALUE   Set or display value.
%   V = VALUE(C) shows the current value(s) V for card(s) C.
%   The returned values V is a numerical matrix with card values
%   ranging between 1(ace) and 13(king) where each element
%   corresponds to a card in the matrix C. If C is a single card then
%   V is a scalar.
%
%   C = VALUE(C,V) alters the value of the card(s) C
%   to value V if V is a scalar value. If V is a matrix with the same
%   dimensions as C, then each card in C is assigned a value from a
%   corresponding element in V. In the latter case, the V matrix must
%   contain integer values (since value 10 cannot be represented with a
%   single character in a character matrix).
%
%   Except from integers ranging from 1 to 13, value(s) V can be
%   either of:
%       'ACE'   = 1
%       'JACK'  = 11
%       'KING'  = 12
%       'QUEEN' = 13
%       '*'     = NaN       (Joker)
%   however, the VALUE method only considers the first character
%   so the remaining characters are redundant. Strings are case
%   insensitive.
%
%   You cannot change the value of a Joker card. You must change both
%   value and suit by using the CHANGE method.
%
%   Examples:
%     c = card(5,'s')
%     format long          %change to display format long
%     value(c)
%     c = value(c,11)
%     c = value(c,'11')
%     c = value(c,'J')
%     c = value(c,'jack')
%     value(c)
%     c = value(c,'Ace')
%     c = value(c,'a')
%     value(c)
%     format short e
%     c = cards(2)
%     c = value(c,'king')
%     c = value(c,[1 5;NaN 12])
%     value(c)
%     format               %change back to default display format
%
%   See also CARD/SUIT, CARD/CHANGE, CARD/WEIGHT, CARD/JOKER, CARD.

% Copyright (c) 2005-06-13, B. Rasmus Anthin.
% Revision: 2005-06-16.

error(nargchk(1,2,nargin))

wrnmsg='Cannot change value of a joker/wild card. Use CHANGE instead.';
errmsg1='Value out of range.';
errmsg2='Invalid value.';
errmsg3='Matrix dimensions must agree.';

if nargin==2
   y=x;
   if ischar(value) | prod(size(value))==1               %set all cards to the same value
      if ischar(value)
         if ~isletter(value(1))
            if value(1)=='*'
               value=NaN;
            else
               value=str2num(value);
            end
            if value<1 | value>13
               error(errmsg1)
            end
         else
            switch(lower(value(1)))
            case 'a'
               value=1;
            case 'j'
               value=11;
            case 'q'
               value=12;
            case 'k'
               value=13;
            otherwise
               error(errmsg2)
            end
         end
      else
         if value<1 | value>13
            error(errmsg1)
         end
      end
      for i=1:length(y(:))
         if ~isnan(y(i).value) | isnan(value)
            y(i).value=value;
            if isnan(value), y(i).suit='*'; end
         else
            warning(wrnmsg)
         end
      end
   elseif isnumeric(value) & isequal(size(y),size(value))      %set individual values for cards
      for i=1:length(y(:))
         val=value(i);
         if val<1 | val>13
            error(errmsg1)
         end
         if ~isnan(y(i).value) | isnan(val)
            y(i).value=val;
            if isnan(val), y(i).suit='*'; end
         else
            warning(wrnmsg)
         end
      end
   else                                        %if dimension mismatch
      error(errmsg3)
   end
   
else
   for i=1:length(x(:))
      y(i)=x(i).value;
   end
   y=reshape(y,size(x));
end