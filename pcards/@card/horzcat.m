function c = horzcat(a,b)
%HORZCAT  Horizontal concatenation of cards.
%   [A B] is the horizontal concatenation of card matrices A and B.
%   A and B must have the same number of rows. [A,B] is the same thing.
%   Any number of matrices can be concatenated within one pair of brackets.
%
%   See also HORZCAT, CARD/VERTCAT, CAT.

% Copyright (c) 2005-06-18, B. Rasmus Anthin.

if nargin==2 & isempty(a)
   c=b;
elseif nargin==1 | isempty(b)
   c=a;
elseif nargin==2 & ~isempty(a) & ~isempty(b)
   row=size(a,1);
   col1=size(a,2);
   col2=size(b,2);
   if ~isequal(row,size(b,1))
      error('All matrices on a row in the bracketed expression must have the same number of rows.')
   end
   c(1:row,1:col1)=a;
   c(1:row,col1+(1:col2))=b;
else
   c=[];
end