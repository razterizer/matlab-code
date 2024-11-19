function [dnet,term,param,def,symb]=mod_diode2(net)

%diode with builtin series resistance.
%
% p1 : Rs
% p2 : Is
% p3 : n
% p4 : vT
% p5 : tT
% p6 : Cj0
% p7 : V0
% p8 : m
% 
%
%     o  1     (anode)
%     |
%     |
%     | 
%     #
%     #    Rs
%     #
%     |
%     |
%     V
%     -
%     |
%     |
%     |
%     o  2     (cathode)
%

% t n1 n2 n3 n4 n5 id p1 p2 p3 p4 p5 p6 p7 p8 p9

if ~nargin, net=nan*ones(1,24);end
def=[1e-3 1e-14 1 25e-3 0 0 1 .5];
if isnan(net(8)), net(8)=def(1);end

dnet=nan*ones(2,24);
dnet(1,1:4)=[7 1 3 net(8)];
dnet(2,1:10)=[11 3 2 net(9:15)];

term={'+','-'};
param={'Rs','Is','n','vT','tT','Cj0','V0','m'};
c=1/3;
symb.patch{1}=c*([1 -1 -1 1]/2+j*[0 1 -1 0]/2);
symb.patchcol={[0 0 0]};
symb.line{1}=c*([1 1]/2+j*[-1 1]/2);
symb.linecol={[0 0 0]};
symb.label='D';
symb.enum=11;
symb.term=c*[-1 1]/2;
symb.rotax=[1 1 2 2];
symb.dx=c*.8;
symb.ang=0;
symb.ortho=0;