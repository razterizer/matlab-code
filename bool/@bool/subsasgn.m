function y=subsasgn(y,s,x)
if ~isa(x,'bool')
   x=bool(x);
end
if length(s)>1, error('Syntax error in subsref.'),end
if strcmp(s.type,'()')
   i=s.subs;
   if iscell(i)
      i=cat(2,i{:});
   end
end   
%y.val(i)=x.val;
y.val=x.val;
y=bool(y.val);