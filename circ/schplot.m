function schplot(sch,fs,n)
%SCHPLOT  Plots schematic from a schematic matrix.
%   SCHPLOT(SCHEMATIC[,FS[,N]])  plots the schematic matrix
%   SCHEMATIC with fontsize FS (10) and with N digits of precision
%   (variable).
%
%   See also ECSIM, VALPLOT, SCH2NET.

% Copyright (c) 2003-08-23, B. Rasmus Anthin.
% Revision 2003-08-29, 2003-08-30, 2003-08-31, 2003-09-02,
%          2003-09-03, 2003-09-08, 2003-09-09, 2003-09-11.

sch(isnan(sch))=inf;
if nargin<2, fs=10;end
if nargin<3, n=[];end
c=1/3;
ish=ishold;
hold on


t=linspace(0,1);
r=c*(cos(2*pi*t)+j*sin(2*pi*t));    %circle

%sort out lines beloning to a terminal in order
%to know how to rotate its label.
for i=1:size(sch,1)
   p1(i)=0;
   p2(i)=0;
   if sch(i,1)==-3
      for k=1:size(sch,1)
         if sch(k,1)==-2
            if sch(i,2)==sch(k,2)
               p1(i)=sch(k,2);
               p2(i)=sch(k,3);
            elseif sch(i,2)==sch(k,3)
               p1(i)=sch(k,3);
               p2(i)=sch(k,2);
            end
         end
      end
   end
end

