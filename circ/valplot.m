function valplot(sch,vn,ivs,ivv,icv,icc,ioa,fs,n)
%VALPLOT  Plots voltages and currents on schematic.
%   VALPLOT(SCHEMATIC,vn,ivs,ivv,icv,icc,ioa[,FS[,N]])
%   plots values vn, ivs, ivv, icv, icc and ioa
%   retrieved from MAT2VAL on the corresponding circuit
%   schematic SCHEMATIC using fontsize FS (10) and with
%   N digits of precision (variable).
%   Alignments for currents and voltages depend only on the
%   tilt of the component they belong to, thus making the text
%   interfere with the text and line objects from the schematic
%   (which is plotted using SCHPLOT).
%
%   See also ECSIM, SCHPLOT, MAT2VAL.

% Copyright (c) 2003-08-24, B. Rasmus Anthin.
% Revision 2003-08-25, 2003-08-29, 2003-08-31.


%fix:
%   * rotation and alignment

error(nargchk(7,9,nargin))
if nargin<8 | isempty(fs), fs=10;end
if nargin<9, n=[];end
[net,isch,N]=sch2net(sch);
c=1/3;
curr1=c*([1 -1 0 1]+j*[1 1 -1 1])/4;
%         |
%  -1,1  ---  1,1
%        \ /
%         V
%        0,-1
curr2=c*([1 -1 0 1]+j*[1 1 -1 1]-6j)/4;
ish=ishold;
hold on

%terminals
sch_t=sch(find(sch(:,1)==-3),:);
for i=1:length(N)
   for k=1:size(sch_t,1)
      if isch(k,1)==-2
         if sch_t(i,2)==isch(k,2)
            I=find(N==isch(i,3));
            N=N([1:N-1 N+1:end]);
            break
         elseif sch_t(i,3)==isch(k,2)
            I=find(N==isch(i,2));
            N=N([1:N-1 N+1:end]);
            break
         end
      end
   end
end

%node voltages
if ~isempty(vn)
   for i=1:length(N)
      text(real(N(i))+1/5,imag(N(i))+1/5,num2scic(vn(i),n,'V'),'color','r','fontsize',fs)
      plot(real(N(i)),imag(N(i)),'.r')
   end
end

%voltage source currents
sch_vs=sch(find(sch(:,1)==1),:);
for i=1:length(ivs)
   m=mean(sch_vs(i,2:3));
   dx=diff(real(sch_vs(i,2:3)));
   dy=diff(imag(sch_vs(i,2:3)));
   phi=atan2(dy,dx);
   T=exp(j*(phi+3*pi/2));
   set(patch(real(curr2*T+m),imag(curr2*T+m),'b'),'edgec','b')
   tpos=c*(1+1/5+j)*exp(j*(phi+pi/2))+m;
   text(real(tpos),imag(tpos),num2scic(-ivs(i),n,'A'),'color','b','fontsize',fs,'horiz','l','vert','m','rot',180/pi*phi+90)
end

%VCVS currents
sch_vv=sch(find(sch(:,1)==3),:);
for i=1:length(ivv)
   m=mean(sch_vv(i,4:5));
   dx=diff(real(sch_vv(i,4:5)));
   dy=diff(imag(sch_vv(i,4:5)));
   phi=atan2(dy,dx);
   T=exp(j*(phi+3*pi/2));
   %source
   set(patch(real(curr2*T+m),imag(curr2*T+m),'b'),'edgec','b')
   tpos=c*(1+1/5+j)*exp(j*(phi+pi/2))+m;
   text(real(tpos),imag(tpos),num2scic(-ivv(i),n,'A'),'color','b','fontsize',fs,'horiz','l','vert','m','rot',180/pi*phi+90)
end

%CCVS currents
sch_cv=sch(find(sch(:,1)==4),:);
for i=1:length(icv)/2
   m(1)=mean(sch_cv(i,2:3));
   m(2)=mean(sch_cv(i,4:5));
   dx(1)=diff(real(sch_cv(i,2:3)));
   dy(1)=diff(imag(sch_cv(i,2:3)));
   dx(2)=diff(real(sch_cv(i,4:5)));
   dy(2)=diff(imag(sch_cv(i,4:5)));
   phi=atan2(dy,dx);
   T=exp(j*(phi+[-3 3]*pi/2));
   %control
   set(patch(real(curr1*T(1)+m(1)),imag(curr1*T(1)+m(1)),'b'),'edgec','b')
   tpos=c/4*(1+j)*exp(j*phi(1))+m(1);
   text(real(tpos),imag(tpos),num2scic(icv(2*i-1),n,'A'),'color','b','fontsize',fs,'horiz','l','vert','m','rot',180/pi*phi(1))
   %source
   set(patch(real(curr2*T(2)+m(2)),imag(curr2*T(2)+m(2)),'b'),'edgec','b')
   tpos=c*(1+1/5+j)*exp(j*(phi(2)+pi/2))+m(2);
   text(real(tpos),imag(tpos),num2scic(-icv(2*i),n,'A'),'color','b','fontsize',fs,'horiz','l','vert','m','rot',180/pi*phi(2)+90)
end

%CCCS currents
sch_cc=sch(find(sch(:,1)==6),:);
for i=1:length(icc)
   m=mean(sch_cc(i,2:3));
   dx=diff(real(sch_cv(i,2:3)));
   dy=diff(imag(sch_cv(i,2:3)));
   phi=atan2(dy,dx);
   T=exp(j*(phi-3*pi/2));
   %control
   set(patch(real(curr1*T+m),imag(curr1*T+m),'b'),'edgec','b')
   tpos=c/4*(1+j)*exp(j*phi)+m;
   text(real(tpos),imag(tpos),num2scic(icc(i),n,'A'),'color','b','fontsize',fs)
end

%Op-amp currents
sch_oa=sch(find(sch(:,1)==10),:);
for i=1:length(ioa)
   m1=mean(sch_oa(i,2:3));
   m3=mean([m1 sch_oa(i,4)]);
   x=real([m1 sch_oa(i,4)]);
   y=imag([m1 sch_oa(i,4)]);
   phi=atan2(diff(y),diff(x));
   T=exp(j*phi);
   set(patch(real((curr1*exp(j*pi/2)+c*4)*T+m3),imag((curr1*exp(j*pi/2)+c*4)*T+m3),'b'),'edgec','b')
   tpos=c*(4+j)*T+m3;
   text(real(tpos),imag(tpos),num2scic(-ioa(i),n,'A'),'color','b','fontsize',fs)
end

if ~ish, hold off,end