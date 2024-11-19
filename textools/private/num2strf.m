function s=num2strf(x)
%NUM2STRF  same as NUM2STR but supresses powers.
%   NUM2STRF changes all numbers in power format - which
%   would be generated when using NUM2STR - into plain
%   numerical format. Eg:
%
%      NUM2STR(eps)   : 2.2204e-016
%      NUM2STRF(eps)  : 0.000000000000000222045
%
%      NUM2STR(pi)    : 3.1416
%      NUM2STRF(pi)   : 3.1416
%
%      NUM2STR(1e24)  : 1.000000e+024
%      NUM2STRF(1e24) : 1000000000000000000000000
%
%   The operand cannot be a complex number!
%
%   See also NUM2STR.

% Copyright (c) 2002-11-23, B. Rasmus Anthin.

s=num2str(x);
if any(s=='e')
   pow=str2num(s(find(s=='e')+1:end));
   if pow<0
      s=num2str(x,['%0.' num2str(5-pow) 'f']);
   else
      s=num2str(x,['%' num2str(pow) '.0f']);
   end
end
   