function [vn,vbl,ivs,ivv,icv,icc,ioa,ibl]=mat2val(varargin)
%MAT2VAL  Evaluate MNA circuit system and get values.
%   [vn,vbl,ivs,ivv,icv,icc,ioa,ibl] =
%   = MAT2VAL(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl)
%   Evaluates vector x from the equation
%      [G B;C D]*x = [Is;Ibl;Vs;Vvv;Vcv;Vcc;Voa;Vbl].
%   x contains the values (vectors)
%      vn    : node voltages
%      vbl   : internal node voltages inside blocks
%      ivs   : current through voltage sources
%      ivv   : currents through VCV sources
%      icv   : current through CCV sources
%      icc   : current through CCC sources
%      ioa   : current towards output of op-amp
%      ibl   : internal currents inside blocks
%
%   See also NET2MAT, SCH2NET.

% Copyright (c) 2003-08-24, B. Rasmus Anthin.
% Revision 2003-09-03.

error(nargchk(12,12,nargin))
k=0;
G=varargin{1+k};
B=varargin{2+k};
C=varargin{3+k};
D=varargin{4+k};
Is=varargin{5+k};
Ibl=varargin{6+k};
Vs=varargin{7+k};
Vvv=varargin{8+k};
Vcv=varargin{9+k};
Vcc=varargin{10+k};
Voa=varargin{11+k};
Vbl=varargin{12+k};

%warn=warning; warning off
x=[G B;C D]\[Is;Ibl;Vs;Vvv;Vcv;Vcc;Voa;Vbl];
%warning(warn)
vn=x(1:length(Is));
n=length(Is);
vbl=x(n+(1:length(Ibl)));
n=n+length(Ibl);
ivs=x(n+(1:length(Vs)));
n=n+length(Vs);
ivv=x(n+(1:length(Vvv)));
n=n+length(Vvv);
icv=x(n+(1:length(Vcv)));
n=n+length(Vcv);
icc=x(n+(1:length(Vcc)));
n=n+length(Vcc);
ioa=x(n+(1:length(Voa)));
n=n+length(Voa);
ibl=x(n+(1:length(Vbl)));
