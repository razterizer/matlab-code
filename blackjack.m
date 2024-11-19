function blackjack(action)
%BLACKJACK  A Blackjack game for Matlab.
%   This is a very basic (head-on) Blackjack game with six decks of cards.
%   The player is not able to split or to surrender in this game.
%   (Splitting will probably be available in next version).
%
%   First thing you will do is to chose how much you wan't to wager by clicking
%   on the chips repeatedly (to bet 11$ click on 1 once and
%   twice on 5 for example). You can reset your bet to zero
%   by clicking the "Reset" button. To accept your bet just click on "Ok".
%   To quit the game, click "Quit".
%   The card count value in the chip selection window shows the true count (running
%   count / remaining decks) and the running count in parantheses. The running count
%   uses a balanced counting system where 2-6 is +1, 7-9 is 0 and 10-A is -1.
%   You should bet high on high and positive count values and low on negative
%   and zero count values.
%
%   Next you click on "hit" till you're satisfied or click on "stand" if you're
%   satisfied with your hand. When the round is over you will be asked to click
%   with the mouse anywhere in the figure.
%   As you start the new round, on the wager dialog the previous bet will be
%   recalled. So to bet the same as the previous round, simply click on "Ok".
%
%   The blackjack program is recursive in that each button calls the blackjack
%   with a string argument corresponding to the function of that button. This enables
%   the blackjack program to remain passive till a button is pressed. The downside with
%   such an approach is that it is hard to get a good overview of what happens in
%   the code (at least IMO). Hence, there can be a number of bugs that I have currently
%   overlooked. I'm sure that the program can be simplified quite a lot, but I haven't
%   got the time to fiddle with it that much. If you have any suggestions for
%   code improvements and such, then let me now.
%
%   This game requires the CARD class.
%
%   See also CARD, CARDPLOT.

% Copyright (c) 2003-08-10, B. Rasmus Anthin.
% Revision: 2003-08-11 - 2003-08-14, 2005-06-10, 2005-07-02.

if ~nargin
   action='init';
end

switch(action)
case 'init'
   %initialize some global variables (since we use callbacks).
   global handle chips dealer player CONST status
   
   CONST.N=6;                   %number of decks
   CONST.cs=1;                  %card size
   CONST.val=[1:9 10 10 10 10]; %card values
   CONST.weight=[-1 1 1 1 1 1 0 0 0 -1 -1 -1 -1]; %card counting weights
   CONST.delay=.5;
   handle.main=[];
   player.bet=0;
   player.money=50;
   player.rcount=0;
   player.count=0;
   player.quit=0;
   dealer.shoe=zeros(4*CONST.N,13);
   %  1 - 13
   %c
   %d
   %h   DECK 1
   %s
   %
   %c
   %d
   %h   DECK 2
   %s


   
   blackjack play
   
case 'play'
   global handle chips dealer player CONST status
   
   player.x=3;          %card horizontal position (you)
   dealer.x=3;          %card horizontal position (dealer)
   player.pt=0;         %your points
   dealer.pt=0;         %dealer's points
   player.hand=[];      %your hand
   dealer.hand=[];      %dealer's hand
   dealer.down=[];      %dealer's down card
   player.pt1=0;
   player.pt2=0;
   
   if ~isempty(handle.main)
      checkmoney('up')
      checkmoney('down')
      set(handle.tit,'string',status)
      set(handle.money,'string',[num2str(player.money) '$'])
      set(handle.bet,'string','bet : 0$')
      xlabel('Click to proceed!')
      waitforbuttonpress
   end
   createboard;
   status='Place a bet...';
   set(handle.tit,'string',status)
   
   %Place a bet
   selectchips
   if player.quit
      delete(gcf)
      return
   end
   player.bet=chips.bet;       %memorize this wager till next time
   player.money=player.money-player.bet;
   figure(handle.main)   %SHG works as well
   set(handle.money,'string',[num2str(player.money) '$'])
   set(handle.bet,'string',['bet : ' num2str(player.bet) '$'])
   
   %Deal
   cardhit('player')
   cardhit('dealer')
   cardhit('player')
   cardhit('dealer','down')
   set(handle.hit,'enable','off')
   set(handle.stand,'enable','off')
   
   %INSURANCE
   if dealer.pt==11 & player.money>=player.bet/2
      blackjack insurancebet
   elseif dealer.pt==11   %cannot insure
      blackjack noinsure
   end
   if player.pt==21   %you've got blackjack
      flipcard
      if dealer.pt==21        %dealer too
         status='Push! (BlackJack)';
         player.money=player.money+player.bet;
      else
         status='You win! (BlackJack)';
         player.money=player.money+(1+3/2)*player.bet;
      end
      countcards
      blackjack play
      return
   end
   
   %HIT/STAND/DOUBLE
   set(handle.hit,'enable','on')
   set(handle.stand,'enable','on')
   if player.money>=player.bet
      set(handle.double,'visible','on')
   end
   status='Choose action...';
   set(handle.tit,'string',status);
   set(handle.money,'string',[num2str(player.money) '$'])
   
