function sch=ecsim(sch,cb)
%ECSIM  Electronic Circuit Simulation In Matlab.
%   ECSIM
%   ECSIM(IN)
%   OUT = ECSIM
%   OUT = ECSIM(IN)
%   where IN is the input schematic matrix
%   and OUT is the output schematic matrix.
%
%   This program is a GUI for circuit design and simulation.
%   It currently features steady-state simulation and sweeping
%   of component parameters (excluding blocks).
%   Transient analysis is not yet developed but might be available
%   in the future if the interest is high enough, and in that case
%   it will be part of a purchasable version which would suggest that
%   this program is a demo.
%   Other limitations (or child diseases) in this software is:
%      - Unable to resolve zero ohm impedances.
%      - Cannot flip components (except for op-amps).
%      - Cannot simulate steady state with mixed frequencies.
%      - Nonlinear devices might cause the Newton-Rhapson solver
%        to stall.
%      - It is not possible to copy, move or rotate an object
%        when it has been placed.
%      - The logarithmic sweep is only decadic, which means it only
%        yields an integer resolution on the mantissa part.
%        (I could just as well have used LOGSPACE instead).
%      - Be careful on which windows you have active. ECSIM
%        might confuse them.
%
%   I hope it will work satisfactory despite these facts and that
%   you will gain some insight on how a circuit simulator might work.
%
%   See also SCH2NET, NET2MAT, SCHPLOT, VALPLOT.

% Copyright (c) 2003-08-31, B. Rasmus Anthin.
% Revision 2003-09-01 - 2003-09-06, 2003-09-09, 2003-09-23.

%%%%%%%% callbacks %%%%%%%%%%

