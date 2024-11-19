function H=mpaint(ah)
%MPAINT  Paint program.
%   H = MPAINT([AH]) returns a vector of handles each corresponding
%   to an object in the figure when in create- or copy-mode.
%   AH is the axis handle (optional).
%
%   MPAINT will first ask you whether you want to create
%   an object (1), move an object (2), copy an object (3),
%   delete an object (4), change color (5), change depth (6),
%   edit text (7), undo an operation (8), redo an operation (9)
%   or clear the undo stack of the current axes (10).
%
%   If you choose to create an object, MPAINT will ask some questions
%   about the object(s) you want to draw:
%
%   1. Grid
%      Input a positive integer if you want a grid to be drawn or just
%      press enter key otherwise.
%      The integer determines the grid spacing.
%      The grid is automatically deleted when the program terminates.
%
%   2. Object
%      Enter which object type you wish to be drawn.
%         l  : line (default)
%         c  : circle
%         e  : ellipse
%         lf : filled polygon
%         cf : filled circle
%         ef : filled ellipse
%         v  : vector
%         t  : text
%
%   3. Color
%      Any of the characters
%         y, m, c, r, g, b, w, k
%      or an RGB-vector.
%
%   4. Depth
%      Alter the depth of the object.
%      Enter a positive integer to bring object forward, and
%      enter a negative integer to bring object backwards.
%      (Default: 0).
%
%   4. Line Style
%      (For non-filled and non-text objects only)
%      Here you input any of the following strings
%         -  : solid (default)
%         :  : dotted
%         -. : dashdot
%         -- : dashed
%
%   5. Line Width
%      (For non-filled and non-text objects only)
%      Input the line width in pixels.
%      Non-solid lines will not be affected.
%      (Default: 0).
%
%   6. Text String
%      (Only for text objects)
%      Input the string to be displayed.
%
%   7. Text Rotation Angle
%      (Only for text objects)
%      Input the rotation angle for the specified text.
%      The direction is counter clockwise.
%      (Default: 0 deg).
%
%   8. Text Size
%      (Only for text objects)
%      Input the font size in points.
%      (Default: 10).
%
%   9. Text Weight
%      (Only for text objects)
%      Input the font weight for the text:
%         n : normal (default)
%         b : bold
%
%   10. Italics
%      (Only for text objects)
%      Set to 1 if true, 0 otherwise.
%      (Default: 0).
%
%   11. Text Alignment
%      (Only for text objects)
%      Input the horizontal alignment for the text:
%         l : left (default)
%         c : center
%         r : right
%
%   12. Text Font Name
%      (Only for text objects)
%      Input the font name for the text.
%      (Default: Helvetica).
%
%   In line mode click to add a line node.
%   In circle mode, first click on the center point and
%   then on "its radius".
%   In ellipse mode, first click on the center point and
%   then on the point corresponding to half its short axis
%   and half its long axis.
%   Click with the right mouse key in order to stop (exit).
%
%   Example:
%      h{1}=mpaint;
%      h{2}=mpaint;
%      h{3}=mpaint;
%      delete(h{2})   %Undo draw object(s) part 2.
%
%   See also PICTEX.

% Copyright (c) 2001-09-05, B. Rasmus Anthin.
%Revisited 2001-09-30.

if ~nargin,ah=gca;end;
set(get(ah,'parent'),'pointer','arrow')
held=ishold;hold on

