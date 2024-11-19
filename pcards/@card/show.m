function c=show(c)
%SHOW   Show card(s).
%   C = SHOW(C) shows a card so that its value and suit
%   can yet be seen by the user from the standard output
%   and it will appear visible when plotted.
%   SHOW sets the vis property of the card(s) to 1.
%
%   Example:
%     c = card('j','s')
%     table([5 3])
%     c = plot(c);
%     pause
%     c = hide(c)      %hide card
%     c = plot(c);     %update view
%     pause
%     c = show(c)      %show card again
%     c = plot(c);     %update view
%
%   See also CARD/ISVISIBLE, CARD/HIDE, CARD/FLIP.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   c(i).vis=1;
end