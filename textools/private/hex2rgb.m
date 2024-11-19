function [rgb,g,b]=hex2rgb(hex,hg,hb)
%HEXRGB   Convert hex color to 0-1 range color.
%   RGB=HEXRGB(HEX) where HEX is a three row two-column string matrix or a
%   string cell or a string of length 6.

% Copyright (c) 2001-10-09, B. Rasmus Anthin.
% Revisited 2002-03-06

if nargin==2,error('Must be 1 or 3 arguments.'),end
if nargin==3,hex=[hex hg hb];end
if size(hex)==[3 2] & ischar(hex)
   rgb=[hex2dec(hex(1,:)) hex2dec(hex(2,:)) hex2dec(hex(3,:))]/255
elseif size(hex)==[1 6] & ischar(hex)
   rgb=[hex2dec(hex(1:2)) hex2dec(hex(3:4)) hex2dec(hex(5:6))]/255;
elseif iscellstr(hex)
   rgb=[hex2dec(hex{1}) hex2dec(hex{2}) hex2dec(hex{3})]/255;
end
if nargout==3
   g=rgb(2);
   b=rgb(3);
   rgb=rgb(1);
end