case 'insurancebet'
   global handle
   status='Insurance?';
   set(handle.hit,'enable','off')
   set(handle.stand,'enable','off')
   set(handle.insure,'visible','on')
   set(handle.noinsure,'visible','on')
   set(handle.double,'visible','off')
   waitforbuttonpress
   
case 'hit'
   global handle chips dealer player CS status
   
   set(handle.hit,'enable','off')
   set(handle.stand,'enable','off')
   set(handle.double,'visible','off')

   
   cardhit('player')
   
   if player.pt>21
      status='You lose! (Busted)';
      flipcard
      countcards
      blackjack play
      return
   else
      set(handle.hit,'enable','on')
      set(handle.stand,'enable','on')
   end
   set(handle.tit,'string',status)
   set(handle.money,'string',[num2str(player.money) '$'])
   set(handle.bet,'string',['bet : ' num2str(player.bet) '$'])
   
case 'stand'
   global handle chips dealer player CONST status
   
   set(handle.hit,'enable','off')
   set(handle.stand,'enable','off')
   set(handle.double,'visible','off')
    
   flipcard
   
   if dealer.pt==21
      status='Dealer wins! (BlackJack)';
      countcards
      blackjack play
      return
   end
     
   
   %dealer gets cards
   while dealer.pt<17
      cardhit('dealer')
   end
   
   if dealer.pt>21
      status='You win! (Dealer busted)';
      player.money=player.money+2*player.bet;
   elseif player.pt>dealer.pt
      status='You win!';
      player.money=player.money+2*player.bet;
   elseif dealer.pt==player.pt
      status='Push!';
      player.money=player.money+player.bet;
   else
      status='Dealer wins!';
   end
   
   countcards
   checkmoney('up')
   checkmoney('down')
   if player.quit
      delete(gcf)
      return
   end
   blackjack play
   return
   
case 'insure'
   global handle chips dealer player CONST status
   
   set(handle.noinsure,'visible','off')
   
   player.ibet=player.bet/2;
   player.money=player.money-player.ibet;
   set(handle.money,'string',[num2str(player.money) '$'])
   set(handle.bet,'string',['bet : ' num2str(player.bet+player.ibet) '$'])
   
   dealer.ipt=sum(dealer.hand,CONST.val,'d');
   if dealer.ipt==21
      flipcard
      player.money=player.money+2*player.ibet;
      if player.pt==21
         status='Push! (BlackJack)';
         player.money=player.money+player.bet;
      else
         status='Dealer wins! (Blackjack)';
      end
      checkmoney('up')
      checkmoney('down')
      if player.quit
         delete(gcf)
         return
      end
      countcards
      blackjack play
      return
   end

   set(handle.insure,'visible','off')
   