%start plotting symbols
for i=1:size(sch,1)
   sch(i,2:5)=sch(i,2:5)+(0:3)*eps*j;   %to make sure that j is in all points.
   m1=mean(sch(i,2:3));                 %midpoint
   m2=mean(sch(i,4:5));
   x1=real(sch(i,2:3));
   y1=imag(sch(i,2:3));
   x2=real(sch(i,4:5));
   y2=imag(sch(i,4:5));
   phi1=atan2(diff(y1),diff(x1));
   phi2=atan2(diff(y2),diff(x2));
   T1=exp(j*(phi1+pi/2));                %rotation factor
   T2=exp(j*(phi2+pi/2));
   plus=c*([-1 1 nan 0 0]/3+j*[0 0 nan -1 1]/3);    %plus sign
   minus=c*([-1 1]/3);                              %minus sign
   arrow=c*[0+.7j 0-.7j nan -.3-.4j 0-.7j .3-.4j];  %down arrow
   box=c*[1+0j 0+j -1+0j 0-j 1+0j];                 %box (romboid)
   curr=c*([1 -1 0 1]+j*[1 1 -1 1])/4*T1;           %current arrow symbol
   num=symbenum(sch,i);                             %component numbering
   clear h
   switch(sch(i,1))
   case -3
      %TERMINAL
      phi=0;
      x=real([p2(i) p1(i)]);
      y=imag([p2(i) p1(i)]);
      phi=atan2(diff(y),diff(x));
      [tpos,halign,valign,angl]=textrot(phi,sch(i,2),c);         %text rotation
      h(1)=plot(sch(i,2),'ko');
      h(2)=text(real(tpos(1)),imag(tpos(1)),['T_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
   case -2
      %LINE
      h=plot(sch(i,2:3),'k');
   case -1
      %DOT
      h=plot(sch(i,2),'k.');
   case 0
      %GND
      h(1)=plot(sch(i,[2 2])-[0 j]*c,'k');
      h(2)=plot(sch(i,[2 2 2])-j*c+[-1 0 1]*c/2,'k');
   case 1
      %VOLTAGE SOURCE
      %nominal oriention:
      %+
      %-
      [tpos,halign,valign,angl]=textrot(phi1,m1,c*1.2);         %text rotation
      pt=[sch(i,2) m1+c*j*T1];       %plus terminal
      mt=[sch(i,3) m1-c*j*T1];       %minus terminal
      h(1)=plot(r+m1,'k');
      h(2)=plot((plus+c*j/2.5)*T1+m1,'k');
      h(3)=plot((minus-c*j/2.5)*T1+m1,'k');
      h(4)=plot(pt,'k');
      h(5)=plot(mt,'k');
      h(6)=text(real(tpos(1)),imag(tpos(1)),['U_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(7)=text(real(tpos(2)),imag(tpos(2)),num2scic(sch(i,8),n,'V'),'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 2
      %CURRENT SOURCE
      %nominal orientation:
      %|
      %v
      [tpos,halign,valign,angl]=textrot(phi1,m1,c*1.2);
      pt=[sch(i,2) m1+c*j*T1];
      mt=[sch(i,3) m1-c*j*T1];
      h(1)=plot(r+m1,'k');
      h(2)=plot(arrow*T1+m1,'k');
      h(3)=plot(pt,'k');
      h(4)=plot(mt,'k');
      h(5)=text(real(tpos(1)),imag(tpos(1)),['I_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(6)=text(real(tpos(2)),imag(tpos(2)),num2scic(sch(i,8),n,'A'),'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 3
      %VCVS
      [tpos,halign,valign,angl]=textrot(phi2,m2,c*1.2);
      pt=[sch(i,4) m2+c*j*T2];
      mt=[sch(i,5) m2-c*j*T2];
      corners=box*T2+m2;
      ci=find(abs(corners-m1)==min(abs(corners-m1)));
      h(1)=plot(box*T2+m2,'k');
      h(2)=plot((plus+c*j/2.5)*T2+m2,'k');
      h(3)=plot((minus-c*j/2.5)*T2+m2,'k');
      h(4)=plot(pt,'k');
      h(5)=plot(mt,'k');
      h(6)=plot([m1 corners(ci)],':r');
      h(7)=plot(x1(1),y1(1),'ko');
      h(8)=plot(x1(2),y1(2),'ko'); set(h(8),'markerface','k')
      h(9)=text(real(tpos(1)),imag(tpos(1)),['E_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(10)=text(real(tpos(2)),imag(tpos(2)),['v=' num2scic(sch(i,8),n,'')],'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 4
      %CCVS
      [tpos,halign,valign,angl]=textrot(phi2,m2,c*1.2);
      pt=[sch(i,4) m2+c*j*T2];
      mt=[sch(i,5) m2-c*j*T2];
      corners=box*T2+m2;
      ci=find(abs(corners-m1)==min(abs(corners-m1)));
      h(1)=plot(box*T2+m2,'k');
      h(2)=plot((plus+c*j/2.5)*T2+m2,'k');
      h(3)=plot((minus-c*j/2.5)*T2+m2,'k');
      h(4)=plot(pt,'k');
      h(5)=plot(mt,'k');
      h(6)=plot([m1 corners(ci)],':b');
      h(7)=plot(sch(i,2:3),'k');
      h(8)=patch(real(curr+m1),imag(curr+m1),'k');
      h(9)=text(real(tpos(1)),imag(tpos(1)),['H_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(10)=text(real(tpos(2)),imag(tpos(2)),['r=' num2scic(sch(i,8),n,'')],'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 5
      %VCCS
      [tpos,halign,valign,angl]=textrot(phi2,m2,c*1.2);
      pt=[sch(i,4) m2+c*j*T2];
      mt=[sch(i,5) m2-c*j*T2];
      corners=box*T2+m2;
      ci=find(abs(corners-m1)==min(abs(corners-m1)));
      h(1)=plot(box*T2+m2,'k');
      h(2)=plot(arrow*T2+m2,'k');
      h(3)=plot(pt,'k');
      h(4)=plot(mt,'k');
      h(5)=plot([m1 corners(ci)],':r');
      h(6)=plot(x1(1),y1(1),'ko');
      h(7)=plot(x1(2),y1(2),'ko'); set(h(7),'markerface','k')
      h(8)=text(real(tpos(1)),imag(tpos(1)),['G_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(9)=text(real(tpos(2)),imag(tpos(2)),['g=' num2scic(sch(i,8),n,'')],'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 6
      %CCCS
      [tpos,halign,valign,angl]=textrot(phi2,m2,c*1.2);
      pt=[sch(i,4) m2+c*j*T2];
      mt=[sch(i,5) m2-c*j*T2];
      corners=box*T2+m2;
      ci=find(abs(corners-m1)==min(abs(corners-m1)));
      h(1)=plot(box*T2+m2,'k');
      h(2)=plot(arrow*T2+m2,'k');
      h(3)=plot(pt,'k');
      h(4)=plot(mt,'k');
      h(5)=plot([m1 corners(ci)],':b');
      h(6)=plot(sch(i,2:3),'k');
      h(7)=patch(real(curr+m1),imag(curr+m1),'k');
      h(8)=text(real(tpos(1)),imag(tpos(1)),['F_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(9)=text(real(tpos(2)),imag(tpos(2)),['b=' num2scic(sch(i,8),n,'')],'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 7
      %RESISTOR
      [tpos,halign,valign,angl]=textrot(phi1,m1,c*.8);
      R=c*([1 -1 -1 1 1]/3+j*[1 1 -1 -1 1])*T1;
      pt=[sch(i,2) m1+c*j*T1];
      mt=[sch(i,3) m1-c*j*T1];
      h(1)=plot(R+m1,'k');
      h(2)=plot(pt,'k');
      h(3)=plot(mt,'k');
      h(4)=text(real(tpos(1)),imag(tpos(1)),['R_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(5)=text(real(tpos(2)),imag(tpos(2)),num2scic(sch(i,8),n,'\Omega'),'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 8
      %CAPACITOR
      [tpos,halign,valign,angl]=textrot(phi1,m1,c);
      w=1/10;
      C=c*([-1 1 nan -1 1]/2+j*[1 1 nan -1 -1]*w)*T1;
      pt=[sch(i,2) m1+c*w*j*T1];
      mt=[sch(i,3) m1-c*w*j*T1];
      h(1)=plot(C+m1,'k');
      h(2)=plot(pt,'k');
      h(3)=plot(mt,'k');
      h(4)=text(real(tpos(1)),imag(tpos(1)),['C_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(5)=text(real(tpos(2)),imag(tpos(2)),num2scic(sch(i,8),n,'F'),'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 9
      %INDUCTOR
      [tpos,halign,valign,angl]=textrot(phi1,m1,c*.8);
      L=c*([1 -1 -1 1 1]/3+j*[1 1 -1 -1 1])*T1;
      pt=[sch(i,2) m1+c*j*T1];
      mt=[sch(i,3) m1-c*j*T1];
      h(1)=patch(real(L+m1),imag(L+m1),'k');
      h(2)=plot(pt,'k');
      h(3)=plot(mt,'k');
      h(4)=text(real(tpos(1)),imag(tpos(1)),['L_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
      h(5)=text(real(tpos(2)),imag(tpos(2)),num2scic(sch(i,8),n,'H'),'fontsize',fs,'horiz',halign{2},'vert',valign{2},'rot',angl(2));
   case 10
      %OP-AMP
      %nominal orientation:
      %+            -
      %  out          out
      %-            +
      m3=mean([m1 sch(i,4)]);
      x=real([m1 sch(i,4)]);
      y=imag([m1 sch(i,4)]);
      phi3=atan2(diff(y),diff(x));
      T3=exp(j*phi3);
      opamp=c*[2+0j -2+2j -2-2j 2+0j]*1.5*T3+m3;
      tt=c*[-2+j -2-j]*1.5*T3+m3;
      h(1)=plot(opamp,'k');
      if norm(sch(i,2)-tt(1))<norm(sch(i,2)-tt(2))
         h(2)=plot([sch(i,2) tt(1)],'k');
         h(3)=plot([sch(i,3) tt(2)],'k');
         h(4)=plot((plus-2*c+c*j*3/2)*T3+m3,'k');
         h(5)=plot((minus-2*c-c*j*3/2)*T3+m3,'k');
      else
         h(2)=plot([sch(i,2) tt(2)],'k');
         h(3)=plot([sch(i,3) tt(1)],'k');
         h(4)=plot((plus-2*c-c*j*3/2)*T3+m3,'k');
         h(5)=plot((minus-2*c+c*j*3/2)*T3+m3,'k');
      end
      h(6)=plot([opamp(1) sch(i,4)],'k');
      [tpos,halign,valign,angl]=textrot(phi3,m3,0);
      h(7)=text(real(m3),imag(m3),['A_{' int2str(num) '}'],'fontsize',fs,'horiz','c','vert','m');
   case 11
      %DIODE
      [tpos,halign,valign,angl]=textrot(phi1,m1,c*.8);
      h=1/2;
      w=1/2;
      anod=c*([1 -1 0 1]*w+j*[1 1 -1 1]*h)*T1;
      katod=c*([-1 1]*w+j*[-1 -1]*h)*T1;
      h(1)=patch(real(anod+m1),imag(anod+m1),'k');
      h(2)=plot(katod+m1,'k');
      h(3)=plot(sch(i,2:3),'k');
      h(4)=text(real(tpos(1)),imag(tpos(1)),['D_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
   case 16
      %BLOCK
      symb=cmlib('sym',sch(i,7));
      rot=sch(i,1+symb.rotax);
      rotax=[mean(rot(1:2)) mean(rot(3:4))];
      m=mean(rotax);
      dx=diff(real(rotax));
      dy=diff(imag(rotax));
      phi=atan2(dy,dx);
      T=exp(j*phi);
      %should treat flipping here!
      [tpos,halign,valign,angl]=textrot(phi,m,symb.dx,symb.ang);
      h=[];
      for k=1:length(symb.patch);
         h(k)=patch(real(symb.patch{k}*T)+real(m),imag(symb.patch{k}*T)+imag(m),'k');
         set(h(k),'facec',symb.patchcol{k},'edgec',symb.patchcol{k})
      end
      len=length(h);
      for k=1:length(symb.line)
         h(k+len)=line(real(symb.line{k}*T)+real(m),imag(symb.line{k}*T)+imag(m));
         set(h(k+len),'color',symb.linecol{k})
      end
      len=length(h);
      for k=1:length(symb.term)
         tline=[sch(i,k+1) symb.term(k)*T+m];
         h(k+len)=plot(real(tline),imag(tline),'k');
      end
      len=length(h);
      h(len+1)=text(real(tpos(1)),imag(tpos(1)),[symb.label '_{' int2str(num) '}'],'fontsize',fs,'horiz',halign{1},'vert',valign{1},'rot',angl(1));
   end
   set(h,'userdata',[sch(i,1) i h])
end
axis(axis+[-1 1 -1 1]/2)
axis equal
if ~ish, hold off,end

function fname=fixedfont
cmp=computer;
switch(cmp(1:2))
case 'PC'
   fname='courier';
case 'MA'
   fname='monaco';
otherwise
   fname='fixed';
end

function [tpos,halign,valign,angl]=textrot(phi,m,dx,ang)
% phi=0 deg:
% -  Lbl +
% o------o
%    Val
%
%tpos(1) : Lbl
%tpos(2) : Val
%halign(1) : Lbl
%...
if nargin==3, ang=0;end                 %angular offset for text
phi0=pi/180*ang;
phi=mod(mod(phi,pi),pi);     %an extra mod to be sure
T=exp(j*(phi+phi0));
if phi>pi/4 & phi<=3*pi/4
   tpos=m+[1 -1]*j*dx*T;
   halign={'right','left'};
   valign={'middle','middle'};
   angl=phi*180/pi*[1 1]-90;
elseif phi>3*pi/4 & phi<=pi
   tpos=m+[-1 1]*j*dx*T;
   halign={'center','center'};
   valign={'baseline','cap'};
   angl=phi*180/pi*[1 1]-180;
else
   tpos=m+[1 -1]*j*dx*T;
   halign={'center','center'};
   valign={'baseline','cap'};
   angl=phi*180/pi*[1 1];
end