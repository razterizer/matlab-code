function varargout=deselect(c,h)
%DESELECT   Deselects a selected card.
%   C = DESELECT(C)  or
%   [C,X,Y] = DESELECT(C) lets the user interactively put a selected
%   card on the table. Prior to usage, the SELECT command should be
%   issued which selects a card from a shoe (vector or matrix of cards)
%   from the table and makes it invisible, at the same time altering
%   the mouse pointer which will look like the picked card. The mouse
%   click will determine the card's new position X and Y (centre of card).
%   The returned card C will be the same as the selected hidden input card
%   C but will be set to visible. When the card is positioned, the mouse
%   pointer will be reverted to its normal look.
%
%   [X,Y] = DESELECT(C) is the same as the above but enables the user to
%   manually position the card given the mouse click position (X,Y).
%   The selected hidden card must then be manually set to visible by
%   invoking the SHOW command. Also here, the mouse pointer will return
%   to normal after this command has terminated.
%
%   [...] = DESELECT(C,AXH)  uses the table in axes AXH.
%   
%   Examples:
%     table([5 10])
%     d = deck;
%     d = plot(d);
%     c = select(d);           %click to pick a card
%     c = deselect(c);         %click again to place the card
%     d(d==c) = c;             %update deck with the repositioned card
%                              %continue with same deck
%     c = select(d);           %select another card
%     [x,y] = deselect(c);     %leave selection mode and retrieve coords
%     c = position(c,x,y-csize(c));  %click on upper left corner of card
%     c = show(c);             %make card visible
%     d(d==c) = plot(c);       %update deck and view
%
%   See also CARD/SELECT, CARD/POSITION, CARD/SHOW, CARD/PLOT.

% Copyright(c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,2,nargin))

if nargin==1
   shg
else
   axes(h)
end
if length(c)>1
   error('Cannot deselect more than one card.')
end

waitforbuttonpress
set(gcf,'pointer','arrow')
pos=get(gca,'currentpoint');
x=pos(1,1,1);
y=pos(1,2,1);

if nargout==1 | nargout==3
   [x0,y0,x1,y1]=position(c);
   c.x=x-(x1-x0)/2;
   c.y=y-(y1-y0)/2;
   c=show(c);
   c=plot(c);
   
   varargout{1}=c;
   if nargout==3
      varargout{2}=x;
      varargout{3}=y;
   end
end
if nargout==2
   varargout{1}=x;
   varargout{2}=y;
end