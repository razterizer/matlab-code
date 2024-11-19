function [netlist,inter,N]=sch2net(schematic)
%SCH2NET  Convert schematic matrix to netlist matrix.
%   [NETLIST,INTER,N]=SCH2NET(SCHEMATIC)
%   Where NETLIST is the resulting netlist matrix, INTER is an internal
%   schematic matrix with reduced nodes and N is the coordinates of these
%   nodes (complex).
%   The schematic matrix SCHEMATIC contains one or more of the following rows:
%   
%   TYPE N1  N2  N3  N4  N5  ID PAR1 PAR2 PAR3 PAR4 PAR5 PAR6 PAR7 PAR8 - PAR17
%    -3  n1
%    -2  n1  n2
%    -1  n1 
%     0  n1 
%     1  n+  n-                 Vs
%     2  n+  n-                 Is
%     3  ni+ ni- no+ no-        v
%     4  ni+ ni- no+ no-        r
%     5  ni+ ni- no+ no-        g
%     6  ni+ ni- no+ no-        beta
%     7  n1  n2                 R
%     8  n1  n2                 C
%     9  n1  n2                 L
%    10  n+  n-  no
%    11  n+  n-                 Is   n    vT   tT   Cj0  V0   m
%    16  n1  n2  n3  n4  n5  id par1 par2 par3 par4 par5 par6 par7 par8 - par17     
%
%   unused elements should be marked with NaNs.
%   N1 through N5 are node coordinates (complex: x+iy)
%
%   TYPE  device
%    -3    terminal (symbolic)
%    -2    line
%    -1    dot
%     0    gnd
%     1    voltage source
%     2    current source
%     3    voltage controlled voltage source
%     4    current controlled voltage source
%     5    voltage controlled current source
%     6    current controlled current source
%     7    resistor
%     8    capacitor
%     9    inductor
%    10    op-amp (ideal)
%    11    diode (exponential model)
%    16    block (component model)
% 
%   The resulting netlist matrix NETLIST will then contain one or more of
%   the following rows:
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
%   See also NET2MAT, MAT2VAL.

% Copyright (c) 2003-08-14, B. Rasmus Anthin.
% Revision 2003-08-15 - 2003-08-17, 2003-08-20, 2003-08-22,
%          2003-08-24, 2003-08-31, 2003-09-02.



%1. lokalisera punkter på linjer. När en punkt ligger på en linje
%   delas linjen upp i två nya linjer med punkt som gemensam ände.
%
%2. Tag bort punkter.
%
%2. Gå igenom alla linjer och flytta alla dess komponenter till
%   dess ena punkt och tag bort linje.
%
%3. Skapa en vektor för koordinaterna för alla jordpunkter
%   denna skall sedan matchas med alla jordpunkter för att
%   identifieras som nod 0.

if isempty(schematic) | all(schematic(:,1)<=0)
   netlist=[];
   inter=[];
   N=[];
   if ~nargout
      clear
   end
   return
end

%add missing columns
[row,col]=size(schematic);
if col<24
   schematic=[schematic nan*ones(row,24-col)];
elseif col>24
   schematic=schematic(:,1:24);
end

%removing terminals (no functionality)
i=find(schematic(:,1)==-3);
schematic=delrow(schematic,i);


%breaking up lines
flag=1;
while flag
   flag=0;
   for i=1:size(schematic,1)
      if schematic(i,1)==-1
         dot=schematic(i,2);
         for k=1:size(schematic,1)
            line=schematic(k,2:3);
            if schematic(k,1)==-2 & dotonline(line,dot)
               line1=[-2 line(1) dot NaN*ones(1,21)];
               line2=[-2 dot line(2) NaN*ones(1,21)];
               schematic(k,:)=line1;
               schematic=insrow(schematic,k+1,line2);
               flag=1;
               break
            end
         end
         if flag, break,end
      end
   end
end
%removing dots
i=find(schematic(:,1)==-1);
schematic=delrow(schematic,i);


%eliminating lines
for i=1:size(schematic,1)
   if schematic(i,1)==-2
      n_from=schematic(i,2);
      n_to=schematic(i,3);
      schematic(i,2)=n_to;
      for k=1:size(schematic,1)
         if i~=k
            l=find(schematic(k,2:6)==n_from);
            if ~isempty(l)
               schematic(k,l+1)=n_to;
            end
         end
      end
   end
end
%removing lines
i=find(schematic(:,1)==-2);
schematic=delrow(schematic,i);
inter=schematic;

%collecting ground node points
N0=[];
for i=1:size(schematic,1)
   if ~schematic(i,1)
      N0=[N0 schematic(i,2)];
   end
end
N0=unique(N0);
%removing ground nodes
i=find(~schematic(:,1));
schematic=delrow(schematic,i);

%collecting node points
N=schematic(1,2);
for i=1:size(schematic,1)
   N=[N schematic(i,2:6)];
end
N=unique(N);
%removing NaNs
i=find(isnan(N));
N=delrow(N(:),i).';
%removing ground nodes from general nodes
N=setdiff(N,N0);

%generating netlist
netlist=NaN*ones(size(schematic,1),24);
for i=1:size(schematic,1)
   netlist(i,1)=schematic(i,1);             %type
   for k=2:6
      netlist(i,k)=findnode(N,N0,schematic(i,k));
   end
   switch(schematic(i,1))
   case {1,2,7,8,9}
      netlist(i,4)=schematic(i,8);
   case {3,4,5,6}
      netlist(i,6)=schematic(i,8);
   case 11
      netlist(i,4:10)=schematic(i,8:14);
   case 16
      netlist(i,7:24)=schematic(i,7:24);
   end
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% functions %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=dotonline(line,dot)
line=[real(line(:)) imag(line(:))];
dot=[real(dot) imag(dot)];
%line : [x1 y1]
%       [x2 y2]
%dot  : [x3 y3]
if ~diff(line(:,2))
   y = dot(2)==line(1,2) & ((line(1,1)<dot(1) & dot(1)<line(2,1)) ...
                          | (line(2,1)<dot(1) & dot(1)<line(1,1)));
elseif ~diff(line(:,1))
   y = dot(1)==line(1,1) & ((line(1,2)<dot(2) & dot(2)<line(2,2)) ...
                          | (line(2,2)<dot(2) & dot(2)<line(1,2)));
else
   k=diff(line(:,2))/diff(line(:,1));
   y = dot(2)-line(2,2)==k*(dot(1)-line(2,1));
end
y = y & ~all(dot==line(1,:)) & ~all(dot==line(2,:));

function B=insrow(A,r,a);
A1=A(1:r-1,:);
A2=A(r:end,:);
B=[A1;a;A2];

function B=delrow(A,r)
i=1:size(A,1);
ir=setdiff(i,r);
B=A(ir,:);

function n=findnode(N,N0,co)
if ~isempty(N0) & any(co==N0)
   n=0;            %ground node identified
elseif ~isempty(N) & any(co==N)
   n=find(co==N);  %other node identified
else
   n=NaN;
end