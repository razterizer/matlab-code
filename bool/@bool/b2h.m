function y=b2h(x)

%B2H  Converts binary to hex.
%   B2H(x), where x is a vector of binary numbers ranging from
%   1 to n where element #1 represents the least significant number
%   and element #n represents the most significant number.
%   The function will return a string that represents the binary number in hex.
%

% Copyright (c), B. Rasmus Anthin.
% Revision: 2002-11-27.

%[MSN     LSN]
%[MSB     LSB]

y=dec2hex(b2d(x));