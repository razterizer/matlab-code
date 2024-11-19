function C_=plot(C,h)
%PLOT   Plot card(s) on table.
%   C = PLOT(C) plots the card(s) C on a user created table
%   (a figure created by the TABLE command). It is advicable to
%   assign the output from the PLOT function to the same pack/shoe
%   of cards in order to properly update its objects handles.
%   After the first time a pack (scalar, vector or matrix) of cards
%   is plotted, the PLOT method will keep track on the objects and
%   only update the contents of the graphics objects of each card
%   after each consecutive call. This feature is time saving since the
%   PLOT method only updates those cards that have their appearances
%   altered.
%
%   Cards are plotted in the order defined by the layer property of
%   each card. Cards with higher layer values are plotted after cards
%   with lower layer values. Cards with the same layer value will be
%   plotted in the order of increasing row and column positions.
%   Cards are plotted in column-row order, i.e. from top left to
%   bottom right.
%
%   C = PLOT(C,AXH)  plots card(s) on table in axes AXH.
%
%   Examples:
%     d = layout(deck.','r',0,0,.5,1)  %transpose deck and align right
%     table([7 5])
%     d = plot(d);
%     pause
%     d(2,7) = change(d(2,7),'jack','clubs');
%     d(3,3) = d(3,3)';
%     d = plot(d)
%     pause
%     d(1,13) = hide(d(1,13));
%     d(1,13) = plot(d(1,13))   %just as fast as the previous plot
%     pause
%     d = delete(d);            %remove cards from the table
%
%   See also CARD, TABLE, CARD/DELETE, CARD/SELECT, CARD/DESELECT.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-16.

error(nargchk(1,2,nargin))

if nargin==1
   shg
else
   axes(h)
end

dim=size(C);
C=C(:);
L=[C.layer];
[foo,I]=sort(L);

for i=I
   c=C(i);
   if isempty(c.h)
      if ~c.vis
         C(i).h=cardplot(c.x,c.y,c.size,-1,c.suit);
         layer2ud(C(i).h,c);
      elseif ~c.up
         C(i).h=cardplot(c.x,c.y,c.size,0,c.suit);
         layer2ud(C(i).h,c);
      else
         C(i).h=cardplot(c.x,c.y,c.size,c.value,c.suit);
         layer2ud(C(i).h,c);
      end
   else
      [v,s]=cardplot(c.h);
      if isempty(s), s='-'; end
      ud=get(c.h(1),'userdata');
      x0=ud{3}(1);
      y0=ud{3}(2);
      csize=ud{3}(5);
      layer=ud{3}(6);
      updated=0;
      if ~c.vis & v~=-1
         cardplot(c.h,c.x,c.y,-1,c.suit);
         updated=1;
      elseif ~c.up & v~=0
         cardplot(c.h,c.x,c.y,0,c.suit);
         updated=1;
      elseif c.vis & c.up & ((v~=c.value & ~isnan(v) & ~isnan(c.value)) | isnan(v)~=isnan(c.value) | s~=c.suit)
         cardplot(c.h,c.x,c.y,c.value,c.suit);
         updated=1;
      end
      if ~updated & (x0~=c.x | y0~=c.y | csize~=c.size | layer~=c.layer)
         delete(C(i).h)
         if ~c.vis
            C(i).h=cardplot(c.x,c.y,c.size,-1,c.suit);
            layer2ud(C(i).h,c);
         elseif ~c.up
            C(i).h=cardplot(c.x,c.y,c.size,0,c.suit);
            layer2ud(C(i).h,c);
         else
            C(i).h=cardplot(c.x,c.y,c.size,c.value,c.suit);
            layer2ud(C(i).h,c);
         end
      end
   end
end
if nargout
   C_=reshape(C,dim);
end


function layer2ud(h,c)
%append current layer to userdata of first plot object of card
ud=get(h(1),'userdata');
ud{3}(6)=c.layer;
set(h(1),'userdata',ud);