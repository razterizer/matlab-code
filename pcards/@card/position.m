function [x0,y0,x1,y1]=position(C,x,y)
%POSITION   Change or display positions of cards.
%   POSITION(C) displays the lower left corner positions of the cards on
%   the standard output, given the dimension of the card matrix is less
%   than 3.
%
%   [X0,Y0,X1,Y1] = POSITION(C) returns the lower left corner positions
%   (X0,Y0) and the upper right corner positions of the cards C.
%
%   C = POSITION(C,X[,Y]) positions the cards at the coordinate(s) X and Y.
%   X and Y can either be scalar (sets the same position on all cards in the
%   matrix) or be matrices with the same dimensions as the card pack
%   (matrix) C. X and Y are the positions of the lower left corner of the
%   cards C. The output is the card matrix with the updated positions.
%
%   See also CARD, CARD/LAYOUT, CARD/PLOT, CARD/SELECT.

% Copyright (c) 2005-06-12, B. Rasmus Anthin.

error(nargchk(1,3,nargin))
load aspect

if nargin>1
   for i=1:length(C(:))
      if prod(size(x))==1
         C(i).x=x;
      elseif isequal(size(x),size(C))
         C(i).x=x(i);
      else
         error('Matrix dimensions must agree.')
      end
      if nargin==3
         if prod(size(y))==1
            C(i).y=y;
         elseif isequal(size(y),size(C))
            C(i).y=y(i);
         else
            error('Matrix dimensions must agree.')
         end
      end
   end
   x0=C;
else
   if ~nargout & length(size(C))==2
      sp=blanks(5);
      %fprintf(['\n' sp 'Positions:\n'])
      %fprintf([sp '----------\n'])
      fprintf \n
      for i=1:size(C,1)
         fprintf(blanks(4))
         for j=1:size(C,2)
            back=0;
            str=[sprintf('%.3g',C(i,j).x) ',' sprintf('%.3g',C(i,j).y)];
            if j<size(C,2)
               str=fixstrlen(str,14);
            end
            fprintf(str)
         end
         fprintf \n\n
      end
   else
      for i=1:length(C(:))
         x0(i)=C(i).x;
         y0(i)=C(i).y;
         x1(i)=C(i).x+C(i).size*aspect;
         y1(i)=C(i).y+C(i).size;
      end
      x0=reshape(x0,size(C));
      y0=reshape(y0,size(C));
      x1=reshape(x1,size(C));
      y1=reshape(y1,size(C));
   end
end