if nargin==2
   global hfig hmenu gsch snap %figsiz
   set(hfig,'windowstyle','normal')
   figure(hfig)
   ax=axis;
   cla
   snapgrid(snap)
   schplot(gsch)
   axis equal,axis(ax)
   p=[];
   clear i x y
   flag=1;
   %INVOKE CALLBACK SPECIFIC ROUTINES
   %(very cluttered and messy)
   switch(cb)
   case -2
      n=2;
      toolguide={'place starting point','place end point'};
   case {-1,-3,0}
      n=1;
      toolguide={'click on location'};
   case {1,2}
      n=2;
      toolguide={'place positive terminal','place negative terminal'};
   case {7,8,9}
      n=2;
      toolguide={'place connection terminal','place connection terminal'};
   case {3,4,5,6}
      n=4;
      toolguide={'place positive control terminal','place negative control terminal', ...
            'place positive source terminal','place negative source terminal'};
   case 10
      n=3;
      toolguide={'place positive input terminal','place negative input terminal', ...
            'place output terminal'};
   case 11
      n=2;
      toolguide={'place anode','place cathode'};
   case 16
      %BLOCK
      load cmlib
      ids=sort([lib.id]);
      id=ids(get(gcbo,'val'));
      term=cmlib('term',id);
      if length(term)<=2
         n=length(term);
         for k=1:n
            toolguide{k}=['place the ' term{k} ' terminal'];
         end
      else
         n=1;
         toolguide={'place component (center point)'};
      end
   case 21
      %EDIT
      flag=0;
      while 1
         title('click on component to edit')
         xlabel('right click resumes')
         ginput(1);
         title(''),xlabel(''), drawnow
         if ~strcmp(get(gcf,'selectiontype'),'normal')
            break
         end
         ud=get(gco,'userdata');
         if ~isempty(ud) & ~iscell(ud) & ~isstruct(ud)
            num=symbenum(gsch,ud(2));
            if 1<=ud(1) & ud(1)<=9
               vstr=get(ud(end-1),'string');
               vstr=[vstr(1) int2str(num)];
            end
            switch(ud(1))
            case 1, ustr='V';
            case 2, ustr='A';
            case 3, ustr='V/V';
            case 4, ustr='V/A';
            case 5, ustr='A/V';
            case 6, ustr='A/A';
            case 7, ustr='ohm';
            case 8, ustr='F';
            case 9, ustr='L';
            end
            switch(ud(1))
            case {1,2,3,4,5,6,7,8,9}
               vald=gsch(ud(2),8);
               valo=inputdlg([vstr '  [' ustr ']'],'Enter component value',1,{num2str(vald)});
               if isempty(valo)
                  valo=vald;
               else
                  valo=str2num(valo{1});
               end
               gsch(ud(2),8)=valo;
            case 11
               vald={'1e-14' '1' '25e-3' '0' '0' '1' '0.5'};
               for k=1:7
                  if ~isnan(gsch(ud(2),k+7))
                     vald{k}=num2str(gsch(ud(2),k+7));
                  end
               end
               valo=inputdlg({'Is' 'n' 'vT' 'tT' 'Cj0' 'V0' 'm'},'Enter model parameters',1,vald);
               if isempty(valo)
                  valo=str2num(char(vald))';
               else
                  valo=str2num(char(valo))';
               end
               gsch(ud(2),8:14)=valo;
            case 16
               def=cmlib('def',gsch(ud(2),7));
               param=cmlib('param',gsch(ud(2),7));
               for k=1:length(def)
                  if ~isnan(gsch(ud(2),k+7))
                     vald{k}=num2str(gsch(ud(2),k+7));
                  else
                     vald{k}=num2str(def(k));
                  end
               end
               valo=inputdlg(param,'Enter model parameters',1,vald);
               if isempty(valo)
                  valo=str2num(char(vald))';
               else
                  valo=str2num(char(valo))';
               end
               gsch(ud(2),7+(1:length(def)))=valo;
            end
            cla
            snapgrid(snap)
            schplot(gsch)
            axis equal, axis(ax)
            drawnow
            break
         end
      end
   case 22
      %DELETE
      flag=0;
      while 1
         title('click on component to delete')
         xlabel('right click resumes')
         ginput(1);
         title(''),xlabel(''), drawnow
         if ~strcmp(get(gcf,'selectiontype'),'normal')
            break
         end
         ud=get(gco,'userdata');
         if ~isempty(ud) & ~iscell(ud)
            k=1:size(gsch,1);
            k=setdiff(k,ud(2));
            gsch=gsch(k,:);
            cla
            snapgrid(snap)
            schplot(gsch)
            axis equal, axis(ax)
            drawnow
         end
      end
   case 23
      %SIMULATE
      flag=0;
      if isempty(gsch) | ~any(~gsch(:,1))
         errordlg('Cannot simulate without a ground point.','Ground point missing')
      elseif ~any(gsch(:,1)>0)
         errordlg('Must place components before simulating.','Components missing');
      else
         h=dialog('name','Simulation method','handlevis','on','windowstyle','normal');
         pos=get(h,'pos');
         set(h,'pos',[pos(1:2) 300 60])
         global foo
         uicontrol('style','push','string','Steady state','pos',[10 10 80 20],'callback','global foo, foo=''ss''; uiresume')
         uicontrol('style','push','string','Sweep','pos',[110 10 80 20],'callback','global foo, foo=''sweep''; uiresume')
         uicontrol('style','push','string','Transient','pos',[210 10 80 20],'callback','global foo, foo=''trans''; uiresume')
         uiwait
         close(h)
         global foo
         switch(foo)
         case 'ss'
            freq=inputdlg({'f [Hz]'},'Input frequency',1,{'0'});
            if isempty(freq)
               clear sch
               return
            else
               freq=str2num(freq{1});
            end
            net=sch2net(gsch);
            [G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl]=net2mat(net,freq,1e-10);
            [vn,vbl,ivs,ivv,icv,icc,ioa,ibl]=mat2val(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl);
            figure(hfig)
            cla
            snapgrid(snap)
            schplot(gsch)
            valplot(gsch,vn,ivs,ivv,icv,icc,ioa,[],3)
            axis equal, axis(ax)
            drawnow
         case 'sweep'
            %sweep options
            hh=dialog('name','Sweep','handlevis','on','windowstyle','normal');
            cmpidx=find(gsch(:,1)>0 & gsch(:,1)<10);
            cmplen=length(cmpidx);
            ymax=20*(cmplen+1)+80;
            pos=get(hh,'pos');
            set(hh,'pos',[pos(1) pos(2)+pos(4)-ymax 100 ymax]);
            clear global h
            clear h
            global h
            for k=1:cmplen
               K=cmpidx(k);           %component index
               num=symbenum(gsch,K);  %component enumeration
               h(k)=uicontrol('style','radio','pos',[10 ymax-20*(k+1) 90 20]);
               switch(gsch(K,1))
               case 1, lbl='U';
               case 2, lbl='I';
               case 3, lbl='E';
               case 4, lbl='H';
               case 5, lbl='G';
               case 6, lbl='F';
               case 7, lbl='R';
               case 8, lbl='C';
               case 9, lbl='L';
               otherwise, set(h(k),'enable','off')
               end
               set(h(k),'string',[' ' lbl num2str(num)]);
            end
            set(h(1),'val',1)
            h(cmplen+1)=uicontrol('style','radio','pos',[10 ymax-20*(k+2) 80 20],'string',' frequency');
            set(h,'callback','global h, set(h,''val'',0), set(gcbo,''val'',1)')
            hlog=uicontrol('style','check','pos',[10 ymax-20*(k+3) 80 20],'string',' logarithmic');
            uicontrol('style','push','string','Ok','pos',[10 10 40 20],'callback','uiresume')
            uiwait
            islog=get(hlog,'val');
            isfreq=get(h(end),'val');
            if isfreq
               lbl='frequency';
            else
               k=find(h(1:end-1)==findobj(h(1:end-1),'val',1));
               K=cmpidx(k);
               lbl=get(h(k),'string');
               lbl=lbl(2:end);
            end
            close(hh)
            %sweep limits
            hh=dialog('handlevis','on','windowstyle','normal');
            pos=get(hh,'pos');
            set(hh,'pos',[pos(1:2) 300 140])
            clear global h
            clear h
            global h
            if islog
               %logarithmic sweep
               uicontrol('style','text','string','start','pos',[10 80 40 20],'horiz','r')
               uicontrol('style','text','string','end','pos',[10 50 40 20],'horiz','r')
               uicontrol('style','text','string','mantissa','pos',[60 110 60 20],'horiz','c')
               uicontrol('style','text','string','exponent','pos',[130 110 90 20],'horiz','c')
               uicontrol('style','text','string','value','pos',[230 110 60 20])
               h(1)=uicontrol('style','slide','pos',[60 80 60 20],'min',1,'max',9,'sliderstep',[1/8 1/4],'val',1);
               h(2)=uicontrol('style','slide','pos',[130 80 90 20],'min',-300,'max',300,'sliderstep',[1/600 1/30],'val',0);
               h(3)=uicontrol('style','text','pos',[230 80 60 20],'string','1e0');
               set(h(1),'callback',['global h,' ...
                     'm=get(h(1),''val'');' ...
                     'e=get(h(2),''val'');' ...
                     's='''';' ...
                     'if sign(e)<0,' ...
                     '   s=''-'';' ...
                     'elseif sign(e)>0,' ...
                     '   s=''+'';' ...
                     'end,' ...
                     'set(h(3),''string'',[int2str(m) ''e'' s int2str(abs(e))])' ...
                  ])
               set(h(2),'callback',get(h(1),'callback'))
               h(4)=uicontrol('style','slide','pos',[60 50 60 20],'min',1,'max',9,'sliderstep',[1/8 1/4],'val',1);
               h(5)=uicontrol('style','slide','pos',[130 50 90 20],'min',-300,'max',300,'sliderstep',[1/600 1/30],'val',1);
               h(6)=uicontrol('style','text','pos',[230 50 60 20],'string','1e1');
               set(h(4),'callback',['global h,' ...
                     'm=get(h(4),''val'');' ...
                     'e=get(h(5),''val'');' ...
                     's='''';' ...
                     'if sign(e)<0,' ...
                     '   s=''-'';' ...
                     'elseif sign(e)>0,' ...
                     '   s=''+'';' ...
                     'end,' ...
                     'set(h(6),''string'',[int2str(m) ''e'' s int2str(abs(e))])' ...
                  ])
               set(h(5),'callback',get(h(4),'callback'))
               set(hh,'name',['Sweep ' lbl ' (logarithmic)'])
            else
               %linear sweep
               uicontrol('style','text','string','start','pos',[10 110 40 20],'horiz','r')
               uicontrol('style','text','string','end','pos',[10 80 40 20],'horiz','r')
               uicontrol('style','text','string','step','pos',[10 50 40 20],'horiz','r')
               h(1)=uicontrol('style','edit','string','0','pos',[60 110 100 20]);
               h(2)=uicontrol('style','edit','string','10','pos',[60 80 100 20]);
               h(3)=uicontrol('style','edit','string','1','pos',[60 50 100 20]);
               set(hh,'name',['Sweep ' lbl ' (linear)'])
            end
            uicontrol('style','push','string','Ok','pos',[10 10 40 20],'callback','uiresume')
            uiwait
            if islog
               vals=logsp(str2num(get(h(3),'string')),str2num(get(h(6),'string')));
            else
               vals=str2num(get(h(1),'string')):str2num(get(h(3),'string')):str2num(get(h(2),'string'));
            end
            close(hh)
            %select output node
            [net,isch,N]=sch2net(gsch);
            hold on
            clear h
            for k=1:length(N)
               h(k)=plot(real(N(k)),imag(N(k)),'*');     %real/imag for plot correctly when N is real
            end
            set(h,'color',[0 .5 0],'markersize',8)
            while 1
               title('select output node')
               ginput(1);
               title(''), drawnow
               if strcmp(get(gco,'type'),'line') & strcmp(get(gco,'marker'),'*')
                  x=get(gco,'xdata');%x=x(1);
                  y=get(gco,'ydata');%y=y(1);
                  n=find(x+y*i==N);
                  break
               end
            end
            delete(h)
            set(plot(real(N(n)),imag(N(n)),'*'),'color',[0 .5 0],'markersize',8)
            hold off
            %start sweeping
            if ~isfreq
               freq=inputdlg({'f [Hz]'},'Input frequency',1,{'0'});
               if isempty(freq)
                  freq=0;
               else
                  freq=str2num(freq{1});
               end
            end
            hw=waitbar(0,'Sweeping...');
            in=vals;out=[];
            sch=gsch;
            for k=1:length(vals)
               if isfreq
                  freq=vals(k);
               else
                  sch(K,8)=vals(k);
                  net=sch2net(sch);
               end
               [G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl]=net2mat(net,freq,1e-10);
               [vn,vbl,ivs,ivv,icv,icc,ioa,ibl]=mat2val(G,B,C,D,Is,Ibl,Vs,Vvv,Vcv,Vcc,Voa,Vbl);
               out(k)=vn(n);
               waitbar(k/length(vals))
            end
            close(hw)
            global sweepnum
            sweepnum=sweepnum+1;
            hsweep=figure;
            set(hsweep,'numbertitle','off','name',['Sweep ' int2str(sweepnum)])
            if isfreq
               xlbl='f [Hz]';
            else
               xlbl=[lbl(1) '_{' lbl(2:end) '}'];
            end
            linestyle='-';
            if islog
               if any(imag(out))
                  subplot(2,1,1)
                  semilogx(in,20*log10(abs(out)),linestyle)
                  xlabel(xlbl)
                  ylabel(['20log_{10}|v_{' int2str(n) '}| [dBV]'])
                  grid
                  title('Bode plot')
                  subplot(2,1,2)
                  semilogx(in,180/pi*unwrap(angle(out)),linestyle)
                  xlabel(xlbl)
                  ylabel(['\angle v_{' int2str(n) '} [\circ]'])
                  grid
               else
                  semilogx(in,out,linestyle)
                  xlabel(xlbl)
                  ylabel(['v_{' int2str(n) '} [V]'])
                  grid
               end
            else
               if any(imag(out))
                  subplot(2,1,1)
                  plot(in,abs(out),linestyle)
                  xlabel(xlbl)
                  ylabel(['|v_{' int2str(n) '}| [V]'])
                  grid
                  subplot(2,1,2)
                  plot(in,180/pi*unwrap(angle(out)),linestyle)
                  xlabel(xlbl)
                  ylabel(['\angle v_{' int2str(n) '} [\circ]'])
                  grid
               else
                  plot(in,out,linestyle)
                  xlabel(xlbl)
                  ylabel(['v_{' int2str(n) '} [V]'])
                  grid
               end
            end
            figure(hsweep)
         case 'trans'
            %THIS IS FOR REGISTERED SHAREWARE USERS ONLY!
            msgbox('This feature is available in the full version!','Shareware notice')
         end
      end
   case 24
      %AXIS
      flag=0;
      axlimdlg
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %CREATE COMPONENT (common routine for case -3 - 16)
   while flag          %do not enter this loop when edit, delete, simulate or axis
      for k=1:n
         title(toolguide{k})
         xlabel('right click resumes')
         [x,y]=ginput(1);
         title(''),xlabel(''), drawnow
         if ~strcmp(get(gcf,'selectiontype'),'normal')
            break
         end
         p(k)=round((x+y*i)/snap)*snap;
      end
      if ~strcmp(get(gcf,'selectiontype'),'normal')
         break
      end
      gsch=[gsch; NaN*ones(1,24)];
      gsch(end,1)=cb;
      if cb==16 & length(term)>2
         symb=cmlib('sym',id);
         m=p;
         if symb.ortho
            hh=dialog('name','Enter rotation','windowstyle','normal');
            pos=get(hh,'pos');
            set(hh,'pos',[pos(1:2) 200 75])
            clear h
            clear global h
            global h
            h(1)=uicontrol('style','radio','val',1,'pos',[10 50 40 20],'string',' 0','horiz','l');
            h(2)=uicontrol('style','radio','val',0,'pos',[60 50 40 20],'string',' 90','horiz','l');
            h(3)=uicontrol('style','radio','val',0,'pos',[110 50 40 20],'string',' 180','horiz','l');
            h(4)=uicontrol('style','radio','val',0,'pos',[160 50 40 20],'string',' 270','horiz','l');
            set(h,'callback','global h, set(h,''val'',0), set(gcbo,''val'',1)')
            uicontrol('style','push','string','Ok','pos',[10 10 40 20],'callback','uiresume')
            uiwait
            phi=pi*(find(findobj(h,'val',1)==h)-1)/2;
            close(hh)
         else    %I don't think this part will ever be used
            phi=inputdlg('phi [deg]','Enter rotation',1,{'0'});
            if isempty(phi)
               phi=0;
            else
               phi=num2str(phi{1})*pi/180;
            end
         end
         T=exp(j*phi);
         gsch(end,(1:length(term))+1)=symb.term*T+m;
      else
         gsch(end,(1:length(p))+1)=p;
      end
      if 0<cb & cb<10
         gsch(end,8)=0;
      elseif cb==16
         gsch(end,7)=id;
      end
      figure(hfig)
      cla
      snapgrid(snap)
      schplot(gsch)
      axis equal, axis(ax)
   end
   clear sch
   figure(hmenu)
   return
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% MAIN ROUTINE %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin
   sch=[];
   ax=[0 10 0 10];
