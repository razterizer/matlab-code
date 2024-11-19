function varargout=grayc(n)

%GRAYC  Generates a matrix of variables in Gray code.
%   GRAYC(n) gives as output a table of n variables coded in Gray code.
%   The output is a cell array of bool-class variables or the correct amount
%   of bool-class variables. Examples:
%
%      [X1 X2 X3 X4]=GRAYC(4);
%      VARS=GRAYC(4);
%
%   See also NBC.
%

% Copyright (c) 2002-11-27, B. Rasmus Anthin.
% Revision 2002-11-29

x=grayc2(n);
for i=1:size(x,2)
   if nargout==1 & n>1
      varargout{1}{i}=bool(x(:,i));
   else
      varargout{i}=bool(x(:,i));
   end
end
