function y=layout(x,dir,x0,y0,xstep,ystep)
%LAYOUT   A layout manager for the card class.
%   C = LAYOUT(C,DIR,X0,Y0,XSTEP,YSTEP) creates a layout for the cards C.
%
%   DIR tells in which order the cards should be dealt. The following
%   values can be choosen from:
%      0 or 'u' or 'up'
%      1 or 'd' or 'down'
%      2 or 'l' or 'left'
%      3 or 'r' or 'right'
%      4 or 'ru' or 'right-up'
%      5 or 'ul' or 'up-left'
%      6 or 'ld' or 'left-down'
%      7 or 'dr' or 'down-right'
%      8 or 'rd' or 'right-down'
%      9 or 'dl' or 'down-left'
%     10 or 'lu' or 'left-up'
%     11 or 'ur' or 'up-right'
%     -1 or 'rnd' or 'rand' or 'random'
%
%   The layout is performed in such a way that the appearence of the
%   cards on the table (when plotted) match the order in which the cards
%   appear in the matrix.
%
%   In order to be able to change the appearance of a matrix of cards
%   properly when having used this method, the cards have to be removed
%   from the table by invoking the DELETE function, otherwise the cards
%   positions may only be altered by this method but the layer changes
%   will not take any effect. See the examples below.
%
%   X0 and Y0 is position of the bottom leftmost card's lower left corner.
%
%   XSTEP and YSTEP determines the edge-to-edge offset between the cards
%   in units of the size of the card (given by CSIZE) in each direction
%   such that XSTEP = 0.6 means that the cards in one row are overlapping
%   each other by 40%, the same holds true for YSTEP = .6 but along
%   the rows. Values greater than 1 means the card will be fully separated.
%   If set to zero, this means that the card overlap each other completely
%   (i.e. they are stacked on top of each other). XSTEP works towards the
%   right and YSTEP works in the upward direction.
%   By setting XSTEP = -1 and/or YSTEP = -1 means the offsets are
%   uniformly randomized for each card around X0 and Y0.
%
%   Examples:
%     c = cards(4,3);
%     c(1,3) = hide(c(1,3));
%     c = layout(c,'right-up',1,.5,.6,.8)
%     layer(c)
%     table([5 5])
%     c = plot(c);
%     pause
%     c = layout(c,'rnd',1,.5,.6,.8);
%     layer(c)
%     c = delete(c);   %for new cardlayers to be shown properly
%     c = plot(c);
%     pause
%     c = delete(c);
%     c = rcard(4,5)
%     c = layout(c,-1,2.5,2.5,-1,-1);
%     c = plot(c);
%
%   See also CARD, CARDS, RCARD, DECK, CARD/LAYER, CARD/POSITION, CARD/CSIZE, CARD/DELETE, CARD/PLOT.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(6,6,nargin))
load aspect

[m n]=size(x);
y=x;
[foo ir]=sort(rand(1,m*n));      %randperm, sort of
if ischar(dir), dir=lower(dir);end
for i=1:m
   for j=1:n
      if xstep<0
         y(i,j).x=x0+n*(.5-rand)*aspect*y(i,j).size;
      else
         y(i,j).x=x0+(j-1)*aspect*y(i,j).size*xstep;
      end
      if ystep<0
         y(i,j).y=y0+m*(.5-rand)*y(i,j).size;
      else
         y(i,j).y=y0+(m-i)*y(i,j).size*ystep;
      end
      switch(dir)
      case {0,'u','up'}
         y(i,j).layer=m-i;
      case {1,'d','down'}
         y(i,j).layer=i-1;
      case {2,'l','left'}
         y(i,j).layer=n-j;
      case {3,'r','right'}
         y(i,j).layer=j-1;
      case {4,'ru','right-up'}
         y(i,j).layer=n*(m-i)+j-1;
      case {5,'ul','up-left'}
         y(i,j).layer=m*(n-j)+m-i;
      case {6,'ld','left-down'}
         y(i,j).layer=n*(i-1)+n-j;
      case {7,'dr','down-right'}
         y(i,j).layer=m*(j-1)+i-1;
      case {8,'rd','right-down'}
         y(i,j).layer=n*(i-1)+j-1;
      case {9,'dl','down-left'}
         y(i,j).layer=m*(n-j)+i-1;
      case {10,'lu','left-up'}
         y(i,j).layer=n*(m-i)+n-j;
      case {11,'ur','up-right'}
         y(i,j).layer=m*(j-1)+m-i;
      case {-1,'rnd','rand','random'}
         y(i,j).layer=ir(sub2ind([m n],i,j))-1;
      otherwise
         error('Unkwown layout direction.')
      end
   end
end