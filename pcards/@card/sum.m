function s=sum(varargin)
%SUM   Sum of cards.
%   S = SUM(C[,DIM]) takes the sum of the values of a matrix
%   of cards. See the native SUM for more details.
%
%   Note that hidden and face-down cards are not included in the count.
%
%   S = SUM(C,KEY) takes the sum over each column of C or the sum of
%   the elements of a card vector C using a weighting rule KEY which
%   has 13 elements each corresponding to a "weight" for each card value
%   from Ace, 2, 3, ..., King. For example, in blackjack the weighting rule
%   can be either [1:9 10 10 10 10] or [11 2:9 10 10 10 10]. The value of
%   each card is used for indexing this "key" or weighting rule such that
%   the corresponding value from the key is used in the summation instead.
%
%   S = SUM(C,DIM,KEY) same as above, but with summation along an arbitrary
%   dimension DIM. KEY defaults to [1:13 0].
%
%   S = SUM(...,FLAG) uses the flag FLAG to determine whether hidden and/or
%   face-down cards should be included in the count or not.
%   Allowed values are:
%      'h'        : include hidden cards
%      'd'        : include cards that are faced down
%      'hd', 'dh' : include both cards that are hidden and cards that are faced down
%   Joker cards are naturally not included in the count (treated as zeros).
%
%   See also SUM, CARD/WEIGHT.

% Copyright (c) 2005-06-13, B. Rasmus Anthin.
% Revision: 2005-06-16, 2005-06-17.

error(nargchk(1,4,nargin))

err='Unknown option.';

c=varargin{1};
switch(nargin)
case 1
   c=remove(c,'');
   c=nojoker(c);
   s=sum(value(c));
case 2
   if length(varargin{2}(:))==1 & isnumeric(varargin{2})
      c=remove(c,'');
      c=nojoker(c);
      dim=varargin{2};
      s=sum(value(c),dim);
   elseif length(varargin{2}(:))>2 & isnumeric(varargin{2})
      c=remove(c,'');
      key=defaultkey(varargin{2});
      s=sum(weight(c,key));
   elseif length(varargin{2}(:))<3 & ischar(varargin{2})
      flag=varargin{2};
      c=remove(c,flag);
      c=nojoker(c);
      s=sum(value(c));
   else
      error(err)
   end
case 3
   if length(varargin{2}(:))==1 & length(varargin{3}(:))>2 & ...
         isnumeric(varargin{2}) & isnumeric(varargin{3})
      dim=varargin{2};
      key=defaultkey(varargin{3});
      c=remove(c,'');
      s=sum(weight(c,key),dim);
   elseif length(varargin{2}(:))==1 & length(varargin{3}(:))<3 & ...
         isnumeric(varargin{2}) & ischar(varargin{3})
      dim=varargin{2};
      flag=varargin{3};
      c=remove(c,flag);
      c=nojoker(c);
      s=sum(value(c),dim);
   elseif length(varargin{2}(:))>2 & length(varargin{3}(:))<3 & ...
         isnumeric(varargin{2}) & ischar(varargin{3})
      key=defaultkey(varargin{2});
      flag=varargin{3};
      c=remove(c,flag);
      s=sum(weight(c,key));
   else
      error(err)
   end
case 4
   if length(varargin{2}(:))==1 & length(varargin{4}(:))<3 & ...
         isnumeric(varargin{2}) & isnumeric(varargin{3}) & ischar(varargin{4})
      dim=varargin{2};
      key=defaultkey(varargin{3});
      flag=varargin{4};
      c=remove(c,flag);
      s=sum(weight(c,key),dim);
   else
      error(err)
   end
end




function x=remove(x,flag)
for i=1:length(x(:))
   resetval=0;
   switch(lower(flag))
   case 'h'
      resetval=~x(i).up;
   case 'd'
      resetval=~x(i).vis;
   case {'hd','dh'}
   case '' %exclude hidden and face-down cards from the count
      resetval=~x(i).up | ~x(i).vis;
   otherwise
      error('Unknown exclusion flag.')
   end
   if resetval
      x(i).value=0;
   end
end

function x=nojoker(x)
for i=1:length(x(:))
   if isnan(x(i).value)        %for joker cards.
      x(i).value=0;
   end
end

function y=defaultkey(x)
if length(x)<14
   y=[x length(x)+1:14];
   y(end)=0;
elseif length(x)>14    %not that it matters
   y=x(1:14);
else
   y=x;
end