function y=size(x)
%SIZE  Size of boolean string.
%   D = SIZE(X), for a bool object X, returns the two-element
%   row vector D = [M, N], where N is the grouping of bits and
%   M is the number of such groupings (like nibbles, bytes etc...).
%
%   See also BOOL/DISPLAY.

% Copyright (c) 2002-11-27, B. Rasmus Anthin.
% Revision 2002-11-29

l=length(x.val);
if ~mod(l,64) %ext dbl
   c=64;
elseif ~mod(l,32) %dbl
   c=32;
elseif ~mod(l,16) %word
   c=16;
elseif ~mod(l,8) %byte
   c=8;
elseif ~mod(1,4) %nibble
   c=4;
else
   c=1;
end
r=l/c;
y=[r c];
