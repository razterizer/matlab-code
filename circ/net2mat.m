function [G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl]=net2mat(netlist,freq,eps0)
%NET2MAT  Convert netlist matrix to MNA circuit matrices.
%   This is the very heart of a circuit simulator.
%   It converts the netlist matrix (nx24) to MNA system matrices
%   and vectors (Modified Nodal Analysis, see the references).
%
%   [G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl] =
%   = NET2MAT(NETLIST[,FREQ[,EPS0]])
%
%          [vn ]   [Is ]
%   [G  B] [vbl]   [Ibl]
%   [    ] [   ]   [   ]
%   [C  D] [ivs]   [Vs ]
%          [ivv] = [Vvv]
%          [icv]   [Vcv]
%          [icc]   [Vcc]
%          [ioa]   [Voa]
%          [ibl]   [Vbl]
%
%   Solve by typing the following:
%      » x = [G B;C D]\[Is;Ibl;Vs;Vvv;Vcv;Vcc;Voa;Vbl];
%   or by using MAT2VAL.
%   NETLIST is the netlist matrix (see below), FREQ is the
%   common operating frequency for steady-state operation, and EPS0
%   is the maximum allowable absolute error for the result
%   (when the netlist contains nonlinear devices).
%
%   G   : interconnections between resistive circuit elements
%   B   : connection of voltage sources
%   C   : connection of voltage sources  (sometimes: B')
%   D   : connection of dependent sources
%   Is  : current sources (combined with sources in blocks)
%   Ibl : same as Is
%   Vs  : voltage sources
%   Vvv : VCVS : 0     = delta (V_out)
%   Vcv : CCVS : [0;0] = delta (V_in; V_out)
%   Vcc : CCCS : 0     = delta (V_in)
%   Voa : voltage difference for inputs in Op-Amps = 0
%   Vbl : voltage sources in blocks
%   vn  : node voltages
%   vbl : node voltages in blocks
%   ivs : currents through voltage sources (+ -> -)
%   ivv : VCVS : I_out
%   icv : CCVS : [I_in;I_out]
%   icc : CCCS : I_in
%   ioa : current into output of Op-Amps
%   ibl : local currents inside block
%   freq : frequency for V/I-sources
%   eps0 : abs error treshold for non-linearities (default: eps)
%
%   current   voltage
%   source    source
%      n+        n+
%   +-----+   +-----+
%   |  |  |   |  +  |
%   |  |  |   |     |
%   |  V  |   |  -  |
%   +-----+   +-----+
%      n-        n-
%
%   The netlist matrix contains one or more of the following rows:
%
%   TYPE C2  C3  C4  C5  C6   C7  C8   C9   C10  C11  - C24
%    1   n+  n-  Vs
%    2   n+  n-  Is
%    3   ni+ ni- no+ no- v
%    4   ni+ ni- no+ no- r
%    5   ni+ ni- no+ no- g
%    6   ni+ ni- no+ no- beta
%    7   n1  n2  R
%    8   n1  n2  C
%    9   n1  n2  L
%   10   n+  n-  no
%   11   n+  n-  Is  n   vT   tT  Cj0  V0   m
%   16   n1  n2  n3  n4  n5   id  par1 par2 par3 par4 - par17
%
%   unused elements should be marked with NaNs.
%
%   TYPE  device
%    1     voltage source
%    2     current source
%    3     voltage controlled voltage source
%    4     current controlled voltage source
%    5     voltage controlled current source
%    6     current controlled current source
%    7     resistor
%    8     capacitor
%    9     inductor
%   10     op-amp (ideal)
%   11     diode (exponential model)
%   16     block (component model)
%
%   See also SCH2NET, MAT2VAL.

% References : [1] Eric Cheever, http://www.swarthmore.edu/NatSci/echeeve1/Ref/mna/MNA1.html
%              [2] Michael Wiese, Diploma thesis, "Symbolic Pole/Zero Approximation
%                  in Analog Circuit Analysis using Equation-based Simplification
%                  driven by Eigenvalue Shift Prediction"

% Copyright (c) 2003-08-14, B. Rasmus Anthin.
% Revision 2003-08-15 - 2003-08-17, 2003-08-20 - 2003-08-22,
%          2003-08-24, 2003-08-31, 2003-09-03, 2003-09-22, 2003-09-23.


if nargin<2
   freq=0;
end
w=2*pi*freq;

[mnet,bnet]=mergenet(netlist);   %"flatten" netlist (only works for one level?).
netlist=[mnet;bnet];
%preparing for rearrangment of matrices at the end of this program.
main.n=length(getnodes(mnet))-1;
main.nvs=sum(mnet(:,1)==1);
main.nvv=sum(mnet(:,1)==3);
main.ncv=sum(mnet(:,1)==4)*2;
main.ncc=sum(mnet(:,1)==6);
main.noa=sum(mnet(:,1)==10);
main.m=main.nvs+main.nvv+main.ncv+main.ncc+main.noa;
if isempty(bnet)
   block.m=0;
else
   block.m=sum(bnet(:,1)==1)+sum(bnet(:,1)==3)+2*sum(bnet(:,1)==4)+sum(bnet(:,1)==6)+sum(bnet(:,1)==10);
end
main.vn=1:main.n;
main.ivs=1:main.nvs;
main.ivv=1:main.nvv;
main.icv=1:main.ncv;
main.icc=1:main.ncc;
main.ioa=1:main.noa;

%replacing resistances that are near zero (<realmin) with realmin (see (*)).
for i=1:size(netlist,1)
   if netlist(i,1)==7 & netlist(i,4)<realmin
      %this makes the solution matrix very ill-conditioned and near-singular.
      %temporary solution
      netlist(i,4)=realmin;
   end
end
%(*) removing resistances that are near zero (<realmin).
%THIS PART MUST BE CORRECTED
%(doesn't work properly cuz the above statements uses MNET for rearrangement of the nodes further on)
if 0
ii=[];
for i=1:size(netlist,1)
   if netlist(i,1)==7 & netlist(i,4)<realmin
      ii=[ii i];
      n_from=netlist(i,2);
      n_to=netlist(i,3);
      netlist(i,2)=n_to;
      for k=1:size(netlist,1)
         if i~=k
            l=find(netlist(k,2:3)==n_from)+1;
            if any(netlist(k,1)==[3:6 10])
               l=[l find(netlist(k,4)==n_from)+3];
               if any(netlist(k,1)==[3:6])
                  l=[l find(netlist(i,5)==n_from)+4];
               end
            end
            if ~isempty(l)
               netlist(k,l)=n_to;
            end
         end
      end
   end
end
%removing small resistors
i=setdiff(1:size(netlist,1),ii);
netlist=netlist(i,:);
%getting the new nodes resulting from the removal scheme
n1=getnodes(netlist);    %assuming n1(1)=0 (otherwise A will be singular)
%renumber nodes
for i=1:size(netlist,1)
   netlist(i,2)=find(n1==netlist(i,2))-1;
   netlist(i,3)=find(n1==netlist(i,3))-1;
   if any(netlist(i,1)==[3:6 10])
      netlist(i,4)=find(n1==netlist(i,4))-1;
      if any(netlist(i,1)==[3:6])
         netlist(i,5)=find(n1==netlist(i,5))-1;
      end
   end
end
end



vs=zeros(0,3);    % N+ N- VAL
cs=zeros(0,3);    % N+ N- VAL
vv=zeros(0,5);    % Nin+ Nin- Nout+ Nout- v
cv=zeros(0,5);    % Nin+ Nin- Nout+ Nout- r
vc=zeros(0,5);    % Nin+ Nin- Nout+ Nout- g
cc=zeros(0,5);    % Nin+ Nin- Nout+ Nout- b
rr=zeros(0,3);    % N1 N2 VAL
oa=zeros(0,3);    % N+ N- N_out
dd=zeros(0,10);   % N+ N- Is n vT tT Cj0 V0 m freq
n=0;
warn=warning;
warning off
for i=1:size(netlist,1)
   n=max(n,max(netlist(i,2:3)));
   if ~isnan(netlist(i,1))              %avoid pseudo-components
      switch(netlist(i,1))
      case 1, vs=[vs;netlist(i,2:4)];
      case 2, cs=[cs;netlist(i,2:4)];
      case 3, vv=[vv;netlist(i,2:6)];
         n=max(n,max(netlist(i,4:5)));
      case 4, cv=[cv;netlist(i,2:6)];
         n=max(n,max(netlist(i,4:5)));
      case 5, vc=[vc;netlist(i,2:6)];
         n=max(n,max(netlist(i,4:5)));
      case 6, cc=[cc;netlist(i,2:6)];
         n=max(n,max(netlist(i,4:5)));
      case 7, rr=[rr;netlist(i,2:4)];
      case 8, rr=[rr;netlist(i,2:3) 1/(j*w*netlist(i,4))];
      case 9, rr=[rr;netlist(i,2:3) j*w*netlist(i,4)];
      case 10, oa=[oa;netlist(i,2:4)];
         n=max(n,netlist(i,4));
      case 11, dd=[dd;netlist(i,2:10) freq];
      end
   end
end
warning(warn)
nvs=size(vs,1);
ncs=size(cs,1);
nvv=size(vv,1);
ncv=size(cv,1);
nvc=size(vc,1);
ncc=size(cc,1);
nrr=size(rr,1);
noa=size(oa,1);
ndd=size(dd,1);


m=nvs+ncc+nvv+ncv*2+noa;
G=zeros(n);            %this is a symmetric conductance matrix
for i=1:nrr
   if rr(i,1)
      G(rr(i,1),rr(i,1))=G(rr(i,1),rr(i,1)) + 1/rr(i,3);   %add all conductances for this node
   end
   if rr(i,2)
      G(rr(i,2),rr(i,2))=G(rr(i,2),rr(i,2)) + 1/rr(i,3);   %add all conductances for this node
   end
   if rr(i,1) & rr(i,2)
      G(rr(i,1),rr(i,2))=G(rr(i,1),rr(i,2)) - 1/rr(i,3);   %subtract conductances between nodes
      G(rr(i,2),rr(i,1))=G(rr(i,2),rr(i,1)) - 1/rr(i,3);   %subtract conductances between nodes
   end
end
n0=nrr;
for i=1:nvc
   if vc(i,3) & vc(i,1)
      G(vc(i,3),vc(i,1))=G(vc(i,3),vc(i,1)) + vc(i,5);     %add gain
   end
   if vc(i,4) & vc(i,1)
      G(vc(i,4),vc(i,1))=G(vc(i,4),vc(i,1)) - vc(i,5);     %subtract gain
   end
   if vc(i,3) & vc(i,2)
      G(vc(i,3),vc(i,2))=G(vc(i,3),vc(i,2)) - vc(i,5);
   end
   if vc(i,4) & vc(i,2)
      G(vc(i,4),vc(i,2))=G(vc(i,4),vc(i,2)) + vc(i,5);
   end
end

%B =
%   VOLTAGE SOURCES
% N
% O
% D   sign(polarity)
% E
% S
B=zeros(n,m);
C=zeros(m,n);
%Voltage Sources
for i=1:nvs
   if vs(i,1)
      B(vs(i,1),i)=+1;
   end
   if vs(i,2)
      B(vs(i,2),i)=-1;
   end
end
C=B';
n0=nvs;
%VCVS
for i=1:nvv
   if vv(i,3)
      B(vv(i,3),n0+i)=+1;
      C(n0+i,vv(i,3))=-1;
   end
   if vv(i,4)
      B(vv(i,4),n0+i)=-1;
      C(n0+i,vv(i,4))=+1;
   end
   if vv(i,1)
      C(n0+i,vv(i,1))=+vv(i,5);
   end
   if vv(i,2)
      C(n0+i,vv(i,2))=-vv(i,5);
   end
end
n0=n0+nvv;
%CCVS
for i=1:ncv
   if cv(i,1)
      B(cv(i,1),n0+2*i-1)=+1;
      C(n0+2*i-1,cv(i,1))=+1;
   end
   if cv(i,2)
      B(cv(i,2),n0+2*i-1)=-1;
      C(n0+2*i-1,cv(i,2))=-1;
   end
   if cv(i,3)
      B(cv(i,3),n0+2*i)=+1;
      C(n0+2*i,cv(i,3))=+1;
   end
   if cv(i,4)
      B(cv(i,4),n0+2*i)=-1;
      C(n0+2*i,cv(i,4))=-1;
   end
end
n0=n0+ncv;
%CCCS
for i=1:ncc
   if cc(i,1)
      B(cc(i,1),n0+i)=+1;
      C(n0+i,cc(i,1))=-1;
   end
   if cc(i,2)
      B(cc(i,2),n0+i)=-1;
      C(n0+i,cc(i,2))=+1;
   end
   if cc(i,3)
      B(cc(i,3),n0+i)=+cc(i,5);
   end
   if cc(i,4)
      B(cc(i,4),n0+i)=-cc(i,5);
   end
end
n0=n0+ncc;
%Op-Amps
for i=1:noa
   if oa(i,3)
      B(oa(i,3),nvs+i)=1;
   end
   if oa(i,1)
      C(nvs+i,oa(i,1))=+1;
   end
   if oa(i,2)
      C(nvs+i,oa(i,2))=-1;
   end
end

D=zeros(m);
n0=nvs+ncc+nvv;
for i=1:ncv
   D(n0+2*i,n0+2*i-1)=-cv(i,5);
end

%%%%%%%%%% sources %%%%%%%%%%%

Is=zeros(n,1);
for i=1:ncs
   if cs(i,1)
      Is(cs(i,1))=Is(cs(i,1))-cs(i,3);
   end
   if cs(i,2)
      Is(cs(i,2))=Is(cs(i,2))+cs(i,3);
   end
end

Vs=vs(:,3);
Vvv=zeros(nvv,1);
Vcv=zeros(ncv*2,1);
Vcc=zeros(ncc,1);
Voa=zeros(noa,1);

%%%%%%%%%% nonlinear elements %%%%%%%%%%%

AD0=zeros(n+m);   %initial guess for A matrix
for i=1:ndd
   %initial guess:
   [foo,diD,GD0]=mod_diode(0,0,dd(i,3),dd(i,4),dd(i,5),dd(i,6),dd(i,7),dd(i,8),dd(i,9),dd(i,10));
   if dd(i,1)
      AD0(dd(i,1),dd(i,1))=AD0(dd(i,1),dd(i,1)) + GD0;
   end
   if dd(i,2)
      AD0(dd(i,2),dd(i,2))=AD0(dd(i,2),dd(i,2)) + GD0;
   end
   if dd(i,1) & dd(i,2)
      AD0(dd(i,1),dd(i,2))=AD0(dd(i,1),dd(i,2)) - GD0;
      AD0(dd(i,2),dd(i,1))=AD0(dd(i,2),dd(i,1)) - GD0;
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% iterate %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=[G B;C D];
A0=A+AD0;
b=[Is;Vs;Vvv;Vcv;Vcc;Voa];
%warn=warning; warning off
x0=A0\b;
%warning(warn)
x=x0;
x1=x-pinv(dF(x,A,dd))*F(x,A,b,dd);
iter=1;
if nargin<3, eps0=eps;end
if ~isempty(dd)
   while any(abs(x-x1)>eps0)
      x=x1;
      x1=x-pinv(dF(x,A,dd))*F(x,A,b,dd);
      iter=iter+1;
   end
end
%iter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% reconstruct %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GDD=zeros(n);
for i=1:ndd
   v1=0;v2=0;
   if dd(i,1), v1=x1(dd(i,1));end
   if dd(i,2), v2=x1(dd(i,2));end
   GD=mod_diode(v1,v2,dd(i,3),dd(i,4),dd(i,5),dd(i,6),dd(i,7),dd(i,8),dd(i,9),dd(i,10));
   if dd(i,1)
      GDD(dd(i,1),dd(i,1))=GDD(dd(i,1),dd(i,1)) + GD;
   end
   if dd(i,2)
      GDD(dd(i,2),dd(i,2))=GDD(dd(i,2),dd(i,2)) + GD;
   end
   if dd(i,1) & dd(i,2)
      GDD(dd(i,1),dd(i,2))=GDD(dd(i,1),dd(i,2)) - GD;
      GDD(dd(i,2),dd(i,1))=GDD(dd(i,2),dd(i,1)) - GD;
   end
end

G=G+GDD;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% rearrange %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% separate main circuit from subcircuits (blocks)

%upper part b
Ibl=Is(main.n+1:n);
Is=Is(main.vn);

%lower part b (C & D), rows
Vbl=Vs(setdiff(1:length(Vs),main.ivs));
Vs=Vs(main.ivs);
Vbl=[Vbl;Vvv(setdiff(1:length(Vvv),main.ivv))];
Vvv=Vvv(main.ivv);
Vbl=[Vbl;Vcv(setdiff(1:length(Vcv),main.icv))];
Vcv=Vcv(main.icv);
Vbl=[Vbl;Vcc(setdiff(1:length(Vcc),main.icc))];
Vcc=Vcc(main.icc);
Vbl=[Vbl;Voa(setdiff(1:length(Voa),main.ioa))];
Cu=zeros(main.m,n);
Cl=zeros(block.m,n);
nupp=[main.ivs nvs+main.ivv nvs+nvv+main.icv nvs+nvv+ncv+main.icc nvs+nvv+ncv+ncc+main.ioa];
Cu=C(nupp,:);
nlow=setdiff(1:m,nupp);
Cl=C(nlow,:);
C=[Cu;Cl];
Du=zeros(main.m,m);
Dl=zeros(block.m,m);
Du=D(nupp,:);
Dl=D(nlow,:);
D=[Du;Dl];

%lower part x (B & D), columns
Bl=zeros(n,main.m);
Br=zeros(n,block.m);
Bl=B(:,nupp);
Br=B(:,nlow);
B=[Bl Br];
Dl=zeros(m,main.m);
Dr=zeros(m,block.m);
Dl=D(:,nupp);
Dr=D(:,nlow);
D=[Dl Dr];

%upper part x (G & C), columns
  %already taken care of by MERGENET

%%%%%%%%%%%%%%%%%%%%%%%%%%% functions %%%%%%%%%%%%%%%%%%%%%

function M=F(x,A,b,dd)
ndd=size(dd,1);
for i=1:ndd
   v1=0;v2=0;
   if dd(i,1), v1=x(dd(i,1));end
   if dd(i,2), v2=x(dd(i,2));end
   GD=mod_diode(v1,v2,dd(i,3),dd(i,4),dd(i,5),dd(i,6),dd(i,7),dd(i,8),dd(i,9),dd(i,10));
   if dd(i,1)
      A(dd(i,1),dd(i,1))=A(dd(i,1),dd(i,1)) + GD;
   end
   if dd(i,2)
      A(dd(i,2),dd(i,2))=A(dd(i,2),dd(i,2)) + GD;
   end
   if dd(i,1) & dd(i,2)
      A(dd(i,1),dd(i,2))=A(dd(i,1),dd(i,2)) - GD;
      A(dd(i,2),dd(i,1))=A(dd(i,2),dd(i,1)) - GD;
   end
end
M=A*x-b;


function J=dF(x,A,dd)
ndd=size(dd,1);
for i=1:ndd
   v1=0;v2=0;
   if dd(i,1), v1=x(dd(i,1));end
   if dd(i,2), v2=x(dd(i,2));end
   [GD,diD]=mod_diode(v1,v2,dd(i,3),dd(i,4),dd(i,5),dd(i,6),dd(i,7),dd(i,8),dd(i,9),dd(i,10));
   if dd(i,1)
      A(dd(i,1),dd(i,1))=A(dd(i,1),dd(i,1)) + diD;
   end
   if dd(i,2)
      A(dd(i,2),dd(i,2))=A(dd(i,2),dd(i,2)) + diD;
   end
   if dd(i,1) & dd(i,2)
      A(dd(i,1),dd(i,2))=A(dd(i,1),dd(i,2)) - diD;
      A(dd(i,2),dd(i,1))=A(dd(i,2),dd(i,1)) - diD;
   end
end
J=A;




function n=getnodes(net)
if isempty(net)
   n=[];
else
   n=net(:,2:3);
   n=n(:)';
   for i=1:size(net,1)
      if any(net(i,1)==[3:6 10])
         n=[n net(i,4)];
         if any(net(i,1)==[3:6])
            n=[n net(i,5)];
         end
      end
   end
   n=unique(n);
end


function [mnet,bnet]=mergenet(net)
%merges the main net with subnets/blocks (ie models).
fubar=nan*ones(size(net,1),24);
fubar(:,1:size(net,2))=net;
net=fubar;                 %correct the number of columns
block=[];                  %blocks netlist
bi=[];                     %block entry idx in total netlist
n=max(getnodes(net));      %highest nodenumber before splitting.
mlen=size(net,1);          %number of components for total netlist
for i=1:mlen                  %collect block items from total netlist
   if net(i,1)==16
      block=[block; net(i,:)];      %append blocks netlist
      bi=[bi i];                    %corresponding entry idx in total netlist
      net(i,1)=NaN;                 %inserting a pseudo-component
   end
end
%i=setdiff(1:mlen,bi);
%mnet=net(i,:);
mnet=net;
blen=size(block,1);
bnet=[];
for i=1:blen
   subnet=cmlib('net',block(i,:));
   for j=1:size(subnet,1)
      subnet(j,2)=replacesubnode(subnet(j,2),block(i,2:6),n);
      nb=subnet(j,2);
      subnet(j,3)=replacesubnode(subnet(j,3),block(i,2:6),n);
      nb=max(nb,subnet(j,3));
      if any(subnet(j,1)==[3:6 10])
         subnet(j,4)=replacesubnode(subnet(j,4),block(i,2:6),n);
         nb=max(nb,subnet(j,4));
         if any(subnet(j,1)==[3:6])
            subnet(j,5)=replacesubnode(subnet(j,5),block(i,2:6),n);
            nb=max(nb,subnet(j,4));
         end
      end
   end
   n=nb;      %increase node numbering for next block
   bnet=[bnet;subnet];
end
%%%%%%%%
function nod=replacesubnode(nod,terminals,n)
nargs=sum(~isnan(terminals));
%nod : local node number
%terminals : terminals (global node numbering)
if any(nod==(1:nargs))      %tänk igenom detta noga!!!
   nod=terminals(nod);
else
   nod=nod-nargs+n;
end