while 1
   if isempty(get(ah,'user'))
      mpptr=0;
      mpstack={};
   else
      data=get(ah,'user');
      mpptr=data.mpptr;
      mpstack=data.mpstack;
   end
   grdh=[];
   
   mainh=figure;
   set(mainh,'position',[10 300 100 410])
   set(mainh,'menubar','none')
   mainstr={'Create Object','Move Object','Copy Object','Delete Object',...
         'Change Color','Change Depth','Edit Text','Undo','Redo','Clear Undo Stack'};
   for i=1:length(mainstr)
      butth(i)=uicontrol(mainh,'position',[5 410-i*30 95 20],'string',mainstr{i},'tag',int2str(i));
   end
   while 1
      waitforbuttonpress
      if ~strcmp(get(gcf,'selectiontype'),'normal'),close(mainh),return,end
      if ~isempty(gco) & any(gco==butth)
         action=str2num(get(gco,'tag'));
         if strcmp(get(gcf,'selectiontype'),'normal'),close(mainh),break,end
      end
   end
   switch(action)
   case 1,  action='create';
   case 2,  action='move';
   case 3,  action='copy';
   case 4,  action='delete';
   case 5,  action='color';
   case 6,  action='depth';
   case 7,  action='edit';
   case 8,  action='undo';
   case 9,  action='redo';
   case 10, action='clear';
   otherwise, return
   end
   op.type=action;
   
   switch(action)
   case 'create'
      %----------------- CREATE OBJECT ----------------------------
      %--- MENU ---
      grd=input('Grid: ');
      if isempty(grd) | grd~=round(grd),grd=0;end
      
      type=input('Object [l lf v c cf e ef t]: ','s');
      if length(type)>1 & type(2)=='f',filled=1;else filled=0;end
      if isempty(type),type='l';end
      type=lower(type(1));
      op.obj=type;
      op.filled=filled;
      
      col=input('Color [y m c r g b w k] or RGB: ','s');
      if isempty(col),col='k';end
      if col(1)=='['
         col=eval(col);
      else
         col=lower(col(1));
      end
      op.col=col;
      
      depth=input('Depth: ');
      if isempty(depth),depth=0;end
      op.dp=depth;
      
      if ~filled & type~='t'
         style=input('Line Style [- : -. --]: ','s');
         op.ls=style;
         width=input('Line Width (pxl): ');
         if isempty(width),width=.5;end
         op.wd=width;
      end
      
      if type=='t'
         txt.str=input('Text String: ','s');
         if isempty(txt.str),txt.str='[no text]';end
         txt.rot=input('Text Rotation Angle (deg): ');
         if isempty(txt.rot),txt.rot=0;end
         txt.siz=input('Text Size (pt): ');
         if isempty(txt.siz),txt.siz=10;end
         txt.wgt=input('Text Weight [n b]: ','s');
         if isempty(txt.wgt),txt.wgt='n';end
         txt.wgt=lower(txt.wgt(1));
         txt.it=input('Italics?: ');
         if isempty(txt.it),txt.it=0;end
         if txt.it, txt.it='i';else txt.it='n';end
         txt.align=input('Text Alignment [l c r]: ','s');
         if isempty(txt.align),txt.align='l';end
         txt.fnt=input('Text Font Name: ','s');
         if isempty(txt.fnt),txt.fnt='Helvetica';end
      end
      
      %--- MAIN ---
      grdh=setgrid(ah,grd);
      
      if type~='t'
         [x0,y0,b]=ginput(1);
      else
         x0=0;y0=0;b=1;
      end
      if grd,x0=round(x0*grd)/grd;y0=round(y0*grd)/grd;end
      x=x0;y=y0;
      if type=='l'
         op.x=x0;
         op.y=y0;
      end
      hh=[];h1=[];h2=[];
      while b==1
         [x1,y1,b]=ginput(1);
         if grd,x1=round(x1*grd)/grd;y1=round(y1*grd)/grd;end
         if b~=1,break;end
         if type=='l' & ~filled
            h1=plot([x0 x1],[y0 y1],style);
            set(h1,'linewidth',width)
            setcolor(h1,col)
            op.x=[op.x x1];
            op.y=[op.y y1];
         elseif type=='l' & filled
            h1=plot([x0 x1],[y0 y1],'k');
            h2=[h2 h1];
            x=[x x1];y=[y y1];
            op.x=[op.x x1];
            op.y=[op.y y1];
         elseif type=='v'
            h1=plotvec([x0 y0],[x1 y1],style);
            set(h1(1),'linewidth',width)
            setcolor(h1,col)
            op.p1=[x0 y0];
            op.p2=[x1 y1];
            [x1,y1,b]=ginput(1);
         elseif type=='c' & ~filled
            h1=circle(sqrt((x1-x0)^2+(y1-y0)^2),[x0 y0],style);
            set(h1,'linewidth',width)
            setcolor(h1,col)
            op.origo=[x0 y0];
            op.r=sqrt((x1-x0)^2+(y1-y0)^2);
            [x1,y1,b]=ginput(1);
         elseif type=='c' & filled
            h1=fcircle(sqrt((x1-x0)^2+(y1-y0)^2),[x0 y0],col);
            op.origo=[x0 y0];
            op.r=sqrt((x1-x0)^2+(y1-y0)^2);
            [x1,y1,b]=ginput(1);
         elseif type=='e' & ~filled
            h1=ellipse([x0 y0],x1-x0,y1-y0,style);
            set(h1,'linewidth',width)
            setcolor(h1,col)
            op.origo=[x0 y0];
            op.a=x1-x0;
            op.b=y1-y0;
            [x1,y1,b]=ginput(1);
         elseif type=='e' & filled
            h1=fellipse([x0 y0],x1-x0,y1-y0,col);
            op.origo=[x0 y0];
            op.a=x1-x0;
            op.b=y1-y0;
            [x1,y1,b]=ginput(1);
         elseif type=='t'
            op.x=x1;op.y=y1;
            h1=text(x1,y1,txt.str);op.str=txt.str;
            set(h1,'rotation',txt.rot),op.rot=txt.rot;
            set(h1,'fontsize',txt.siz),op.siz=txt.siz;
            set(h1,'fontweight',txt.wgt),op.wgt=txt.wgt;
            set(h1,'fontangle',txt.it),op.it=txt.it;
            set(h1,'horizontalalignment',txt.align),op.align=txt.align;
            set(h1,'fontname',txt.fnt),op.fnt=txt.fnt;
            setcolor(h1,col)
         end
         setdepth(h1,depth)
         hh=[hh h1];
         if grd,x1=round(x1*grd)/grd;y1=round(y1*grd)/grd;end
         x0=x1;y0=y1;
         if type~='l'
            op.h=h1;
            mpptr=mpptr+1;
            mpstack{mpptr}=op;
            mpstack=resize(mpstack,mpptr);
         end
      end
      if type=='l'
         if filled
            hh=patch(x,y,col);
            delete(h2)
            set(hh,'edgec',get(hh,'facec'))
         end
         op.h=hh;
         mpptr=mpptr+1;
         mpstack{mpptr}=op;
         mpstack=resize(mpstack,mpptr);
      end
      if nargout,H=hh;end
   case 'move'
      %----------------- MOVE OBJECT ------------------------------
      %--- MENU ---
      grd=input('Grid: ');
      if isempty(grd) | grd~=round(grd),grd=0;end
      
      %--- MAIN ---
      grdh=setgrid(ah,grd);
      
      set(gcf,'pointer','crosshair')
      while 1
         waitforbuttonpress
         obj=gco(gcf);
         op.h=obj;
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         ax0=get(gca,'currentpoint');ax0=ax0(1,1:2);
         if grd,ax0=round(ax0*grd)/grd;end
         waitforbuttonpress
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         ax1=get(gca,'currentpoint');ax1=ax1(1,1:2);
         if grd,ax1=round(ax1*grd)/grd;end
         usr=get(obj,'user');
         if gcf~=obj & gca~=obj & (isempty(grdh) | all(grdh~=obj))
            if strcmp(get(obj,'type'),'text')
               op.istxt=1;
               set(obj,'position',get(obj,'position')+[ax1(1)-ax0(1) ax1(2)-ax0(2) 0])
            elseif iscell(usr) & strcmp(usr{1},'vector')
               op.istxt=0;
               op.h(2)=usr{4};
               if strcmp(get(op.h(1),'type'),'patch'),op.h=op.h([2 1]);end
               set(op.h(1),'xdata',get(op.h(1),'xdata')+(ax1(1)-ax0(1)))
               set(op.h(1),'ydata',get(op.h(1),'ydata')+(ax1(2)-ax0(2)))
               set(op.h(2),'xdata',get(op.h(2),'xdata')+(ax1(1)-ax0(1)))
               set(op.h(2),'ydata',get(op.h(2),'ydata')+(ax1(2)-ax0(2)))
            else
               op.istxt=0;
               set(obj,'xdata',get(obj,'xdata')+(ax1(1)-ax0(1)))
               set(obj,'ydata',get(obj,'ydata')+(ax1(2)-ax0(2)))
            end
         end
         op.dx=ax1(1)-ax0(1);
         op.dy=ax1(2)-ax0(2);
         mpptr=mpptr+1;
         mpstack{mpptr}=op;
         mpstack=resize(mpstack,mpptr);
      end
   case 'copy'
      %----------------- COPY OBJECT ------------------------------
      %--- MENU ---
      grd=input('Grid: ');
      if isempty(grd) | grd~=round(grd),grd=0;end
      
      %--- MAIN ---
      grdh=setgrid(ah,grd);
      
      set(gcf,'pointer','crosshair')
      hh=[];
      while 1
         waitforbuttonpress
         obj=gco(gcf);
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         ax0=get(gca,'currentpoint');ax0=ax0(1,1:2);
         if grd,ax0=round(ax0*grd)/grd;end
         waitforbuttonpress
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         ax1=get(gca,'currentpoint');ax1=ax1(1,1:2);
         if grd,ax1=round(ax1*grd)/grd;end      
         if gcf~=obj & gca~=obj & (isempty(grdh) | all(grdh~=obj))
            obj2=copyobj(obj,ah);
            op.h=obj2;
            op.col=getcolor(obj2);
            hh=[hh obj2];
            type=get(obj2,'user');
            if ~iscell(type),type={''};end
            dx=ax1(1)-ax0(1);
            dy=ax1(2)-ax0(2);
            switch(type{1})
            case 'circle'
               op.obj='c';
               op.filled=0;
               op.r=type{2};
               op.origo=[type{3}(1)+dx type{3}(2)+dy];
               op.ls=get(obj2,'linestyle');
               op.wd=get(obj2,'linewidth');
            case 'fcircle'
               op.obj='c';
               op.filled=1;
               op.r=type{2};
               op.origo=[type{3}(1)+dx type{3}(2)+dy];
            case 'ellipse'
               op.obj='e';
               op.filled=0;
               op.a=type{2};
               op.b=type{3};
               op.origo=[type{4}(1)+dx type{4}(2)+dy];
               op.ls=get(obj2,'linestyle');
               op.wd=get(obj2,'linewidth');
            case 'fellipse'
               op.obj='e';
               op.filled=0;
               op.a=type{2};
               op.b=type{3};
               op.origo=[type{4}(1)+dx type{4}(2)+dy];
            case 'vector'
               op.h(2)=copyobj(type{4},ah);
               usr1=get(op.h(1),'user');
               usr2=get(op.h(2),'user');
               usr1{4}=op.h(2);
               usr2{4}=op.h(1);
               set(op.h(1),'user',usr1)
               set(op.h(2),'user',usr2)
               if strcmp(get(op.h(1),'type'),'patch'),op.h=op.h([2 1]);end
               op.obj='v';
               op.filled=0;
               op.p1=type{2}+[dx dy];
               op.p2=type{3}+[dx dy];
               set(usr1{4},'xdata',get(usr1{4},'xdata')+dx)
               set(usr1{4},'ydata',get(usr1{4},'ydata')+dy)
               hh=[hh(1:end-1) op.h];
            otherwise
               switch(get(obj2,'type'))
               case 'line'
                  op.obj='l';
                  op.filled=0;
                  op.x=get(obj2,'xdata')+dx;
                  op.y=get(obj2,'ydata')+dy;
                  op.ls=get(obj2,'linestyle');
                  op.wd=get(obj2,'linewidth');
               case 'patch'
                  op.obj='l';
                  op.filled=1;
                  op.x=get(obj2,'xdata')+dx;
                  op.y=get(obj2,'ydata')+dy;
               case 'text'
                  op.obj='t';
                  op.str=get(obj2,'string');
                  pos=get(obj2,'position');
                  op.x=pos(1)+dx;
                  op.y=pos(2)+dy;
                  op.rot=get(obj2,'rotation');
                  op.siz=get(obj2,'fontsize');
                  op.wgt=get(obj2,'fontweight');
                  op.it=get(obj2,'fontangle');
                  op.align=get(obj2,'horiz');
                  op.fnt=get(obj2,'fontname');
               end
            end
            
            if ~strcmp(get(obj2,'type'),'text')
               op.dp=get(obj2,'zdata');
               if isempty(op.dp)
                  op.dp=0;
               else
                  op.dp=op.dp(1);
               end
            else
               op.dp=get(obj2,'position');
               op.dp=op.dp(3);
            end
            
            if strcmp(get(obj,'type'),'text')
               set(obj2,'position',ax1)
            else
               set(obj2,'xdata',get(obj2,'xdata')+dx)
               set(obj2,'ydata',get(obj2,'ydata')+dy)
            end
            mpptr=mpptr+1;
            mpstack{mpptr}=op;
            mpstack=resize(mpstack,mpptr);
         end
      end
      if nargout,H=hh;end
   case 'delete'
      %----------------- DELETE OBJECT ----------------------------
      axes(ah)
      set(gcf,'pointer','crosshair')
      while 1
         waitforbuttonpress
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         if gcf~=gco(gcf) & gca~=gco(gcf)
            op.h=gco(gcf);
            set(op.h,'visible','off')
            usr=get(op.h,'user');
            if iscell(usr) & strcmp(usr{1},'vector') & ishandle(usr{4})
               op.h(2)=usr{4};
               set(op.h(2),'visible','off')
               if strcmp(get(op.h(1),'type'),'patch'),op.h=op.h([2 1]);end
            end
            mpptr=mpptr+1;
            mpstack{mpptr}=op;
            mpstack=resize(mpstack,mpptr);
         end
      end
   case 'color'
      %----------------- CHANGE COLOR -----------------------------
      %--- MENU ---
      fprintf('1. RGB Picker\n')
      fprintf('2. Color Picker (dropper)\n')
      method=input(': ');
      if isempty(method),method=0;end
      
      if ~nargin,ah=gca;end
      if method==1
         fact=255;
         ch=figure;
         rh=uicontrol(ch,'style','slide','position',[30 300 500 20]);
         set(rh,'min',0),set(rh,'max',fact),set(rh,'sliderstep',[1 10]/fact)
         gh=uicontrol(ch,'style','slide','position',[30 270 500 20]);
         set(gh,'min',0),set(gh,'max',fact),set(gh,'sliderstep',[1 10]/fact)
         bh=uicontrol(ch,'style','slide','position',[30 240 500 20]);
         set(bh,'min',0),set(bh,'max',fact),set(bh,'sliderstep',[1 10]/fact)
         colh=subplot(212);
         txt1=uicontrol(ch,'style','text','position',[150 330 60 20],...
            'string',['[0,' int2str(fact) ']'],'horiz','l','background',getcolor(ch));
         rtxt1=uicontrol(ch,'style','edit','position',[200 330 60 20]);
         gtxt1=uicontrol(ch,'style','edit','position',[260 330 60 20]);
         btxt1=uicontrol(ch,'style','edit','position',[320 330 60 20]);
         txt2=uicontrol(ch,'style','text','position',[150 360 60 20],...
            'string','[0,1]','horiz','l','background',getcolor(ch));
         rtxt2=uicontrol(ch,'style','edit','position',[200 360 60 20]);
         gtxt2=uicontrol(ch,'style','edit','position',[260 360 60 20]);
         btxt2=uicontrol(ch,'style','edit','position',[320 360 60 20]);
         
         axes(ah);
         set(gcf,'pointer','crosshair')
         waitforbuttonpress
         obj=gco(gcf);
         op.h=obj;
         figure(ch)
         col=getcolor(obj);
         op.col0=col;
         rcol=col(1);
         gcol=col(2);
         bcol=col(3);
         set(rh,'background',[1 0 0])
         set(gh,'background',[0 1 0])
         set(bh,'background',[0 0 1])
         axes(colh)
         setcolor(colh,[rcol gcol bcol])
         while 1
            if ~isempty(gco) & any(gco==[rh gh bh])
               rcol=get(rh,'value')/fact;
               gcol=get(gh,'value')/fact;
               bcol=get(bh,'value')/fact;
            elseif ~isempty(gco) & any(gco==[rtxt1 gtxt1 btxt1])
               rcol=str2num(get(rtxt1,'string'))/fact;
               gcol=str2num(get(gtxt1,'string'))/fact;
               bcol=str2num(get(btxt1,'string'))/fact;
            elseif ~isempty(gco) & any(gco==[rtxt2 gtxt2 btxt2])
               rcol=str2num(get(rtxt2,'string'));
               gcol=str2num(get(gtxt2,'string'));
               bcol=str2num(get(btxt2,'string'));
            end
            if isempty(rcol)
               rcol=col(1);
            elseif rcol<0
               rcol=0;
            elseif rcol>1
               rcol=1;
            end
            if isempty(gcol)
               gcol=col(2);
            elseif gcol<0
               gcol=0;
            elseif gcol>1
               gcol=1;
            end
            if isempty(bcol)
               bcol=col(2);
            elseif bcol<0
               bcol=0;
            elseif bcol>1
               bcol=1;
            end
            set(rh,'value',floor(rcol*fact))
            set(gh,'value',floor(gcol*fact))
            set(bh,'value',floor(bcol*fact))
            setcolor(colh,[rcol gcol bcol])
            set(rtxt1,'string',int2str(rcol*fact))
            set(gtxt1,'string',int2str(gcol*fact))
            set(btxt1,'string',int2str(bcol*fact))
            set(rtxt2,'string',num2str(rcol))
            set(gtxt2,'string',num2str(gcol))
            set(btxt2,'string',num2str(bcol))
            waitforbuttonpress
            if strcmp(get(gcf,'selectiontype'),'alt') | strcmp(get(gcf,'selectiontype'),'extend'),break,end
         end
         
         close(ch)
         col=[rcol gcol bcol];
         op.col1=col;
         setcolor(obj,col)
         usr=get(obj,'user');
         if iscell(usr) & strcmp(usr{1},'vector')
            op.h(2)=usr{4};
            setcolor(usr{4},col)
            if strcmp(get(op.h(1),'type'),'patch'),op.h=op.h([2 1]);end
         end
         mpptr=mpptr+1;
         mpstack{mpptr}=op;
         mpstack=resize(mpstack,mpptr);
      elseif method==2
         axes(ah)
         setdropper(gcf)
         waitforbuttonpress
         set(gcf,'pointer','crosshair')
         obj=gco(gcf);
         col=getcolor(obj);
         op.col1=col;
         while 1
            waitforbuttonpress
            if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
            obj=gco(gcf);
            op.h=obj;
            op.col0=getcolor(obj);
            setcolor(obj,col)
            usr=get(obj,'user');
            if iscell(usr) & strcmp(usr{1},'vector')
               op.h(2)=usr{4};
               setcolor(usr{4},col)
               if strcmp(get(op.h(1),'type'),'patch'),op.h=op.h([2 1]);end
            end
            mpptr=mpptr+1;
            mpstack{mpptr}=op;
            mpstack=resize(mpstack,mpptr);
         end
      end
   case 'depth'
      %----------------- CHANGE DEPTH ----------------------------
      axes(ah)
      set(gcf,'pointer','crosshair')
      while 1
         waitforbuttonpress
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         obj=gco(gcf);
         op.h=obj;
         usr=get(obj,'user');
         if iscell(usr) & strcmp(usr{1},'vector')
            op.h(2)=usr{4};
            if strcmp(get(op.h(1),'type'),'patch'),op.h=op.h([2 1]);end
         end
         if obj~=gcf & obj~=gca
            if ~strcmp(get(op.h(1),'type'),'text')
               op.dp0=get(op.h(1),'zdata');
               if isempty(op.dp0)
                  op.dp0=0;
               else
                  op.dp0=op.dp0(1);
               end
            else
               op.dp0=get(op.h(1),'position');
               op.dp0=op.dp0(3);
            end
            fprintf('\nCurrent depth: %i\n',op.dp0)
            op.dp1=input('New depth: ');
            setdepth(op.h,op.dp1,op.dp0)
            mpptr=mpptr+1;
            mpstack{mpptr}=op;
            mpstack=resize(mpstack,mpptr);
         end
      end
   case 'edit'
      %----------------- EDIT TEXT ----------------------------
      axes(ah)
      set(gcf,'pointer','crosshair')
      while 1
         waitforbuttonpress
         if ~strcmp(get(gcf,'selectiontype'),'normal'),break,end
         obj=gco(gcf);
         op.h=obj;
         if strcmp(get(obj,'type'),'text')
            op.str0=get(obj,'string');
            op.rot0=get(obj,'rotation');
            op.siz0=get(obj,'fontsize');
            op.wgt0=get(obj,'fontweight');
            op.it0=get(obj,'fontangle');
            op.align0=get(obj,'horiz');
            op.fnt0=get(obj,'fontname');
            
            op.str1=input('Text String: ','s');
            if isempty(op.str1),op.str1=op.str0;end
            op.rot1=input('Text Rotation Angle (deg): ');
            if isempty(op.rot1),op.rot1=op.rot0;end
            op.siz1=input('Text Size (pt): ');
            if isempty(op.siz1),op.siz1=op.siz0;end
            op.wgt1=input('Text Weight [n b]: ','s');
            if isempty(op.wgt1),op.wgt1=op.wgt0;end
            op.wgt1=lower(op.wgt1(1));
            op.it1=input('Italics?: ');
            if isempty(op.it1)
               op.it1=op.it0;
            elseif op.it1
               op.it1='i';
            else
               op.it1='n';
            end
            op.align1=input('Text Alignment [l c r]: ','s');
            if isempty(op.align1),op.align1=op.align0;end
            op.fnt1=input('Text Font Name: ','s');
            if isempty(op.fnt1),op.fnt1=op.fnt0;end
            fprintf \n
            
            set(obj,'string',op.str1)
            set(obj,'rotation',op.rot1)
            set(obj,'fontsize',op.siz1)
            set(obj,'fontweight',op.wgt1)
            set(obj,'fontangle',op.it1)
            set(obj,'horiz',op.align1)
            set(obj,'fontname',op.fnt1)
            
            mpptr=mpptr+1;
            mpstack{mpptr}=op;
            mpstack=resize(mpstack,mpptr);
         end
      end
   case 'undo'
      %----------------- UNDO OPERATION ---------------------------
      axes(ah)
      if ~isempty(mpstack) & ~isempty(mpptr) & mpptr
         op=mpstack{mpptr};
         mpptr=mpptr-1;
         if all(ishandle(op.h))
            switch(op.type)
            case {'create','copy'}
               delete(op.h)
            case 'move'
               for i=1:length(op.h)
                  if op.istxt
                     set(op.h(i),'position',get(op.h(i),'position')-[op.dx op.dy 0])
                  else
                     set(op.h(i),'xdata',get(op.h(i),'xdata')-op.dx)
                     set(op.h(i),'ydata',get(op.h(i),'ydata')-op.dy)
                  end
               end
            case 'delete'
               for i=1:length(op.h)
                  set(op.h(i),'visible','on')
               end
            case 'color'
               setcolor(op.h,op.col0)
            case 'depth'
               setdepth(op.h,op.dp0)
            case 'edit'
               set(op.h,'string',op.str0)
               set(op.h,'rotation',op.rot0)
               set(op.h,'fontsize',op.siz0)
               set(op.h,'fontweight',op.wgt0)
               set(op.h,'fontangle',op.it0)
               set(op.h,'horiz',op.align0)
               set(op.h,'fontname',op.fnt0)
            end
         end
      end
      if ~mpptr,warning('No more undo-data.'),end
   case 'redo'
      %----------------- REDO OPERATION ---------------------------
      if ~nargin,gca;else,axes(ah),end
      shg
      if ~isempty(mpptr) & mpptr<length(mpstack)
         mpptr=mpptr+1;
         op=mpstack{mpptr};
         switch(op.type)
         case {'create','copy'}
            switch(op.obj)
            case 'l'
               if ~op.filled
                  op.h=plot(op.x,op.y,op.ls);
                  set(op.h,'linewidth',op.wd)
               else
                  op.h=patch(op.x,op.y,op.col);
               end
            case 'v'
               op.h=plotvec(op.p1,op.p2,op.ls);
               set(op.h(1),'linewidth',op.wd)
            case 'c'
               if ~op.filled
                  op.h=circle(op.r,op.origo,op.ls);
                  set(op.h,'linewidth',op.wd)
               else
                  op.h=fcircle(op.r,op.origo,op.col);
               end
            case 'e'
               if ~op.filled
                  op.h=ellipse(op.origo,op.a,op.b,op.ls);
                  set(op.h,'linewidth',op.wd)
               else
                  op.h=fellipse(op.origo,op.a,op.b,op.col);
               end
            case 't'
               op.h=text(op.x,op.y,op.str);
               set(op.h,'rotation',op.rot)
               set(op.h,'fontsize',op.siz)
               set(op.h,'fontweight',op.wgt)
               set(op.h,'fontangle',op.it)
               set(op.h,'horizontalalignment',op.align)
               set(op.h,'fontname',op.fnt)
            end
            setcolor(op.h,op.col)
            setdepth(op.h,op.dp)
            mpstack{mpptr}=op;
         case 'move'
            if all(ishandle(op.h))
               for i=1:length(op.h)
                  if op.istxt
                     set(op.h(i),'position',get(op.h(i),'position')+[op.dx op.dy 0])
                  else
                     set(op.h(i),'xdata',get(op.h(i),'xdata')+op.dx)
                     set(op.h(i),'ydata',get(op.h(i),'ydata')+op.dy)
                  end
               end
            end
         case 'delete'
            if all(ishandle(op.h))
               for i=1:length(op.h)
                  set(op.h(i),'visible','off')
               end
            end
         case 'color'
            if all(ishandle(op.h))
               setcolor(op.h,op.col1)
            end
         case 'depth'
            if all(ishandle(op.h))
               setdepth(op.h,op.dp1)
            end
         case 'edit'
            if all(ishandle(op.h))
               set(op.h,'string',op.str1)
               set(op.h,'rotation',op.rot1)
               set(op.h,'fontsize',op.siz1)
               set(op.h,'fontweight',op.wgt1)
               set(op.h,'fontangle',op.it1)
               set(op.h,'horiz',op.align1)
               set(op.h,'fontname',op.fnt1)
            end
         end
      end
      if mpptr>=length(mpstack),warning('No more redo-data.'),end
   case 'clear'
      %----------------- CLEAR STACK ------------------------------
      do=input('Are you sure?: ','s');
      if ~isempty(do) & (lower(do(1))=='y' | do(1)=='1')
         set(ah,'user',[])
         doclear=1;
         fprintf('Undo stack is cleared.\n')
      else
         doclear=0;
         fprintf('Undo stack is intact.\n')
      end
   end
   fprintf \n
   data.mpptr=mpptr;
   data.mpstack=mpstack;
   if strcmp(action,'clear') & doclear
   else
      set(ah,'user',data)
   end
   set(gcf,'pointer','arrow')
   delete(grdh)
