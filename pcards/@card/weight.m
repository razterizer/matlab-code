function w=weight(c,key)
%WEIGHT   Weighted value of card(s).
%   W = WEIGHT(C) is equivalent to W = VALUE(C)
%
%   W = WEIGHT(C,KEY) uses the card value(s) to index the KEY vector
%   and returns this/these value(s). The new/replaced values of the cards
%   are thus defined by the KEY vector. The elements in KEY correspond to
%   the following values:
%      KEY = [Ace 2, ..., 10, Jack, Queen, King, Joker]
%
%   For KEY = [1:13 NaN], WEIGHT(C,KEY) gives the same result as VALUE(C).
%   
%   This method is useful for situation where cards
%   have different values than those printed on them. For example,
%   in blackjack the weighting rules (KEY) would be
%   [1:9 10 10 10 10 NaN] and [11 2:9 10 10 10 10 NaN].
%
%   See also CARD/SUM.

% Copyright (c) 2005-06-13, B. Rasmus Anthin.
% Revision: 2005-06-17.

error(nargchk(1,2,nargin))

for i=1:length(c(:))
   if nargin<2 | isempty(key)
      w(i)=c(i).value;
   else
      key=defaultkey(key);
      if isnan(c(i).value), c(i).value=14;end    %if Joker
      if c(i).value
         w(i)=key(c(i).value);
      else
         w(i)=0;                 %used only by SUM
      end
   end
end
w=reshape(w,size(c));



function y=defaultkey(x)
if length(x)<14
   y=[x length(x)+1:14];
   y(end)=NaN;
elseif length(x)>14    %not that it matters
   y=x(1:14);
else
   y=x;
end