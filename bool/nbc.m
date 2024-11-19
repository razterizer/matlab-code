function varargout=nbc(n)

%NBC  Generates a matrix of variables in nbc.
%   NBC(n) gives as output a table of n variables coded in nbc,
%   (Natural Binary Code).
%   The output is a cell array of bool-class variables or the correct amount
%   of bool-class variables. Examples:
%
%      [X1 X2 X3 X4]=NBC(4);
%      VARS=NBC(4);
%
%   See also GRAYC.
%

% Copyright (c) 2002-11-27, B. Rasmus Anthin.
% Revision 2002-11-29

x=nbc2(n);
for i=1:size(x,2)
   if nargout==1 & n>1
      varargout{1}{i}=bool(x(:,i));
   else
      varargout{i}=bool(x(:,i));
   end
end
