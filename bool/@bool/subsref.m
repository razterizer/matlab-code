function y=subsref(x,s)
if length(s)>1, error('Syntax error in subsref.'),end
if strcmp(s.type,'()')
   i=s.subs;
   if iscell(i)
      i=cat(2,i{:});
   end
end   
y.val=x.val(i);
y=bool(y);