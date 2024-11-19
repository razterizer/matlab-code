function str=texgennum(num,format,prec)
% 1 : float
%    str.msgn  = mantissa sign
%    str.m1    = digit before decimal
%    str.m2    = digits after decimal including dot
%    str.esgn  = exponent sign
%    str.e     = exponent
%
% 2 : integer
%    str.sgn   = sign
%    str.num   = number
%
% 3 : complex float
%    str{1,2}.<float>
%
% 4 : complex integer
%    str{1,2}.<integer>
%

error(nargchk(1,3,nargin))
if nargin<2 | isempty(format)
   format=1;
end
if nargin<3
   prec=-1;
end

int=~mod(format,2);
switch format
case {1,2}
   str=getnumstr(num,int,prec);
case {3,4}
   str{1}=getnumstr(real(num),int,prec);
   str{2}=getnumstr(imag(num),int,prec);
end



function str=getnumstr(num,int,prec)
switch int
case 0   %--------------- FLOAT
   str.msgn='';
   if num<0, str.msgn='-';end
   num=abs(num);
   if num
      [m e]=split(num);
      mstr=num2str(m,prec);
      if m==floor(m) & ~e
         str.m1=mstr;
         str.m2='0';
         str.esgn='';
         str.e='';
      else
         str.m1=mstr(1);
         str.m2=mstr(3:end);
         if isempty(str.m2), str.m2='0';end
         str.esgn='+';
         if e<0, str.esgn='-';end
         str.e=int2str(abs(e));
         if ~e
            str.esgn='';
            str.e='';
         end
      end
   else
      str.m1='0';
      str.m2='';
      str.esgn='';
      str.e='';
   end
case 1   %--------------- INTEGER
   str.sgn='';
   if num<0, str.sgn='-';end
   str.num=int2str(abs(num));
end