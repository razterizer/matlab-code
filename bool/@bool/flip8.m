function y=flip8(x)
%FLIP8  Flips overall order of each byte.
%   For instance:
%      FLIP8([1 0 1 0  0 1 0 1  0 0 1 1])
%   results in
%      0101 0011  0000 1010

% Copyright (c) 2002-11-29, B. Rasmus Anthin.

x=bool(x);
y=flip8i(flip(x));
