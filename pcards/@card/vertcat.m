function c = vertcat(a,b)
%VERTCAT  Vertical concatenation of cards.
%   [A;B] is the vertical concatenation of card matrices A and B.
%   A and B must have the same number of columns.
%   Any number of matrices can be concatenated within one pair of brackets.
%
%   See also VERTCAT, CARD/HORZCAT, CAT.

% Copyright (c) 2005-06-18, B. Rasmus Anthin.

if nargin==2 & isempty(a)
   c=b;
elseif nargin==1 | isempty(b)
   c=a;
elseif nargin==2 & ~isempty(a) & ~isempty(b)
   row1=size(a,1);
   row2=size(b,1);
   col=size(a,2);
   if ~isequal(col,size(b,2))
      error('All rows in the bracketed expression must have the same number of columns.')
   end
   c(1:row1,1:col)=a;
   c(row1+(1:row2),1:col)=b;
else
   c=[];
end