function display(x)
sp(1:5)=' ';
v=double(x.val);
fprintf(['\n' inputname(1) ' =\n\n' sp])
for i=1:length(v)
   fprintf('%s',v(i)+48)
   if ~mod(i,4)
      fprintf(' ')
   end
   if ~mod(i,8)
      fprintf(' ')
   end
   if ~mod(i,16)
      fprintf(' ')
   end
   if ~mod(i,32)
      fprintf(' ')
   end
   if ~mod(i,64)
      fprintf(' ')
   end
end
fprintf \n\n