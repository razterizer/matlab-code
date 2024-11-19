function y=horzcat(varargin)
%HORZCAT  Horizontal concatenation for bool objects.
%   [X1 X2 X3...] where Xn can be either bool objects or
%   numerical arrays.

% Copyright (c) 2002-11-27, B. Rasmus Anthin.
% Revision 2002-11-29.

y.val=[];
for i=1:length(varargin)
   x=bool(varargin{i});
   y.val=[y.val x.val];
end
y=bool(y);
