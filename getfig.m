function getfig(h,opt)
%GETFIG  Get back figure if it is located out of reach.
%   GETFIG
%   GETFIG(H)
%   GETFIG(OPT)
%   GETFIG(H,OPT)
%   Takes figure(s) with handle(s) H (or GCF if omitted) and puts its
%   lower left corner on the lower left corner of the screen.
%   If OPT = 'resize' then the figure will be resized to the
%   half width of the screen if the figure width is longer than
%   the half screen width, or will be resized to the half
%   height of the screen if the figure height is longer than the
%   half screen height.
%
%   See also SET, GET, GCF, FIGURE.

% Copyright (c) 2003-08-08, B. Rasmus Anthin.

if ~nargin
   h=gcf;
   opt=' ';
elseif nargin==1 & ischar(h)
   opt=h;
   h=gcf;
elseif nargin==1 & isnumeric(h)
   opt=' ';
end
for i=1:length(h)
   pos=get(h(i),'pos');
   if lower(opt(1))=='r'
      sc=get(0,'screensize');
      if pos(3)>sc(3)/2, pos(3)=sc(3)/2;end
      if pos(4)>sc(4)/2, pos(4)=sc(4)/2;end
   end
   set(h(i),'pos',[0 0 pos(3:4)])
end