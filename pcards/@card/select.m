function y=select(x,h)
%SELECT   Interactively selects a card with the mouse.
%   C = SELECT(CS) enables the user to select a card C
%   from a pack or shoe (matrix) of cards CS that have been plotted
%   on a playing table by selecting it with the mouse.
%   The method waits for the user to click with the mouse on a card
%   located on the current card table. Once the card has been selected,
%   the card will be hidden on the table and the mouse pointer will have
%   the look of the selected card, and so the method terminates and
%   returns the selected hidden card. Useful utility for solitaire games
%   and the like.
%
%   C = SELECT(CS,AXH)  uses the table in axes AXH.
%
%   The SELECT method should be used in conjunction with its counterpart
%   DESELECT, which places the card on a location given by another mouse
%   click (or enables the programmer to do so). Furthermore, DESELECT
%   will turn the mouse pointer to normal.
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
%   See also CARD/DESELECT, CARD/POSITION, CARD/SHOW, CARD/PLOT.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-17.

error(nargchk(1,2,nargin))

if nargin==1
   shg
else
   axes(h)
end
I=0;
while 1
   waitforbuttonpress
   ud=get(gco,'userdata');
   if iscell(ud) & length(ud)==3 & ~isempty(ud{2})
      h=ud{2};
      for i=1:length(x(:))
         if ~isempty(x(i).h) & x(i).h(1)==h(1)
            I=i;
            break
         end
      end
      if I & isvisible(x(I))
         if ~isup(x(I))
            cardplot(0,x(I).suit)
         else
            cardplot(x(I).value,x(I).suit)
         end
         x(I)=hide(x(I));
         x(I)=plot(x(I));
         break
      end
   end
end
y=x(I);