else
   sch=[sch NaN*ones(size(sch,1),24-size(sch,2))];
   sch2=sch; sch2(isnan(sch2))=NaN+NaN*j;
   ax(1)=min(min(real(sch2(:,2:6))))-1;
   ax(2)=max(max(real(sch2(:,2:6))))+1;
   ax(3)=min(min(imag(sch2(:,2:6))))-1;
   ax(4)=max(max(imag(sch2(:,2:6))))+1;
end
clear global
global hfig hmenu gsch snap sweepnum
sweepnum=0;
snap=1/2;
gsch=sch;
hfig=figure;
set(hfig,'menubar','none','numbertitle','off','name','Circuit')
hold off
axis equal, axis(ax)
cla
snapgrid(snap)
schplot(sch)
axis equal, axis(ax)
hmenu=dialog('name','EC-SIM','handlevis','on','windowstyle','normal');
pos=get(hmenu,'pos');
set(hmenu,'pos',[pos(1:2) 100 420])
h(1)=uicontrol('style','push','string','Line','pos',[5 390 90 20],'callback','ecsim([],-2)');
h(2)=uicontrol('style','push','string','Dot','pos',[5 370 90 20],'callback','ecsim([],-1)');
h(3)=uicontrol('style','push','string','Terminal','pos',[5 350 90 20],'callback','ecsim([],-3)');
h(4)=uicontrol('style','push','string','Ground','pos',[5 330 90 20],'callback','ecsim([],0)');
h(5)=uicontrol('style','push','string','VS','pos',[5 300 45 20],'callback','ecsim([],1)');
h(6)=uicontrol('style','push','string','CS','pos',[50 300 45 20],'callback','ecsim([],2)');
h(7)=uicontrol('style','push','string','VCVS','pos',[5 280 45 20],'callback','ecsim([],3)');
h(8)=uicontrol('style','push','string','VCCS','pos',[50 280 45 20],'callback','ecsim([],5)');
h(9)=uicontrol('style','push','string','CCVS','pos',[5 260 45 20],'callback','ecsim([],4)');
h(10)=uicontrol('style','push','string','CCCS','pos',[50 260 45 20],'callback','ecsim([],6)');
h(11)=uicontrol('style','push','string','Resistor','pos',[5 230 90 20],'callback','ecsim([],7)');
h(12)=uicontrol('style','push','string','Capacitor','pos',[5 210 90 20],'callback','ecsim([],8)');
h(13)=uicontrol('style','push','string','Inductor','pos',[5 190 90 20],'callback','ecsim([],9)');
h(14)=uicontrol('style','push','string','Op-Amp','pos',[5 160 90 20],'callback','ecsim([],10)');
h(15)=uicontrol('style','push','string','Diode','pos',[5 140 90 20],'callback','ecsim([],11)');
load cmlib
h(16)=uicontrol('style','popup','string',{lib([lib.id]).name},'pos',[5 120 90 20],'callback','ecsim([],16)');
h(17)=uicontrol('style','push','string','Edit','pos',[5 85 90 20],'callback','ecsim([],21)');
h(18)=uicontrol('style','push','string','Delete','pos',[5 65 90 20],'callback','ecsim([],22)');
h(19)=uicontrol('style','push','string','Simulate','pos',[5 45 90 20],'callback','ecsim([],23)');
h(20)=uicontrol('style','push','string','Axis','pos',[5 25 90 20],'callback','ecsim([],24)');
h(21)=uicontrol('style','push','string','Exit','pos',[5 5 90 20],'callback','uiresume');
uiwait
global gsch
sch=gsch;
close(hmenu)
figure(hfig)
ax=axis;
clear global foo gsch h hfig hmenu lib matpath snap sweepnum
if ~nargout, clear sch,end