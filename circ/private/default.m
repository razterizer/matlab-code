function var=default(new,old)
%DEFAULT  Return default value if needed.
%   VAR = DEFAULT(NEW,OLD) returns variable OLD if
%   variable NEW is empty, otherwise it returns variable NEW.

% Copyright (c) 2002-02-09, B. Rasmus Anthin.

if isempty(new)
   var=old;
else
   var=new;
end