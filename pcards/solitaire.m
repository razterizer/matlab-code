%solitaire template
table([6 5.5])
pos=get(gcf,'pos');
pos(1:2)=pos(1:2)-pos(3:4)*.2;
pos(3:4)=pos(3:4)*1.2;
set(gcf,'pos',pos)

d=deck;
d=reshape(d(1:7*7),[7 7]);   %ensure we have 49 unique cards
[cs I]=rcard(d);         %randomize order of cards
cs=hide(cs);
for i=1:7      %make "triangle"
   for j=i:7
      cs(i,j)=show(cs(i,j));
   end
   for j=i+1:7
      cs(i,j)=facedn(cs(i,j));
   end
end
cs(~isvisible(cs))=joker(cs(~isvisible(cs)));
cs=layout(cs,'down',.2,2,1.1,.15)
cs=plot(cs);

xs=.2+cwidth(cs(1))*1.1*(3:6);
[xx,yy]=position(cs);
ys=repmat(max(yy(:))+csize(cs(1))+.1,[1 4]);
for i=1:4
   slot(csize(cs(1)),xs(i),ys(i))
end

for i=1:7         %move a few cards
   c=deselect(select(cs))
   c=layer(c,7);      %ensure cards are on top
   %c=snap(c,.2,2,1.1,.15);
   [c,moved]=snap(c,xs,ys,.5);
   if ~moved
      [x,y]=position(cs(cs==c));
      c=position(c,x,y);
   end
   c=delete(c);
   cs(cs==c)=c;       %update card's position (put it back in the deck)
   cs=plot(cs);       %update view of cards
end
