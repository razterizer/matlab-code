function disp(C)
%DISP   Display card objects.
%   DISP(C) displays the card(s) C, without printing the card(s)' name.
%   Refer to CARD/DISPLAY for more information.
%
%   See also CARD/DISPLAY, FORMAT, CARD.

% Copyright (c) 2005-06-09, B. Rasmus Anthin.
% Revision: 2005-06-16.

val={'A' '2' '3' '4' '5' '6' '7' '8' '9' '01' 'J' 'Q' 'K'};
val=fliplr(char(val));

spc=strcmp(get(0,'formatspacing'),'loose');

if spc, fprintf \n,end               %loose spacing
if length(C(:))==1
   fprintf([blanks(5) 'Card:\n'])
else
   fprintf([blanks(5) 'Cards:\n'])
end
for i=1:size(C,1)
   for j=1:size(C,2)
      switch(get(0,'format'))
      case 'short'
         fprintf(blanks(4))
         if C(i,j).vis
            if C(i,j).up
               if ~isnan(C(i,j).value)
                  fprintf([val(C(i,j).value,:) upper(C(i,j).suit)])
               else
                  fprintf(' **')    %Joker
               end
            else
               fprintf(' --')    %Face down
            end
         else
            fprintf('   ')    %Hidden
         end
         
      case 'long'
         fprintf(blanks(5))
         if C(i,j).vis
            if C(i,j).up
               if ~isnan(C(i,j).value)
                  switch(C(i,j).value)
                  case 1
                     vstr='Ace';
                  case {2,3,4,5,6,7,8,9,10}
                     vstr=int2str(C(i,j).value);
                  case 11
                     vstr='Jack';
                  case 12
                     vstr='Queen';
                  case 13
                     vstr='King';
                  otherwise
                     vstr='';
                  end
                  switch(C(i,j).suit)
                  case 'c'
                     sstr='Clubs';
                  case 'd'
                     sstr='Diamonds';
                  case 'h'
                     sstr='Hearts';
                  case 's'
                     sstr='Spades';
                  otherwise
                     sstr='';
                  end
                  fprintf(fixstrlen([vstr ' of ' sstr],17))
               else
                  fprintf([repmat('*',1,5) ' Joker ' repmat('*',1,5)])    %Joker
               end
            else
               fprintf(repmat('-',1,17))    %Face down
            end
         else
            fprintf(blanks(17))    %Hidden
         end
         
      case 'shortE'
         fprintf(blanks(5))
         if C(i,j).vis
            if C(i,j).up
               if ~isnan(C(i,j).value)
                  switch(C(i,j).value)
                  case 1
                     vstr='Ace';
                  case {2,3,4,5,6,7,8,9,10}
                     vstr=int2str(C(i,j).value);
                  case 11
                     vstr='Jack';
                  case 12
                     vstr='Queen';
                  case 13
                     vstr='King';
                  otherwise
                     vstr='';
                  end
                  fprintf(strjust(fixstrlen([vstr ' of ' upper(C(i,j).suit)],10)))
               else
                  %fprintf(repmat('*',1,10))    %Joker
                  fprintf([' * Joker *'])
               end
            else
               fprintf(repmat('-',1,10))    %Face down
            end
         else
            fprintf(blanks(10))    %Hidden
         end
         
      case 'longE'
         fprintf(blanks(5))
         if C(i,j).vis
            if C(i,j).up
               if ~isnan(C(i,j).value)
                  switch(C(i,j).value)
                  case 1
                     vstr='Ace';
                  case 2
                     vstr='Two';
                  case 3
                     vstr='Three';
                  case 4
                     vstr='Four';
                  case 5
                     vstr='Five';
                  case 6
                     vstr='Six';
                  case 7
                     vstr='Seven';
                  case 8
                     vstr='Eight';
                  case 9
                     vstr='Nine';
                  case 10
                     vstr='Ten';
                  case 11
                     vstr='Jack';
                  case 12
                     vstr='Queen';
                  case 13
                     vstr='King';
                  otherwise
                     vstr='';
                  end
                  switch(C(i,j).suit)
                  case 'c'
                     sstr='Clubs';
                  case 'd'
                     sstr='Diamonds';
                  case 'h'
                     sstr='Hearts';
                  case 's'
                     sstr='Spades';
                  otherwise
                     sstr='';
                  end
                  fprintf(fixstrlen([vstr ' of ' sstr],17))
               else
                  fprintf([repmat('*',1,5) ' Joker ' repmat('*',1,5)])    %Joker
               end
            else
               fprintf(repmat('-',1,17))    %Face down
            end
         else
            fprintf(blanks(17))    %Hidden
         end
      end
   end
   fprintf \n
   if spc, fprintf \n,end               %loose spacing
end