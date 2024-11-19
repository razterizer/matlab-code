function [tnet,term,param,def,symb]=mod_npnlarge_em(net)
% Ebers-Moll model
%
% p1 : betaF
% p2 : betaR
% p3 : Is
% p4 : n
% p5 : vT
%
% n1 : B
% n2 : C
% n3 : E
%
%        2
% 1  |_/
%  --|
%    |>
%      \ 3
%
%                      2
%                    o
%                    |
%           +--------+--------+---------------+
%           |                 |               |
%           |                 |               |
%    Is     -                 |               |
%    --     A                 |               |
%   betaR   |                 |               |
%           | 4               |               |
%           |                 |               | iBC*betaR
%           ^ iBC             |              / \
%  1        |                / \            / ^ \
%   o-------+               / | \           \ | /
%           |               \ v /            \ /
%           v iBE            \ /              |
%           |                 | iBE*betaF     |
%           | 5               |               |
%           |                 |               |
%    Is     V                 |               |
%    --     -                 |               |
%   betaF   |                 |               |
%           |                 |               |
%           +--------+--------+---------------+
%                    |
%                    o
%                      3
%
%  betaF = beta  (typically large)
%  betaR (very small, typically <1)
%

% t n1 n2 n3 n4 n5 id p1 p2 p3 p4 p5 p6 p7 p8 p9

if ~nargin, net=nan*ones(1,24);end
def=[100 .02 1e-16 1 25e-3];
if isnan(net(8)), net(8)=def(1);end
if isnan(net(9)), net(9)=def(2);end
if isnan(net(10)), net(10)=def(3);end
betaF=net(8);
betaR=net(9);
Is=net(10);
n=net(11);
vT=net(12);

tnet=nan*ones(4,24);
tnet(1,1:6)=[11 4 2 Is/betaR n vT];
tnet(2,1:6)=[11 5 3 Is/betaF n vT];
tnet(3,1:6)=[ 6 1 5 2 3 betaF];
tnet(4,1:6)=[ 6 1 4 3 2 betaR];

term={'B','C','E'};
param={'betaF','betaR','Is','n','vT'};
c=1/2;
symb.patch{1}=c*(-[.3 .2 .2 .3]+j*[.75 .75 -.75 -.75]);  %base plate
symb.patch{2}=c*(([5/4 3/4 3/4]+j*[0 1/5 -1/5])*exp(j*atan2(-3/4,1))-(.25+.25j));
symb.patchcol={[0 0 0],[0 0 0]};
symb.line{1}=c*(-[1 .25]+j*[0 0]);      %base terminal
symb.line{2}=c*([-.25 .75 1]+j*[.25 1 1]);    %collector terminal
symb.line{3}=c*([-.25 .75 1]-j*[.25 1 1]);    %emitter terminal
symb.line{4}=c*1.25*(cos(2*pi*linspace(0,1))+j*sin(2*pi*linspace(0,1)));
symb.linecol={[0 0 0],[0 0 0],[0 0 0],[0 0 0]};
symb.label='Q';
symb.enum=17;
symb.term=c*([-1+0j 1+j 1-j]);        %B, C, E
symb.rotax=[1 1 2 3];
symb.dx=1;
symb.ang=-90;
symb.ortho=1;