end
if ~held,hold off,end

%----------------- FUNCTIONS ---------------------------

function stack=resize(stack,ptr)
for i=1:ptr
   tmp{i}=stack{i};
end
stack=tmp;

function setdropper(h)
x=nan;
dptr=[x x x x x x x x x x x x x x x x;...
      x x x x x x x x x x x x x x x x;...
      x x x x x x x x x x x 1 1 x x x;...
      x x x x x x x x 1 x 1 1 1 1 x x;...
      x x x x x x x x x 1 1 1 1 1 x x;...
      x x x x x x x x 1 2 1 1 1 x x x;...
      x x x x x x x 1 2 2 2 1 x x x x;...
      x x x x x x 1 2 2 2 1 x 1 x x x;...
      x x x x x 1 2 2 2 1 x x x x x x;...
      x x x x 1 2 2 2 1 x x x x x x x;...
      x x x 1 2 2 2 1 x x x x x x x x;...
      x x 1 2 2 2 1 x x x x x x x x x;...
      x x 1 2 2 1 x x x x x x x x x x;...
      x 1 2 1 1 x x x x x x x x x x x;...
      x x 1 x x x x x x x x x x x x x;...
      x x x x x x x x x x x x x x x x];
dhotspot=[15 2];
set(h,'Pointer','custom')
set(h,'PointerShapeCData',dptr)
set(h,'PointerShapeHotSpot',dhotspot)

