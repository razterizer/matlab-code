function n=symbenum(sch,row)
%   for intrinsic components and models -3, 1..11 :
%      ENUM = TYPE
%
%   for user defined models (blocks) :
%      ENUM = 16,17,...    [int]
%      when ENUM = -3, 1..11 it will be numbered the same way
%      as the intrinsic components.
%
%   There are reservations for upcoming intrinsic models
%   in the 12-15 gap for the TYPE entry.
%
%   Example:
%     Component   | Enumeration Class
%     ------------+------------------
%     Terminal    | -3
%     Voltage src |  1
%     Resistor    |  7
%     Diode       | 11
%     Zener diode | 16
%     Transistor  | 17
%

% Copyright (c) 2003-09-10, B. Rasmus Anthin.

comp=sch(row,:);
if any(comp(1)==[-3:11])
   comp_enum=comp(1);
elseif comp(1)==16
   symb=cmlib('symb',comp(7));
   comp_enum=symb.enum;
end
n=0;
for i=1:row
   if any(sch(i,1)==[-3 1:11]) & comp_enum==sch(i,1)
      n=n+1;
   elseif sch(i,1)==16
      symb=cmlib('symb',sch(i,7));
      if comp_enum==symb.enum
         n=n+1;
      end
   end
end
