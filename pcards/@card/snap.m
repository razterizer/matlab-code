function [c,moved]=snap(c,varargin)
%SNAP   Snap to grid.
%   C = SNAP(C,X0,Y0,XSTEP,YSTEP) snaps the position of cards C
%   to the grid defined by X0, Y0, XSTEP and YSTEP. X0 and Y0 is the
%   position of the bottom leftmost card's lower left corner. XSTEP
%   and YSTEP is the edge-to-edge offset between cards in units of the
%   size of each card (given by CSIZE) in each direction.
%   Refer to LAYOUT for more information.
%
%   C = SNAP(C,X,Y) snaps each card in C to the nearest position in
%   X and Y. X and Y are positions for the lower left corner of a card.
%   If X and Y are scalar, all cards will be located with their lower
%   left corners on (X,Y). X and Y must be vectors of equal lengths.
%
%   [C,MOVED] = SNAP(C,X,Y,LIMIT) same as above but using a limiting
%   factor LIMIT. If the distance between the cards and positions
%   fall outside the radius defined by LIMIT, then those cards are not
%   moved. Output MOVED contains information about which cards were moved
%   and which were not. MOVED has the same dimensions as C.
%   
%   Examples:
%     cs = deck.'; cs = reshape(cs(1:12),4,3); [cs,i] = rcard(cs);
%     cs = layout(cs,'dl',1,.5,.6,.8);
%     table([5 5])
%     cs = plot(cs);
%     c = deselect(select(cs))
%     c = snap(c,1,.5,.6,.8);
%     c = plot(c);
%     pause                              %next example
%     c = delete(c); cs = delete(cs);    %reset card graphics
%     cs = plot(cs);
%     x=[3 3]; y=[1 3];
%     slot(csize(cs(1)),x(1),y(1))       %create card slots
%     slot(csize(cs(1)),x(2),y(2))
%     c = deselect(select(cs))     %move without limit
%     c = snap(c,x,y);             %moves card to the closest slot
%     c = delete(c);
%     cs(cs==c) = c;
%     cs = plot(cs);
%     c = deselect(select(cs))     %move with limit
%     [c,m] = snap(c,x,y,.5);      %if longer than 0.5 units, skip
%     if m, cs(cs==c) = c; end     %if moved then update
%     cs = delete(cs);
%     cs = plot(cs);
%
%   See also CARD/LAYOUT, SLOT.

% Copyright (c) 2005-06-17, B. Rasmus Anthin.

error(nargchk(3,5,nargin))

load aspect

if nargin==5
   x0=varargin{1};
   y0=varargin{2};
   xstep=varargin{3};
   ystep=varargin{4};
   
   xstep=xstep*aspect;
   for i=1:length(c(:))
      xx=c(i).size*xstep;
      c(i).x=x0+ceil((c(i).x-x0-xstep/2)/xx)*xx;
      yy=c(i).size*ystep;
      c(i).y=y0+ceil((c(i).y-y0-ystep/2)/yy)*yy;
   end
elseif nargin<5
   x=varargin{1};
   y=varargin{2};
   lim=inf;
   if nargin==4, lim=varargin{3};end
   if ~isequal(size(x),size(y))
      error('X and Y must have equal dimensions.')
   end
   if length(lim(:))~=1
      error('Limit must be a scalar.')
   end
   
   for i=1:length(c(:))
      for j=1:length(x)
         n(j)=norm([c(i).x c(i).y]-[x(j) y(j)]);
      end
      if min(n)<lim
         c(i).x=x(n==min(n));
         c(i).y=y(n==min(n));
      end
      moved(i)=min(n)<lim;
   end
   moved=reshape(moved,size(c));
end