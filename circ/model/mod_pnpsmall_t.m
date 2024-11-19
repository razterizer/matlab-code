function [tnet,term,param,def,symb]=mod_pnpsmall_t(net)
%
% p1 : beta
% p2 : Re
%
% n1 : B
% n2 : C
% n3 : E
%
%        2
% 1  |_/
%  --|
%    |<
%      \ 3
%
%                  3
%                o
%                |
%                v iE
%                |
%              4 |
%                |
%                #
%                # Re
%                #
%    1           |
%     o----------+
%                |
%               / \
%              / | \  iE*alpha
%              \ v /
%               \ /
%                |
%                |
%                o
%                  2
%
%    alpha = beta/(beta+1)
%    Re = Rpi/(beta+1)

% t n1 n2 n3 n4 n5 id p1 p2 p3 p4 p5 p6 p7 p8 p9

if ~nargin, net=nan*ones(1,24);end
def=[100 50];
if isnan(net(8)), net(8)=def(1);end
if isnan(net(9)), net(9)=def(2);end
beta=net(8);
alpha=beta/(beta+1);
Rpi=net(9);
Re=Rpi/(beta+1);

tnet=nan*ones(2,24);
tnet(1,1:4)=[ 7 4 1 Re];
tnet(2,1:6)=[ 6 3 4 1 2 alpha];

term={'B','C','E'};
param={'beta','Rpi'};
c=1/2;
symb.patch{1}=c*(-[.3 .2 .2 .3]+j*[.75 .75 -.75 -.75]);  %base plate
symb.patch{2}=c*((.1+[0 2/4 2/4]+j*[0 1/5 -1/5])*exp(j*atan2(-3/4,1))-(.25+.25j));    %the arrow
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