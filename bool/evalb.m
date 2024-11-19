function y=evalb(x)
%EVALB  Convert to boolean arrays.
%   EVALB(X), converts array X to an array of ones
%   and zeroes. All nonzero elements in X are regarded
%   as ones.
%
%   See also BTAB.

% Copyright (c), B. Rasmus Anthin.
% Revision 2002-11-27.

y=~~x(:)';

