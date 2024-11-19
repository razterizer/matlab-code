%SNAILRACE  Bet on racing snails.
%   Bet on a snail that you fancy,
%   then press a key to watch the race and
%   see which snail that won the race.
%   (There is no input for this game.)
%
%   Next version will enable to input money to wager
%   for a specific snail that you want to bet on.
%   Also, it will feature the possibility of buying a
%   snail and train it or just to study the trend of
%   physical improvement for a specific snail (others
%   train it).
%
%   This is a very simple game yet so far, and is an
%   example on how to make a simple game in matlab.
%   It's not very addictive though. But might come in handy
%   when you're bored.

% Copyright (c) 2003-08-10, B. Rasmus Anthin.
% Revision 2003-09-23.

goal=10;
snails=10;
x=zeros(snails,1);
x0=x;
y=(1:snails)';
ax=[0 goal 0 snails+1];
w=abs(randn(snails,1))*.01+1;
fprintf('\n  The odds:\n\n')
for i=1:snails
   n=num2str(i);
   if i<10, n=[' ' n];end
   odds=sprintf('%.2f',w(i)/sum(w)*100);
   if w(i)/sum(w)<10, odds=[' ' odds];end
   fprintf([' '  n ' : ' odds '%%\n'])
end
pause
while all(x<goal)
   x=x+w.*rand(snails,1)*.15;
   plot([x0 x]',[y y]',x,y,'>','markerface','b','markeredge','b')
   axis(ax)
   axis ij
   drawnow
end
winner=find(x==max(x));
winner=winner(1);          %not really necessary :-)
fprintf(['\n\n  And the winner is snail ' num2str(winner) '!\n\n'])