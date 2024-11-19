function s=num2stre(n)
s=num2str(n);
i=1+find(s=='e');
if ~isempty(i) & s(i+1)=='0';
   s=s([1:i i+2:end]);
   if s(i+1)=='0';
      s=s([1:i i+2:end]);
   end
end