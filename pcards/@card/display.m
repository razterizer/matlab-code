function display(C)
%DISPLAY   Display card objects.
%   Depending on the current display format the cards can be
%   displayed in short format, long format, "extended short" format or
%   "extended long" format.
%   The format is changed as usual using the FORMAT command.
%   If any other than the below listed formats are used, the card
%   display function will default to short format. The following list
%   shows how two cards, 7 of clubs and ace of spades,
%   are displayed in different formats:
%      FORMAT SHORT    : 7C               AS
%      FORMAT LONG     : 7 of Clubs       Ace of Spades
%      FORMAT SHORT E  : 7 of C           Ace of S
%      FORMAT LONG E   : Seven of Clubs   Ace of Spades
%
%   FORMAT LOOSE and FORMAT COMPACT also affects the output, in a way
%   similar to displaying numerical matrices.
%
%   Note that both short formats results in the texts being right
%   justified while both the long formats causes the texts to be
%   left justified.
%
%   See also CARD/DISP, FORMAT, CARD.

% Copyright (c) 2005-06-09, B. Rasmus Anthin.
% Revision: 2005-06-16.

val={'A' '2' '3' '4' '5' '6' '7' '8' '9' '01' 'J' 'Q' 'K'};
val=fliplr(char(val));

spc=strcmp(get(0,'formatspacing'),'loose');

if spc, fprintf \n,end               %loose spacing
fprintf([inputname(1) ' =\n'])
disp(C)