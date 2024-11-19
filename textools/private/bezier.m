function C=bezier(P,n)
%BEZIER  Bezier Spline curve.
%   C=BEZIER(P[,N]), where P is the control points,
%   N are the number interpolated points (N=length(C))
%   (N defaults to 100),
%   and C are the resulting B-Spline interpolation.
%
%   See also SPLINE.

% Copyright (c) 2002-10-28, B. Rasmus Anthin.

B=inline('cmb(n,i).*t.^i.*(1-t).^(n-i)','i','n','t');  %Bernstein polynomial
n=size(P,2);
t=linspace(0,1);

C=zeros(2,100);
for i=1:n
   C=C+P(:,i)*B(i-1,n-1,t);
end