function impxfig(file,h)
%IMPXFIG  Imports an Xfig figure.
%   IMPXFIG(FILE[,H]) imports Xfig figure from file FILE
%   and draws the figure in the matlab figure with handle H
%   or creates a new figure if left out.
%
%   See also MPAINT, TEXPIC.

% Copyright (c) 2002-10-25, B. Rasmus Anthin.
% Revision: 2002-10-26, 2002-10-28, 2002-11-23.

% needs: ELLIPSE, FELLIPSE, HEX2RGB.

error(nargchk(1,2,nargin))
if ~any(file=='.')
   file=[file '.fig'];
end
if nargin<2 | isempty(h)
   h=gcf;
end
figure(h);
hold on
set(gcf,'NumberTitle','off')
set(gcf,'Name',file)
set(gcf,'UserData','xfig')

% ok here goes...

fp=fopen(file,'r');
ver=fgetl(fp);
if ~strcmp(ver(1:4),'#FIG')
   error('This is not an Xfig figure.')
end

switch str2num(ver(6:8))
case 3.2
   set(h,'PaperOrientation',fgetl(fp))
   fgetl(fp);            %justification
   unit=deblank(fgetl(fp));
   if strcmp(unit,'Metric')
      set(gcf,'PaperUnits','centimeters')
   else
      set(gcf,'PaperUnits',unit)
   end
   switch deblank(fgetl(fp))
   case 'Legal'
      set(gcf,'PaperType','uslegal')
   case 'A3'
      set(gcf,'PaperType','a3')
   case 'A4'
      set(gcf,'PaperType','a4letter')
   case 'Tabloid'
      set(gcf,'PaperType','tabloid')
   otherwise
      set(gcf,'PaperType','usletter')
   end
   fgetl(fp);            %magnification
   fgetl(fp);            %multiple-page
   fgetl(fp);            %transparent color
   ulcoord=str2num(fgetl(fp));   % i don't think I need this.
   I=0;
   while 1
      I=I+1;
      line=fgetl(fp);
      if isnumeric(line), break,end
      while iscontinue(fp)
         line=[line fgetl(fp)];
      end
      line=deblank(line);
      is=find(isspace(line));
      if ~isempty(is), is=is(end);end
      object{I}.v=str2num(line(1:is));
      object{I}.s=[];
      if isempty(object{I}.v)  % for 6 and -6.
         I=I-1;
      else
         if any(object{I}.v(1)==[0 4])
            object{I}.s=line(is:end);
         else
            object{I}.v=[object{I}.v str2num(line(is:end))];
         end
      end
   end
   for i=1:I-1
      tmp{i}.v=object{i}.v;
      tmp{i}.s=object{i}.s;
   end
   clear object
   for i=1:I-1
      object{i}.v=tmp{i}.v;
      object{i}.s=tmp{i}.s;
   end

   palette=zeros(512,3);    %initiering av paletten
   for i=1:length(object)   %för varje objekt utför följande...
      obj=object{i}.v;
      str=object{i}.s;
      switch obj(1)
      case 0  %Color pseudo-object.
         colnum=obj(2);
         sharp=find(str=='#');
         palette(colnum,:)=hex2rgb(str(sharp+1:end));
      case 1  %Ellipse.
         %sub_type=obj(2);
         line_style=Gline_style(obj(3));
         thickness=Gthickness(obj(4));
         pen_color=Gpen_color(obj(5),palette);
         fill_color=Gpen_color(obj(6),palette);
         fc=obj(6);
         depth=-obj(7);
         %pen_style=obj{8};
         area_fill=obj(9);
         %style_val=obj(10);
         %direction=obj(11);
         angle=obj(12);
         center=obj([13 14])/1000;
         radius_x=obj(15)/1000;
         radius_y=obj(16)/1000;
         %start_x=obj(17);
         %start_y=obj(18);
         %end_x=obj(19);
         %end_y=obj(20);
         if area_fill>=0
            h=fellipse(center,radius_x,radius_y,Gfill_color(fc,fill_color,area_fill));
            %set(h,'EdgeColor',pen_color);
            set(h,'LineStyle',line_style);
            set(h,'LineWidth',thickness);
            set(h,'zdata',ones(size(get(h,'xdata')))*depth);
            rotate_obj(h,center,angle)
         end
         hb=ellipse(center,radius_x,radius_y);
         set(hb,'Color',pen_color);
         set(hb,'LineStyle',line_style);
         set(hb,'LineWidth',thickness);
         set(hb,'zdata',ones(size(get(hb,'xdata')))*(depth+.5));
         rotate_obj(hb,center,angle)
      case 2  %Polyline.
         sub_type=obj(2);
         if sub_type>3
            warning('Arc-boxes are not yet supported.')
         end
         line_style=Gline_style(obj(3));
         thickness=Gthickness(obj(4));
         pen_color=Gpen_color(obj(5),palette);
         fill_color=Gpen_color(obj(6),palette);
         fc=obj(6);
         depth=-obj(7);
         %pen_style=obj(8);
         area_fill=obj(9);
         %style_val=obj(10);
         %join_style=obj(11);
         %cap_style=obj(12);
         %radius=obj(13);
         forward_arrow=obj(14);
         backward_arrow=obj(15);
         if forward_arrow | backward_arrow
            warning('Arrows are not yet supported.')
         end
         %npoints=obj(16);
         px=obj(17);
         py=obj(18);
         for k=20:2:length(obj)
            px=[px obj(k-1)];
            py=[py obj(k)];
         end
         px=px/1000;
         py=py/1000;
         if area_fill>=0
            h=patch(px,py,Gfill_color(fc,fill_color,area_fill));
            %set(h,'EdgeColor',pen_color);
            set(h,'LineStyle',line_style);
            set(h,'LineWidth',thickness);
            set(h,'zdata',ones(size(get(h,'xdata')))*depth);
         end
         hb=plot(px,py);
         set(hb,'Color',pen_color)
         set(hb,'LineStyle',line_style);
         set(hb,'LineWidth',thickness);
         set(hb,'zdata',ones(size(get(hb,'xdata')))*(depth+.5));
      case 3  %Spline.
         sub_type=obj(2);
         % 0: open B-spline (appr)
         % 1: closed B-spline (appr)
         % 2: open spline (interp)
         % 3: closed spline (interp)
         % 4: opened X-spline ???
         % 5: closed X-spline ???
         line_style=Gline_style(obj(3));
         thickness=Gthickness(obj(4));
         pen_color=Gpen_color(obj(5),palette);
         fill_color=Gpen_color(obj(6),palette);
         fc=obj(6);
         depth=-obj(7);
         %pen_style=obj(8);
         area_fill=obj(9);
         %style_val=obj(10);
         %cap_style=obj(11);
         forward_arrow=obj(12);
         backward_arrow=obj(13);
         if forward_arrow | backward_arrow
            warning('Arrows are not yet supported.')
         end
         npoints=obj(14);
         px=obj(15);
         py=obj(16);
         for k=18:2:length(obj)-npoints
            px=[px obj(k-1)];
            py=[py obj(k)];
         end
         px=px/1000;
         py=py/1000;
