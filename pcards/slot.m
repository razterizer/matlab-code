function [h,L]=slot(siz,x,y,color)
%SLOT   Card stacking slot.
%   [H,BORDER] = SLOT(SIZE,X,Y) creates a slot of size SIZE
%   with its lower left corner position at X and Y.
%   The plotted object H is a line object defined by the points
%   in BORDER. The color is set to black and all its other
%   object properties are set to their default values.
%
%   The following description shows how the points in BORDER are
%   organized:
%      BORDER(1) = lower left corner (bottom after arc)
%      BORDER(2) = lower right corner (bottom before arc)
%      BORDER(103) = lower right corner (right after arc)
%      BORDER(104) = upper right corner (right before arc)
%      BORDER(205) = upper right corner (top after arc)
%      BORDER(206) = upper left corner (top before arc)
%      BORDER(307) = upper left corner (left after arc)
%      BORDER(308) = lower left corner (left before arc)
%
%        206 205
%        .-----.
%     307|     |104
%        |     |
%     308|     |103
%        ._____.
%         1   2 
%
%   To alter the properties of the slot border (line object)
%   such as colour or width, use the SET command.
%
%   [...] = SLOT(SIZE,X,Y,COLOR) creates a slot which is a patch
%   type object rather than a line type object. The patch object has
%   its face color set to COLOR.
%
%   Examples:
%     table([-.2 4 -.2 3])
%     c = rcard;
%     plot(c);                         %serves as reference
%     slot(csize(c),1,0)                          %standard slot
%     h = slot(csize(c),1+cwidth(c)+.05,0);
%     set(h,'color','b','linestyle',':')          %change the look
%     slot(csize(c),1+2*cwidth(c)+.1,0,'g');      %patched slot
%     h = slot(csize(c),1+3*cwidth(c)+.15,0,'y');
%     set(h,'edgecolor','r','linewidth',2)        %change the look
%
%   See also TABLE, CARD/PLOT, CARD/SELECT, CARD/DESELECT.

% Copyright (c) 2005-06-18, B. Rasmus Anthin.

error(nargchk(3,4,nargin))

L=cardplot(x,y,siz);
hold on
if nargin<4
   h=plot(L,'k');
else
   h=patch(real(L),imag(L),color);
end
if ~nargout, clear h, end