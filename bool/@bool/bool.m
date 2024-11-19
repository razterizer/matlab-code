function y=bool(x)
%BOOL  Constructor for the BOOL class.
%   BOOL(X), where X is a bool object, a numeric array
%   (or bool-struct).
%
%   See also BOOL/DISPLAY.

% Copyright (c) 2002-11-27, B. Rasmus Anthin.
% Revision 2002-11-29

if isnumeric(x)
   y.val=uint8(~~x(:)');
   y=class(y,'bool');
elseif isstruct(x)
   y=class(x,'bool');
elseif isbool(x)
   y=x;
else
   error('Input must be numeric.')
end
