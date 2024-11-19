function y=flip4(x)
%FLIP4  Flips overall order of each nibble.
%   For instance:
%      FLIP4([1 0 1 0  0 1 0 1  0 0 1 1])
%   results in
%      0011 0101  1010

% Copyright (c) 2002-11-29, B. Rasmus Anthin.

x=bool(x);
y=flip4i(flip(x));
