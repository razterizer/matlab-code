function flipfig(h)
%FLIPFIG  Flip y-axis in figure.
%   FLIPFIG([H]) flips the figure's y-axis where H
%   is the figure handle. If omitted, H is the current figures
%   handle. This routine is mainly used in order to compensate
%   for the xfig type axis when converting the figure to eepic-
%   format.
%
%   See also TEXPIC, IMPXFIG.

% Copyright (c) 2002-11-23, B. Rasmus Anthin.

if ~nargin, h=gcf;end
ah=get(h,'child'); %axis
ax=axis;
for obj=get(ah,'child')'
   %get(obj,'type')
   switch get(obj,'type')
   case 'patch'
      y=get(obj,'ydata');
      set(obj,'ydata',flipy(y,ax))
   case 'line'
      y=get(obj,'ydata');
      set(obj,'ydata',flipy(y,ax))
   case 'text'
      pos=get(obj,'pos');
      pos(2)=flipy(pos(2),ax);
      set(obj,'pos',pos)
   end
   usr=get(obj,'user');
   if iscell(usr)
      switch usr{1}
      case {'circle','fcircle'}
         usr{3}(2)=flipy(usr{3}(2),ax);
      case {'ellipse','fellipse'}
         usr{4}(2)=flipy(usr{4}(2),ax);
      case 'vector'
         usr{2}(2)=flipy(usr{2}(2),ax);
         usr{3}(2)=flipy(usr{3}(2),ax);
      end
      set(obj,'user',usr)
   end
end
if strcmp(get(ah,'ydir'),'normal')
   set(ah,'ydir','rev')
else
   set(ah,'ydir','nor')
end

function fy=flipy(y,ax)
fy=ax(4)-y+ax(3);