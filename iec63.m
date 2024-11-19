function [v,tol]=iec63(N)
%IEC63  Standard normalized E-series values.
%   [V,TOL] = IEC63(N) gives a table of normalized values for the
%   E-series of order N according to the IEC-63 or EIA standard.
%   N = 3*2^i, i=0..6. Ie:
%      N = [ 3 | 6 | {12} | 24 | 48 | 96 | 192 ]
%   where N=12 is the default value if N is omitted.
%   The values V will always have the constraint 1 <= V < 10,
%   (ie V is normalized).
%   The additional output TOL is the error tolerance in percent.

% Copyright (c) 2003-08-03, B. Rasmus Anthin.
% Revision 2003-08-04.

%E192:
if ~nargin, N=12;end
v=round(100*10.^((0:191)/192))/100;
v(186)=9.20;        %correction
switch(N)
case {192,96,48}
   n=1:192/N:192;
   v=v(n);
case {24,12,6,3}
   v=[10 11 12 13   %too many corrections for above formula, using table instead.
      15 16 18 20
      22 24 27 30
      33 36 39 43
      47 51 56 62
      68 75 82 91]/10;
   v=reshape(v',1,24);
   n=1:24/N:24;
   v=v(n);
otherwise
   error('Wrong base value N.')
end
switch(N)
case 3, tol=50;
case 6, tol=20;
case 12, tol=10;
case 24, tol=5;
case 48, tol=2;
case 96, tol=1;
case 192, tol=[.5 .25 .1];
end