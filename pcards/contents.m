% Playing Cards Toolbox.
% Version 1.0 17-Jun-2005
%
% What's new.
%   readme_card.txt - New features, bug fixes, and changes in this version.
%
% Miscellaneous.
%   cardplot   - Plots cards (non-object).
%   solitaire  - A solitaire game template of sorts.
%
% Card creation.
%   card       - Card object constructor.
%   cards      - Card matrix.
%   deck       - 13x4 Standard card deck.
%   rcard      - Random card matrix.
%
% Card tests.
%   iscard     - True for card objects.
%   isjoker    - True for joker cards.
%   isup       - True for face up cards.
%   isvisible  - True for visible cards.
%
% Relational operators.
%   eq         - Equal values.                        ==
%   ne         - Not equal values.                    ~=
%   lt         - Less than for values.                 <
%   gt         - Greater than for values.              >
%   le         - Less than or equal for values.       <=
%   ge         - Greater than or equal for values.    >=
%
% Concatenation.
%   horzcat    - Horizontal concatenation.            [,]
%   vertcat    - Vertical concatenation.              [;]
%
% Card operations.
%   change     - Change value and suit.
%   ctranspose - Flip card.                         '
%   facedn     - Turn card face down.
%   faceup     - Turn card face up.
%   flip       - Flip card.
%   hide       - Hide card.
%   joker      - Change to joker cards.
%   show       - Show card.
%   suit       - Set or show suit.
%   value      - Set or show value.
%
% Card arithmetics.
%   sum        - Sum or "weighted" sum of values.
%   weight     - Weighting card values.
%
% Card plotting and display.
%   table      - Creates a card table.
%   delete     - Deletes plotted card objects from table.
%   deselect   - Pick a card with the mouse.
%   disp       - Display card objects.
%   display    - Standard output for card objects.
%   plot       - Plots cards on a table.
%   select     - Put down picked card.
%   slot       - Card stacking slot.
%
% Card layout.
%   csize      - Size of card.
%   cwidth     - Width of card.
%   layer      - Set or show card layer.
%   layout     - A layout manager.
%   position   - Set or show card position.
%   snap       - Snap cards to grid.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.
% Revision: 2005-06-16, 2005-06-17.
