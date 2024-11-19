function h=plotvec(p1,p2,linespec)
%PLOTVEC   Draws a vector.
%   PLOTVEC(P1,P2[,LINESPEC]) draws a vector from point P1
%   to point P2 using linespecification LINESPEC (see PLOT).
%
%   H = PLOTVEC(...) returns handles of the objects.
%
%   See also CIRCLE, FCIRCLE, ELLIPSE, FELLIPSE.

% Copyright (c) 2001-09-28, B. Rasmus Anthin.

if nargin==2,linespec='';end
held=ishold;hold on
x=[p1(1) p2(1)];
y=[p1(2) p2(2)];
dx=diff(x);
dy=diff(y);
hh(1)=plot(x,y,linespec);
ax=axis;
lx=diff(ax(1:2))*25e-3;
ly=diff(ax(3:4))*10e-3;
phi=atan2(dy,dx);
head=rotate2([-lx 0 -lx;ly 0 -ly],[0;0],phi);
col=get(hh(1),'color');
hh(2)=patch(head(1,:)+p2(1),head(2,:)+p2(2),col);
set(hh(2),'edgec',col)
set(hh(1),'user',{'vector',p1,p2,hh(2)})
set(hh(2),'user',{'vector',p1,p2,hh(1)})
if ~held,hold off,end
if nargout,h=hh;end