case 'noinsure'
   global handle chips dealer player CONST status
   
   set(handle.insure,'visible','off')
   
   dealer.ipt=sum(dealer.hand,CONST.val,'d');
   if dealer.ipt==21
      flipcard
      if player.pt==21
         status='Push! (BlackJack)';
         player.money=player.money+player.bet;
      else
         status='Dealer wins! (Blackjack)';
      end
      checkmoney('up')
      checkmoney('down')
      if player.quit
         delete(gcf)
         return
      end
      countcards
      blackjack play
      return
   end
   
   set(handle.noinsure','visible','off')
   
case 'double'
   global handle chips dealer player CONST status
   
   set(handle.hit,'enable','off')
   set(handle.stand,'enable','off')
      
   player.money=player.money-player.bet;
   player.bet=2*player.bet;
   set(handle.money,'string',[num2str(player.money) '$'])
   set(handle.bet,'string',['bet : ' num2str(player.bet) '$'])
   
   cardhit('player')
   flipcard
   if player.pt>21
      status='You lose! (Busted)';
      countcards
      blackjack play
      return
   elseif dealer.pt==21
      status='Dealer wins! (BlackJack)';
      countcards
      blackjack play
      return
   end
   
   while dealer.pt<17
      cardhit('dealer')
   end
   
   if dealer.pt>21
      status='You win! (Dealer busted)';
      player.money=player.money+2*player.bet;
   elseif dealer.pt>player.pt
      status='Dealer wins!';
   elseif dealer.pt==player.pt
      status='Push!';
      player.money=player.money+player.bet;
   else
      status='You win!';
      player.money=player.money+2*player.bet;
   end
   set(handle.double,'visible','off')
   checkmoney('up')
   checkmoney('down')
   if player.quit
      delete(gcf)
      return
   end
   countcards
   blackjack play
   return

   
end




%%%%%%%%%%%%%%%%%%%% functions %%%%%%%%%%%%%%%%%%%%%%

function cardhit(who,dir)
%dir=[{'up'} | 'down']
global handle chips dealer player CONST status
pause(CONST.delay)
if nargin<2
   dir='up';
end
vrand=ceil(rand*13);   %random card value
srand=ceil(rand*4);    %random card suit
drand=ceil(rand*CONST.N);    %random deck
shuffle
while ~dealer.shoe(srand+4*(drand-1),vrand) %if already used, select new card
   vrand=ceil(rand*13);
   srand=ceil(rand*4);
   drand=ceil(rand*CONST.N);
end
dealer.shoe(srand+4*(drand-1),vrand)=0;  %mark card as used
shuffle
%utilize the card class (for simplicity (..? (or so I thought)))
switch(who)
case {'player'}
   player.hand=[player.hand card(vrand,srand,1,CONST.cs,0,0,1)];
   player.hand=layout(player.hand,'r',3,0,.75,0);
   player.hand=plot(player.hand);
   player.pt=sum(player.hand,CONST.val);
   if any(value(player.hand)==1) & player.pt+10<=21
      player.pt=player.pt+10;
   end
   set(handle.you,'string',[blanks(4) 'you : ' num2str(player.pt)])
case {'dealer'}
   dealer.hand=[dealer.hand card(vrand,srand,1,CONST.cs,0,0,1)];
   dealer.hand=layout(dealer.hand,'r',3,5-CONST.cs,.75,0);
   if ~strcmp(dir,'up')
      dealer.hand(end)=dealer.hand(end)';
   end
   dealer.hand=plot(dealer.hand);
   dealer.pt=sum(dealer.hand,CONST.val);
   if ~isempty(dealer.hand) & any(value(dealer.hand)==1 & isup(dealer.hand)) & dealer.pt+10<=21
      dealer.pt=dealer.pt+10;
   end
   set(handle.comp,'string',['dealer : ' num2str(dealer.pt)])
end


function checkmoney(dir)
global handle player chips
if player.money<chips.val(1) & strcmp(dir,'down')
   errordlg('You have no more money left to wager!','Game Over!')
   waitforbuttonpress
   player.quit=1;
elseif player.money>10e3 & strcmp(dir,'up')
   errordlg({'Congratulations!','You broke the bank!'},'Casino urgent message')
   waitforbuttonpress
   player.quit=1;
end


function shuffle
global handle dealer CONST
%if sum(dealer.shoe(:))<17          %can only be a maximum of 17 cards in one round: [1,1,1,1,2,2,2,2,3,3,3] [3,4,4,4,4,5]
if sum(dealer.shoe(:))==0
   player.rcount=0;
   player.count=0;
   dealer.shoe=ones(4*CONST.N,13);
   if isfield(dealer,'hand') & ~isempty(dealer.hand)
      dealer.shoe(suit(dealer.hand),value(dealer.hand))=0;
   end
   if isfield(player,'hand') & ~isempty(player.hand)
      dealer.shoe(suit(player.hand),value(player.hand))=0;
   end
   status='Shuffling cards...';
   set(handle.tit,'string',status)
   h=dialog('menubar','none','numbertitle','off','name','','handlevis','on');
   pos=get(handle.main,'pos');
   set(h,'pos',[pos(1)+pos(3)/2-150 pos(2)+pos(4)/2-50 300 100])
   uicontrol('style','text','string',status,'backgroundcolor',get(h,'color'),'pos',[0 30 300 50],'fontsize',30)
   pause(1)
   delete(h)
   figure(handle.main)
end


function flipcard
global handle dealer player CONST
pause(CONST.delay)
dealer.hand(~isup(dealer.hand))=flip(dealer.hand(~isup(dealer.hand)));
dealer.hand=plot(dealer.hand);
dealer.pt=sum(dealer.hand,CONST.val);
if ~isempty(dealer.hand) & any(value(dealer.hand)==1) & dealer.pt+10<=21
   dealer.pt=dealer.pt+10;
end
set(handle.comp,'string',['dealer : ' num2str(dealer.pt)])


function countcards
global dealer player CONST
hand=player.hand;
player.rcount=player.rcount+sum(hand,CONST.weight)+sum(dealer.hand,CONST.weight);
player.count=player.rcount*52/sum(dealer.shoe(:));


function createboard
global handle dealer player status
delete(gca)
handle.main=gcf;
set(gcf,'name','Blackjack 5.1','menubar','none','numbertitle','off')
pos=get(gcf,'pos');
scr=get(0,'screensize');
set(gcf,'pos',[scr(3:4)*.1 760 520])
set(gcf,'deletefcn','clear global')
table([10 5])                    %create the board.
handle.hit=uicontrol('style','push','string','Hit','callback','blackjack(''hit'')');
handle.stand=uicontrol('style','push','string','Stand','pos',[100 20 60 20],'callback','blackjack(''stand'')');
handle.noinsure=uicontrol('style','push','string','Play','pos',[180 30 60 20],'callback','blackjack(''noinsure'')','visible','off');
handle.insure=uicontrol('style','push','string','Insure','pos',[180 10 60 20],'callback','blackjack(''insure'')','visible','off');
handle.double=uicontrol('style','push','string','Double','pos',[260 20 60 20],'callback','blackjack(''double'')','visible','off');
handle.comp=uicontrol('style','text','string',['dealer : ' num2str(dealer.pt)],'pos',[480 30 60 20],'horiz','l','backgroundcolor',get(gcf,'color'));
handle.you=uicontrol('style','text','string',[blanks(4) 'you : ' num2str(player.pt)],'pos',[480 10 60 20],'horiz','l','backgroundcolor',get(gcf,'color'));
handle.money=uicontrol('style','text','string',[num2str(player.money) '$'],'pos',[600 20 150 20],'horiz','r','backgroundcolor',get(gcf,'color'));
handle.bet=uicontrol('style','text','pos',[600 0 150 20],'horiz','r','backgroundcolor',get(gcf,'color'));
handle.t(1)=text(5,5,'Dealer','fontsize',40,'color',[0 .65 0],'horiz','c','vert','t');
handle.t(2)=text(5,0,'You','fontsize',40,'color',[0 .65 0],'horiz','c','vert','bo');
handle.tit=title('');

function selectchips
global handle chips player CONST
handle.betdlg=dialog('name','Select chips','handlevis','on','windowstyle','normal');
pos=get(handle.main,'pos');
set(handle.betdlg,'pos',[pos(1:2)+pos(3:4)/2-100 200 200])
chips.bet=player.bet;   %use previous bet
if chips.bet>player.money  %if wager too much
   chips.bet=player.money;
   if mod(chips.bet,chips.val(1)), chips.bet=chips.bet-chips.val(1)/2;end
end
axes('pos',[.05 .2 .8 .8])
t=linspace(0,2*pi);
hold on
chips.val=[1 5 25 100];
chips.col={[.9 .9 .9],'r','g','k'};
for i=1:4
   handle.chip(i)=patch(.5+cos(t)*.25,5-sin(t)*.25-i,chips.col{i});
   text(1,5-i,num2str(chips.val(i)),'horiz','l','vert','m')
   set(handle.chip(i),'buttondownfcn',['global handle player chips, chips.bet=chips.bet+chips.val(' num2str(i) ');' ...
         'if chips.bet>player.money,' ...
         '   chips.bet=player.money;' ...
         '   if mod(chips.bet,2), chips.bet=chips.bet-1;end,' ...
         '   warndlg(''Cannot exceed your bankroll!''),' ...
         'end,' ...
         'set(handle.cbet,''string'',[num2str(chips.bet) ''$''])']);
end
handle.count=text(0,.2,['card count : ' sprintf('%.2g',player.count) ' (' int2str(player.rcount) ')']);
handle.cbet=text(5,2,[num2str(chips.bet) '$'],'horiz','r','vert','m','buttondownfcn','global handle chips, chips.bet=chips.bet-1; set(handle.bet,''string'',[num2str(chips.bet) ''$''])');
axis equal off, axis([0 5 0 5])
uicontrol('style','push','string','Ok','pos',[10 10 40 20],'callback','uiresume,close')
uicontrol('style','push','string','Reset','pos',[80 10 40 20],'callback','global handle chips, chips.bet=0;set(handle.cbet,''string'',[num2str(chips.bet) ''$''])')
uicontrol('style','push','string','Quit','pos',[150 10 40 20],'callback','global player, player.quit=1; close, uiresume')
uiwait
