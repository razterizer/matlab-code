function textmat(A,format,prec,exp,brack,file)
%TEXMAT  Creates an LaTeX matrix.
%   TEXMAT(A[,FORMAT[,PREC[,EXP[,BRACK[,FILE]]]])
%   creates a tex-file for use with LaTeX.
%   Variable A is the matrix to be LaTeX:ed.
%   FORMAT decides the format of the values in the matrix:
%      1 : FLOAT (default)
%      2 : INTEGER
%      3 : COMPLEX FLOAT
%      4 : COMPLEX INTEGER
%   where modes 2,4 truncates the values to integers.
%   Parameter PREC is the precision or number of digits of
%   precision, defaults to -1 which means that enables automatic
%   choice of precision (see NUM2STR).
%   EXP is the type of exponent used:
%      'e', 'E' or '10',
%   where '10' is the default value.
%   BRACK is the type of brackets on each side of the matrix.
%   It must be a string of two characters length.
%   A dot represents an abcense of a bracket. Brackets to use are:
%      ( ) [ ] { } < >
%   BRACK defaults to '()'.
%   FILE is the filename and defaults to "out.tex".
%   The main tex-file could look approximately like this:
%
%     \documentclass{article}
%     \begin{document}
%       \begin{equation}
%         \input{test.tex}
%       \end{equation}
%     \end{document}
%
%   See also TEXPIC, TEXTAB.

% Copyright (c) 2002-09-24, B. Rasmus Anthin.
% Revision: 2002-09-25, B. Rasmus Anthin.

error(nargchk(1,6,nargin))
if nargin<6
   file='out';
end
if nargin<5 | isempty(brack)
   brack='()';
end
if nargin<4 | isempty(exp)
   exp='10';
end
if nargin<3 | isempty(prec)
   prec=-1;   %-1
end
if nargin<2 | isempty(format)
   format=1;
end
if ~any(file=='.')
   file=[file '.tex'];
end

fp=fopen(file,'w');
%fprintf(fp,'%%This file was generated by TeXmat v.2 for MATLAB.\n');
%fprintf(fp,'%%Copyright (c) 2002-08-24, B. Rasmus Anthin.\n\n');

nr=size(A,1);
nc=size(A,2);
br1=strrep(brack(1),'{','\\{');
br2=strrep(brack(2),'}','\\}');

fprintf(fp,['\\left' br1 '\n']);
fprintf(fp,'\\begin{array}{');
for i=1:nc
   switch(format)
   case 1, fprintf(fp,'r@{.}l');
   case 2, fprintf(fp,'r@{}c');
   case 3, fprintf(fp,'r@{\\,}c@{\\,}l');
   case 4, fprintf(fp,'r@{}c@{}l');
   end
end
fprintf(fp,'}\n');

for i=1:nr
   for j=1:nc
      num=A(i,j);
      str=texgennum(num,format,prec);
      switch(format)
      case 1
         estr=texgenexp(str,exp);
         cell=[str.msgn str.m1 '&' str.m2 estr];
      case 2
         cell=[str.sgn '&' str.num];
      case 3
         estr1=texgenexp(str{1},exp);
         estr2=texgenexp(str{2},exp);
         dot1='';dot2='';
         if real(num), dot1='.';end
         if imag(num), dot2='.';end
         mstr1=[str{1}.msgn [str{1}.m1 dot1 str{1}.m2]];
         mstr2=[str{2}.m1 dot2 str{2}.m2];
         csgn=str{2}.msgn;
         if isempty(csgn), csgn='+';end
         cell=[mstr1 estr1 '&' csgn '&' mstr2 estr2 'i'];
      case 4
         num1=[str{1}.sgn str{1}.num];
         num2=str{2}.num;
         csgn=str{2}.sgn;
         if isempty(csgn), csgn='+';end
         cell=[num1 '&' csgn '&' num2 'i'];
      end
      if j==1
         fprintf(fp,cell);
      else
         fprintf(fp,[' & ' cell]);
      end
   end
   if i<nr
      fprintf(fp,' \\\\\n');
   else
      fprintf(fp,'\n');
   end
end
fprintf(fp,'\\end{array}\n');
fprintf(fp,['\\right' br2]);

fclose(fp);