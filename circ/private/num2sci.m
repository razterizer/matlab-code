function [y,p]=num2sci(x,n)
%NUM2SCI  Convert number to scientific format.
%   S = NUM2SCI(X) converts the number X into a string representation S
%   with about 4 digits and a prefix if required. This is useful for
%   labeling plots with the TITLE, XLABEL, YLABEL, and TEXT commands.
%
%   S = NUM2SCI(X,N) converts the number X into a string representation
%   with a maximum N digits of precision.
%
%   [S,P] = NUM2SCI(X,N) where S is the string corresponding to the number
%   and P is the corresponding prefix.
%
%   The prefixes used are the following:
%
%      Prefix Exponent      Prefix Exponent
%      ---------------      ---------------
%        y      -24           Y       24
%        z      -21           Z       21
%        a      -18           E       18
%        f      -15           P       15
%        p      -12           T       12
%        n      -9            G       9
%        u      -6            M       6
%        m      -3            k       3
%
%   See also NUM2STR.

% Copyright (c) 2001-11-28, B. Rasmus Anthin.
% Revision 2003-08-31.

step=3;

pfix='yzafpnum kMGTPEZY';
f=(1+5*step*eps);
if ~isnan(x) & x
   e=floor(log10(abs(x*f)));
else
   e=0;
end
t=e-mod(e,step);
if -8*step<=t & t<9*step
   if nargin<2 | isempty(n) | n<0
      y=num2str(x/10^t);
   else
      y=num2str(x/10^t,n);
   end
   p=pfix((9*step+t)/step);
   if p==' ',p='';end
   if nargout<2
      y=[y ' ' p];
   end
else
   if nargin<2 | isempty(n) | n<0
      y=num2str(x);
   else
      y=num2str(x,n);
   end
   p='';
end