%         if sub_type<2
%            [xi yi]=appr_spline(px,py);
%            %'bezier'
         if sub_type<4   %elseif
            [xi yi]=interp_spline(px,py);
            %'natural'
         end
         if area_fill>=0
            h=patch(xi,yi,Gfill_color(fc,fill_color,area_fill));
            %set(h,'EdgeColor',pen_color);
            set(h,'LineStyle',line_style);
            set(h,'LineWidth',thickness);
            set(h,'zdata',ones(size(get(h,'xdata')))*depth);
         end
         hb=plot(xi,yi);
         set(hb,'Color',pen_color)
         set(hb,'LineStyle',line_style);
         set(hb,'LineWidth',thickness);
         set(hb,'zdata',ones(size(get(hb,'xdata')))*(depth+.5));
      case 4  %Text.
         sub_type=obj(2);
         color=Gpen_color(obj(3));
         depth=-obj(4);
         %pen_style=obj(5);
         font=obj(6);
         font_size=obj(7);
         angle=obj(8);
         font_flags=obj(9);
         %height=obj(10);
         %length=obj(11);
         x=obj(12)/1000;
         y=obj(13)/1000;
         string=str(1:end-4);
         %---
         h=text(x,y,string);
         set(h,'Color',color);
         set(h,'Position',[x y depth]);
         %set(h,'FontName',
         set(h,'FontSize',font_size);
         set(h,'Rotation',angle*180/pi);
         switch sub_type
         case 1, set(h,'HorizontalAlignment','left');
         case 2, set(h,'HorizontalAlignment','center');
         case 3, set(h,'HorizontalAlignment','right');
         end
         set(h,'VerticalAlignment','middle');
      case 5  %Arc.
         sub_type=obj(2);
         line_style=Gline_style(obj(3));
         thickness=Gthickness(obj(4));
         pen_color=Gpen_color(obj(5),palette);
         fill_color=Gpen_color(obj(6),palette);
         depth=-obj(7);
         %pen_style=obj(8);
         area_fill=obj(9);
         %style_val=obj(10);
         %cap_style=obj(11);
         direction=obj(12);
         forward_arrow=obj(13);
         backward_arrow=obj(14);
         c=obj([15 16])/1000;
         p1=obj([17 18])/1000;
         p2=obj([19 20])/1000;
         p3=obj([21 22])/1000;
         a1=atan2(p1(2)-c(2),p1(1)-c(1));
         a2=atan2(p2(2)-c(2),p2(1)-c(1));
         a3=atan2(p3(2)-c(2),p3(1)-c(1));
         a=unwrap([a1 a2 a3]);
         r=norm(p1-c);
         phi=linspace(a(1),a(3));
         x=r*cos(phi)+c(1);
         y=r*sin(phi)+c(2);
         if sub_type
            x=[x x(1)];
            y=[y y(1)];
         end
         if area_fill>=0
            h=patch(x,y,Gfill_color(fc,fill_color,area_fill));
            %set(h,'EdgeColor',pen_color);
            set(h,'LineStyle',line_style);
            set(h,'LineWidth',thickness);
            set(h,'zdata',ones(size(get(h,'xdata')))*depth);
         end
         hb=plot(x,y);
         set(hb,'Color',pen_color)
         set(hb,'LineStyle',line_style);
         set(hb,'LineWidth',thickness);
         set(hb,'zdata',ones(size(get(hb,'xdata')))*(depth+.5));
      case 6  %Compound object.
         %no need for this...
      otherwise
         error('Unrecognized operation.')
      end
   end
otherwise
   error('Version of Xfig not supported yet.')
end
axis equal
if unit(1)=='I', dim='inch';end
if unit(1)=='M', dim='mm';end
xlabel(['x [' dim ']'])
ylabel(['y [' dim ']'])
set(gca,'XaxisLocation','top')
set(gca,'YDir','reverse')
set(gca,'YAxisLocation','right')

fclose(fp);


% help functions...

function y=iscontinue(fp)
pos=ftell(fp);
line=fgetl(fp);
y=isspace(line(1));
fseek(fp,pos,-1);

function color=Gpen_color(arg,palette)
c=[255 207 175 143];
switch arg
case -1, color='k';
case 0, color='k';
case 1, color='b';
case 2, color='g';
case 3, color='c';
case 4, color='r';
case 5, color='m';
case 6, color='y';
case 7, color='w';
case {8,9,10}, color=[0 0 c(12-arg)]/255;             %Blue4-Blue2
case 11, color=[127 200 255]/255;                     %LtBlue
case {12,13,14}, color=[0 c(16-arg) 0]/255;           %Green4-Green2
case {15,16,17}, color=[0 c(19-arg) c(19-arg)]/255;   %Cyan4-Cyan2
case {18,19,20}, color=[c(22-arg) 0 0]/255;           %Red4-Red2
case {21,22,23}, color=[c(25-arg) 0 c(25-arg)]/255;   %Magenta4-Magenta2
case 24, color=[127 47 0]/255;                        %Brown4
case 25, color=[159 63 0]/255;                        %Brown3
case 26, color=[191 95 0]/255;                        %Brown2
case 27, color=[255 127 127]/255;                     %Pink4
case 28, color=[255 159 159]/255;                     %Pink3
case 29, color=[255 191 191]/255;                     %Pink2
case 30, color=[255 223 223]/255;                     %Pink
case 31, color=[255 215 0]/255;                       %Gold
end
%additional colors here...
if 31<arg & arg<544
   color=palette(arg,:);
end

function y=Gfill_color(fc,fcol,area)
patt='Patterns are not yet supported.';
switch fc
case 7
   if area<0
      y=-1;
   elseif ~area
      y='k';
   elseif 0<area & area<20
      grey=linspace(0,1,21);
      y=grey(area+1)*ones(1,3);
   elseif area==20
      y='w';
   else
      y='w';
      warning(patt)
   end
case {-1,0}
   if area<0
      y=-1;
   elseif ~area
      y='w';
   elseif 0<area & area<20
      grey=linspace(1,0,21);
      y=grey(area+1)*ones(1,3);
   elseif area==20
      y='k';
   else
      y='k'
      warning(patt)
   end
otherwise
   if area<0
      y=-1;
   elseif 0<=area & area<20    %black-color
		y=fcol-fcol*(20-area)/20
   elseif area==20             %color
      y=fcol;
   elseif 20<area & area<=40   %color-white
      compl=ones(1,3)-fcol;
      y=fcol+compl*(area-20)/20;
   elseif area>40
      y=fcol;
      warning(patt)
   end   
end
   
function style=Gline_style(arg)
switch arg
case -1, style='-';
case 0, style='-';
case 1, style='--';
case 2, style=':';
case {3,4,5}, style='-.';
otherwise
   error('Unknown linestyle.')
end

function [xi,yi]=interp_spline(x,y)
%natural
t=linspace(0,1,length(x));
ti=linspace(0,1,100*length(t));
xi=spline(t,x,ti);
yi=spline(t,y,ti);

function [xi,yi]=appr_spline(x,y)
%bezier
P=[x(:)';y(:)'];
C=bezier(P,100*length(x));
xi=C(1,:);
yi=C(2,:);

function y=Gthickness(x)
y=x/2*~~x+~x/2;

function rotate_obj(h,origo,phi)
x=get(h,'xdata');
y=get(h,'ydata');
pts=[x(:)';y(:)'];
o=origo';
npts=rotate2(pts,o,-phi);
nx=npts(1,:);
ny=npts(2,:);
%plot(o(1),o(2),'or')  %test
set(h,'xdata',nx);
set(h,'ydata',ny);