function grdh=setgrid(ah,grd)
axes(ah)
ax=axis;
axis equal
axis(ax)
maxx=max([1 round(ax(2)) round(ax(4))]);
grdh=[];
if grd
   grd=grd+1;
   v=linspace(0,maxx,grd);
   grdh=plot(repmat(v,[1 grd]),reshape(repmat(v,[grd 1]),[1 grd^2]),'k.');
   set(grdh,'markersize',.5)
   grd=grd-1;
end

function setdepth(h,dp,default)
if isempty(dp) & nargin==2,dp=0;end
if isempty(dp) & nargin==3,dp=default;end
for i=1:length(h)
   if ~strcmp(get(h(i),'type'),'text')
      set(h(i),'zdata',dp*ones(size(get(h(i),'xdata'))))
   else
      pos=get(h(i),'position');
      pos(3)=dp;
      set(h(i),'position',pos)
   end
end

function setcolor(h,col)
for i=1:length(h)
   if strcmp(get(h(i),'type'),'patch')
      set(h(i),'edgec',col)
      set(h(i),'facec',col)
   else
      set(h(i),'color',col)
   end
end

function col=getcolor(h)
if strcmp(get(h(1),'type'),'patch')
   col=get(h(1),'facec');
else
   col=get(h(1),'color');
end