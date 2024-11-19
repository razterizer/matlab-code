function hh=fellipse(varargin)
%FELLIPSE   Draws a filled ellipse.
%   FELLIPSE(F1,F2,R,[,LINESPEC])
%   FELLIPSE(O,A,B[,LINESPEC]), where LINESPEC is any of the
%   following characters
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
%   H = FELLIPSE(...)
%
%   See also CIRLCE, FCIRCLE, ELLIPSE.

% Copyright (c) 2001-09-15, B. Rasmus Anthin.

ni=nargin;
opt='';
if nargin & (ischar(varargin{end}) | length(varargin{end})==3)
   opt=varargin{end};
   ni=ni-1;
end
error(nargchk(3,3,ni))
if length(varargin{2})>1
   f1=varargin{1};
   f2=varargin{2};
   r=varargin{3}*2;
   if abs(f1(1)-f2(1))<abs(f1(2)-f2(2))
      m=mean([f1(1) f2(1)]);
      f1(1)=m;f2(1)=m;
   else
      m=mean([f1(2) f2(2)]);
      f1(2)=m;f2(2)=m;
   end
   o=[mean([f1(1) f2(1)]) mean([f1(2) f2(2)])];
   c=abs(f2-o);
   if ~c(1)
      b=max([r c(2)]);
      a=sqrt(b^2-c(2)^2);
   elseif ~c(2)
      a=max([r c(1)]);
      b=sqrt(a^2-c(1)^2);
   end
   %hold on,plot(f1(1),f1(2),'x'),plot(f2(1),f2(2),'x')
else
   o=varargin{1};
   a=varargin{2};
   b=varargin{3};
end
phi=linspace(0,2*pi);
h=patch(o(1)+a*cos(phi),o(2)+b*sin(phi),opt);
set(h,'edgec',get(h,'facec'));
set(h,'user',{'fellipse',abs(a),abs(b),o});
if nargout,hh=h;end