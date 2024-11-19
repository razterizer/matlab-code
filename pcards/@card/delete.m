function c=delete(c)
%DELETE   Removes card graphics from game table (figure).
%   C = DELETE(C) deletes the graphics representation of the card(s) C
%   from the current table (figure). Do not use this when updating a
%   card's (or several cards) value, suit and position etc, but only
%   use it when you need to clear the table from card(s). If you wish
%   to temporarily hide cards, use the HIDE function to hide the card(s)
%   and plot the card(s) again.
%
%   Example:
%     c = card('k','d',1,1,0,0,1)    %create card
%     table([7 5])                   %create a 5x5 table
%     c = plot(c);                   %plot the card
%     pause
%     c = delete(c);                 %remove card
%
%   See also CARD/TABLE, CARD/PLOT, CARD/HIDE, CARD/SHOW.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

if ~nargout, error('Must assign output to the same card(s).'), end

for i=1:length(c(:))
   if ~isempty(get(0,'child'))   %check if there is any figure active
      h=get(gca,'child');        %get current figure's (the card table) axis
      if any(h==c(i).h(1))       %if the children of the (table's) axis contains the card
         delete(c(i).h)          %delete it
      end
   end
   c(i).h=[];                    %clear handles
end