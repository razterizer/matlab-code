function [znet,term,param,def,symb]=mod_zener(net)
%
% p1  : vZ
% p2  : rZ
% p3  : nZ
% p4  : Is
% p5  : n
% p6  : vT
% p7  : tT
% p8  : Cj0
% p9  : V0
% p10 : m
% 
%
%     o  1     (anode)
%     |
% +---+---+
% |       | 
% |       #    rZ
% |       #
% |    4  |    -
% |       -    vZ
% |      ---   +
% V    3  |
% -       -
% |       A  ideal diode
% |       |
% +---+---+
%     |
%     o  2     (cathode)
%

% 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16  17  18  19  20  21  22  23  24
% t n1 n2 n3 n4 n5 id p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17

if ~nargin, net=nan*ones(1,24);end
def=[4 1e-3 1 1e-14 1 25e-3 0 0 1 .5];
if isnan(net(8)), net(8)=def(1);end
if isnan(net(9)), net(9)=def(2);end
if isnan(net(10)), net(10)=def(3);end   %should be 0.01
vZ=net(8);
rZ=net(9);
nZ=net(10);
Is=net(11);
n=net(12);
vT=net(13);
tT=net(14);
Cj0=net(15);
V0=net(16);
m=net(17);

znet=nan*ones(4,24);
znet(1,1:10)=[11 1 2 Is n vT tT Cj0 V0 m];
znet(2,1:10)=[11 2 3 Is nZ vT tT Cj0 V0 m];      % supposed to be nZ=0.01 but becomes singular with the NR scheme.
znet(3,1:4) =[ 1 3 4 vZ];
znet(4,1:4) =[ 7 4 1 rZ];

term={'+','-'};
param={'vZ','rZ','nZ','Is','n','vT','tT','Cj0','V0','m'};
c=1/3;
symb.patch{1}=c*([1 -1 -1 1]/2+j*[0 1 -1 0]/2);
symb.patchcol={[0 0 0]};
symb.line{1}=c*([1 1]/2+j*[-1 1]/2);
symb.line{2}=c*([1 0]/2+j/2);
symb.line{3}=c*([1 2]/2-j/2);
symb.linecol={[0 0 0],[0 0 0],[0 0 0]};
symb.label='Z';
symb.enum=16;
symb.term=c*([-1 1]/2);
symb.rotax=[1 1 2 2];
symb.dx=c*.8;
symb.ang=0;
symb.ortho=0;