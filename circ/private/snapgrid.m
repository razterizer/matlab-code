function h=snapgrid(snap,col)
if nargin<2, col='b';end
ax=axis;
xmin=ceil(ax(1)/snap)*snap;
xmax=floor(ax(2)/snap)*snap;
ymin=ceil(ax(3)/snap)*snap;
ymax=floor(ax(4)/snap)*snap;
[x,y]=meshgrid(xmin:snap:xmax,ymin:snap:ymax);
h=plot(x(:),y(:),'.');
set(h,'color',col,'markersize',.5)
if ~nargout, clear h,end