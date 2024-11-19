function es=texgenexp(str,exp)
if strcmp(exp,'10')
   exp1='\\cdot10^{'; exp2='}';
   if strcmp(str.esgn,'+'), str.esgn='';end
elseif strcmp(exp,'e')
   exp1='\\textrm{\\footnotesize{e'; exp2='}}';
elseif strcmp(exp,'E')
   exp1='\\textrm{\\footnotesize{E'; exp2='}}';
else
   error('Unrecognized exponent format.')
end
if isempty(str.e)
   es='';
else
   es=[exp1 str.esgn str.e exp2];
end