function newpoints=rotate2(points,origo,phi)
%ROTATE2  rotate points in 2 dimensions.
%   NEWPOINTS=ROTATE(POINTS,ORIGO,PHI) rotates the points in POINTS PHI radians around the ORIGO point.
%   ROTATE returns NEWPOINTS as the rotated points from POINTS.

% Copyright(c) 2000-05-14 by B. Rasmus Anthin.

%A=[cos(phi) -sin(phi);sin(phi) cos(phi)];
%newpoints=A*points+origo*ones(1,size(points,2));

o=origo*ones(1,size(points,2));
p=points;
A=[cos(phi) -sin(phi);sin(phi) cos(phi)];
newpoints=A*(p-o)+o;