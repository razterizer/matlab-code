function [GD,diD,GD0]=mod_diode(v1,v2,Is,n,vT,tT,Cj0,V0,m,freq);
% Intrinsic model, do not change!
%
% GD  : Conductance element
% diD : current derivative (diD/dvD)
% GD0 : initial guess
%
%   o    1
%   |
%   |
%   +---------+    +
%   |         |
%   |         |/
% +---+  CD -----
% | | |     -----
% | v | iD   /|     vD = v1-v2
% +---+       |
%   |         |
%   |         |
%   |         |
%   +---------+    -
%   |
%   |
%   o    2

if isnan(Is),  Is=1e-14;end
if isnan(n),   n=1;end
if isnan(vT),  vT=25e-3;end
if isnan(tT),  tT=0;end
if isnan(Cj0), Cj0=0;end
if isnan(V0),  V0=1;end
if isnan(m),   m=.5;end

dv=v1-v2;
idx=find(~dv); dv(idx)=eps;
w=2*pi*freq;
u=1/(n*vT);

iD=Is*(exp(dv*u)-1);
CD=tT*u*Is*exp(dv*u) + ...
   Cj0/(1-dv/V0)^m;
dCDdv=tT*u*Is*(exp(dv*u)*dv*u+exp(dv*u)) + ...
   Cj0/(1-dv/V0)^m*(1+dv*m/(V0-dv));
%for the MNA system
GD=iD./dv + j*w*CD;
%Jacobi element = diff(GD*dv,dv)
diD=(iD+Is)*u + j*w*dCDdv;
%initial guess
GD0=0.02;