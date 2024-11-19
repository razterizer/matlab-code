function c=hide(c)
%HIDE   Hide card(s).
%   C = HIDE(C) hides a card so that its value and suit
%   cannot be seen by the user from the standard output
%   and it will appear invisible when plotted
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
%   See also CARD/ISVISIBLE, CARD/SHOW, CARD/FLIP.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,1,nargin))

for i=1:length(c(:))
   c(i).vis=0;
end