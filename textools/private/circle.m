function hh=circle(r,o,s)
%CIRCLE  draws a cirlce
%   CIRCLE(R,O) draws a cirlce with radius R and center O.
%   Various line types and colors may be obtained with CIRCLE(R,O,S)
%   where S character made from one element from any of the following
%   3 columns:
%
%      y   yellow            .   point              -   solid (default)
%      m   magenta           o   circle             :   dotted
%      c   cyan              x   x-mark             -.  dashdot
%      r   red               +   plus               --  dashed
%      g   green             *   star
%      b   blue (default)    s   square
%      w   white             d   diamond
%      k   black             v   triangle (down)
%                            ^   triangle (up)
%                            <   triangle (left)
%                            >   triangle (right)
%                            p   pentagram
%                            h   hexagram
%
%   H = CIRCLE(...), returns the handle for the created circle object.

% Copyright (c) 2000-05-16 by B. Rasmus Anthin.
% changed 2001-08-17


phi=linspace(0,2*pi);
phi=[phi 0];
if nargin==2
   h=plot(r*cos(phi)+o(1),r*sin(phi)+o(2));
else
   h=plot(r*cos(phi)+o(1),r*sin(phi)+o(2),s);
end
set(h,'user',{'circle',r,o});
if nargout,hh=h;end