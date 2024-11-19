function hh=fcircle(r,o,s)
%FCIRCLE  draws a filled cirlce
%   FCIRCLE(R,O) draws a cirlce with radius R and center O.
%   Various line types and colors may be obtained with FCIRCLE(R,O,S)
%   where S is any of the following characters
%
%      y   yellow
%      m   magenta
%      c   cyan
%      r   red
%      g   green
%      b   blue (default)
%      w   white
%      k   black
%
%   or an RGB vector.
%
%   H = FCIRCLE(...), returns the handle(s) for the created fcircle
%   object(s). If FCIRCLE draws a border then the second element in H
%   will correspond to the border object handle.

% Copyright (c) 2000-05-19 by B. Rasmus Anthin.
% Rev. 2000-10-24

phi=linspace(0,2*pi);
if nargin==2
   h=patch(r*cos(phi)+o(1),r*sin(phi)+o(2),'');
else
   h=patch(r*cos(phi)+o(1),r*sin(phi)+o(2),s);
end
set(h,'edgec',get(h,'facec'));
set(h,'user',{'fcircle',r,o});
if nargout,hh=h;end